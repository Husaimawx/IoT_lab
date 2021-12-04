function code = QAM_demod(signal, fs, duration, f)
M = 16;
k = log2(M);

window = fs * duration;

%设置每个采样点数据对应的时间
t = (0 : 1 / fs : duration - 1 / fs);

%产生同相正交两路载频信号
sigI = sin(2 * pi * f * t);
sigQ = cos(2 * pi * f * t);

sig_cnt = length(signal) / window;

% 解出I,Q
out_I = zeros(1, sig_cnt);
out_Q = zeros(1, sig_cnt);
for i = 1 : sig_cnt
    temp_sig = signal((i - 1) * window + 1 : i * window);
    out_I(i) = round(temp_sig * sigI' / 600);
    out_Q(i) = round(temp_sig * sigQ' / 600);
end

outI = out_I
OUTQ = out_Q
% 反推二进制码
dataMod = out_I + sqrt (-1) * out_Q
dataSymbolsOut = qamdemod(dataMod,M,'bin')
dataOutMatrix = de2bi(dataSymbolsOut,k)'
code = dataOutMatrix(:);

end