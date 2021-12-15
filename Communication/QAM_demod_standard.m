function [i,q] = QAM_demod_standard(signal, fs, duration, f)
% 设置每个采样点数据对应的时间
t = 0 : 1 / fs : duration - 1 / fs;
window = fs * duration;

% 产生同相正交两路载频信号
sigI = sin(2 * pi * f * t);
sigQ = cos(2 * pi * f * t);

% 解出I,Q

i = signal * sigI' / window * 2;
q = signal * sigQ' / window * 2;

end