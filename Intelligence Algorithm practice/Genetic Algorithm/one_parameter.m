clc
clear
close all
%f=200*exp(-0.05*x)*sin(x);
%找这个的最大值


Set_precision=0.0001;
population_number=20;  %初始种群数量
Mating_probability=0.13; %交配概率
Mutation_probability=0.005; %突变概率
Gen=150; %迭代代数


%% 调试代码
% Encoded_Bin_number=Encode(parameter1_range_Low,parameter1_range_Upper,Set_precision,5.361653);
% ans2=Decode(parameter1_range_Low,parameter1_range_Upper,Set_precision,Encoded_Bin_number);
% 
% Encoded_Bin_number=Encode(parameter1_range_Low,parameter1_range_Upper,Set_precision,-2.687969);
% ans2=Decode(parameter1_range_Low,parameter1_range_Upper,Set_precision,Encoded_Bin_number);

% init_list_Bin=init_population(parameter1_range_Low,parameter1_range_Upper,Set_precision,population_number); %将初始化后的种群存放在一个表中
% fitness_list=eval(parameter1_range_Low,parameter1_range_Upper,Set_precision,init_list_Bin) ;             %适应度表，包括适应度函数的值，概率和累积概率
% copy_list_Bin=operate_copy(fitness_list,init_list_Bin);
% list_Bin_out=Mating_operation(Mating_probability,copy_list_Bin);
% list_Bin_out1=Mutation_operate(Mutation_probability,list_Bin_out);
%%
%自变量只有一个
figure;
parameter1_range_Low=-3;
parameter1_range_Upper=12.1;

population=init_population(parameter1_range_Low,parameter1_range_Upper,Set_precision,population_number);
for i=1:Gen
    fitness_list=eval(parameter1_range_Low,parameter1_range_Upper,Set_precision,population);
    population=operate_copy(fitness_list,population); %经过一轮自然选择
    population=Mating_operation(Mating_probability,population); %经过一轮交叉
    population=Mutation_operate(Mutation_probability,population); %经过一轮突变
    [Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter1_range_Low,parameter1_range_Upper,Set_precision,fitness_list,population); %从一个种群中得到适应度最好的一个解，输入参数为该种群和该种群的适应度表
    plot(i,Best_dec_dependent,'.');
    xlabel('代数')
    ylabel('最小值')
   % axis([-5 10 -300 100]);
    hold on;
    drawnow;
end
%最后一代的信息,不一定是最好的，最好的可以从plot画出来的找：
fitness_list=eval(parameter1_range_Low,parameter1_range_Upper,Set_precision,population);
[Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter1_range_Low,parameter1_range_Upper,Set_precision,fitness_list,population); %从一个种群中得到适应度最好的一个解，输入参数为该种群和该种群的适应度表







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
    Sum=0;
    for i=1:size(init_list_Bin,1)
        Dec_number=Decode(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin(i,:));
        fitness_list(i,1)=-(200*exp(-0.05*Dec_number)*sin(Dec_number)-300); %要注意的是适应度函数与目标函数是不同的，这里将最小值问题转化为了最大值问题
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
    Sub_max=fitness_list(1,1);
    row_of_max=1;
    for i=1:size(fitness_list,1)
        if fitness_list(i,1)>Sub_max
            Sub_max=fitness_list(i,1);
            row_of_max=i;
        end
    end
    Best_dec_independent=Decode(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_in(row_of_max,:));
    Best_dec_dependent=200*exp(-0.05*Best_dec_independent)*sin(Best_dec_independent);
end









