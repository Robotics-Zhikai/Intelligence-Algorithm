function Bin_number=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,Dec_number) %输入为十进制数，输出为二进制向量
    digits=ceil(log2((parameter_range_Upper-parameter_range_Low)*(1/Set_precision)+1));
    Dec_number=round((Dec_number-parameter_range_Low) / ((parameter_range_Upper-parameter_range_Low)/(2^digits-1)));
    Sub_Bin_number=dec2bin(Dec_number,digits);
    for i=1:digits
        Bin_number(i)=double(Sub_Bin_number(i))-48;
    end
end