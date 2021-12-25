clear;
clc;

%% 参数
fs = 48000;                                 % 设置采样频率
duration = 0.025;                           % 指定生成的信号持续时间
f = 5000;                                  % 指定声音信号频率
chirp_f1 = 18000;                           % start freq
chirp_f2 = 20000;                           % end freq
preamble_code = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1];

%% 输入英文字符串
str = '1234567890';

%% 生成chirp信号
t = (0 : 1 / fs : duration - 1 / fs);
chirp_signal = chirp(t, chirp_f1, duration, chirp_f2, 'linear');

%% 定义片段长度
window = fs * duration;

%% 编码+调制
code = string2bin( str )';
code = [preamble_code, code];
signal = QPSK_Modulator(code, fs, duration, f);
length(signal)
signal = [10 * zeros(1, window), chirp_signal, 2 * zeros(1, window), signal, 10 * zeros(1, window)];

figure(1);
plot(signal);

% 生成音频文件
audiowrite('test_qpsk_sender.wav', signal, fs);

%% 播放音频
R = audiorecorder(fs, 16 , 1) ;  
record(R, 7);
pause(3)
sound(signal, fs);
% 获取录音数据
pause(4);
signal_n = getaudiodata(R);
figure(2);
plot(signal_n)
% 写入音频文件
audiowrite('test_qpsk_receiver.wav', signal_n, fs);
