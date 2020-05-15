function pbmads()
    etol=0.00001;
    while (Δ<etol || h<etol)
        d=1;
    end
return 0
end

function rd(n)
    x = zeros(n)
    x = rand(n,1)-0.5*ones(n,1)
    x /= norm(x)
return x
end
