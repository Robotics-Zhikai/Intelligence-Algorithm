function Dec_number=Decode(parameter_range_Low,parameter_range_Upper,Set_precision,Bin_number) %����Ϊ�����������������Ϊ10������
    Sub_dec=0;
    for i=1:size(Bin_number,2)
        Sub_dec=Sub_dec+Bin_number(size(Bin_number,2)-i+1)*2^(i-1);
    end
    Dec_number=parameter_range_Low+Sub_dec* ( (parameter_range_Upper-parameter_range_Low) / (2^size(Bin_number,2)-1) );
    
    Dec_number = round(Dec_number);

end