function sitnumGrade = GetsitnumGrade(sitnum)
    global szq;
    global y2qx1q;
    global y2q;
    global x2qy1q;
    global y1qx1q;
    global x2q;
    global y1q;
    global x1q;
    global szbq;
    %顺序是[szq y2qx1q y2q x2qy1q y1qx1q x2q y1q x1q szbq]
    sx = [szq y2qx1q y2q x2qy1q y1qx1q x2q y1q x1q szbq];
    %分数是加权和
    sitnumGrade = 0;
    for i=1:size(sitnum,2)
        sitnumGrade = sitnumGrade + sitnum(i) * sx(i);
    end

end