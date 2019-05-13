export @fun_args, @match_tuple
export @addpoints, @addlines

"To match the tuple expression inside `begin` block and discard the rest."
match_tuple = @λ begin
    e::Expr -> e.head == :tuple ? e : nothing
    a -> nothing
end

"To call the tuple args by `f`."
macro fun_args(f, expr)
    args = filter!(!isnothing, map(match_tuple, expr.args))
    exs = [:($(f)($(arg.args...))) for arg in args]
    Expr(:block, ((esc(ex) for ex in exs)...))
end

macro addpoints(expr)
    esc(:(@fun_args gmsh.model.geo.addPoint $(expr)))
end

macro addlines(expr)
    esc(:(@fun_args gmsh.model.geo.addLine $(expr)))
end
