function str = decode(signal, preamble_code, fs, duration, f, chirp_f1, chirp_f2)
figure(1);
plot(signal);
signal = signal';

%% TODO： 短信号解调
window = fs * duration;
pre_len = length(preamble_code);
header_len = 8;
massage = [];
%% 寻找目标信号
cut_size = 0;
chirp_pos = find_chirp(signal, fs, duration, chirp_f1, chirp_f2)
while cut_size + window < length(signal)
%     length(signal)
    start_pos = chirp_pos + window;
    %% 除去chirp
    signal = signal(start_pos - cut_size - 1: length(signal));
%     cut_pos = start_pos - cut_size;
    cut_size = start_pos - 1;
    
    temp_preamble_code = QAM_demod(signal(1 : 4 * window), fs, duration, f)';
    preamble_code = temp_preamble_code(1 : pre_len)
    header_code = temp_preamble_code(pre_len + 1 : pre_len + header_len)
    
    payload_length = 0;
    x = 1;
    for i = 1:8
        payload_length = payload_length + header_code(9 - i) * x;
        x = x * 2;
    end
    payload_length
    whole_length = pre_len + header_len + payload_length
    ans = (whole_length / 4) * window
    %% QAM 解调信号
    payload = QAM_demod(signal(1 : (whole_length / 4) * window), fs, duration, f)';
    payload = payload(pre_len + header_len + 1 : pre_len + header_len + payload_length);
    massage = [massage, payload];
    signal = signal(whole_length / 4 * window : length(signal));
     
%% 找chirp起始位置
    chirp_pos = cut_size + find_chirp(signal, fs, duration, chirp_f1, chirp_f2);
end

%% 解码为字符串
str = bin2string(massage);

end