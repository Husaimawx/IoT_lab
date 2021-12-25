function signal = QAM_mod(code, fs, duration, f)
M = 4;
k = log2(M);

% 设置每个采样点数据对应的时间
t = 0 : 1 / fs : duration - 1 / fs;
window = fs * duration;

% 产生同相正交两路载频信号
sigI = sin(2 * pi * f * t);
sigQ = cos(2 * pi * f * t);

% 片元数量
sig_cnt = floor(length(code) / k);

% 调制，得到I, Q
dataInMatrix = reshape(code, k, sig_cnt)';
dataSymbolsIn = bi2de(dataInMatrix);
dataMod = qammod(dataSymbolsIn, M, 'bin');
I = real(dataMod)';
Q = imag(dataMod)';
% 得到signal
signal = zeros(1, window * sig_cnt);
for i = 1 : sig_cnt
    signal((i - 1) * window + 1 : i * window) = I(i) * sigI + Q(i) * sigQ;
end

end