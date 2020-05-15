using LinearAlgebra

#Initialization
hmin=10^(-10);
n=2;#number of states
m=4;#number of tested points
v=zeros(n,m); #need this
for i=1:m
v[:,i] = rand(n,1)-0.5*ones(n,1);
v[:,i] /= norm(v[:,i]);
end

τ=4;
ωp=1;
ωn=-1;

Δm=0.000001;
Δp=1;

k=0;

#Initial guess
x1=0;
x2=0;

#Define incubents
V0=((x1,x2));
(f,h)=fh(x1,x2);
Fk=[];
Ik=[];
Pk=[];
Vk=[];
if h<hmin
    push!(Fk,(x1,x2))
else
    push!(Ik,(x1,x2))
end

if size(Fk)[1]>0
    (fkf,tmp)=fh(Fk[1]);
else
    fkf=Inf;
end

if size(Ik)[1]>0
    (fki,hki)=fh(Ik[1]);
else
    (fki,hki)=(Inf,Inf);
end

#Poll
if size(Ik)[1]!=0
    for i=1:m
        push!(Pk,(collect(Ik[1])+Δp*v[:,i]))
    end
end
if size(Fk)[1]!=0
    for i=1:m
        push!(Pk,(collect(Fk[1])+Δp*v[:,i]))
    end
end


#type=Checktype2(Pk,fkf,fki,hki);
for i=1:2

global type=0;
    while size(Pk)[1]!=0
        global type
        p=pop!(Pk);
        (f1,h1)=fh(p);
        if hmin<h1 && h1<hki && f1>fki
            type=1;
            #push!(Vk,p);
        end
        if (hmin<h1 && h1<hki && f1<=fki) || ((h1<hmin) && f1<fkf) || (h1==hki && f1<fki)
            type=2;
            #push!(Vk,p);
        end
    end
end

#if type ==1
#end
println(type);
