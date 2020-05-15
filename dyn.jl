using DynamicalSystems  # Package for simulating dynamical systems
using MeshAdaptiveDirectSearch

# Simple rocket dynamics system
# Equations of motion:
@inline @inbounds function loop(u, p, t)
    σ = p[1]; c=2000.0; T=1000.0; D=0.0076; α=2.252*10^(-5); β=4.256; g=9.81;
    du1 = u[2];
    du2 = ((T*σ-D*(u[2]^2)*((1-α*u[1])^β))/u[3])-g;
    du3 = -T*σ/c;
    return SVector{3}(du1, du2, du3)
end

#[a,b]=initial();

function g(x)
    ds = ContinuousDynamicalSystem(loop, [0.0, 0.0, 32.0], [1.0]);
    tr = trajectory(ds, x[1];dt=0.01);
    ds = ContinuousDynamicalSystem(loop, tr[end] , [0.0]);
    tr = trajectory(ds, x[2];dt=0.01);
    return tr[end]
end
#function h(x)
#    return x[2]+x[1]
#end

function f(x)
    return abs(3048-g(x)[1]);
end
#println(g(0.0,0.0)[2])
y=minimize(LtMADS(2), f, [11.326,17.365], lowerbound = [0, 0], upperbound = [30, 50], constraints = [x -> g(x)[2]>=-0.05 , x -> g(x)[2]<=0.05])
println(y);
