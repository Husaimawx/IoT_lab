clear;
clc;

%% 参数
fs = 48000;                                 % 设置采样频率
duration = 0.025;                           % 指定生成的信号持续时间
f = 1 / duration;                           % 指定声音信号频率

%% 输入英文字符串
% str = 'Tsinghua';
str = input('Please input a string\n','s');
disp('Modulating...');

%% 编码为二进制串
in_code = string2bin( str )';

%% QAM调制信号
in_signal = QAM_mod(in_code, fs, duration, f);
% figure(1);
% plot(in_signal);

%% 生成音频文件
in_signal = in_signal / 4.3;
audiowrite('sender.wav', in_signal, fs);

%% 播放音频
% disp('Playing sound...');
% sound(in_signal, fs);

%% 读取音频文件
[out_signal, fs] = audioread('sender.wav');
out_signal = out_signal * 4.3;

% %% 录制音频
% R = audiorecorder(fs, 16 ,1) ;  
% disp('Start speaking.')
% recordblocking(R, 1);
% disp('End of Recording.');
% % 回放录音数据
% play(R);
% % 获取录音数据
% myRecording = getaudiodata(R);
% % 绘制录音数据波形
% plot(myRecording);
% % 写入音频文件
% audiowrite('receiver.wav', myRecording, fs);

%% QAM 解调信号
out_code = QAM_demod(out_signal', fs, duration, f);

%% 解码为字符串
str = bin2string(out_code)
