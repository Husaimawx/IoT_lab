function num = binarytouint8(binary_code)
    num = 0;
    x = 1;
    for i = 1:8
        num = num + binary_code(9 - i) * x;
        x = x * 2;
    end
end