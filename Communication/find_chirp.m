function start_pos = find_chirp(signal, fs, duration, chirp_f1, chirp_f2)
    t = (0 : 1 / fs : duration - 1 / fs);  
    c = chirp(t, chirp_f1, duration, chirp_f2); 
    c = c(end : -1 : 1);
    figure(1)
    plot(signal)

    hd = design(fdesign.bandpass('N,F3dB1,F3dB2', 6, chirp_f1 - 1000, chirp_f2 + 1000, fs), 'butter');
    signal = filter(hd, signal);
    
    figure(2)
    plot(signal)

    [~, start_pos] = max(conv(signal, c, 'valid'));
    start_pos = start_pos - 5;
end