# **《物联网导论》大作业**

小组成员：

* 马文煊 2018011406
* 申子琳 2017012345
* 郑舒文 2018013426

[toc]

## 代码逻辑

### 声波通信



### 声波定位

#### 测距

采用 BeepBeep 算法。

##### tcp 连接

通过如下代码实现 Server 端和 Client 端的 tcp 连接：

```matlab
% server
Server = tcpip(IP, PortN, 'NetworkRole', 'server');
fopen(Server);

% client
Client = tcpip(IP, PortN, 'NetworkRole', 'client');
fopen(Client);
```

实践中发现，Server 端和 Client 端需要连接在同一局域网下，且 Server 调用 tcpip 时的参数 `IP` 应为 Client 的 ip 地址，而 Client 调用 tcpip 时的参数 `IP` 应为 Server 的 ip 地址，才能成功连接。

##### BeepBeep 过程

BeepBeep 过程可用下图概括性地表达：



BeepBeep 的巧思在于两个设备执行代码时的延迟可以大致抵消，而两个设备成功连接后时钟差距不大、实际测量距离不远，因此可以设置一个与固定的等待时长，使得 A 和 B 播放的 chirp 不重合。

##### 计算过程

两端各自通过如下代码找到两段 chirp 的起点，继而找到各自接收到信号的时间区间长度，将两个长度相减，即可得到和距离相关的时间差，进而得到距离：

```matlab
z1 = chirp(t, f1, T, f2); z1 = z1(end : -1 : 1);
z2 = chirp(t, f2, T, f3); z2 = z2(end : -1 : 1);
[~, p1] = max(conv(recvData, z1, 'valid'));
[~, p2] = max(conv(recvData, z2, 'valid'));
```

实践中对比频谱图发现，当提高 chirp 声波频率时，找到的起点更精确，猜测这是因为频率提高使得信号与噪声之间的区别更明显。

#### 定位

对应 `Location\Locate.m` 文件，采用三边定位算法。

假设 n 个锚结点的坐标分别为 $(x_1, y_1), (x_2, y_2), \cdots, (x_n, y_n)$，目标节点到它们的距离分别为 $d_1, d_2,\cdots, d_n$，那么可列出方程组：
$$
(x-x_i)^2 + (y-y_i)^2 = d_i^2, \ \ 1 \leq i \leq n
$$
将前 n-1 个方程都减去第 n 个方程消去关于 x 和 y 的二次项，有
$$
2(x_i-x_n)x + 2(y_i-y_n)y = x_i^2 - x_n^2 + y_i^2 - y_n^2 - d_i^2 + d_n^2 \ \, 1 \leq i < n
$$
令$A = \left[ \begin{matrix} 2(x_1-x_n) & 2(y_1-y_n) \\ ... \\ 2(x_{n-1}-x_n) & 2(y_{n-1}-y_n) \end{matrix} \right], B = \left[ \begin{matrix} x_1^2 - x_n^2 + y_1^2 - y_n^2 - d_1^2 + d_n^2 \\ ... \\ x_{n-1}^2 - x_n^2 + y_{n-1}^2 - y_n^2 - d_{n-1}^2 + d_n^2 \end{matrix} \right], X = \left[ \begin{matrix} x\\ y \end{matrix} \right]$，而实际测量存在误差，故最终优化目标为
$$
\min_{X} \|AX - B\|_2^2
$$
令其导数为 0，有 $2A^T(AX-B) = 0$，解得
$$
X = (A^TA)^{-1}A^TB
$$
`Locate` 函数基本模拟了这个过程。

