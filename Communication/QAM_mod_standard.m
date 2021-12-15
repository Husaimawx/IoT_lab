function signal = QAM_mod_standard(I, Q, fs, duration, f)
% 设置每个采样点数据对应的时间
t = 0 : 1 / fs : duration - 1 / fs;
window = fs * duration;

% 产生同相正交两路载频信号
sigI = sin(2 * pi * f * t);
sigQ = cos(2 * pi * f * t);

% 得到signal
signal = I * sigI + Q * sigQ;
end