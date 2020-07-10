# same as `sum.jl`, but reusing the Julia compiler to compile and execute the IR

using Test

using LLVM
using LLVM.Interop

if length(ARGS) == 2
    x, y = parse.([Int32], ARGS[1:2])
else
    x = Int32(1)
    y = Int32(2)
end

JuliaContext() do ctx
    param_types = [LLVM.Int32Type(ctx), LLVM.Int32Type(ctx)]
    ret_type = LLVM.Int32Type(ctx)
    sum, _ = create_function(ret_type, param_types)

    # generate IR
    Builder(ctx) do builder
        entry = BasicBlock(sum, "entry", ctx)
        position!(builder, entry)

        tmp = add!(builder, parameters(sum)[1], parameters(sum)[2], "tmp")
        ret!(builder, tmp)
    end

    # make Julia compile and execute the function
    push!(function_attributes(sum), EnumAttribute("alwaysinline"))
    @eval call_sum(x, y) = $(call_function(sum, Int32, Tuple{Int32, Int32}, :(x, y)))
end

@test call_sum(x, y) == x + y
