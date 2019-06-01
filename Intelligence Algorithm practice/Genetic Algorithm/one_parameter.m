clc
clear
close all
%f=200*exp(-0.05*x)*sin(x);
%����������ֵ


Set_precision=0.0001;
population_number=20;  %��ʼ��Ⱥ����
Mating_probability=0.13; %�������
Mutation_probability=0.005; %ͻ�����
Gen=150; %��������


%% ���Դ���
% Encoded_Bin_number=Encode(parameter1_range_Low,parameter1_range_Upper,Set_precision,5.361653);
% ans2=Decode(parameter1_range_Low,parameter1_range_Upper,Set_precision,Encoded_Bin_number);
% 
% Encoded_Bin_number=Encode(parameter1_range_Low,parameter1_range_Upper,Set_precision,-2.687969);
% ans2=Decode(parameter1_range_Low,parameter1_range_Upper,Set_precision,Encoded_Bin_number);

% init_list_Bin=init_population(parameter1_range_Low,parameter1_range_Upper,Set_precision,population_number); %����ʼ�������Ⱥ�����һ������
% fitness_list=eval(parameter1_range_Low,parameter1_range_Upper,Set_precision,init_list_Bin) ;             %��Ӧ�ȱ�������Ӧ�Ⱥ�����ֵ�����ʺ��ۻ�����
% copy_list_Bin=operate_copy(fitness_list,init_list_Bin);
% list_Bin_out=Mating_operation(Mating_probability,copy_list_Bin);
% list_Bin_out1=Mutation_operate(Mutation_probability,list_Bin_out);
%%
%�Ա���ֻ��һ��
figure;
parameter1_range_Low=-3;
parameter1_range_Upper=12.1;

population=init_population(parameter1_range_Low,parameter1_range_Upper,Set_precision,population_number);
for i=1:Gen
    fitness_list=eval(parameter1_range_Low,parameter1_range_Upper,Set_precision,population);
    population=operate_copy(fitness_list,population); %����һ����Ȼѡ��
    population=Mating_operation(Mating_probability,population); %����һ�ֽ���
    population=Mutation_operate(Mutation_probability,population); %����һ��ͻ��
    [Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter1_range_Low,parameter1_range_Upper,Set_precision,fitness_list,population); %��һ����Ⱥ�еõ���Ӧ����õ�һ���⣬�������Ϊ����Ⱥ�͸���Ⱥ����Ӧ�ȱ�
    plot(i,Best_dec_dependent,'.');
    xlabel('����')
    ylabel('��Сֵ')
   % axis([-5 10 -300 100]);
    hold on;
    drawnow;
end
%���һ������Ϣ,��һ������õģ���õĿ��Դ�plot���������ң�
fitness_list=eval(parameter1_range_Low,parameter1_range_Upper,Set_precision,population);
[Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter1_range_Low,parameter1_range_Upper,Set_precision,fitness_list,population); %��һ����Ⱥ�еõ���Ӧ����õ�һ���⣬�������Ϊ����Ⱥ�͸���Ⱥ����Ӧ�ȱ�







%% ����
function Bin_number=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,Dec_number) %����Ϊʮ�����������Ϊ����������
    digits=ceil(log2((parameter_range_Upper-parameter_range_Low)*(1/Set_precision)+1));
    Dec_number=round((Dec_number-parameter_range_Low) / ((parameter_range_Upper-parameter_range_Low)/(2^digits-1)));
    Sub_Bin_number=dec2bin(Dec_number,digits);
    for i=1:digits
        Bin_number(i)=double(Sub_Bin_number(i))-48;
    end
end

function Dec_number=Decode(parameter_range_Low,parameter_range_Upper,Set_precision,Bin_number) %����Ϊ�����������������Ϊ10������
    Sub_dec=0;
    for i=1:size(Bin_number,2)
        Sub_dec=Sub_dec+Bin_number(size(Bin_number,2)-i+1)*2^(i-1);
    end
    Dec_number=parameter_range_Low+Sub_dec* ( (parameter_range_Upper-parameter_range_Low) / (2^size(Bin_number,2)-1) );
end

function init_list_Bin=init_population(parameter_range_Low,parameter_range_Upper,Set_precision,population_number) %��ʼ����Ⱥ����������������ޡ����Ⱥ���Ⱥ����
    for i=1:population_number
        init_list_Bin(i,:)=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,parameter_range_Low+unifrnd(Set_precision,parameter_range_Upper-parameter_range_Low));
    end
end

function fitness_list=eval(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin) %������Ӧ�ȣ���Ӧ�Ⱥ����������������ʵ���������,����������Ƕ����Ƶĳ�ʼ����Ⱥ
    Sum=0;
    for i=1:size(init_list_Bin,1)
        Dec_number=Decode(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin(i,:));
        fitness_list(i,1)=-(200*exp(-0.05*Dec_number)*sin(Dec_number)-300); %Ҫע�������Ӧ�Ⱥ�����Ŀ�꺯���ǲ�ͬ�ģ����ｫ��Сֵ����ת��Ϊ�����ֵ����
        Sum=Sum+fitness_list(i,1); %������Ӧ��ֵ�ܺ�
    end
    for i=1:size(init_list_Bin,1)
        fitness_list(i,2)=fitness_list(i,1)/Sum; %�ڶ�������ӦȾɫ�屻���Ƶĸ���
        if i==1
            fitness_list(i,3)=fitness_list(i,2);
        else
            fitness_list(i,3)=fitness_list(i-1,3)+fitness_list(i,2);
        end
    end
end

function list_Bin_out=operate_copy(fitness_list,list_Bin_in) %��Ȼѡ��
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

function list_Bin_out=Mating_operation(Mating_probability,list_Bin_in)   %�������
    %ceil(10*unifrnd(0,1)); %����1-10��������� ���ȷֲ�
    mating_number=round(size(list_Bin_in,1)*Mating_probability);
    if (mod(mating_number,2)~=0)  %��֤�Ƕ��ı���
        mating_number=fix(mating_number);
    end
    if (mod(mating_number,2)~=0)
        mating_number=ceil(mating_number);
    end
    if (mod(mating_number,2)~=0)
        mating_number=mating_number+1;
    end
    
    for i=1:mating_number %�������mating_number�������ظ���������picked_id��
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

function list_Bin_out=Mutation_operate(Mutation_probability,list_Bin_in) %ͻ�����
    Sum_Bin_number=size(list_Bin_in,1)*size(list_Bin_in,2);
    Mutation_Bin_number=ceil(Sum_Bin_number*Mutation_probability); %ͻ��Ļ�����
    
    for i=1:Mutation_Bin_number %�������Mutation_Bin_number�������ظ���������picked_id��
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

function [Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,list_Bin_in) %��һ����Ⱥ�еõ���Ӧ����õ�һ���⣬�������Ϊ����Ⱥ�͸���Ⱥ����Ӧ�ȱ�
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









