using DirectSearch
using DifferentialEquations
using Polynomials
using Plots
pyplot();

function goddardu!(du,u,p,t)
 σ = p[1]; c=1900.0; T=1000.0; D=0.0076; α=2.252*10^(-5); β=4.256; g=9.81;
 du[1] = u[2];
 du[2] = ((T*σ-D*(u[2]^2)*((1-α*u[1])^β))/u[3])-g;
 du[3] = -T*σ/c;
end

function goddardl!(du,u,p,t)
 σ = p[1]; c=2100.0; T=1000.0; D=0.0076; α=2.252*10^(-5); β=4.256; g=9.81;
 du[1] = u[2];#max(u2,0)
 if du[1]<=0
     du[1]=0;
 end
 du[2] = ((T*σ-D*(u[2]^2)*((1-α*u[1])^β))/u[3])-g;
 du[3] = -T*σ/c;
end

function gu(x)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,x[1])
    p = [1.0];
    prob = ODEProblem(goddardu!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    u0 = sol[end];
    tspan = (x[1],x[2])
    p = [0.0];
    prob = ODEProblem(goddardu!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    return sol[end]
end

function gl(x)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,x[1])
    p = [1.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    u0 = sol[end];
    tspan = (x[1],x[3])
    p = [0.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    return sol[end]
end

p = DSProblem(3);
obj(x) =max(abs(3048-gu(x)[1]),abs(3048-gl(x)[1]));#max(abs(3048-gl(x)[1]),abs(3048-gu(x)[1]));

SetInitialPoint(p, [11.0,26.0,27.0]);
SetObjective(p,obj);
SetIterationLimit(p, 50000);
tol=0.05;
cons(x) = gu(x)[2]-tol;
AddProgressiveConstraint(p, cons)
cons2(x) = -gu(x)[2]+tol;
AddProgressiveConstraint(p, cons2)
cons3(x) = gl(x)[2]-tol;
AddProgressiveConstraint(p, cons3)
cons4(x) = -gl(x)[2]+tol;
AddProgressiveConstraint(p, cons4)
#new_progressive_collection_index = AddProgressiveCollection(p);
Optimize!(p);
@show p.status
@show p.x
@show p.x_cost
