function [fitness_list,GradeList,init_list_Bin]=evalfuc(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin) %评价适应度，适应度函数，输入参数根据实际情况而定,这里输入的是二进制的初始化种群
    global column;
    global Area;
%     global column_x2;
%     global column_x3;
%     global column_x4;
%     global column_x5;
    Sum=0;
    for i=1:size(init_list_Bin,1)
%         DecNumber = [];
%         for numdecn = 1:size(init_list_Bin,2)/column
%             DecNumber(numdecn) = Decode(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin(i,(numdecn-1)*column+1 : numdecn*column));
%         end
        DecNumber = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin(i,:));
        Area1 = Area;
        record = [];
        Graderecord = [];
        solution = DecNumber;
        recordsolutioni = [];
        for solutioni=1:size(solution,2)
            xy = [ceil(solution(solutioni)/size(Area1,1)),mod(solution(solutioni)-1,size(Area1,1))+1];
            Grade = GetGrade(Area1,xy+[1,1]);
            if (Grade>0)
                record = [record,[{xy};Grade]];
                Graderecord = [Graderecord;Grade];
                recordsolutioni = [recordsolutioni;solution(solutioni)];%存储有效的挖掘顺序
            end
            Area1(xy(2),xy(1)) = 0;
        end
        allGrade = 0;
        for recordi=1:size(record,2)
            allGrade = record{2,recordi} + allGrade;
        end
        for Area1x = 1:size(Area1,2)
            for Area1y = 1:size(Area1,1)
                if (Area1(Area1y,Area1x) == 1)
                    Grade = GetGrade(Area1,[Area1x,Area1y]+[1,1]);
                    allGrade = allGrade + Grade;
                    Graderecord = [Graderecord;Grade];
                    recordsolutioni = [recordsolutioni;(Area1x-1)*size(Area1,1)+Area1y];
                end
            end
        end
%         a(1,:) = init_list_Bin(i,:);
        init_list_Bin(i,:) = Getchromosome(parameter_range_Low,parameter_range_Upper,Set_precision,recordsolutioni');
%         a(2,:) = init_list_Bin(i,:);
        fitness_list(i,1) = allGrade;
        GradeList{i,1} = Graderecord;
%         fitness_list(i,1)=Dec_number_x1^2+Dec_number_x2^2+3*Dec_number_x3^2+4*Dec_number_x4^2+2*Dec_number_x5^2-8*Dec_number_x1-2*Dec_number_x2-3*Dec_number_x3-Dec_number_x4-2*Dec_number_x5;
        Sum=Sum+fitness_list(i,1); %计算适应度值总和
    end
    avg = mean(fitness_list)
    maxs = max(fitness_list)
    mins = min(fitness_list)
    for i=1:size(init_list_Bin,1)
        fitness_list(i,2)=fitness_list(i,1)/Sum; %第二列是相应染色体被复制的概率
        if i==1
            fitness_list(i,3)=fitness_list(i,2);
        else
            fitness_list(i,3)=fitness_list(i-1,3)+fitness_list(i,2);
        end
    end
end
