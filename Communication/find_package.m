function [start_pos, end_pos] = find_package(signal, window)
window_size = 4800;
signal = signal(window : length(signal));
% 获得包络线
temp_signal = abs(hilbert(signal));
figure(2)
plot(temp_signal);
% 滑动平均
temp_signal = MovingAverageFilter(temp_signal, window_size);

figure(3)
plot(temp_signal);

locs = find(temp_signal > 0.05 - 0.003 & temp_signal < 0.05 + 0.003);
temp = locs(1);
res_locs = temp;
for i = 2 : length(locs)
    if locs(i) - temp < window
        i = i + 1;
    else 
        temp = locs(i);
        res_locs = [res_locs, temp];
    end
end

locs = res_locs;
res_locs

if rem(length(locs), 2) ~= 0
    start_pos = [];
    end_pos = [];
    return
end

start_pos = zeros(1, length(locs) / 2);
end_pos = zeros(1, length(locs) / 2);
for i = 1 : length(locs) / 2
    start_pos(i) = locs(2 * i - 1) - window_size;
    end_pos(i) = locs(2 * i) + window_size;
end
end

function x1 = MovingAverageFilter(x,win_sz)
L = length(x);
x1 = zeros(L,1);

half_win = ceil(win_sz/2);
half_win_ = floor(win_sz/2);

if half_win==half_win_
    half_win = half_win+1;
end

x1(1:half_win) = x(1:half_win);
x1(L-half_win:L) = x(L-half_win:L);

for i = half_win:L-half_win
    k=0;
    for j = i-half_win_:i+half_win_  %对第i个窗里面的数求平均
        k = k+1;
        temp(k) = x(j) ; %临时存储第i个窗的数据
    end
    x1(i) = mean(temp); %第i个窗里面的平均值给第i个数
end
end