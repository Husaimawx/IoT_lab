%%
% TCP连接，IP地址和端口可以自己设置，只需保证设备A和设备B一致即可
IP = '0.0.0.0';
PortN = 20000;

%设备A发送调频连续波信号(chirp)，频率从4000Hz变化到6000Hz，持续0.5秒
fs = 48000;
T = 1;
f1 = 6000; f2 = 8000; f3 = 10000;
t = linspace(0, T, fs * T);
y = chirp(t, f1, T, f2);
%%
% 启动TCP连接的服务端
Server = tcpip(IP, PortN, 'NetworkRole', 'server');
x=1
fopen(Server);
x=2
%%
Rec = audiorecorder(fs, 16, 1);
fprintf(Server, 'Server Ready');      %服务端发送消息给客户端，设备A准备开始发送声波
rdy = fgetl(Server);                         %服务端收到客户端准备就绪的消息
record(Rec, T * 9);                             %设备A开始录音
soundsc(y, fs, 16);                        %设备A发送声音
pause(T * 9);                                           %等待录音结束
%%
recvData = getaudiodata(Rec)';
spectrogram(recvData, 128, 120, 128, fs);

%找到信号起始位置
z1 = chirp(t, f1, T, f2); z1 = z1(end : -1 : 1);
z2 = chirp(t, f2, T, f3); z2 = z2(end : -1 : 1);
[~, p1] = max(conv(recvData, z1, 'valid'));
[~, p2] = max(conv(recvData, z2, 'valid'));

%从频谱图中可以比对找到的信号开始位置是否准确
p1 = (p1 - 1) / fs
p2 = (p2 - 1) / fs
hold on;
plot([0, fs / 1000 / 2], [p1, p1], 'r-');
plot([0, fs / 1000 / 2], [p2, p2], 'b-');

%从客户端处收到设备B计算的信号起始位置差，转换成时间差
psub = fgetl(Server)
psub = str2double(psub) / fs

%声速取343m/s，设备A和设备B自身的麦克风与扬声器间距取值20cm
dAA = 0.1;
dBB = 0.1;
fprintf('Result: %f\n', 343 / 2 * (p2 - p1 - psub) + (dAA + dBB) / 2);

%%
fclose(Server);