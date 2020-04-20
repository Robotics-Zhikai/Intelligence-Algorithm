function sitnum = getsitnum(Situationrecord)
    global szq;
    global y2qx1q;
    global y2q;
    global x2qy1q;
    global y1qx1q;
    global x2q;
    global y1q;
    global x1q;
    global szbq;
    sitnum = zeros(1,9);
    for i=1:size(Situationrecord,1)
        if (Situationrecord(i)==szq)
            sitnum(1) = sitnum(1)+1;
        end
        if (Situationrecord(i)==y2qx1q)
            sitnum(2) = sitnum(2)+1;
        end
        if (Situationrecord(i)==y2q)
            sitnum(3) = sitnum(3)+1;
        end
        if (Situationrecord(i)==x2qy1q)
            sitnum(4) = sitnum(4)+1;
        end
        if (Situationrecord(i)==y1qx1q)
            sitnum(5) = sitnum(5)+1;
        end
        if (Situationrecord(i)==x2q)
            sitnum(6) = sitnum(6)+1;
        end
        if (Situationrecord(i)==y1q)
            sitnum(7) = sitnum(7)+1;
        end
        if (Situationrecord(i)==x1q)
            sitnum(8) = sitnum(8)+1;
        end
        if (Situationrecord(i)==szbq)
            sitnum(9) = sitnum(9)+1;
        end
    end
end