function initial()
    for y in 11.362:0.001:11.364
        for x in 16.8:0.01:17.8
            ds = ContinuousDynamicalSystem(loop, [0.0, 0.0, 32.0], [1.0]);
            tr = trajectory(ds, y;dt=0.01);
            ds = ContinuousDynamicalSystem(loop, tr[size(tr)[1]] , [0.0]);
            tr = trajectory(ds, x;dt=0.01);
            #println([x,y])
            #println([tr[size(tr)[1]][1],tr[size(tr)[1]][2]])
                if (isapprox(tr[size(tr)[1]][2], 0, atol=0.01) && isapprox(tr[size(tr)[1]][1], 3048, atol=5))
                    return [x,y];
                    break;
                end
                if tr[size(tr)[1]][2]< 0
                    break;
                end
        end
    end

end
