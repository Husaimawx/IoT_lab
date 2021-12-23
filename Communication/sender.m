clear;
clc;

%% 参数
fs = 48000;
duration = 0.025;                           % 指定生成的信号持续时间
f = 6000;                                  % 指定声音信号频率
chirp_f1 = 15000;                           % start freq
chirp_f2 = 18000;                           % end freq

%% 输入英文字符串
% str = 'When the summer holiday comes, students will ';

%% 生成随机串
symbols = '!' : '~';
stLength = 200;
nums = randi(numel(symbols),[1 stLength]);
str = symbols (nums);
save sender.txt -ascii str

%% 编码
signal = encode(str, fs, duration, f, chirp_f1, chirp_f2);

%% 波形图
figure(1);
plot(signal);

% %% 生成音频文件
audiowrite('sender.wav', signal, fs);