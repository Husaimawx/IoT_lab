clear;
clc;

%% 参数
duration = 0.025;                           % 指定生成的信号持续时间
f = 6000;                                  % 指定声音信号频率
chirp_f1 = 15000;                           % start freq
chirp_f2 = 18000;                           % end freq
preamble_code = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1];

%% 读取音频文件
[signal, fs] = audioread('sender.wav');
% [signal, fs] = audioread('receiver.wav');

% plot(signal);

%% 录制音频
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

%% 解码
signal = signal';
str = decode (signal, preamble_code, fs, duration, f, chirp_f1, chirp_f2);

%% 输出结果
disp(['message:', str]);