# Lab Net

在本实验中，需要补全xv6的网络驱动程序，使其可以基于E1000设备进行网络通信。虽然实验看起来难度很大，且E1000的软件开发手册也十分难懂，但如果跟随实验指导书的提示，本实验的难度则并不是很大。

## E1000的接受与传输机制

为了完成本实验，我们必须要了解E1000硬件的数据包接受与传输机制。在软件层面上，E1000的接受和传输主要都是基于一种名为 **描述符** 的数据结构完成的。描述符担任了硬件与软件数据传输中介的功能，并为E1000设备提供了DMA（直接内存访问）机制。在每个描述符中都存放了一个位于RAM内存的地址，其可被硬件和软件共同访问和操作。并且，为了提升E1000设备的大规模数据承载能力，E1000驱动程序维护了 **描述符环** 数据结构作为数据包传输和接受的缓冲机制。

###  接受描述符环

接受描述符的数据结构如下所示：

```
116 struct rx_desc
117 { 
118   uint64 addr;       /* Address of the descriptor's data buffer */
119   uint16 length;     /* Length of data DMAed into data buffer */
120   uint16 csum;       /* Packet checksum */
121   uint8 status;      /* Descriptor status */
122   uint8 errors;      /* Descriptor Errors */
123   uint16 special;
124 };
```

其中，主要的条目为`addr`、`length` 和 `status`。其中 `addr` 为该描述符所映射的地址，其内存由驱动程序软件预先分配，并当E1000设备接受到数据包时被硬件填充。`length` 为硬件填充的数据长度。`status` 中存放了当前描述符的状态，其中最重要的状态位为 `E1000_RXD_STAT_DD` ，当硬件完成了对当前描述符的填充时，该位被置为1，以通知驱动程序软件将其提取。

接受描述符环的数据结构如下图所示：

![figure1](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab8-net/figure1.png)

其实质上即为一个存放接受描述符的循环队列，图中的灰色区域代表已经被硬件填充，但未被软件所提取的描述符；白色区域代表当前的未使用描述符，可以被硬件所填充。在这里，队列的长度被驱动程序初始化并存放在 `RDLEN` 寄存器中；`Head` 指向了硬件应填充的第一个描述符，其被存放在 `RDH` 寄存器中并被硬件自动更新，被初始化为 0 ；`Tail` 指向了最后一个未被填充的描述符，其被存放在 `RDT` 寄存器中并被驱动程序所更新，被初始化为 `RDLEN - 1`。

### 传输描述符环

传输描述符的数据结构如下所示：

```
100 struct tx_desc
101 {
102   uint64 addr;
103   uint16 length;
104   uint8 cso;
105   uint8 cmd;
106   uint8 status;
107   uint8 css;
108   uint16 special;
109 };
```

其中，主要的条目为`addr`、`length` 、`cmd`和 `status`。`addr` 为该描述符所映射的内存，其内容被软件填充，并被硬件所提取；`length` 为软件填充的数据长度；`cmd` 控制了该描述符的行为，当 `E1000_TXD_CMD_EOP` 被设置时，表示当前描述符为用于存储一块数据包的最后一个描述符（当数据包较大时可由多个描述符共同存储），当 `E1000_TXD_CMD_RS` 被设置时，硬件在提取当前描述符的内容时，会自动将该描述符的`status` 置为 `E1000_TXD_STAT_DD` 。

传输描述符环的数据结构如下所示：

![figure2](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab8-net/figure2.png)

其与接受描述符环的结构类似，队列的长度被软件初始化并存放在 `E1000_TDLEN` 寄存器中。`Head` 指向了当前硬件所要提取的描述符，被存放在 `TDH` 中并初始化为 0，并被硬件自动更新；`Tail` 指向了当前软件所要填充的描述符，被存放在 `TDT` 中并初始化为 0，并被驱动程序更新。

在这里，接受和传输描述符所指向的内存段被构造成了 `mbuf` 缓冲区数据结构以方便被其他函数操作，且驱动程序为接受和传输描述符环各分配了一个存放 `mbuf` 缓冲区指针的数组：

```
 11 #define TX_RING_SIZE 16
 12 static struct tx_desc tx_ring[TX_RING_SIZE] __attribute__((aligned(16)));
 13 static struct mbuf *tx_mbufs[TX_RING_SIZE];
 14 
 15 #define RX_RING_SIZE 16
 16 static struct rx_desc rx_ring[RX_RING_SIZE] __attribute__((aligned(16)));
 17 static struct mbuf *rx_mbufs[RX_RING_SIZE];
```

## 实验源码及讲解

在本实验中，驱动程序的初始化及一些支撑数据结构已经被编写完成，在这里只需填充用于接受和传输数据包的主要驱动程序函数即可。其中，用于传输数据包的函数为 `int e1000_transmit(struct mbuf *m)` ，其由驱动程序主动调用来传输数据包，其实现如下：

```
 97 int
 98 e1000_transmit(struct mbuf *m)
 99 {
100     //
101     // Your code here.
102     //
103     // the mbuf contains an ethernet frame; program it into
104     // the TX descriptor ring so that the e1000 sends it. Stash
105     // a pointer so that it can be freed after sending.
106     acquire(&e1000_txlock);
107     uint32 tail = regs[E1000_TDT];
108     if(!(tx_ring[tail].status & E1000_TXD_STAT_DD)){
109         release(&e1000_txlock);
110         return -1;
111     }
112     if(tx_mbufs[tail])
113         mbuffree(tx_mbufs[tail]);
114     tx_ring[tail].addr = (uint64)m->head;
115     tx_ring[tail].length = (uint16)m->len;
116     tx_ring[tail].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
117     tx_mbufs[tail] = m;
118     regs[E1000_TDT] = (tail+1) % TX_RING_SIZE;
119     release(&e1000_txlock);
120     return 0;
121 }
```

在这里，使用互斥锁 `e1000_txlock` 保护传输描述符环，其在 `e1000_init` 中被初始化。

**107 - 111行：**通过提取 `TDT` 寄存器的值，得到当前所需填充的描述符索引，并检查 `status` 判断其是否已经被硬件提取完毕或未被填充（在`e1000_init` 中 `status` 被初始化为 0）。如当前描述符被填充且未被硬件提取完毕，则释放锁并返回 -1。

**112 - 118行**：如当前描述符未被填充或已被硬件提取完毕，则释放被该描述符所指向的缓冲区。并将当前描述符的 `addr` 置为函数传入的缓冲区的 `head` 地址（其中存放了缓冲区的具体数据）；将 `length` 置为缓冲区所表示的数据长度；并将 `cmd` 置为 `RS | EOP`（原因见上文）。最后，递增 `TDT` 寄存器的值。

用于接受数据的函数为 `static void e1000_recv(void)`。当操作系统接受到数据包时，其将产生设备中断并在 `devintr` 中调用 `e1000_intr` ，该函数调用 `e1000_recv` 完成对数据包的具体接受工作，其实现如下：

```
123 static void
124 e1000_recv(void)
125 {
126     //
127     // Your code here.
128     //
129     // Check for packets that have arrived from the e1000
130     // Create and deliver an mbuf for each packet (using net_rx()).
131     struct mbuf *newmbuf;
132     acquire(&e1000_rxlock);
133     uint32 tail = regs[E1000_RDT];
134     uint32 curr = (tail + 1) % RX_RING_SIZE;
135     while(1){
136         if(!(rx_ring[curr].status & E1000_RXD_STAT_DD)){
137             break;
138         }
139         rx_mbufs[curr]->len = rx_ring[curr].length;
140         net_rx(rx_mbufs[curr]);
141         tail = curr;
142         newmbuf = mbufalloc(0);
143         rx_mbufs[curr] = newmbuf;
144         rx_ring[curr].addr = (uint64)newmbuf->head;
145         rx_ring[curr].status = 0;
146         regs[E1000_RDT] = curr;
147         curr = (curr + 1) % RX_RING_SIZE;
148     }
149     regs[E1000_RDT] = tail;
150     release(&e1000_rxlock);
151 }
```

在这里，使用互斥锁 `e1000_rxlock` 保护接受描述符环，其在 `e1000_init` 中被初始化。

**133 - 134行：**提取 `RDT` 得到最后一个应被硬件填充的描述符索引，并将 `curr` 置为 `RDT` 所指向的下一个描述符索引，其为可能被硬件填充并待软件接受的第一个描述符。

**135 - 138行：**在这里，陷入循环以提取所有被硬件填充的描述符。值得注意的是，在软件进行提取的过程中，硬件也可以同时对描述符进行填充，因此该方法可应对次数超出环大小的硬件填充。在循环中，通过检查 `status` 以判断当前描述符是否已被硬件填充，如未填充则跳出循环结束函数。

**139 - 140行：**如当前描述符被硬件填充，则通过缓冲区中的实际数据长度更新描述符的 `length` 字段，并调用 `nex_rx` 将该缓冲区的内容发生至网络堆栈使得操作系统可以将其提取。

**141 - 149行：**在完成 `new_rx` 后，将 `tail` 置为 `curr` 以记录最后一个被软件所提取的描述符索引。然后，为该描述符分配新的缓冲区并将描述符的 `status` 和 `addr` 字段更新。最后，将 `curr` 更新为下一个描述符的索引。在循环结束后，将 `tail` 回写至 `RDT`。

## 实验结果

```
== Test running nettests == (2.7s) 
== Test   nettest: ping == 
  nettest: ping: OK 
== Test   nettest: single process == 
  nettest: single process: OK 
== Test   nettest: multi-process == 
  nettest: multi-process: OK 
== Test   nettest: DNS == 
  nettest: DNS: OK 
== Test time == 
time: OK 
Score: 100/100
```



