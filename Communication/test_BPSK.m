clear;
clc;
number = 10;
Code_array = randi([0 1],number,1)
file_name = "test_bpsk.wav";
accuracy =zeros(1,61);
for sigSNR = 10:-1:-50
    temp_accuracy = zeros(1,10);
    for j = 1:10
        BPSK_Modulator(Code_array, file_name, sigSNR)
        codes = BPSK_Demodulator(file_name);
        count = 0;
        for i = 1:number
            if Code_array(i)==codes(i)
                count=count+1;
            end
        end
        temp_accuracy(j)=count/number;
    end
    accuracy(11-sigSNR) = mean(temp_accuracy);
end
plot(10:-1:-50,accuracy)

