using DirectSearch

p = DSProblem(2);
obj(x) =(x[1]+0.1)^2+(x[2]-1.0)^2;#max(abs(3048-gl(x)[1]),abs(3048-gu(x)[1]));

SetInitialPoint(p, [1.0,2.0]);
SetObjective(p,obj);
SetIterationLimit(p, 50000);
tol=0.05;
cons(x) = -(-x[1]+tol);
progressive_constraint_index = AddProgressiveConstraint(p, cons)
#extreme_constraint_index = AddExtremeConstraint(p, cons);
#cons2(x) = -gu(x)[2]-tol;
#progressive_constraint_index = AddProgressiveConstraint(p, cons2)
#new_progressive_collection_index = AddProgressiveCollection(p);
Optimize!(p);
@show p.status
@show p.x
@show p.x_cost
