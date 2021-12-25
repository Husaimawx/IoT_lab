function BPSK_Modulator(codes, filename, sigSNR)
fs = 48000;
T = 0.025;
f = 20e3;
cLen = length(codes);
if mod(cLen, 2)==1
    codes  =[codes,0];
    cLen = cLen+1;
end

N = fs*T;
t = (0:N-1)/fs;
sigI = sin(2*pi*f*t);
sigQ = cos(2*pi*f*t);
sigL = length(sigI);

sig = zeros(1, sigL*cLen/4);
for i = 1:cLen/2
    fI = (1-2*codes(i*2-1))*sqrt(2)/2;
    fQ = (1-2*codes(i*2))*sqrt(2)/2;
    sig((i-1)*sigL+1:i*sigL) = fI * sigI + fQ*sigQ;
end
sig = awgn(sig, sigSNR, 'measured');
sig = sig/max(abs(sig));
audiowrite(filename,sig,fs);
end

