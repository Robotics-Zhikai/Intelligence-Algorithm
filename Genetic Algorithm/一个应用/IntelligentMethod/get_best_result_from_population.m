function [Best_dec_independent,Best_dec_dependent,BestGrade]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,list_Bin_in,GradeList) %从一个种群中得到适应度最好的一个解，输入参数为该种群和该种群的适应度表
    global column;

    Sub_max=fitness_list(1,1);
    row_of_max=1;
    for i=1:size(fitness_list,1) %找到该种群的最大适应度的个体
        if fitness_list(i,1)>Sub_max
            Sub_max=fitness_list(i,1);
            row_of_max=i;
        end
    end
    Best_dec_independent = [];
    for j = 1:size(list_Bin_in,2)/column
        Best_dec_independent(j)=Decode(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_in(row_of_max,(j-1)*column+1:j*column));
    end
    Best_dec_dependent=fitness_list(row_of_max,1);
    BestGrade = GradeList{row_of_max};

end