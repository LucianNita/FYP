using Test

function randir(n::Int32)
    #Function that generates random direction of modulus 1 in n dimensional space

    sum=0;  #Current sum which is the bound for the next random component
    r=Array{Float64}(undef, n); #Predefine array  #Default?
    for i=1:(n-1)
        r[i]=rand()*sqrt(1-sum); #generate random number   ##Generate first and then normalize them
        sum=sum+r[i]^2; #update sum
    end
    r[n]=sqrt(1-sum); #last number
    return r; #array of coefficients for versors
end

@testset "Sample Tests" begin
        @test length(randir(7))==7;
        @test length(randir(9))==9;
        a=randir(3);
        @test a[1]^2+a[2]^2+a[3]^2 ≈ 1;
    for i in a
        @test i<=1;
    end
    #negative & zero vals
end;
