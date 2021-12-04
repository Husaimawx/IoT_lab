%%
% TCP连接，IP地址和端口可以自己设置，只需保证设备A和设备B一致即可
IP = '0.0.0.0';
PortN = 20000;

%设备B发送调频连续波信号(chirp)，频率从6000Hz变化到8000Hz，持续0.5秒
fs = 48000;
T = 0.5;
f1 = 4000; f2 = 6000; f3 = 8000;
t = linspace(0, T, fs * T);
y = chirp(t, f2, T, f3);
%%
% 启动TCP连接的客户端
Client = tcpip(IP, PortN, 'NetworkRole', 'client');
fopen(Client);
%%
Rec = audiorecorder(fs, 16, 1);
rdy = fgetl(Client);                            %客户端收到服务端准备就绪的消息
fprintf(Client, 'Client Ready');    %客户端发送消息给服务端，设备B准备开始发送声波
record(Rec, T * 6);                             %设备B开始录音
pause(T * 3);                                           %接收设备A发送的声音
soundsc(y, fs, 16);                             %设备B发送声音
pause(T * 3);                                           %等待录音结束
%%
recvData = getaudiodata(Rec)';
spectrogram(recvData, 128, 120, 128, fs);

%找到信号起始位置
z1 = chirp(t, f1, T, f2); z1 = z1(end : -1 : 1);
z2 = chirp(t, f2, T, f3); z2 = z2(end : -1 : 1);
[~, p1] = max(conv(recvData, z1, 'valid'));
[~, p2] = max(conv(recvData, z2, 'valid'));

%将计算的信号起始位置差发送给服务端
psub = num2str(p2 - p1);
fprintf(Client, psub);

%从频谱图中可以比对找到的信号开始位置是否准确
p1 = (p1 - 1) / fs;
p2 = (p2 - 1) / fs;
hold on;
plot([0, fs / 1000 / 2], [p1, p1], 'r-');
plot([0, fs / 1000 / 2], [p2, p2], 'b-');
%%
fclose(Client);