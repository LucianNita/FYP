function simulate(t::Array{Float64},dt) #Function that simulates the Goddard rocket dynamics
    #Inputs: t-Array of switch times (on-off); dt-timestep of the simulation
    #Outputs: (xf,vf,mf)-final state of the rocket

    h=0.0; #initial altitude
    v=0.0; #initial velocity
    m=32.0;#initial mass
    T=1000.0; #Full throttle engine thrust
    c=2000.0; #Specific impulse Isp
    D0=0.0076;#1/2*Cd*rho0*S term
    a=2.252*10^(-5); #Atmosphric model constant (valid for troposphere (1-ah)^b)
    b=4.256 #Atmosphric model constant (valid for troposphere (1-ah)^b)
    grav=9.81; #Gravitational Constant
    R0=6.371*10^6;# Earth Radius

    for i=1:length(t)-1 #If there are length(t) points there are length(t)-1 time intervals
        for j=t[i]+dt:dt:t[i+1] #For each time interval --- Note the +dt
            #println(h,' ',v,' ',m); #Artifact - Still learning how to properly use the debugger :)))

            dh=v; #Dynamic equations: dh/dt=v
            dv=1/m*(T*(i%2)-D0*v^2*(1-a*h).^4.256)-grav*R0^2/((R0+h)^2); #ma=T-D-mg => dv/dt=(T-D(h,v))/m-g(h)
            dm=-T*(i%2)./c; #dm/dt=-T/c

            h+=dh*dt; #Use forward difference to approximate derivatives
            v+=dv*dt; #These states are just forward simulated: (x,v,m)(t(n+1))=(x,v,m)(t(n))+dt*(dx,dv,dm)
            m+=dm*dt; #Use forward difference to approximate derivatives
        end
    end
    return h,v,m #Return final state - Note memory optimization - dh,dv,dm are naturally local in the for loop
end

using Test

@testset "Simulation Tests" begin
         @test simulate([0.0,0.0],0.1) == (0,0,32) #Caution on [0,0] as well!
         @test simulate([1.1,1.1],0.1)  == (0,0,32) #initial time should not matter
         @test simulate([0.0, 1.0, 2.0],0.01) == simulate([1.0,2.0,3.0],0.01) #differences in time is the only thing that matters
         @test simulate([0.0,1.0,2.0],0.01) != simulate([0.0,1.0,2.0],0.1) #result depends on the mesh resolution
         @test round(simulate([0.0,1.0,2.0],0.00001)[1],digits=3) == round(simulate([0.0,1.0,2.0],0.000001)[1],digits=3) #eventually should converge to the same thing
         @test round(simulate([0.0,1.0,2.0],0.00001)[2],digits=3) == round(simulate([0.0,1.0,2.0],0.000001)[2],digits=3) #eventually should converge to the same thing
         @test round(simulate([0.0,1.0,2.0],0.00001)[3],digits=3) == round(simulate([0.0,1.0,2.0],0.000001)[3],digits=3) #eventually should converge to the same thing
         atest=simulate([0.0,11.361990740054472,28.769520309859058],0.001)
         @test (round(atest[1],digits=0),round(atest[2],digits=1),round(atest[3],digits=2)) == (3048,0,26.32); #map+round
end;  #TDD is quicker than having to write a separate class with tests - unit test is within the function definition
