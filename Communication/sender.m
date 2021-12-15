clear;
clc;

%% 参数
fs = 48000;                                 % 设置采样频率
duration = 0.025;                           % 指定生成的信号持续时间
f = 6000;                                  % 指定声音信号频率
chirp_f1 = 15000;                           % start freq
chirp_f2 = 18000;                           % end freq
preamble_code = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1];

%% 输入英文字符串
str = '1';
% str = '#include <iostream> using namespace std;';
% str = 'A variety of integrity constraints have been studied for data cleaning. While these constraints can detect the presence of errors, they fall short of guiding us to correct the errors. Indeed, data repairing based on these constraints may not find certain fixes that are absolutely correct, and worse, may introduce new errors when repairing the data. We propose a method for finding certain fixes, based on master data, a notion of certain regions, and a class of editing rules. A certain region is a set of attributes that are assured correct by the users. Given a certain region and master data, editing rules tell us what attributes to fix and how to update them. We show how the method can be used in data monitoring and enrichment. We develop techniques for reasoning about editing rules, to decide whether they lead to a unique fix and whether they are able to fix all the attributes in a tuple, relative to master data and a certain region. We also provide an algorithm to identify minimal certain regions, such that a certain fix is warranted by editing rules and master data as long as one of the regions is correct. We experimentally verify the effectiveness and scalability of the algorithm.';

% str = input('Please input a string\n','s');
disp('Modulating...');

%% 编码
signal = encode(str, preamble_code, fs, duration, f, chirp_f1, chirp_f2);
figure(1);
signal = signal / max(signal);
plot(signal);

% 生成音频文件
audiowrite('sender.wav', signal, fs);
% 
% %% 播放音频
% R = audiorecorder(fs, 16 , 1) ;  
% record(R, 7);
% pause(1)
% sound(signal, fs);
% % 获取录音数据
% pause(4);
% signal_n = getaudiodata(R);
% max(signal_n)
% if max(signal_n) > 1.0
%     signal_n = signal_n / max(signal_n);
% end
% % 绘制录音数据波形 
% figure(2);
% plot(signal_n);
% % 写入音频文件
% audiowrite('receiver.wav', signal_n, fs);
