function codes = QPSK_Demodulator(signal, fs, duration, f)
% [sig, fs] = audioread([fileName, '.wav']);
% sig = sig';

%生成I信号和Q信号
sigI = sin(2 * pi * f * (0 : 1/fs : duration - 1/fs));
sigQ = cos(2 * pi * f * (0 : 1/fs : duration - 1/fs));

%生成星座图上的4个点对应的标准基带信号，保存在一个4行的矩阵中
sigL = length(sigI);
sigMat = sqrt(2) / 2 * (...
    [1; 1; -1; -1] .* repmat(sigI, 4, 1) + ...
    [1; -1; 1; -1] .* repmat(sigQ, 4, 1));

cLen = 2 * length(signal) / sigL;
codes = zeros(1, cLen);

for i = 1 : cLen / 2
    seg = signal((i - 1) * sigL + 1 : i * sigL);
    %通过积分的方式（积分针对的是连续信号，离散信号则是对点积求和），判断当前的这一段信号和哪个标准信号距离最近。积分的结果越大代表两个信号越相似。
    [~, maxI] = max(sigMat * seg');
    codes(2 * i - 1) = maxI > 2;
    codes(2 * i) = mod(maxI, 2) == 0;
end

end