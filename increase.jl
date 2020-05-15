using Test

function increase(a,b)
    if (a==1)
        a=2;
    elseif (a==2)
        a=5;
    elseif (a==5)
        a=1;
        b+=1;
    else println("Wrong input");
    end
    return (a,b);
end



@testset "Sample Tests" begin
         @test increase(1,2)   == (2,2)
         @test increase(5,3)  == (1,4)
         @test increase(2,1) == (5,1)
         @test increase(3,1) == (3,1)
end;
