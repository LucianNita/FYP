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
    tspan = (x[1],x[3])
    p = [0.0];
    prob = ODEProblem(goddardu!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    return sol[end]
end

function gl(x)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,x[2])
    p = [1.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    u0 = sol[end];
    tspan = (x[2],x[4])
    p = [0.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    return sol[end]
end

function hmu(x)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,x[1])
    p = [1.0];
    prob = ODEProblem(goddardu!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    return sol[end][1]
end

function hml(x)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,x[2])
    p = [1.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    return sol[end][1]
end

function hu(t,x)
    if t<=x[1]
        u0 = [0.0;0.0;32.0]
        tspan = (0.0,t)
        p = [1.0];
        prob = ODEProblem(goddardu!,u0,tspan,p);
        sol = solve(prob,dtmin=10^(-10));
            return sol[end][1]
    else
        u0 = [0.0;0.0;32.0]
        tspan = (0.0,x[1])
        p = [1.0];
        prob = ODEProblem(goddardu!,u0,tspan,p);
        sol = solve(prob,dtmin=10^(-10));
        u0 = sol[end];
        tspan = (x[1],t)
        p = [0.0];
        prob = ODEProblem(goddardu!,u0,tspan,p);
        sol = solve(prob,dtmin=10^(-10));
            return sol[end][1]
    end
end

function hl(t,x)
    if t<=x[2]
        u0 = [0.0;0.0;32.0]
        tspan = (0.0,t)
        p = [1.0];
        prob = ODEProblem(goddardl!,u0,tspan,p);
        sol = solve(prob,dtmin=10^(-10));
            return sol[end][1]
    else
        u0 = [0.0;0.0;32.0]
        tspan = (0.0,x[2])
        p = [1.0];
        prob = ODEProblem(goddardl!,u0,tspan,p);
        sol = solve(prob,dtmin=10^(-10));
        u0 = sol[end];
        tspan = (x[2],t)
        p = [0.0];
        prob = ODEProblem(goddardl!,u0,tspan,p);
        sol = solve(prob,dtmin=10^(-10));
            return sol[end][1]
    end
end

p = DSProblem(6); #10+1*no. of colloc pts

Ni=1;
#discretise into 10 intervals => 11 collocation pts
#value of kh at colloc pts => x[5,7,9,11,13,15,17,19,21,23,25]
#value of k0 at colloc pts => x[6,8,10,12,14,16,18,20,22,24,26]

obj(x) = 10*max(abs(3048-gu(x)[1]),abs(3048-gl(x)[1]))+(gl(x)[2])^2+ #10 and 100 are scalings
(100*(x[1]-x[5]*hu(1*x[1]/Ni,x)-x[6]))^2+(100*(x[2]-x[5]*hl(1*x[1]/Ni,x)-x[6]))^2;#max(abs(3048-gl(x)[1]),abs(3048-gu(x)[1]));
#t1=k*hu+k0 true t2=k*hl+k0 true
SetInitialPoint(p, [11.3,11.41,28.7,28.8,-0.5,15.0]);
SetObjective(p,obj);
SetIterationLimit(p, 50000);
tol=0.05;
cons(x) = gu(x)[2];
progressive_constraint_index = AddProgressiveConstraint(p, cons)
#cons2(x) = gu(x)[2]+tol;
#progressive_constraint_index = AddProgressiveConstraint(p, cons2)
#cons3(x) = -gl(x)[2]+tol;
#progressive_constraint_index = AddProgressiveConstraint(p, cons3)
#cons4(x) = gl(x)[2]+tol;
#progressive_constraint_index = AddProgressiveConstraint(p, cons4)
#cons5(x) = x[1]-x[5]*hmu(x)-x[6];
#progressive_constraint_index = AddProgressiveConstraint(p, cons5)
#cons6(x) = x[2]-x[5]*hml(x)-x[6];
#progressive_constraint_index = AddProgressiveConstraint(p, cons6)
new_progressive_collection_index = AddProgressiveCollection(p);
Optimize!(p);
@show p.status
@show p.x
@show p.x_cost
