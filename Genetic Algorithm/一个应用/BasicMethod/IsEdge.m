function Flag = IsEdge(Area,xy) %�õ�ĳһ���Ƿ��Ǳ߽�
    if ( Area(xy(1)-1,xy(2)) == -1 || Area(xy(1)+1,xy(2)) == -1 || Area(xy(1),xy(2)+1) == -1 || Area(xy(1),xy(2)-1) == -1)
        Flag = 1;
    else
        Flag = 0;
    end
    return ;
end