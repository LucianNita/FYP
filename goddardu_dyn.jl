using DifferentialEquations

function goddardu_dyn(ts::Real,tf::Real)
    u0= [0.0;0.0;32.0]
    tspan = (0.0,ts)
    p = [1.0];
    prob = ODEProblem(goddardu!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-6));
    u0 = sol[end];
    tspan = (ts,tf)

    p = [0.0];
    prob = ODEProblem(goddardu!,u0,tspan,p);
    println(typeof(prob))
    sol = solve(prob,dtmin=0.00001);
    re=convert(Array{Real,1},sol[end]);
    return re
end
