%f(x,y)=x^2+y^2-10*cos(2*pi*x)-10*cos(2*pi*y)+20; [-5,5]
clear
close all
clc


global omiga;
global omiga_end;
global c1;
global c2;
global alpha;
global P_limit;%λ���޷�
global V_limit;%�ٶ��޷�
global Best_among_whole_group;
number=30; %����Ⱥ������
P_limit=[-5,5;-5,5];
V_limit=[0.2;0.2];
omiga=0.9;
omiga_start=omiga;
omiga_end=0.4;
c1=2.05;
c2=2.05;
alpha=1;
Gen=60; %��������

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
fitness_list_init=Get_fitness(init_group); %��ȡ��ʼgroup����Ӧ�ȱ�
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

function printf_countour1(x,y,z) %���Ʋ������ֵĵȸ���ͼ
    contour(x,y,z);
end

function printf_countour(x,y,z) %���ƴ����ֵĵȸ���ͼ
    contour(x,y,z);
    [C,h] = contour(x,y,z);
    set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);
end

function printf_group(group)
    global P_limit;%λ���޷�
    for i=1:size(group,1)
        plot(group(:,1),group(:,2),'.');
        axis([P_limit(1,1)-1 P_limit(1,2)+1 P_limit(2,1)-1 P_limit(2,2)+1]);
    end
end

function init_group=create_init_group(number,P_limit,V_limit) %����ΪȺ������������λ�õ��޷�P_limit(��ռ��ĳһ��������ж��ٸ��������ж����У�������)���ٶȵ��޷�V_limit�����ٸ������У����У�,init_group���number��4��
    global Best_among_whole_group;
    init_group=zeros(number,1);
    for i=1:number
        init_group(i,1)=unifrnd(P_limit(1,1),P_limit(1,2));%��һ��Ϊ��i�����ӵ�x1��������
        init_group(i,2)=unifrnd(P_limit(2,1),P_limit(2,2));%�ڶ���Ϊ��i�����ӵ�x2��������
        init_group(i,3)=unifrnd(-V_limit(1,1),V_limit(1,1)); %������Ϊ��i�����ӵ�x1�����仯�ٶ�
        init_group(i,4)=unifrnd(-V_limit(2,1),V_limit(2,1)); %������Ϊ��i�����ӵ�x2�����仯�ٶ�
        init_group(i,5)=init_group(i,1); %������Ϊ��i�����ӵ�x1�������������
        init_group(i,6)=init_group(i,2); %������Ϊ��i�����ӵ�x2�������������
    end
    Best_among_whole_group=Get_best_particle_among_whole_group(init_group); %��ʼ��ʱ��ȡ��õ�λ��
end

function fitness_list=Get_fitness(group) %�õ�group��ÿ�����ӵĵ���Ӧ�ȣ���ŵ�һ��fitness_list��,һ��
    fitness_list=zeros(size(group,1),1);
    for i=1:size(group,1)
        x1=group(i,1);
        x2=group(i,2);
        fitness_list(i,1)=x1^2+x2^2-10*cos(2*pi*x1)-10*cos(2*pi*x2)+20;
    end
end

%%
%�����ֵ������Сֵ���±������������޸�
function Best=Get_best_particle_among_whole_group(group) %��ȡ����group��ȫ������ֵ��Ӧ��������Ϣ
    fitness_list=Get_fitness(group);
    MAX=fitness_list(1,1);
    number=1;
    for i=1:size(fitness_list,1)
        if MAX<fitness_list(i,1) %��ȡ�����Ӧֵ
            MAX=fitness_list(i,1);
            number=i;
        end
    end
    Best=group(number,:);
end

function group_out=update(group_in) %����group_in���ٶ���λ����Ϣ,ͬʱ���¸��������ֵ
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
    for i=1:size(fitness_now_list,1) %���¸�������ֵ
        if fitness_now_list(i,1)>fitness_last_list(i,1)
            group_in(i,5:6)=group_in(i,1:2);
        end
    end
    Best=Get_best_particle_among_whole_group(group_in);
    if Best>Best_among_whole_group %����ȫ������ֵ
        Best_among_whole_group=Best;
    end
    group_out=group_in;
end

%%
function update_omiga(Gen,Gen_now) %����omiga���������Ϊ���������͵�ǰ��������
    global omiga;
    global omiga_end;
    %omiga=omiga-(omiga-omiga_end)*(Gen-Gen_now)/Gen;
    omiga=omiga-(omiga-omiga_end)*((Gen_now/Gen)^2);
end






