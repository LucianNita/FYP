#ENV["GKS_WSTYPE"] = 100
using Plots
#plotly()
#using GR
pyplot()
x = 1:10; y = rand(10); # These are the plotting data
plot(x,y)
