
function [X] = location(nodes, distances)
%     nodes = [0, 0; 2, 0; 1, 1.732];    % 定位信标的坐标
%     distances = [1.155, 1.155, 1.155]; % 定位目标点到多个定位信标的距离
    n = length(distances);
    A = [];
    B = [];
    xn = nodes(n, 1);
    yn = nodes(n, 2);
    dn = distances(n);
    for i = 1:n-1
        xi = nodes(i, 1);
        yi = nodes(i, 2);
        di = distances(i);
        A = [A; 2 * (xi - xn), 2 * (yi - yn)];
        B = [B; xi * xi + yi *yi - xn * xn - yn * yn + dn * dn - di * di];
    end    %计算线性方程组的参数A和B

    X = inv(A'*A)*A'*B;   %根据最小二乘法公式计算结果X
end