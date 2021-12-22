clear;
clc;

%% 参数
fs = 48000;
duration = 0.025;                           % 指定生成的信号持续时间
f = 6000;                                  % 指定声音信号频率
chirp_f1 = 15000;                           % start freq
chirp_f2 = 18000;                           % end freq

%% 输入英文字符串
str = '012345678901234567890123456789tsinghua012345678901234567890123456789tsinghua012345678901234567890123456789tsinghua';
%% 编码
signal = encode(str, fs, duration, f, chirp_f1, chirp_f2);

%% 波形图
figure(1);
plot(signal);

% %% 生成音频文件
% audiowrite('sender.wav', signal, fs);


%% 播放音频
R = audiorecorder(fs, 16 , 1) ;  
record(R, 20);
pause(1)
sound(signal, fs);
% 获取录音数据
pause(18);
signal_n = getaudiodata(R);

figure(2);
plot(signal_n)

% 写入音频文件
audiowrite('receiver.wav', signal_n, fs);
