#functions to test call graph on
#Test cases at some point?

m_v_mult(M::AbstractMatrix, v::AbstractVector) = M*v
#=
CodeInfo(
1 ─ %1 = Base.arraysize(M, 1)::Int64
│        Base.arraysize(M, 2)::Int64
│   %3 = Base.slt_int(%1, 0)::Bool
│   %4 = Base.ifelse(%3, 0, %1)::Int64
│   %5 = $(Expr(:foreigncall, :(:jl_alloc_array_1d), Array{Int64,1}, svec(Any, Int64), :(:ccall), 2, Array{Int64,1}, :(%4), :(%4)))::Array{Int64,1}
│   %6 = invoke LinearAlgebra.generic_matvecmul!(%5::Array{Int64,1}, 'N'::Char, _2::Array{Int64,2}, _3::Array{Int64,1})::Array{Int64,1}
└──      return %6
) => Array{Int64,1}
=#
function m_m_mult(M1::AbstractMatrix, M2::AbstractMatrix)
        n, m = size(M2)
        return hcat([ m_v_mult(M1,M2[:,i]) for i in 1:n]...)
end
#=
CodeInfo(
1 ─ %1 = Base.arraysize(M2, 1)::Int64
│        Base.arraysize(M2, 2)::Int64
│   %3 = %new(getfield(Main, Symbol("##69#70")){Array{Int64,2},Array{Int64,2}}, M1, M2)::getfield(Main, Symbol("##69#70")){Array{Int64,2},Array{Int64,2}}
│   %4 = Base.sle_int(1, %1)::Bool
│   %5 = Base.ifelse(%4, %1, 0)::Int64
│   %6 = %new(UnitRange{Int64}, 1, %5)::UnitRange{Int64}
│   %7 = %new(Base.Generator{UnitRange{Int64},getfield(Main, Symbol("##69#70")){Array{Int64,2},Array{Int64,2}}}, %3, %6)::Base.Generator{UnitRange{Int64},getfield(Main, Symbol("##69#70")){Array{Int64,2},Array{Int64,2}}}
│   %8 = invoke Base.collect(%7::Base.Generator{UnitRange{Int64},getfield(Main, Symbol("##69#70")){Array{Int64,2},Array{Int64,2}}})::Array{Array{Int64,1},1}
│   %9 = Core._apply(Main.hcat, %8)::Array
└──      return %9
) => Array
=#

#function that contains an inline for loop
function foo1(a::Int64)
        return [a+i for i in 1:a]
end
#=
CodeInfo(
1 ─ %1 = %new(getfield(Main, Symbol("##71#72")){Int64}, a)::getfield(Main, Symbol("##71#72")){Int64}
│   %2 = Base.sle_int(1, a)::Bool
│   %3 = Base.ifelse(%2, a, 0)::Int64
│   %4 = %new(UnitRange{Int64}, 1, %3)::UnitRange{Int64}
│   %5 = %new(Base.Generator{UnitRange{Int64},getfield(Main, Symbol("##71#72")){Int64}}, %1, %4)::Base.Generator{UnitRange{Int64},getfield(Main, Symbol("##71#72")){Int64}}
│   %6 = invoke Base.collect(%5::Base.Generator{UnitRange{Int64},getfield(Main, Symbol("##71#72")){Int64}})::Array{Int64,1}
└──      return %6
) => Array{Int64,1}
=#
function foo1_2(a::Int64)
        for i in 1:a
                foo5(a+i)
        end
        return
end
#=
CodeInfo(
1 ── %1  = Base.sle_int(1, a)::Bool
│    %2  = Base.ifelse(%1, a, 0)::Int64
│    %3  = Base.slt_int(%2, 1)::Bool
└───       goto #3 if not %3
2 ──       goto #4
3 ──       goto #4
4 ┄─ %7  = φ (#2 => true, #3 => false)::Bool
│    %8  = φ (#3 => 1)::Int64
│    %9  = φ (#3 => 1)::Int64
│    %10 = Base.not_int(%7)::Bool
└───       goto #10 if not %10
5 ┄─ %12 = φ (#4 => %8, #9 => %21)::Int64
│    %13 = φ (#4 => %9, #9 => %22)::Int64
│    %14 = Base.add_int(a, %12)::Int64
│          invoke Main.foo5(%14::Int64)::Any
│    %16 = (%13 === %2)::Bool
└───       goto #7 if not %16
6 ──       goto #8
7 ── %19 = Base.add_int(%13, 1)::Int64
└───       goto #8
8 ┄─ %21 = φ (#7 => %19)::Int64
│    %22 = φ (#7 => %19)::Int64
│    %23 = φ (#6 => true, #7 => false)::Bool
│    %24 = Base.not_int(%23)::Bool
└───       goto #10 if not %24
9 ──       goto #5
10 ┄       return
) => Nothing
=#

function foo1_5(a::Int64)
        for i in 1:a
                foo5(a+i)
        end
        return
end
#=
CodeInfo(
1 ── %1  = Base.sle_int(1, a)::Bool
│    %2  = Base.ifelse(%1, a, 0)::Int64
│    %3  = Base.slt_int(%2, 1)::Bool
└───       goto #3 if not %3
2 ──       goto #4
3 ──       goto #4
4 ┄─ %7  = φ (#2 => true, #3 => false)::Bool
│    %8  = φ (#3 => 1)::Int64
│    %9  = φ (#3 => 1)::Int64
│    %10 = Base.not_int(%7)::Bool
└───       goto #10 if not %10
5 ┄─ %12 = φ (#4 => %8, #9 => %21)::Int64
│    %13 = φ (#4 => %9, #9 => %22)::Int64
│    %14 = Base.add_int(a, %12)::Int64
│          invoke Main.foo5(%14::Int64)::Any
│    %16 = (%13 === %2)::Bool
└───       goto #7 if not %16
6 ──       goto #8
7 ── %19 = Base.add_int(%13, 1)::Int64
└───       goto #8
8 ┄─ %21 = φ (#7 => %19)::Int64
│    %22 = φ (#7 => %19)::Int64
│    %23 = φ (#6 => true, #7 => false)::Bool
│    %24 = Base.not_int(%23)::Bool
└───       goto #10 if not %24
9 ──       goto #5
10 ┄       return
) => Nothing
=#

#function that has goto branches in the IR
function foo2(a::Int64)
        if a > 10
                res = 1+a
                return res
        else
                return "a"
        end
end
#=
CodeInfo(
1 ─ %1 = Base.slt_int(10, a)::Bool
└──      goto #3 if not %1
2 ─ %3 = Base.add_int(1, a)::Int64
└──      return %3
3 ─      return "a"
) => Union{Int64, String}
=#

#function with explicit for loop
function foo3(a::Int64)
        result = 0
        for i in 1:a
                result = result + 1
        end
        return result
end
#=
CodeInfo(
1 ── %1  = Base.sle_int(1, a)::Bool
│    %2  = Base.ifelse(%1, a, 0)::Int64
│    %3  = Base.slt_int(%2, 1)::Bool
└───       goto #3 if not %3
2 ──       goto #4
3 ──       goto #4
4 ┄─ %7  = φ (#2 => true, #3 => false)::Bool
│    %8  = φ (#3 => 1)::Int64
│    %9  = Base.not_int(%7)::Bool
└───       goto #10 if not %9
5 ┄─ %11 = φ (#4 => 0, #9 => %13)::Int64
│    %12 = φ (#4 => %8, #9 => %19)::Int64
│    %13 = Base.add_int(%11, 1)::Int64
│    %14 = (%12 === %2)::Bool
└───       goto #7 if not %14
6 ──       goto #8
7 ── %17 = Base.add_int(%12, 1)::Int64
└───       goto #8
8 ┄─ %19 = φ (#7 => %17)::Int64
│    %20 = φ (#6 => true, #7 => false)::Bool
│    %21 = Base.not_int(%20)::Bool
└───       goto #10 if not %21
9 ──       goto #5
10 ┄ %24 = φ (#8 => %13, #4 => 0)::Int64
└───       return %24
) => Int64
=#

@noinline function foo5(a::Int64)
        if a > 10
                res = 1+a
                return res
        else
                return "a"
        end
end
