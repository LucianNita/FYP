module Initialization
using LinearAlgebra
    n=2;
    v = rand(n,1)-0.5*ones(n,1);
    v /= norm(v);
end
