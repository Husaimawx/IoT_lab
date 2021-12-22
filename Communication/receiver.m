clear;
clc;

%% 参数
fs = 48000;
duration = 0.025;                           % 指定生成的信号持续时间
f = 6000;                                  % 指定声音信号频率
chirp_f1 = 15000;                           % start freq
chirp_f2 = 18000;                           % end freq

%% 读取音频文件
% [signal, fs] = audioread('sender.wav');
[signal, fs] = audioread('receiver.wav');

figure(1)
plot(signal);

%% 解码
signal = signal';
str = decode (signal, fs, duration, f, chirp_f1, chirp_f2);

% 输出结果
disp(['message:', str]);