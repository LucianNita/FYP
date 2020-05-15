function Checktype(Pk,fkf,fki,hki)
global type=0;
while size(Pk)[1]!=0
    global type
    p=pop!(Pk);
    (f1,h1)=fh(p);
    if hmin<h1 && h1<hki && f1>fki
        type=1;
        push!(Vk,p);
    end
    if (hmin<h1 && h1<hki && f1<=fki) || ((h1<hmin) && f1<fkf) || (h1==hki && f1<fki)
        type=2;
        push!(Vk,p);
    end
end
return type;
end
