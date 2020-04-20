function [Best_dec_independent,Best_dec_dependent,BestGrade]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,list_Bin_in,GradeList) %��һ����Ⱥ�еõ���Ӧ����õ�һ���⣬�������Ϊ����Ⱥ�͸���Ⱥ����Ӧ�ȱ�
    global column;

    Sub_max=fitness_list(1,1);
    row_of_max=1;
    for i=1:size(fitness_list,1) %�ҵ�����Ⱥ�������Ӧ�ȵĸ���
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