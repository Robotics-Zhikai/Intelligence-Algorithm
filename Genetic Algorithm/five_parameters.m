clc
clear
close all
%本程序求的是这个x1(i1)^2+x2(i2)^2+3*x3(i3)^2+4*x4(i4)^2+2*x5(i5)^2-8*x1(i1)-2*x2(i2)-3*x3(i3)-x4(i4)-2*x5(i5)的极值
Set_precision=0.0001;
population_number=80;  %初始种群数量
Mating_probability=0.4; %交配概率
Mutation_probability=0.001; %突变概率
Gen=1500; %迭代代数
%最大值为1.02e5
%1.027e5
%1.028e5
%%
%当自变量有5个时
% x1=0:0.01:100;
% x2=0:0.01:100;
% x3=0:0.01:70;
% x4=0:0.01:80;
% x5=0:0.01:150;
% k=1;
% for i1=1:size(x1,2)
%     for i2=1:size(x2,2)
%         for i3=1:size(x3,2)
%             for i4=1:size(x4,2)
%                 for i5=1:size(x5,2)
%                     result(k)=x1(i1)^2+x2(i2)^2+3*x3(i3)^2+4*x4(i4)^2+2*x5(i5)^2-8*x1(i1)-2*x2(i2)-3*x3(i3)-x4(i4)-2*x5(i5);
%                     k=k+1;
%                 end
%             end
%         end
%     end
% end

parameter_x1_range_low=0;
parameter_x2_range_low=0;
parameter_x3_range_low=0;
parameter_x4_range_low=0;
parameter_x5_range_low=0;
parameter_x1_range_upper=100;
parameter_x2_range_upper=100;
parameter_x3_range_upper=70;
parameter_x4_range_upper=80;
parameter_x5_range_upper=150;

%构建染色体
population_x1=init_population(parameter_x1_range_low,parameter_x1_range_upper,Set_precision,population_number);
population_x2=init_population(parameter_x2_range_low,parameter_x2_range_upper,Set_precision,population_number);
population_x3=init_population(parameter_x3_range_low,parameter_x3_range_upper,Set_precision,population_number);
population_x4=init_population(parameter_x4_range_low,parameter_x4_range_upper,Set_precision,population_number);
population_x5=init_population(parameter_x5_range_low,parameter_x5_range_upper,Set_precision,population_number);
population=[population_x1,population_x2,population_x3,population_x4,population_x5];

global column_x1;
column_x1=size(population_x1,2);
global column_x2;
column_x2=size(population_x2,2);
global column_x3;
column_x3=size(population_x3,2);
global column_x4;
column_x4=size(population_x4,2);
global column_x5;
column_x5=size(population_x5,2);

parameter_range_Low=[parameter_x1_range_low;parameter_x2_range_low;parameter_x3_range_low;parameter_x4_range_low;parameter_x5_range_low];%这是常矩阵
parameter_range_Upper=[parameter_x1_range_upper;parameter_x2_range_upper;parameter_x3_range_upper;parameter_x4_range_upper;parameter_x5_range_upper];%这是常矩阵

fitness_list=eval(parameter_range_Low,parameter_range_Upper,Set_precision,population);
for i=1:Gen
    population=operate_copy(fitness_list,population);
    population=Mating_operation(Mating_probability,population);
    population=Mutation_operate(Mutation_probability,population);
    fitness_list=eval(parameter_range_Low,parameter_range_Upper,Set_precision,population);
    [Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,population); %从一个种群中得到适应度最好的一个解，输入参数为该种群和该种群的适应度表
    subplot(121)
    plot(i,Best_dec_dependent,'.');
    xlabel('代数')
    ylabel('Best_dec_dependent')
    hold on;
    subplot(122)
    plot(i,mean(fitness_list(:,1)),'.');
    xlabel('代数')
    ylabel('average（each generation）') %从这里可以看到优势种群的进化
    hold on;
    drawnow;
end
%%
%% 函数
function Bin_number=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,Dec_number) %输入为十进制数，输出为二进制向量
    digits=ceil(log2((parameter_range_Upper-parameter_range_Low)*(1/Set_precision)+1));
    Dec_number=round((Dec_number-parameter_range_Low) / ((parameter_range_Upper-parameter_range_Low)/(2^digits-1)));
    Sub_Bin_number=dec2bin(Dec_number,digits);
    for i=1:digits
        Bin_number(i)=double(Sub_Bin_number(i))-48;
    end
end

function Dec_number=Decode(parameter_range_Low,parameter_range_Upper,Set_precision,Bin_number) %输入为二进制数向量，输出为10进制数
    Sub_dec=0;
    for i=1:size(Bin_number,2)
        Sub_dec=Sub_dec+Bin_number(size(Bin_number,2)-i+1)*2^(i-1);
    end
    Dec_number=parameter_range_Low+Sub_dec* ( (parameter_range_Upper-parameter_range_Low) / (2^size(Bin_number,2)-1) );
end

function init_list_Bin=init_population(parameter_range_Low,parameter_range_Upper,Set_precision,population_number) %初始化种群，输入参数的上下限、精度和种群数量
    for i=1:population_number
        init_list_Bin(i,:)=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,parameter_range_Low+unifrnd(Set_precision,parameter_range_Upper-parameter_range_Low));
    end
end

function fitness_list=eval(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin) %评价适应度，适应度函数，输入参数根据实际情况而定,这里输入的是二进制的初始化种群
    global column_x1;
    global column_x2;
    global column_x3;
    global column_x4;
    global column_x5;
    Sum=0;
    for i=1:size(init_list_Bin,1)
        Dec_number_x1=Decode(parameter_range_Low(1,:),parameter_range_Upper(1,:),Set_precision,init_list_Bin(i,1:column_x1));
        Dec_number_x2=Decode(parameter_range_Low(2,:),parameter_range_Upper(2,:),Set_precision,init_list_Bin(i,column_x1+1:column_x1+column_x2));
        Dec_number_x3=Decode(parameter_range_Low(3,:),parameter_range_Upper(3,:),Set_precision,init_list_Bin(i,column_x1+column_x2+1:column_x1+column_x2+column_x3));
        Dec_number_x4=Decode(parameter_range_Low(4,:),parameter_range_Upper(4,:),Set_precision,init_list_Bin(i,column_x1+column_x2+column_x3+1:column_x1+column_x2+column_x3+column_x4));
        Dec_number_x5=Decode(parameter_range_Low(5,:),parameter_range_Upper(5,:),Set_precision,init_list_Bin(i,column_x1+column_x2+column_x3+column_x4+1:column_x1+column_x2+column_x3+column_x4+column_x5));
        
        fitness_list(i,1)=Dec_number_x1^2+Dec_number_x2^2+3*Dec_number_x3^2+4*Dec_number_x4^2+2*Dec_number_x5^2-8*Dec_number_x1-2*Dec_number_x2-3*Dec_number_x3-Dec_number_x4-2*Dec_number_x5;
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

function list_Bin_out=operate_copy(fitness_list,list_Bin_in) %自然选择
    for i=1:size(list_Bin_in,1)
        random_array(i)=unifrnd(0,1);
    end
    k=1;
    for i=1:size(list_Bin_in,1)
        for j=1:size(list_Bin_in,1)-1
            if (random_array(i)>fitness_list(j,3))&&(random_array(i)<fitness_list(j+1,3))
                list_Bin_out(k,:)=list_Bin_in(j+1,:);
              %  if k<size(list_Bin_in,1)
                   k=k+1;
            end
        end
        if (random_array(i)<fitness_list(1,3))
                list_Bin_out(k,:)=list_Bin_in(1,:);
                %if k<size(list_Bin_in,1)
                   k=k+1;
               % end
        end
    end
end

function list_Bin_out=Mating_operation(Mating_probability,list_Bin_in)   %交叉操作
    %ceil(10*unifrnd(0,1)); %生成1-10的随机整数 均匀分布
    mating_number=round(size(list_Bin_in,1)*Mating_probability);
    if (mod(mating_number,2)~=0)  %保证是二的倍数
        mating_number=fix(mating_number);
    end
    if (mod(mating_number,2)~=0)
        mating_number=ceil(mating_number);
    end
    if (mod(mating_number,2)~=0)
        mating_number=mating_number+1;
    end
    
    for i=1:mating_number %随机生成mating_number个互不重复的数字在picked_id里
        picked_id(i)=ceil(size(list_Bin_in,1)*unifrnd(0,1));
        flag=0;
        while 1
            for j=1:i-1
                if (picked_id(i)~=picked_id(j))
                    flag=flag+1;
                end
            end
            if flag==i-1
                break;
            else
                flag=0;
                picked_id(i)=ceil(size(list_Bin_in,1)*unifrnd(0,1));
            end
        end
    end
    
    for i=1:2:mating_number-1
        chromosome1=list_Bin_in(picked_id(i),:);
        chromosome2=list_Bin_in(picked_id(i+1),:);
        random_number=ceil(size(chromosome1,2)*unifrnd(0,1));
        for j=random_number:size(chromosome1,2)
            mid_number=chromosome1(j);
            chromosome1(j)=chromosome2(j);
            chromosome2(j)=mid_number;
        end
        list_Bin_in(picked_id(i),:)=chromosome1;
        list_Bin_in(picked_id(i+1),:)=chromosome2;
    end
    list_Bin_out=list_Bin_in;
end

function list_Bin_out=Mutation_operate(Mutation_probability,list_Bin_in) %突变操作
    Sum_Bin_number=size(list_Bin_in,1)*size(list_Bin_in,2);
    Mutation_Bin_number=ceil(Sum_Bin_number*Mutation_probability); %突变的基因数
    
    for i=1:Mutation_Bin_number %随机生成Mutation_Bin_number个互不重复的数字在picked_id里
        picked_id(i)=ceil(Sum_Bin_number*unifrnd(0,1));
        flag=0;
        while 1
            for j=1:i-1
                if (picked_id(i)~=picked_id(j))
                    flag=flag+1;
                end
            end
            if flag==i-1
                break;
            else
                flag=0;
                picked_id(i)=ceil(Sum_Bin_number*unifrnd(0,1));
            end
        end
    end
    
    for i=1:Mutation_Bin_number
        r=fix(picked_id(i)/size(list_Bin_in,2));
        l=mod(picked_id(i),size(list_Bin_in,2));
        if l==0
            if list_Bin_in(r,size(list_Bin_in,2))==0
                    list_Bin_in(r,size(list_Bin_in,2))=1;
            else
                if list_Bin_in(r,size(list_Bin_in,2))==1
                    list_Bin_in(r,size(list_Bin_in,2))=0;
                end
            end
        else
            if list_Bin_in(r+1,l)==0
                    list_Bin_in(r+1,l)=1;
            else
                if list_Bin_in(r+1,l)==1
                    list_Bin_in(r+1,l)=0;
                end
            end
        end
    end
    list_Bin_out=list_Bin_in;
end

function [Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,list_Bin_in) %从一个种群中得到适应度最好的一个解，输入参数为该种群和该种群的适应度表
    global column_x1;
    global column_x2;
    global column_x3;
    global column_x4;
    global column_x5;
    column=[column_x1,column_x2,column_x3,column_x4,column_x5];
    Sub_max=fitness_list(1,1);
    row_of_max=1;
    for i=1:size(fitness_list,1) %找到该种群的最大适应度的个体
        if fitness_list(i,1)>Sub_max
            Sub_max=fitness_list(i,1);
            row_of_max=i;
        end
    end
    j=0;
    for i=1:size(parameter_range_Low,1)
        if (i==1)
            j=1;
        else
            j=j+column(i-1);
        end
        Best_dec_independent(i)=Decode(parameter_range_Low(i,:),parameter_range_Upper(i,:),Set_precision,list_Bin_in(row_of_max,j:j-1+column(i)));
    end
    Best_dec_dependent=Best_dec_independent(1)^2+Best_dec_independent(2)^2+3*Best_dec_independent(3)^2+4*Best_dec_independent(4)^2+2*Best_dec_independent(5)^2-8*Best_dec_independent(1)-2*Best_dec_independent(2)-3*Best_dec_independent(3)-Best_dec_independent(4)-2*Best_dec_independent(5);
end

