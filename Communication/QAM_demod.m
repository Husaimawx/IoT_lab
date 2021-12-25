function code = QAM_demod(signal, standard_i, standard_q, fs, duration, f)
M = 4;
k = log2(M);

window = fs * duration;

%设置每个采样点数据对应的时间
t = (0 : 1 / fs : duration - 1 / fs);

%产生同相正交两路载频信号
sigI = sin(2 * pi * f * t);
sigQ = cos(2 * pi * f * t);

sig_cnt = floor(length(signal) / window);

% 解出I,Q
out_I = zeros(1, sig_cnt);
out_Q = zeros(1, sig_cnt);
for i = 1 : sig_cnt
    part_sig = signal((i - 1) * window + 1 : i * window);
    out_I(i) = part_sig * sigI' / window * 2;
    out_Q(i) = part_sig * sigQ' / window * 2;
end
[actual_i, actual_q] = getActualIQ(out_I, out_Q, standard_i, standard_q);
figure(7)
scatter(out_I, out_Q);
% out_I
% out_Q
% actual_i
% actual_q
% 反推二进制码
dataMod = actual_i + sqrt (-1) * actual_q;
dataSymbolsOut = qamdemod(dataMod,M,'bin');
dataOutMatrix = de2bi(dataSymbolsOut,k)';
code = dataOutMatrix(:);

end

function [actual_i, actual_q] = getActualIQ(out_I, out_Q, standard_i, standard_q)
M = 4;
standard_map_i = [1, 1, -1, -1];
standard_map_q = [1, -1, 1, -1];
actual_i = zeros(1, length(out_I));
actual_q = zeros(1, length(out_Q));
for index = 1 : length(out_I)
    current_point = [out_I(index), out_Q(index)];
    min_dis = 1000;
    min_index = -1;
    for k = 1 : M
        s_point = [standard_i(k), standard_q(k)];
        dis = norm(s_point - current_point);
        if dis < min_dis 
            min_dis = dis;
            min_index = k;
        end
    end
    actual_i(index) = standard_map_i(min_index);
    actual_q(index) = standard_map_q(min_index);
end


% 16QAM
% standard_map_i = [3, 3, 3, 3, 1, 1, 1, 1, -1, -1, -1, -1, -3, -3, -3, -3];
% standard_map_q = [3, 1, -1, -3, 3, 1, -1, -3, 3, 1, -1, -3, 3, 1, -1, -3];
% actual_i = zeros(1, length(out_I));
% actual_q = zeros(1, length(out_Q));
% for index = 1 : length(out_I)
%     current_point = [out_I(index), out_Q(index)];
%     min_dis = 1000;
%     min_index = -1;
%     for k = 1 : 16
%         s_point = [standard_i(k), standard_q(k)];
%         dis = norm(s_point - current_point);
%         if dis < min_dis 
%             min_dis = dis;
%             min_index = k;
%         end
%     end
%     min_index
%     actual_i(index) = standard_map_i(min_index);
%     actual_q(index) = standard_map_q(min_index);
% end
end






function v = getNearest(v_o)
v = [];
for i = 1 : length(v_o)
    min_dis = 10;
    temp = v_o(i);
    nearest = 0;
    if abs(temp - 3) < min_dis
        min_dis = abs(temp - 3);
        nearest = 3;
    end
    if abs(temp - 1) < min_dis
        min_dis = abs(temp - 1);
        nearest = 1;
    end
    if abs(temp + 1) < min_dis
        min_dis = abs(temp + 1);
        nearest = -1;
    end
    if abs(temp + 3) < min_dis
        min_dis = abs(temp + 3);
        nearest = -3;
    end
    v = [v, nearest];
end
end