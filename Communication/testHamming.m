clear;
clc;

real_size = 1;
real_size_bin = uint8tobinary(real_size)
encode = hamming_encode(real_size_bin)
% decode = hamming_decode(encode)
% 
% % 计算数据包长度
% payload_length = 0;
% x = 1;
% for i = 1:8
%     payload_length = payload_length + decode(9 - i) * x;
%     x = x * 2;
% end
% payload_length

