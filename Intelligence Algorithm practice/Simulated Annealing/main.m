clear 
close all
clc


% load('city.mat');
% load('Distance_matrix.mat');
Data
global Distance_matrix;
global city_init;
global maintain_init_city_ENABLE;

T0=500; %模拟退火初始温度
Alpha_T=0.5; %温度衰减系数
T_f=0.001; %终止温度
Markov_length=15000; %马尔科夫链长度
city_init=5; %初始城市编号
maintain_init_city_ENABLE=0;  %失能maintain_init_city函数

path_sequence_last=randperm(size(city,1));
path_sequence_last=maintain_init_city(path_sequence_last);
%Energy=Get_E(path_sequence_last);
T=T0;
%T=Alpha_T*T;  

while T>T_f
    for i=1:Markov_length
        if (unifrnd(0,1)<=0.5)
            path_sequence_now=Generate_new_sequence_two(path_sequence_last);
            path_sequence_now=maintain_init_city(path_sequence_now);
        else
            path_sequence_now=Generate_new_sequence_three(path_sequence_last);
            path_sequence_now=maintain_init_city(path_sequence_now);
        end
        path_sequence_last=update_path_sequence(path_sequence_now,path_sequence_last,T);
    end 
    for i=1:size(path_sequence_last,2)
        position_x(i)=city(path_sequence_last(i),1);
        position_y(i)=city(path_sequence_last(i),2);
        if i==1
            plot(position_x(i),position_y(i),'o');
        else
            plot(position_x(i),position_y(i),'.');
        end
        hold on;
    end
    position_x(i+1)=city(path_sequence_last(1),1);
    position_y(i+1)=city(path_sequence_last(1),2);
    plot(position_x,position_y);
    drawnow;    
    hold off;
    T=Alpha_T*T;  
end
Energy=Get_E(path_sequence_last);


function new_path_sequence=maintain_init_city(old_path_sequence) %保持出发的城市不变
    global city_init;
    global maintain_init_city_ENABLE;
    if maintain_init_city_ENABLE==1
        for i=1:size(old_path_sequence,2)
            if old_path_sequence(i)==city_init
                number=i;
                break;
            end
        end
        mid=old_path_sequence(number);
        old_path_sequence(number)=old_path_sequence(1);
        old_path_sequence(1)=mid;
        new_path_sequence=old_path_sequence;
    else
        new_path_sequence=old_path_sequence;
    end
end

function E=Get_E(path_sequence) %获取内能
    global Distance_matrix;
    E=0;
    for i=1:size(path_sequence,2)-1
        E=E+Distance_matrix(path_sequence(1,i),path_sequence(1,i+1));
    end
    E=E+Distance_matrix(path_sequence(1,size(path_sequence,2)),path_sequence(1,1));
end

function new_path_sequence=Generate_new_sequence_two(old_path_sequence) %二变换法生成新解
    random_1=ceil(unifrnd(0,size(old_path_sequence,2)));
    random_2=ceil(unifrnd(0,size(old_path_sequence,2)));
    while random_1==random_2
        random_1=ceil(unifrnd(0,size(old_path_sequence,2)));
        random_2=ceil(unifrnd(0,size(old_path_sequence,2)));
    end
    mid_number=old_path_sequence(1,random_1);
    old_path_sequence(1,random_1)=old_path_sequence(1,random_2);
    old_path_sequence(1,random_2)=mid_number;
    new_path_sequence=old_path_sequence;
end

function new_path_sequence=Generate_new_sequence_three(old_path_sequence) %三变换法生成新解
    while 1
        random_1=ceil(unifrnd(0,size(old_path_sequence,2)));
        random_2=ceil(unifrnd(0,size(old_path_sequence,2)));
        random_3=ceil(unifrnd(0,size(old_path_sequence,2)));
        if (random_1<=random_2)&&(random_3>random_2)
            break;
        end
    end
    count=0;
    Save_number=zeros(0);
    for i=random_1:random_2
        count=count+1;
        Save_number(count)=old_path_sequence(1,i);
    end
    for i=random_2+1:size(old_path_sequence,2) %删除操作，将count个数删除
        old_path_sequence(1,i-count)=old_path_sequence(1,i);
    end
    for i=(size(old_path_sequence,2)-count):-1:(random_3)-count+1 %random3后边的数移位操作
        old_path_sequence(1,i+count)=old_path_sequence(1,i);
    end
    k=1;
    for i=random_3-count+1:random_3
        old_path_sequence(1,i)=Save_number(k);
        k=k+1;
    end
    new_path_sequence=old_path_sequence;
end

function new_path_sequence=update_path_sequence(path_sequence_now,path_sequence_last,Ti) %接受新解
    E_now=Get_E(path_sequence_now);
    E_last=Get_E(path_sequence_last);
    if (E_now<=E_last)
        new_path_sequence=path_sequence_now;
    else
        derta_E=E_now-E_last;
        probability=exp(-derta_E/Ti); %这个概率是关键！
        %probability=0; 改变这个接受函数时，结果不好，说明了解的产生不是完全随机的，解与解之间有关系才行。
        if (unifrnd(0,1)<probability)
            new_path_sequence=path_sequence_now;
        else
            new_path_sequence=path_sequence_last;
        end      
    end
end









