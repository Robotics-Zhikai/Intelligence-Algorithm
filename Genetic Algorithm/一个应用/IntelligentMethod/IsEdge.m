function Flag = IsEdge(Area,xy) %得到某一点是否是边界
    if ( Area(xy(1)-1,xy(2)) == -1 || Area(xy(1)+1,xy(2)) == -1 || Area(xy(1),xy(2)+1) == -1 || Area(xy(1),xy(2)-1) == -1)
        Flag = 1;
    else
        Flag = 0;
    end
    return ;
end