function init_list_Bin=init_population(parameter_range_Low,parameter_range_Upper,Set_precision,population_number) %初始化种群，输入参数的上下限、精度和种群数量
    for i=1:population_number
        init_list_Bin(i,:)=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,parameter_range_Low+unifrnd(Set_precision,parameter_range_Upper-parameter_range_Low));
    end
end