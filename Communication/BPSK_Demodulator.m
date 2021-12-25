function codes = BPSK_Demodulator(filename)
[sig,fs] = audioread(filename);
sig = sig';
length(sig)
plot(sig)
time = 0.025;
f = 20e3;
N = fs*time;
t = (0:N-1)/fs;
sigI = sin(2*pi*f*t);
sigQ = cos(2*pi*f*t);
sigL = length(sigI);
sigMat = sqrt(2)/2*(...
    [1;1;-1;-1].*repmat(sigI,4,1)+...
    [1;-1;1;-1].*repmat(sigQ,4,1));
cLen = 2*length(sig)/sigL;
codes = zeros(1,cLen);

for i = 1: cLen/2
    seg = sig((i-1)*sigL+1: i*sigL);
    [~,maxI]=max(sigMat*seg');
    if maxI>2
        codes(2*i-1)=1;
    else
        codes(2*i-1)=0;
    end
    
    if mod(maxI,2)==0
        codes(2*i)=1;
    else
        codes(2*i)=0;
    end
end

end