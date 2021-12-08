function signal = encode(str, preamble_code, fs, duration, f, chirp_f1, chirp_f2)
%% 编码为二进制串
code = string2bin( str )';
code_len = length(code);

%% 生成chirp信号
t = (0 : 1 / fs : duration - 1 / fs);
chirp_signal = chirp(t, chirp_f1, duration, chirp_f2, 'linear');

%% 分割数据并调制
% 前导码 (Preamble) + 包头(Header) + 数据内容段(Payload)
pre_len = length(preamble_code);
header_len = 8;
payload_size = 240;
window = fs * duration;

package = zeros(1, pre_len + header_len + payload_size);
signal = [];
package_cnt = 0;
while code_len > 0
    package_cnt = package_cnt + 1;
    % 数据段部分
    if code_len > payload_size
        package(pre_len + header_len + 1 : pre_len + header_len + payload_size) = code(1 : payload_size);
        real_size = payload_size;
        code = code(payload_size + 1 : code_len);
        code_len = code_len - payload_size;
    else
        package(pre_len + header_len + 1 : pre_len + header_len + code_len) = code;
        real_size = code_len;
        code_len = 0;
    end
    % 前导码部分
    package(1 : pre_len) = preamble_code;    
    % 包头部分
    package(pre_len + 1 : pre_len + header_len) = uint8tobinary(real_size);
    
    whole_length = pre_len + header_len + real_size;

    % 调试输出
    p =  package(1 : pre_len)
    h =  package(pre_len +  1 : pre_len + header_len)

    % QAM调制信号
    part_signal = QAM_mod(package(1 : whole_length), fs, duration, f);

    part_signal = part_signal / 4.3;

    % 拼接信号
    signal = [signal, zeros(1, window), chirp_signal, part_signal];
end
% 得到最终信号
signal = [zeros(1, window), signal, zeros(1, window)];

% 输出
disp('Modulation succeed.');
disp([num2str(package_cnt), ' package intotal.']);
end

function binary_code = uint8tobinary(num)
    binary_code = zeros(1, 8);
    for i = 1 : 8
        binary_code(9-i) = bitand(num, 1);
        num = bitshift(num, -1);
    end
end
