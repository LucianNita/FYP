using MeshAdaptiveDirectSearch
f(x) = (x[1]^2+x[2]^2)
g(x) = x[1]+x[2]
y=minimize(LtMADS(2), f, [1.5,-10.0], lowerbound = [-10, -10], upperbound = [30, 30], constraints = [x -> g(x) < 2.5, x -> x[1] == 1.75])
println(y);
