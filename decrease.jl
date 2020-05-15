function decrease(a,b)
    if (a==1)
        a=5;
        b-=1;
    elseif (a==2)
        a=1;
    else
        a=2;
    end
    return (a,b);
end
