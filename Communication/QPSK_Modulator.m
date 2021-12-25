function signal = QPSK_Modulator(codes, fs, duration, f)
cLen = length(codes);
%生成I信号和Q信号
sigI = sin(2 * pi * f * (0 : 1/fs : duration - 1/fs));
sigQ = cos(2 * pi * f * (0 : 1/fs : duration - 1/fs));

%生成两路基带信号，并相加
sigL = length(sigI);
signal = zeros(1, sigL * cLen / 2);
for i = 1 : cLen / 2
    fI = (1 - 2 * codes(i * 2 - 1)) * sqrt(2) / 2;
    fQ = (1 - 2 * codes(i * 2)) * sqrt(2) / 2;
    signal((i - 1) * sigL + 1 : i * sigL) = fI * sigI + fQ * sigQ;
end

%将信号幅度恢复为1
signal = signal / max(abs(signal));
end