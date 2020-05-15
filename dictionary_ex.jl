d = Dict("A"=>1, "B"=>3, "C"=>6, "D"=>5)
keys(d)
values(d)

d["A"]
d["D"]

getindex(d,"A")
getindex(d,"C")

d["A"] = 100

d

d2 = Dict([("A",1),("B",4),("F",6)])
in(("B"=>2),d)
haskey(d,"E")

d3 = merge(d,d2)

get(d3,"B",0)
