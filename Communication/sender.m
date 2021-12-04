clear;
clc;

%% 参数
fs = 48000;                                 % 设置采样频率
duration = 0.025;                           % 指定生成的信号持续时间
f = 1 / duration;                           % 指定声音信号频率
chirp_f1 = 18000;                           % start freq
chirp_f2 = 20500;                           % end freq
preamble_code = [0, 1, 0, 1, 0, 1, 0, 1];

%% 输入英文字符串
% str = '1';
% str = '#include <iostream> using namespace std;';
str = 'When we allow freedom to ring, when we let it ring from every village and hamlet, from every state and city, we will be able to speed up that day when all of Gods children - black men and white men, Jews and Gentiles, Catholics and Protestants - will be able to join hands and to sing in the words of the old Negro spiritual, "Free at last, free at last; thank God Almighty, we are free at last.';
% str = input('Please input a string\n','s');
disp('Modulating...');

signal = encode(str, preamble_code, fs, duration, f, chirp_f1, chirp_f2);
% plot(signal);

%% 生成音频文件
audiowrite('sender.wav', signal, fs);

%% 播放音频
% disp('Playing sound...');
% sound(in_signal, fs);
