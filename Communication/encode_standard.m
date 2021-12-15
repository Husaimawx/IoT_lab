function signal = encode_standard(fs, duration, f)
window = fs * duration;
QAM_33 = QAM_mod_standard(3, 3, fs, duration, f);
QAM_11 = QAM_mod_standard(1, 1, fs, duration, f);
QAM_n1n1 = QAM_mod_standard(-1, -1, fs, duration, f);
QAM_n3n3 = QAM_mod_standard(-3, -3, fs, duration, f);
signal = [zeros(1, window), QAM_33, zeros(1, window), QAM_11, zeros(1, window), QAM_n1n1, zeros(1, window), QAM_n3n3, zeros(1, window)];
end