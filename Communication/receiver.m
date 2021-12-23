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
% [signal, fs] = audioread('receiver.wav');

str = [];
load sender.txt str
str

% % %% 录制音频
% % R = audiorecorder(fs, 16 , 1) ;  
% % record(R, 9);
% % % 获取录音数据
% % pause(9);
% % signal_n = getaudiodata(R);
% % 
% % figure(2);
% % plot(signal_n)
% % 
% % % 写入音频文件
% % audiowrite('receiver.wav', signal_n, fs);
% % signal = signal_n;
% % 
% % 
% % %% 解码
% % signal = signal';
% % str = decode (signal, fs, duration, f, chirp_f1, chirp_f2);
% % 
% % % 输出结果
% % disp(['message:', str]);
% % 
