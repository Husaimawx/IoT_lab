function binary_code = uint8tobinary(num)
    binary_code = zeros(1, 8);
    for i = 1 : 8
        binary_code(9 - i) = bitand(num, 1);
        num = bitshift(num, -1);
    end
end
