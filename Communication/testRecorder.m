fs = 48000;                                 % 设置采样频率

%% 录制音频
R = audiorecorder(fs, 16 ,1) ;  
disp('Start speaking.')
recordblocking(R, 1);
disp('End of Recording.');
% % 回放录音数据
% play(R);
% 获取录音数据
myRecording = getaudiodata(R);
% 绘制录音数据波形
plot(myRecording);
