function str = decode(signal, preamble_code, fs, duration, f, chirp_f1, chirp_f2)

window = fs * duration;

%% 定义长度
whole_signal_length = length(signal);
pre_len = length(preamble_code);
header_len = 12;
front_piece_cnt = (pre_len + header_len) / 4;

massage = [];
%% 寻找目标信号
cut_size = 0;
first_chirp_pos = find_chirp(signal, fs, duration, chirp_f1, chirp_f2);
standard_signal = signal(first_chirp_pos + window: first_chirp_pos + 9 * window);
[stadnard_i_3, stadnard_i_1, stadnard_i_n3, stadnard_i_n1, stadnard_q_3, stadnard_q_1, stadnard_q_n3, stadnard_q_n1] = decode_standard(standard_signal, fs, duration, f);
stadnard_i_3
stadnard_i_1
stadnard_i_n3
stadnard_i_n1
stadnard_q_3
stadnard_q_1
stadnard_q_n3
stadnard_q_n1
str = '123';
% package_cnt = 0;
% while chirp_pos + window < whole_signal_length
%     chirp_pos
%     package_cnt = package_cnt + 1;
% 
%     start_pos = chirp_pos + window;
% 
%     % 除去chirp
%     signal = signal(start_pos - cut_size - 1: length(signal));
%     cut_size = start_pos - 1;
%     
%     % 解出前导码和包头 
%     temp_preamble_code = QAM_demod(signal(1 : front_piece_cnt * window), fs, duration, f)'
%     
%     % 包头信息
% %     preamble_code = temp_preamble_code(1 : pre_len)
%     header_code = temp_preamble_code(pre_len + 1 : pre_len + header_len);
%     
%     % 计算数据包长度
%     data_length = hamming_decode(header_code);
%     real_length = binarytouint8(data_length)
% 
%     whole_length = pre_len + header_len + real_length;
%     length_in_signal = (whole_length / 4) * window;
% 
%     % QAM 解调信号
%     payload = QAM_demod(signal(front_piece_cnt * window + 1 : length_in_signal), fs, duration, f)';
%     
%     % 拼接
%     massage = [massage, payload];
%     
%     % 截取signal
%     signal = signal(whole_length / 4 * window : length(signal));
%     
%     if length(signal) < window + pre_len + header_len
%         break;
%     end
% 
%     % 在剩下部分中找chirp起始位置
%     chirp_pos = cut_size + find_chirp(signal, fs, duration, chirp_f1, chirp_f2);
% 
% end
% 
% % 输出
% disp('Demodulation succeed.');
% disp([num2str(package_cnt), ' package intotal.']);
% 
% %% 解码为字符串
% str = bin2string(massage);
end