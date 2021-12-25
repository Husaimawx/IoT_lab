function str = decode(signal, fs, duration, f, chirp_f1, chirp_f2)
%% 定义变量
% 片段长度
window = fs * duration;
% 数据包各部分长度
header_len = 8;
package_whole_len = 64;
payload_len = package_whole_len - header_len;

% QAM参数
M = 4;
standard_piece_cnt = 3;
standard_part_length = standard_piece_cnt * M * window;
standard_signal = encode_standard(fs, duration, f);

%% 拆分数据包 
[start_pos, end_pos] = find_package(signal, window);
start_pos
end_pos
str = [];
package_cnt = length(start_pos)
for i = 1 : package_cnt
    % 截取数据包     
    package_signal = signal(start_pos(i) : end_pos(i));
    if end_pos(i) - start_pos(i) < window + standard_part_length
        return
    end
    % 寻找目标信号
    first_chirp_pos = find_chirp(package_signal, fs, duration, chirp_f1, chirp_f2);
    temp_signal = package_signal(first_chirp_pos : first_chirp_pos + 2 * window + standard_part_length);
    delaytime = finddelay(standard_signal, temp_signal);
    temp_signal = package_signal(first_chirp_pos + delaytime: first_chirp_pos + delaytime + standard_part_length);
    [standard_i, standard_q] = decode_standard(temp_signal, fs, duration, f);
    figure(2)
    scatter(standard_i,standard_q);
    
    payload_signal = package_signal(first_chirp_pos + delaytime + standard_part_length: length(package_signal));
    package = QAM_demod(payload_signal, standard_i, standard_q, fs, duration, f)';
    header = package(1 : 8);
    data_code_length = binarytouint8(header);
    data_code_length
    data_code = package(9 : data_code_length + 8);
    part_str = bin2string(data_code);
    str = [str, part_str];
end