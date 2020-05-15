function mads2(x0::Array{Float64},a0::Int64,b0::Float64)
    delta=eval((a0,b0));
    #global x=zeros(Float64,(2,2,3));
    a=a0;
    b=b0;
    dt=0.01;

    dif=simulate(x0,dt)[1]-3048;
    min=(dif>0 ? dif+simulate(x0,dt)[2]^2*100 : -dif+simulate(x0,dt)[2]^2*100)

    xn=copy(x0);

    while min>1.5
        x0=copy(xn);
        succ=0;
        ra=randir(length(x0)-1);

        for i=1:2
            for j=2:length(x0)
                xt=copy(x0);

                for k=2:length(x0)
                xt[k]=xt[k]+(-1)^i*ra[k-1]*delta;
                end
                if j>2
                    aux=xt[2];
                    xt[2]=xt[j];
                    xt[j]=-aux;
                end

                dif=simulate(xt,dt)[1]-3048;
                dif=(dif>0 ? dif+simulate(xt,dt)[2]^2*100 : -dif+simulate(xt,dt)[2]^2*100);
                if dif<min
                    xn=copy(xt);
                    min=dif;
                    succ=1;
                end
            end
        end
        if succ==1
            (a,b)=increase(a,b);
            delta=eval((a,b));
            println(xn);
        else
            xn=copy(x0);
            (a,b)=decrease(a,b);
            delta=eval((a,b));
        end
    end
end
