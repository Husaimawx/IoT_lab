function [stadnard_i_3, stadnard_i_1, stadnard_i_n3, stadnard_i_n1, stadnard_q_3, stadnard_q_1, stadnard_q_n3, stadnard_q_n1] = decode_standard(signal, fs, duration, f)
figure(1)
plot(signal)
window = fs * duration;
figure(2)
plot(signal(window + 1: 2 * window))
[stadnard_i_3, stadnard_q_3] = QAM_demod_standard(signal(window + 1: 2 * window), fs, duration, f);
figure(3)
plot(signal(3 * window + 1: 4 * window))
[stadnard_i_1, stadnard_q_1] = QAM_demod_standard(signal(3 * window + 1: 4 * window), fs, duration, f);
figure(4)
plot(signal(5 * window + 1: 6 * window))
[stadnard_i_n1, stadnard_q_n1] = QAM_demod_standard(signal(5 * window + 1: 6 * window), fs, duration, f);
figure(5)
plot(signal(7 * window + 1: 8 * window))
[stadnard_i_n3, stadnard_q_n3] = QAM_demod_standard(signal(7 * window + 1: 8 * window), fs, duration, f);
end