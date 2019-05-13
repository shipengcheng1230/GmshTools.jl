export @fun_args, match_tuple

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

const GmshModelGeoOps = Dict(
    :addPoint => :(gmsh.model.geo.addPoint),
    :addLine => :(gmsh.model.geo.addLine),
    :setTransfiniteCurve => :(gmsh.model.geo.mesh.setTransfiniteCurve),
)

for (k, v) in GmshModelGeoOps
    @eval begin
        export $(Symbol("@" * String(k)))
        macro $(k)(expr)
            esc(:(@fun_args($$(QuoteNode(v)), $(expr))))
        end
    end
end
