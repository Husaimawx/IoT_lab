clear;
clc;

[signal_sender, ~] = audioread('test_qpsk_sender.wav');
[signal_receiver, ~] = audioread('qpsk.m4a');
% signal_receiver = signal_receiver(:,1);
figure(1)
plot(signal_sender)
figure(2)
plot(signal_receiver(:,1))
figure(3)
plot(signal_receiver(:,2))
% 
% t = abs(finddelay(signal_receiver, signal_sender));
% signal_receiver = signal_receiver(t + 1: length(signal_sender) + t);
% 
% % %% 对录音数据进行滤波
% % hd = design(fdesign.bandpass('N,F3dB1,F3dB2',6,4000,9000,48000),'butter');
% % %用定义好的带通滤波器对data进行滤波
% % signal_receiver = filter(hd,signal_receiver);
% 
% 
% figure(3)
% plot(signal_receiver)
% SNR = snr(signal_receiver, signal_sender)
% 
% sigPower = sum(abs(signal_sender).^2)/length(signal_sender);          %求出信号功率
% noisePower=sum(abs(signal_receiver-signal_sender).^2)/length(signal_receiver-signal_sender);   %求出噪声功率
% SNR=10*log10(sigPower/noisePower)        %由信噪比定义求出信噪比，单位为db