using LightGraphs, MetaGraphs, Gadfly, GraphPlot

#=vertex meta:
Level -> doesn't mean very much at the moment
Expr -> function to be called
Type -> type returned by the function
=#
const ignore_f = [Symbol("gotoifnot"), Symbol("return")]

function rpl_slotnums(expr::Expr, sltnms::Vector{Symbol})
    #this assumes the functions don't call lower functions
    ret_expr = expr
    for (i,arg) in enumerate(expr.args)
        if typeof(arg) == Core.SlotNumber
            #println(arg.id, typeof(arg.id))
            ret_expr.args[i] = sltnms[arg.id]
        end
    end
    return ret_expr
end

function fcgraph(ci::Base.CodeInfo)
    fcg = MetaDiGraph(SimpleDiGraph(1))
    if !ci.inferred
        error("CodeInfo object has no type inference")
    else
        #init graph
        MetaGraphs.set_props!(fcg, 1, Dict(:Level=>"Main", :Expr=>:(), :Type=>:()))
        i=2
        for (line, type) in zip(ci.code,ci.ssavaluetypes)
            #check for actual calls
            if typeof(line) == Core.Expr
                if line.head ∉ ignore_f
                    #add vertex
                    LightGraphs.add_vertex!(fcg)
                    MetaGraphs.set_props!(fcg, i, Dict(:Level=>2, :Expr=>rpl_slotnums(line, ci.slotnames), :Type=>type))
                    LightGraphs.add_edge!(fcg, 1, i)
                    i+=1
                end
            end
        end
    end
    return fcg
end

A=[1 2; 3 4]
B=[0 1; -1 0]
v = [1; 2]
a=1

#get the codeinfo
ci1 = @code_typed m_v_mult(A,v)
ci1_t = first(ci1)
ci2 = @code_typed foo2(a)
ci2_t = first(ci2)
ci3_t = first( @code_typed m_m_mult(A,B) )
ci4_t = first( @code_typed foo1_2(a) )
ci5_t = first( @code_typed foo1_5(a) )
ci6_t = first( @code_typed foo3(a) )

fcg1 = fcgraph(ci6_t)

gplot(fcg1)

for i in 2:size(fcg1)[1] #vertices
    println(MetaGraphs.props(fcg1, i))
end
#=
Dict{Symbol,Any}(:Type => Bool,:Expr => :(Base.sle_int(1, a)),:Level => 2)
Dict{Symbol,Any}(:Type => Int64,:Expr => :(Base.ifelse(%1, a, 0)),:Level => 2)
Dict{Symbol,Any}(:Type => Bool,:Expr => :(Base.slt_int(%2, 1)),:Level => 2)
Dict{Symbol,Any}(:Type => Bool,:Expr => :(Base.not_int(%7)),:Level => 2)
Dict{Symbol,Any}(:Type => Int64,:Expr => :(Base.add_int(%11, 1)),:Level => 2)
Dict{Symbol,Any}(:Type => Bool,:Expr => :(%12 === %2),:Level => 2)
Dict{Symbol,Any}(:Type => Int64,:Expr => :(Base.add_int(%12, 1)),:Level => 2)
Dict{Symbol,Any}(:Type => Bool,:Expr => :(Base.not_int(%20)),:Level => 2)
=#
