function init_list_Bin=init_population(parameter_range_Low,parameter_range_Upper,Set_precision,population_number) %��ʼ����Ⱥ����������������ޡ����Ⱥ���Ⱥ����
    for i=1:population_number
        init_list_Bin(i,:)=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,parameter_range_Low+unifrnd(Set_precision,parameter_range_Upper-parameter_range_Low));
    end
end