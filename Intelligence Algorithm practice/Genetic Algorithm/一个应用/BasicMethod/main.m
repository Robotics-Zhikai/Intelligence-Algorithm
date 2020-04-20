%将一块区域划分为网格可以将问题抽象为矩阵，网格数量可控制抽象为矩阵行列可控制。
%未挖的区域设置为1.
%挖了的区域，为空设置为0。
%不属于挖的区域设置为-1。
%即便实际存在缺块，即存在不属于挖的区域，也应该通过设置-1 保证矩阵的规整
%Area 是根据你的矿图去修改的，初始化所有值为1.

clear
close all
clc
%修改如下的分数可以对相对排序进行修改
%四周都是实体
global szbq ;
szbq = 9;
%x方向有一个空缺
global x1q;
x1q = 8;
%y方向有一个空缺
global y1q;
y1q = 7;
%x方向有两个空缺
global x2q ;
x2q = 6;
%y方向和X方向各有一个空缺
global y1qx1q;
y1qx1q = 5;
%y方向有两个空缺
global y2q ;
y2q = 3;
%y方向有两个空缺和x方向有一个空缺
global y2qx1q ;
y2qx1q = 2;
%四周都是空缺
global szq ;
szq = 1;
%x有两个空缺，y有1个空缺21
global x2qy1q;
x2qy1q = 4;

%坐标系是x轴向右，y轴向下
SizeX = 45;%地图的x轴方向的长度
SizeY = 60;%地图的y轴方向的长度
% Area = ones(SizeY,SizeX); %矩阵与常规的地图x y 是不一样的 反着来的
Areastore = xlsread('数据图.xlsx');
Area = Areastore;



BestGrade = 0;
BestPath = [];

disp('迭代Iteration次，Iteration越大，越有机会找到最优值');
Iteration = 1
for num = 1:Iteration
    record = [];
    situationrecord = [];
%     Area = ones(SizeY,SizeX); %矩阵与常规的地图x y 是不一样的 反着来的
    Area = Areastore;
    solution = randperm((size(Area,2))*(size(Area,1)));
    for i=1:size(solution,2)
        xy = [ceil(solution(i)/size(Area,1)),mod(solution(i)-1,size(Area,1))+1];
        Grade = GetGrade(Area,xy+[1,1]);
        situationrecord = [situationrecord;Grade];
        if (Grade~=0)
            record = [record,[{xy};Grade]];
        end
        Area(xy(2),xy(1)) = 0;
    end
    allGrade = 0;
    for i=1:size(record,2)
        allGrade = record{2,i} + allGrade;
    end
    if (allGrade>BestGrade)
        BestGrade = allGrade
        BestPath = record(1,:);
        BestSituationrecord = situationrecord;
    end
end
finalBestPath = BestPath';

disp('迭代Iteration次后，最佳分数为finalBestGrade');
finalBestGrade = BestGrade
disp('最佳开采顺序储存在finalBestPath中');

sitnum = zeros(1,9);
for i=1:size(BestSituationrecord,1)
    if (BestSituationrecord(i)==szq)
        sitnum(1) = sitnum(1)+1;
    end
    if (BestSituationrecord(i)==y2qx1q)
        sitnum(2) = sitnum(2)+1;
    end
    if (BestSituationrecord(i)==y2q)
        sitnum(3) = sitnum(3)+1;
    end
    if (BestSituationrecord(i)==x2qy1q)
        sitnum(4) = sitnum(4)+1;
    end
    if (BestSituationrecord(i)==y1qx1q)
        sitnum(5) = sitnum(5)+1;
    end
    if (BestSituationrecord(i)==x2q)
        sitnum(6) = sitnum(6)+1;
    end
    if (BestSituationrecord(i)==y1q)
        sitnum(7) = sitnum(7)+1;
    end
    if (BestSituationrecord(i)==x1q)
        sitnum(8) = sitnum(8)+1;
    end
    if (BestSituationrecord(i)==szbq)
        sitnum(9) = sitnum(9)+1;
    end
    
end
disp('不同情况出现的次数存储在sitnum中')
sitnum

for i=1:size(finalBestPath,1)
    plot(finalBestPath{i}(1),finalBestPath{i}(2),'r.');
    hold on ;
    pause(0.0005);
end










