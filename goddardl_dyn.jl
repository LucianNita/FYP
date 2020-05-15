function goddardl_dyn(ts,tf)
    u0 = [0.0;0.0;32.0]
    tspan = (0.0,ts)
    p = [1.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=10^(-10));
    u0 = sol[end];
    tspan = (ts,tf)
    p = [0.0];
    prob = ODEProblem(goddardl!,u0,tspan,p);
    sol = solve(prob,dtmin=0.00001);
    return sol[end]
end
