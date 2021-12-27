function signal = encode(str, fs, duration, f, chirp_f1, chirp_f2)
%% 定义变量
% 片段长度
window = fs * duration;
% 数据包各部分长度
header_len = 8;
package_whole_len = 64;
payload_len = package_whole_len - header_len;
% chirp信号
t = (0 : 1 / fs : duration - 1 / fs);
chirp_signal = chirp(t, chirp_f1, duration, chirp_f2, 'linear');
% standard
standard_QAM_signal = encode_standard(fs, duration, f);
standard_QAM_signal = standard_QAM_signal / max(standard_QAM_signal);

%% 编码为二进制串
code = string2bin( str )';
code
code_len = length(code);

%% 分割数据
signal = [];
package_cnt = 0;
while code_len > 0
    package_cnt = package_cnt + 1;
    package = [];
    if code_len > payload_len
        package = code(1 : payload_len);
        real_size = payload_len;
        code = code(payload_len + 1 : code_len);
        code_len = code_len - payload_len;
    else
        package = code;
        real_size = code_len;
        code_len = 0;
    end
    
    
    %% payload = header + code
    header_code = uint8tobinary(real_size);
    real_size
    package = [header_code, package];
    payload = QAM_mod(package, fs, duration, f);
    payload = payload / max(payload);

    % partial_signal = 

    %% 拼接信号 package_signal = chirp + standard + payload + zeros
    package_signal = [zeros(1, 20 * window), chirp_signal, standard_QAM_signal, payload];
    signal = [signal, package_signal];
end

% 得到最终信号
signal = [zeros(1, 10 * window), signal, zeros(1, 10 * window)];

% 输出
disp('Modulation succeed.');
disp([num2str(package_cnt), ' package intotal.']);
end