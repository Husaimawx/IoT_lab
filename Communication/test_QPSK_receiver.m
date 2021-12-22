clear;
clc;

%% 参数
fs = 48000;                                 % 设置采样频率
duration = 0.025;                           % 指定生成的信号持续时间
f = 5000;                                  % 指定声音信号频率
chirp_f1 = 18000;                           % start freq
chirp_f2 = 20000;                           % end freq
preamble_code = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1];

[signal, fs] = audioread('test_qpsk_receiver.wav');
figure(1)
plot(signal);
signal = signal';
window = fs * duration;
first_chirp_pos = find_chirp(signal, fs, duration, chirp_f1, chirp_f2)
signal = signal(first_chirp_pos + 2 * window + 1: first_chirp_pos + 2 * window + 57600);
figure(2)
plot(signal);
code_out = QPSK_Demodulator(signal, fs, duration, f)
% code_out = code_out(1:8)
str_out = bin2string(code_out)