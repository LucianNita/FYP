using DifferentialEquations
using MeshAdaptiveDirectSearch
using Plots
pyplot()

function goddardu!(du,u,p,t)
 σ = p[1]; c=2000.0; T=1000.0; D=0.0076; α=2.252*10^(-5); β=4.256; g=9.81;
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

function g(x)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,x[1])
    p = [1.0];
    prob = ODEProblem(goddard!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    u0 = sol[end];
    tspan = (0.0,x[2])
    p = [0.0];
    prob = ODEProblem(goddard!,u0,tspan,p);
    sol = solve(prob,dtmin=0.00001);
    return sol[end]
end
#,dtmin=0.00001

function gu(x)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,x[1])
    p = [1.0];
    prob = ODEProblem(goddardu!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    u0 = sol[end];
    tspan = (0.0,x[2])
    p = [0.0];
    prob = ODEProblem(goddardu!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    return sol[end]
end
#,Euler(),dt=0.0001
#,dtmin=10^(-10)
function gl(x)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,x[1])
    p = [1.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    u0 = sol[end];
    tspan = (0.0,x[2])
    p = [0.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    return sol[end]
end

function f(x)
    return abs(3048-g(x)[1]);
end

function fol(x)
    return max(abs(3048-gl(x)[1]),abs(3048-gu(x)[1]));
end

y=minimize(LtMADS(2), fol, [11.326,17.365], lowerbound = [0, 0], upperbound = [30, 50], constraints = [x -> gu(x)[2]>=-0.05 , x -> gu(x)[2]<=0.05])#range inequality
#y2=minimize(LtMADS(2), fol, [0.0,11.326], lowerbound = [-50,-50], upperbound = [50, 50]), #countable & uncount vs discr&cont #opt finite dim vs inf dim # find f(t) - inf dim - approx sol from fin dimention (Re->Re) #parametrize into static parameters -> decision parameters for parametrization #by coeff / by data points -> nath - package for interpolation #decision variables as coefficients to poly package #look with ed&see what is already there
println(y); # theory - > testing - > assumptin of mono holds for testing # round up & verify theory using sims

u0 = [0.0;0.0;32.0]
tspan = (0.0,y.x[1])
p = [1.0];
prob = ODEProblem(goddardl!,u0,tspan,p);
sol = solve(prob,dtmin=10^(-10));
plot(sol,vars=(1),label="x1-Ph1-Lower")
u0 = sol[end];
tspan = (y.x[1],y.x[1]+y.x[2])
p = [0.0];
prob = ODEProblem(goddardl!,u0,tspan,p);
sol = solve(prob,dtmin=10^(-10));
plot!(sol,vars=(1),xlims=(0.0,y.x[1]+y.x[2]),label="x1-Ph2-Lower")

u0 = [0.0;0.0;32.0]
tspan = (0.0,y.x[1])
p = [1.0];
prob = ODEProblem(goddardu!,u0,tspan,p);
sol = solve(prob,dtmin=10^(-10));
plot!(sol,vars=(1),label="x1-Ph1-Upper")
u0 = sol[end];
tspan = (y.x[1],y.x[1]+y.x[2])
p = [0.0];
prob = ODEProblem(goddardu!,u0,tspan,p);
sol = solve(prob,dtmin=10^(-10));
plot!(sol,vars=(1),xlims=(0.0,y.x[1]+y.x[2]),label="x1-Ph2-Upper")
