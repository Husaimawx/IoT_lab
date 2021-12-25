function [ str ] = bin2string( binary )
% 把二进制串转化为字符串
L = length(binary);
str = [];
L = 8 * floor(L / 8);
binary = binary(1 : L);
binary = reshape(binary',[8,L/8]);
binary = binary';
for i=1:L/8
    s= 0;
    for j = 1:8
        s = s+2^(8-j)*binary(i,j);
    end
    str = [str,char(s)];
end
end