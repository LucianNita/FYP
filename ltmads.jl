f(x) = (x[1]^2+x[2]^2+x[3]^2)

y=minimize(LtMADS(3), f, [1.1, 1.1, 1.1], lowerbound = [-10, -10, -10], upperbound = [10, 10, 10], constraints = [x -> sum(x) < 3.5])
