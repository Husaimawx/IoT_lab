function signal = QAM_mod(code, fs, duration, f)

M = 16;
k = log2(M);

%设置每个采样点数据对应的时间
t = (0 : 1 / fs : duration - 1 / fs);                  

%产生同相正交两路载频信号
sigI = sin(2 * pi * f * t);
sigQ = cos(2 * pi * f * t);

sigL = length(sigI); 
sig_cnt = length(code) / k;

% 调制，得到I, Q
dataInMatrix = reshape(code, sig_cnt, k);
dataSymbolsIn = bi2de(dataInMatrix);
dataMod = qammod(dataSymbolsIn, M, 'bin');
I = real(dataMod)';
Q = imag(dataMod)';

% 得到signal
signal = zeros(1, sigL * sig_cnt);
for i = 1 : sig_cnt
    signal((i - 1) * sigL + 1 : i * sigL) = I(i) * sigI + Q(i) * sigQ;
end

disp('Modulation succeed.');
end