function [i, q] = decode_standard(signal, fs, duration, f)
window = fs * duration;
pos = 0;
cnt = 0;
M = 4;
standard_piece_cnt = 3;
i = zeros(1, M);
q = zeros(1, M);
while cnt < M
    cnt = cnt + 1;
    [i_1, q_1] = QAM_demod_standard(signal(pos + 1 : window + pos), fs, duration, f);
    [i_2, q_2] = QAM_demod_standard(signal(window + pos + 1 : 2 * window + pos), fs, duration, f);
    [i_3, q_3] = QAM_demod_standard(signal(2 * window + pos + 1 : 3 * window + pos), fs, duration, f);
    pos = pos + standard_piece_cnt * window;
    i(cnt) = (i_1 + i_2 + i_3) / 3;
    q(cnt) = (q_1 + q_2 + q_3) / 3;
end
end

% [stadnard_i_3, stadnard_i_1, stadnard_i_n3, stadnard_i_n1, stadnard_q_3, stadnard_q_1, stadnard_q_n3, stadnard_q_n1] = 