function goddardl!(du,u,p,t)
 σ = p[1]; c=2100.0; T=1000.0; D=0.0076; α=2.252*10^(-5); β=4.256; g=9.81;
 du[1] = u[2];#max(u2,0)
 if du[1]<=0
     du[1]=0;
 end
 du[2] = ((T*σ-D*(u[2]^2)*((1-α*u[1])^β))/u[3])-g;
 du[3] = -T*σ/c;
end