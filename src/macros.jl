export match_tuple
export @addField, @addOption

"To match the tuple expression inside `begin` block and discard the rest."
match_tuple = @λ begin
    e::Expr -> e.head == :tuple ? e : nothing
    a -> nothing
end

"To call the tuple args by `f`."
macro fun_call_tuple(f, expr)
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
            # https://github.com/JuliaLang/julia/issues/23221
            esc(:(GmshTools.@fun_call_tuple($$(QuoteNode(v)), $(expr))))
        end
    end
end

function parse_field_arg(tag::Integer, option::String, val::Number)
    gmsh.model.mesh.field.setNumber(tag, option, val)
end

function parse_field_arg(tag::Integer, option::String, val::AbstractVector)
    gmsh.model.mesh.field.setNumbers(tag, option, val)
end

function parse_field_arg(tag::Integer, option::String, val::AbstractString)
    gmsh.model.mesh.field.setString(tag, option, val)
end

"To add `gmsh.model.mesh.field`."
macro addField(tag, name, expr)
    args = filter(!isnothing, map(match_tuple, expr.args))
    exs = [:(parse_field_arg($(esc(tag)), $(map(esc, arg.args)...))) for arg in args]
    ex1 = esc(:(gmsh.model.mesh.field.add($(name), $(tag))))
    quote
        $(ex1)
        $(Expr(:block, (ex for ex in exs)...))
    end
end

function parse_option_arg(name, val::AbstractString)
    gmsh.option.setString(name, val)
end

function parse_option_arg(name, val::Number)
    gmsh.option.setNumber(name, val)
end

# not available for v4.3.0
# function parse_option_arg(name, r::I, g::I, b::I, a::I=0) where I<:Integer
#     gmsh.option.setColor(name, r, g, b, a)
# end

"To add `gmsh.option`."
macro addOption(expr)
    args = filter(!isnothing, map(match_tuple, expr.args))
    exs = [:(parse_option_arg($(map(esc, arg.args)...))) for arg in args]
    Expr(:block, (ex for ex in exs)...)
end
