clear;
clc;

%% 参数
fs = 48000;                                 % 设置采样频率
duration = 0.025;                           % 指定生成的信号持续时间
f = 1 / duration;                           % 指定声音信号频率
chirp_f1 = 18000;                           % start freq
chirp_f2 = 20500;                           % end freq
preamble_code = [0, 1, 0, 1, 0, 1, 0, 1];

window = fs * duration;

% %% 读取音频文件
[signal, fs] = audioread('sender.wav');


% %% 录制音频
% R = audiorecorder(fs, 16 , 1) ;  
% disp('Start speaking.')
% recordblocking(R, 7);
% disp('End of Recording.');
% % 回放录音数据
% play(R);
% % 获取录音数据
% signal = getaudiodata(R);
% % 绘制录音数据波形
% plot(signal);
% % 写入音频文件
% audiowrite('receiver.wav', signal, fs);

signal = signal * 4.3;
str = decode (signal, preamble_code, fs, duration, f, chirp_f1, chirp_f2);
disp(['message:', str]);