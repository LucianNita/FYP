using JuMP
using Ipopt
using DifferentialEquations
using Plots
plotly()


model = Model(Ipopt.Optimizer)

@variable(model, ts, start = 0.0)
@variable(model, tf, start = 0.0)

@objective(model, Min,
goddardu_dyn(ts,tf)[1]-3048.0)

@constraint(model, con1, goddardu_dyn(ts,0.0)[2]==0.0)
@constraint(model, con2, ts >= 0.0)
@constraint(model, con3, tf >= 0.0)
@constraint(model, con4, ts <= 20.0)
@constraint(model, con5, tf <= 35.0)

optimize!(model)

#termination_status(model)
#primal_status(model)
#dual_status(model)

objective_value(model)

#value(x)
