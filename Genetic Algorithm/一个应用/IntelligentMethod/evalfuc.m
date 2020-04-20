function [fitness_list,GradeList]=evalfuc(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin) %评价适应度，适应度函数，输入参数根据实际情况而定,这里输入的是二进制的初始化种群
    global column;
    global Area;
%     global column_x2;
%     global column_x3;
%     global column_x4;
%     global column_x5;
    Sum=0;
    for i=1:size(init_list_Bin,1)
        DecNumber = [];
        for numdecn = 1:size(init_list_Bin,2)/column
            DecNumber(numdecn) = Decode(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin(i,(numdecn-1)*column+1 : numdecn*column));
        end
        Area1 = Area;
        record = [];
        Graderecord = [];
        solution = DecNumber;
        for solutioni=1:size(solution,2)
            xy = [ceil(solution(solutioni)/size(Area1,1)),mod(solution(solutioni)-1,size(Area1,1))+1];
            Grade = GetGrade(Area1,xy+[1,1]);
            Graderecord = [Graderecord;Grade];
            if (Grade~=0)
                record = [record,[{xy};Grade]];
            end
            Area1(xy(2),xy(1)) = 0;
        end
        allGrade = 0;
        for recordi=1:size(record,2)
            allGrade = record{2,recordi} + allGrade;
        end
        fitness_list(i,1) = allGrade;
        GradeList{i,1} = Graderecord;
%         fitness_list(i,1)=Dec_number_x1^2+Dec_number_x2^2+3*Dec_number_x3^2+4*Dec_number_x4^2+2*Dec_number_x5^2-8*Dec_number_x1-2*Dec_number_x2-3*Dec_number_x3-Dec_number_x4-2*Dec_number_x5;
        Sum=Sum+fitness_list(i,1); %计算适应度值总和
    end
    for i=1:size(init_list_Bin,1)
        fitness_list(i,2)=fitness_list(i,1)/Sum; %第二列是相应染色体被复制的概率
        if i==1
            fitness_list(i,3)=fitness_list(i,2);
        else
            fitness_list(i,3)=fitness_list(i-1,3)+fitness_list(i,2);
        end
    end
end
