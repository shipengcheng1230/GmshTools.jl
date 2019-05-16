export @fun_args, match_tuple
export @addField

"To match the tuple expression inside `begin` block and discard the rest."
match_tuple = @λ begin
    e::Expr -> e.head == :tuple ? e : nothing
    a -> nothing
end

"To call the tuple args by `f`."
macro fun_args(f, expr)
    args = filter(!isnothing, map(match_tuple, expr.args))
    exs = [:($(f)($(arg.args...))) for arg in args]
    Expr(:block, (esc(ex) for ex in exs)...)
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

@generated function parse_field_arg(tag::Integer, option::String, val::Number)
    :(gmsh.model.mesh.field.setNumber(tag, option, val))
end

@generated function parse_field_arg(tag::Integer, option::String, val::AbstractVector)
    :(gmsh.model.mesh.field.setNumbers(tag, option, val))
end

@generated function parse_field_arg(tag::Integer, option::String, val::AbstractString)
    :(gmsh.model.mesh.field.setString(tag, option, val))
end

"To add gmsh.model.mesh.field."
macro addField(tag, name, expr)
    args = filter(!isnothing, map(match_tuple, expr.args))
    exs = [:(GmshTools.parse_field_arg($(tag), $(arg.args...))) for arg in args]
    # this `esc` whole thing again deals with Linux `Main.gmsh`
    esc(quote
        gmsh.model.mesh.field.add($(name), $(tag))
        $(Expr(:block, (ex for ex in exs)...))
    end)
end
