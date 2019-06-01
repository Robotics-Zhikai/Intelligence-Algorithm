clear
clc
close all
global Distance_matrix;

Data    
yita2=test2();
yita1=test1();
yita3=test3();
function yita=test1()
    global Distance_matrix;
    yita=zeros(0);
    for i=1:size(Distance_matrix,1)
        for j=1:size(Distance_matrix,2)
            yita(i,j)=1/Distance_matrix(i,j);
        end
    end
end
function yita2=test2()
    global Distance_matrix;
    yita2=1./Distance_matrix;
end
function yita=test3()
    global Distance_matrix;
    for i=1:size(Distance_matrix,1)
        for j=1:size(Distance_matrix,2)
            yita(i,j)=1/Distance_matrix(i,j);
        end
    end
end