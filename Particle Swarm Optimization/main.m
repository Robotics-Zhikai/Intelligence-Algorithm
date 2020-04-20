%f(x,y)=x^2+y^2-10*cos(2*pi*x)-10*cos(2*pi*y)+20; [-5,5]
clear
close all
clc


global omiga;
global omiga_end;
global c1;
global c2;
global alpha;
global P_limit;%位置限幅
global V_limit;%速度限幅
global Best_among_whole_group;
number=30; %粒子群的数量
P_limit=[-5,5;-5,5];
V_limit=[0.2;0.2];
omiga=0.9;
omiga_start=omiga;
omiga_end=0.4;
c1=2.05;
c2=2.05;
alpha=1;
Gen=60; %迭代代数

[x,y]=meshgrid(P_limit(1,1)-1:0.1:P_limit(1,2)+1,P_limit(2,1)-1:0.1:P_limit(2,2)+1);
z=x.^2+y.^2-10*cos(2*pi*x)-10*cos(2*pi*y)+20;
[x1,y1]=meshgrid(P_limit(1,1):0.1:P_limit(1,2),P_limit(2,1):0.1:P_limit(2,2));
z1=x1.^2+y1.^2-10*cos(2*pi*x1)-10*cos(2*pi*y1)+20;
theory_max=max(max(z1))
figure;
set(gcf,'outerposition',get(0,'screensize'));
printf_countour(x,y,z);
%F=getframe(gcf);
%imshow(F.cdata);
figure
init_group=create_init_group(number,P_limit,V_limit);
fitness_list_init=Get_fitness(init_group); %获取初始group的适应度表
group=init_group;
for i=1:Gen
    subplot(121)
    group=update(group);
    update_omiga(Gen,i);
    printf_group(group);
    hold on;
    printf_countour1(x,y,z);
    hold off;
    drawnow;
    subplot(122)
    plot(i,omiga,'.');
    axis([0 Gen omiga_end omiga_start]);
    title('omiga');
    hold on;
    drawnow;
end
Best_fitness=Best_among_whole_group(1,1)^2+Best_among_whole_group(1,2)^2-10*cos(2*pi*Best_among_whole_group(1,1))-10*cos(2*pi*Best_among_whole_group(1,2))+20
% plot(init_group(:,3),init_group(:,4),'.');

function printf_countour1(x,y,z) %绘制不带数字的等高线图
    contour(x,y,z);
end

function printf_countour(x,y,z) %绘制带数字的等高线图
    contour(x,y,z);
    [C,h] = contour(x,y,z);
    set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);
end

function printf_group(group)
    global P_limit;%位置限幅
    for i=1:size(group,1)
        plot(group(:,1),group(:,2),'.');
        axis([P_limit(1,1)-1 P_limit(1,2)+1 P_limit(2,1)-1 P_limit(2,2)+1]);
    end
end

function init_group=create_init_group(number,P_limit,V_limit) %输入为群体数量，所在位置的限幅P_limit(解空间的某一个具体解有多少个变量就有多少行，有两列)，速度的限幅V_limit（多少个变量行，两列）,init_group输出number行4列
    global Best_among_whole_group;
    init_group=zeros(number,1);
    for i=1:number
        init_group(i,1)=unifrnd(P_limit(1,1),P_limit(1,2));%第一列为第i个粒子的x1参数坐标
        init_group(i,2)=unifrnd(P_limit(2,1),P_limit(2,2));%第二列为第i个粒子的x2参数坐标
        init_group(i,3)=unifrnd(-V_limit(1,1),V_limit(1,1)); %第三列为第i个粒子的x1参数变化速度
        init_group(i,4)=unifrnd(-V_limit(2,1),V_limit(2,1)); %第四列为第i个粒子的x2参数变化速度
        init_group(i,5)=init_group(i,1); %第五列为第i个粒子的x1参数的最好坐标
        init_group(i,6)=init_group(i,2); %第六列为第i个粒子的x2参数的最好坐标
    end
    Best_among_whole_group=Get_best_particle_among_whole_group(init_group); %初始化时获取最好的位置
end

function fitness_list=Get_fitness(group) %得到group内每个粒子的的适应度，存放到一个fitness_list中,一列
    fitness_list=zeros(size(group,1),1);
    for i=1:size(group,1)
        x1=group(i,1);
        x2=group(i,2);
        fitness_list(i,1)=x1^2+x2^2-10*cos(2*pi*x1)-10*cos(2*pi*x2)+20;
    end
end

%%
%找最大值或者最小值在下边两个函数中修改
function Best=Get_best_particle_among_whole_group(group) %获取本次group的全局最优值对应的粒子信息
    fitness_list=Get_fitness(group);
    MAX=fitness_list(1,1);
    number=1;
    for i=1:size(fitness_list,1)
        if MAX<fitness_list(i,1) %获取最大适应值
            MAX=fitness_list(i,1);
            number=i;
        end
    end
    Best=group(number,:);
end

function group_out=update(group_in) %更新group_in的速度与位置信息,同时更新个体的最优值
    global omiga;
    global c1;
    global c2;
    global alpha;
    global Best_among_whole_group;
    global V_limit;
    fitness_last_list=Get_fitness(group_in);
    for i=1:size(group_in,1)
        group_in(i,1)=group_in(i,1)+alpha*group_in(i,3);
        group_in(i,2)=group_in(i,2)+alpha*group_in(i,4);
        
        group_in(i,3)=omiga*group_in(i,3)+c1*unifrnd(0,1)*(group_in(i,5)-group_in(i,1))+c2*unifrnd(0,1)*(Best_among_whole_group(1,5)-group_in(i,1));
        if group_in(i,3)>V_limit(1,1)
            group_in(i,3)=V_limit(1,1);
        else
            if group_in(i,3)<-V_limit(1,1)
                group_in(i,3)=-V_limit(1,1);
            end
        end
        group_in(i,4)=omiga*group_in(i,4)+c1*unifrnd(0,1)*(group_in(i,6)-group_in(i,2))+c2*unifrnd(0,1)*(Best_among_whole_group(1,6)-group_in(i,2));
        if group_in(i,4)>V_limit(2,1)
            group_in(i,4)=V_limit(2,1);
        else
            if group_in(i,4)<-V_limit(2,1)
                group_in(i,4)=-V_limit(2,1);
            end
        end
    end
    fitness_now_list=Get_fitness(group_in);
    for i=1:size(fitness_now_list,1) %更新个体最优值
        if fitness_now_list(i,1)>fitness_last_list(i,1)
            group_in(i,5:6)=group_in(i,1:2);
        end
    end
    Best=Get_best_particle_among_whole_group(group_in);
    if Best>Best_among_whole_group %更新全局最优值
        Best_among_whole_group=Best;
    end
    group_out=group_in;
end

%%
function update_omiga(Gen,Gen_now) %更新omiga，输入参数为最大迭代数和当前迭代代数
    global omiga;
    global omiga_end;
    %omiga=omiga-(omiga-omiga_end)*(Gen-Gen_now)/Gen;
    omiga=omiga-(omiga-omiga_end)*((Gen_now/Gen)^2);
end






