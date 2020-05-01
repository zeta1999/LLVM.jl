const __bodyfunction__ = Dict{Method,Any}()

# Find keyword "body functions" (the function that contains the body
# as written by the developer, called after all missing keyword-arguments
# have been assigned values), in a manner that doesn't depend on
# gensymmed names.
# `mnokw` is the method that gets called when you invoke it without
# supplying any keywords.
function __lookup_kwbody__(mnokw::Method)
    function getsym(arg)
        isa(arg, Symbol) && return arg
        @assert isa(arg, GlobalRef)
        return arg.name
    end

    f = get(__bodyfunction__, mnokw, nothing)
    if f === nothing
        fmod = mnokw.module
        # The lowered code for `mnokw` should look like
        #   %1 = mkw(kwvalues..., #self#, args...)
        #        return %1
        # where `mkw` is the name of the "active" keyword body-function.
        ast = Base.uncompressed_ast(mnokw)
        if isa(ast, Core.CodeInfo) && length(ast.code) >= 2
            callexpr = ast.code[end-1]
            if isa(callexpr, Expr) && callexpr.head == :call
                fsym = callexpr.args[1]
                if isa(fsym, Symbol)
                    f = getfield(fmod, fsym)
                elseif isa(fsym, GlobalRef)
                    if fsym.mod === Core && fsym.name === :_apply
                        f = getfield(mnokw.module, getsym(callexpr.args[2]))
                    elseif fsym.mod === Core && fsym.name === :_apply_iterate
                        f = getfield(mnokw.module, getsym(callexpr.args[3]))
                    else
                        f = getfield(fsym.mod, fsym.name)
                    end
                else
                    f = missing
                end
            else
                f = missing
            end
        else
            f = missing
        end
        __bodyfunction__[mnokw] = f
    end
    return f
end

function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    isdefined(LLVM, Symbol("#callback#19")) && precompile(Tuple{getfield(LLVM, Symbol("#callback#19")),Ptr{Nothing}})
    isdefined(LLVM, Symbol("#callback#20")) && precompile(Tuple{getfield(LLVM, Symbol("#callback#20")),Ptr{Nothing}})
    let fbody = try __lookup_kwbody__(which(any, (Function,Array{Target,1},))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Function,typeof(any),Function,Array{Target,1},))
        end
    end
    precompile(Tuple{Type{Array{Tuple{Instruction,BasicBlock},1}},UndefInitializer,Int64})
    precompile(Tuple{Type{Array{Tuple{LLVM.User,BasicBlock},1}},UndefInitializer,Int64})
    precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Axes,F,Args} where Args<:Tuple where F where Axes},typeof(convert),Tuple{Base.RefValue{Type{LLVMType}},Array{Any,1}}})
    precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Axes,F,Args} where Args<:Tuple where F where Axes},typeof(convert),Tuple{Base.RefValue{Type{LLVMType}},Array{DataType,1}}})
    precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Axes,F,Args} where Args<:Tuple where F where Axes},typeof(LLVM.ref),Tuple{Tuple{BasicBlock,BasicBlock}}})
    precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Axes,F,Args} where Args<:Tuple where F where Axes},typeof(LLVM.ref),Tuple{Tuple{ConstantFP,LLVM.FAddInst}}})
    precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Axes,F,Args} where Args<:Tuple where F where Axes},typeof(LLVM.ref),Tuple{Tuple{LLVM.AddInst,LLVM.SubInst}}})
    precompile(Tuple{Type{Base.Iterators.Zip},Tuple{Tuple{ConstantFP,BasicBlock},Tuple{LLVM.FAddInst,BasicBlock}}})
    precompile(Tuple{Type{Base.Iterators.Zip},Tuple{Tuple{LLVM.AddInst,BasicBlock},Tuple{LLVM.SubInst,BasicBlock}}})
    precompile(Tuple{Type{ConstantAggregateZero},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{ConstantExpr},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{ConstantInt},Int32})
    precompile(Tuple{Type{ConstantInt},Int64})
    precompile(Tuple{Type{ConstantInt},UInt64})
    precompile(Tuple{Type{Context}})
    precompile(Tuple{Type{GenericValue},LLVM.IntegerType,Int64})
    precompile(Tuple{Type{GenericValue},LLVM.IntegerType,UInt64})
    precompile(Tuple{Type{GenericValue},LLVM.LLVMDouble,Float32})
    precompile(Tuple{Type{GenericValue},LLVM.LLVMDouble,Float64})
    precompile(Tuple{Type{GenericValue},Ptr{UInt8}})
    precompile(Tuple{Type{LLVM.AShrInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.AddInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.AddrSpaceCastInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.AllocaInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.AndInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.BitCastInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.BrInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.CallInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FAddInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FCmpInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FDivInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FMulInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FPExtInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FPToSIInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FPToUIInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FPTruncInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FRemInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FSubInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.FenceInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.GetElementPtrInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.ICmpInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.IntToPtrInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.LShrInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.LabelType}})
    precompile(Tuple{Type{LLVM.LoadInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.MetadataAsValue},Array{LLVM.MetadataAsValue,1},Context})
    precompile(Tuple{Type{LLVM.MetadataAsValue},Array{LLVM.MetadataAsValue,1}})
    precompile(Tuple{Type{LLVM.MetadataAsValue},String,Context})
    precompile(Tuple{Type{LLVM.MetadataAsValue},String})
    precompile(Tuple{Type{LLVM.MulInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.OrInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.PHIInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.PointerType},LLVM.PointerType,Int64})
    precompile(Tuple{Type{LLVM.PtrToIntInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.ResumeInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.RetInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.SDivInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.SExtInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.SIToFPInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.SRemInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.SelectInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.ShlInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.StoreInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.StructType},Array{LLVM.VoidType,1}})
    precompile(Tuple{Type{LLVM.StructType},String})
    precompile(Tuple{Type{LLVM.SubInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.TruncInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.UDivInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.UIToFPInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.URemInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.UnreachableInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.VoidType}})
    precompile(Tuple{Type{LLVM.XorInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{LLVM.ZExtInst},Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{Type{MemoryBuffer},Array{UInt8,1}})
    precompile(Tuple{Type{ModulePassManager}})
    precompile(Tuple{Type{PassManagerBuilder}})
    precompile(Tuple{Type{TargetMachine},Target,String})
    precompile(Tuple{Type{Target},String})
    precompile(Tuple{typeof(!=),Context,Context})
    precompile(Tuple{typeof(!=),GlobalVariable,Nothing})
    precompile(Tuple{typeof(!=),LLVM.AllocaInst,Nothing})
    precompile(Tuple{typeof(!=),LLVM.IntegerType,LLVM.IntegerType})
    precompile(Tuple{typeof(!=),LLVM.Module,LLVM.Module})
    precompile(Tuple{typeof(==),Argument,Argument})
    precompile(Tuple{typeof(==),Array{Argument,1},Array{Argument,1}})
    precompile(Tuple{typeof(==),Array{Attribute,1},Array{EnumAttribute,1}})
    precompile(Tuple{typeof(==),Array{Attribute,1},Array{StringAttribute,1}})
    precompile(Tuple{typeof(==),Array{BasicBlock,1},Array{BasicBlock,1}})
    precompile(Tuple{typeof(==),Array{GlobalVariable,1},Array{GlobalVariable,1}})
    precompile(Tuple{typeof(==),Array{Instruction,1},Array{LLVM.BrInst,1}})
    precompile(Tuple{typeof(==),Array{LLVM.AddInst,1},Array{LLVM.AddInst,1}})
    precompile(Tuple{typeof(==),Array{LLVM.Function,1},Array{LLVM.Function,1}})
    precompile(Tuple{typeof(==),Array{LLVMType,1},Array{LLVM.IntegerType,1}})
    precompile(Tuple{typeof(==),Array{LLVMType,1},Array{LLVMType,1}})
    precompile(Tuple{typeof(==),Array{Value,1},Array{Any,1}})
    precompile(Tuple{typeof(==),BasicBlock,BasicBlock})
    precompile(Tuple{typeof(==),ConstantAggregateZero,ConstantAggregateZero})
    precompile(Tuple{typeof(==),ConstantInt,ConstantInt})
    precompile(Tuple{typeof(==),LLVM.AddInst,LLVM.AddInst})
    precompile(Tuple{typeof(==),LLVM.BrInst,LLVM.BrInst})
    precompile(Tuple{typeof(==),LLVM.Function,LLVM.Function})
    precompile(Tuple{typeof(==),LLVM.LLVMFloat,LLVM.LLVMFloat})
    precompile(Tuple{typeof(==),LLVM.MetadataAsValue,LLVM.MetadataAsValue})
    precompile(Tuple{typeof(==),LLVM.PointerType,LLVM.PointerType})
    precompile(Tuple{typeof(==),LLVM.RetInst,LLVM.RetInst})
    precompile(Tuple{typeof(==),LLVM.StructType,LLVM.StructType})
    precompile(Tuple{typeof(==),Metadata,Metadata})
    precompile(Tuple{typeof(==),Target,Target})
    precompile(Tuple{typeof(==),Use,Use})
    precompile(Tuple{typeof(Base.Broadcast.broadcasted),Function,Tuple{BasicBlock,BasicBlock}})
    precompile(Tuple{typeof(Base.Broadcast.broadcasted),Function,Tuple{ConstantFP,LLVM.FAddInst}})
    precompile(Tuple{typeof(Base.Broadcast.broadcasted),Function,Tuple{LLVM.AddInst,LLVM.SubInst}})
    precompile(Tuple{typeof(Base.Broadcast.combine_styles),Base.RefValue{Type{LLVMType}},Array{Any,1}})
    precompile(Tuple{typeof(Base.Broadcast.combine_styles),Base.RefValue{Type{LLVMType}},Array{DataType,1}})
    precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{LLVM.AddInst,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(user),Tuple{Base.Broadcast.Extruded{Array{Use,1},Tuple{Bool},Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})
    precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{LLVM.AddInst,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(value),Tuple{Base.Broadcast.Extruded{Array{Use,1},Tuple{Bool},Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})
    precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{LLVM.IntegerType,1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(convert),Tuple{Base.RefValue{Type{LLVMType}},Base.Broadcast.Extruded{Array{DataType,1},Tuple{Bool},Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})
    precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{Ptr{LLVM.API.LLVMOpaqueType},1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(LLVM.ref),Tuple{Base.Broadcast.Extruded{Array{LLVMType,1},Tuple{Bool},Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})
    precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Array{Ptr{LLVM.API.LLVMOpaqueValue},1},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(LLVM.ref),Tuple{Base.Broadcast.Extruded{Array{Value,1},Tuple{Bool},Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})
    precompile(Tuple{typeof(Base.Broadcast.instantiate),Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Nothing,typeof(LLVM.ref),Tuple{Tuple{BasicBlock,BasicBlock}}}})
    precompile(Tuple{typeof(Base.Broadcast.instantiate),Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Nothing,typeof(LLVM.ref),Tuple{Tuple{ConstantFP,LLVM.FAddInst}}}})
    precompile(Tuple{typeof(Base.Broadcast.instantiate),Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Nothing,typeof(LLVM.ref),Tuple{Tuple{LLVM.AddInst,LLVM.SubInst}}}})
    precompile(Tuple{typeof(Base.Broadcast.materialize),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(convert),Tuple{Base.RefValue{Type{LLVMType}},Array{Any,1}}}})
    precompile(Tuple{typeof(Base.Broadcast.materialize),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Nothing,typeof(convert),Tuple{Base.RefValue{Type{LLVMType}},Array{DataType,1}}}})
    precompile(Tuple{typeof(Base.allocatedinline),Type{Ptr{LLVM.API.LLVMOpaqueExecutionEngine}}})
    precompile(Tuple{typeof(Base.allocatedinline),Type{Ptr{LLVM.API.LLVMOpaqueMemoryBuffer}}})
    precompile(Tuple{typeof(Base.allocatedinline),Type{Ptr{LLVM.API.LLVMOpaqueModule}}})
    precompile(Tuple{typeof(Base.allocatedinline),Type{Ptr{LLVM.API.LLVMOpaqueType}}})
    precompile(Tuple{typeof(Base.allocatedinline),Type{Ptr{LLVM.API.LLVMOpaqueValue}}})
    precompile(Tuple{typeof(Base.allocatedinline),Type{Value}})
    precompile(Tuple{typeof(Base.indexed_iterate),Base.Iterators.Zip{Tuple{Tuple{ConstantFP,BasicBlock},Tuple{LLVM.FAddInst,BasicBlock}}},Int64,Tuple{Int64,Int64}})
    precompile(Tuple{typeof(Base.indexed_iterate),Base.Iterators.Zip{Tuple{Tuple{ConstantFP,BasicBlock},Tuple{LLVM.FAddInst,BasicBlock}}},Int64})
    precompile(Tuple{typeof(Base.indexed_iterate),Base.Iterators.Zip{Tuple{Tuple{LLVM.AddInst,BasicBlock},Tuple{LLVM.SubInst,BasicBlock}}},Int64,Tuple{Int64,Int64}})
    precompile(Tuple{typeof(Base.indexed_iterate),Base.Iterators.Zip{Tuple{Tuple{LLVM.AddInst,BasicBlock},Tuple{LLVM.SubInst,BasicBlock}}},Int64})
    precompile(Tuple{typeof(Base.promote_typeof),Tuple{ConstantFP,BasicBlock},Tuple{LLVM.FAddInst,BasicBlock}})
    precompile(Tuple{typeof(Base.promote_typeof),Tuple{LLVM.AddInst,BasicBlock},Tuple{LLVM.SubInst,BasicBlock}})
    precompile(Tuple{typeof(Base.vect),LLVM.AddInst})
    precompile(Tuple{typeof(Base.vect),LLVM.BrInst})
    precompile(Tuple{typeof(Base.vect),LLVM.IntegerType,Vararg{Any,N} where N})
    precompile(Tuple{typeof(Base.vect),LLVM.MetadataAsValue})
    precompile(Tuple{typeof(Base.vect),LLVM.VoidType})
    precompile(Tuple{typeof(Base.vect),Tuple{ConstantFP,BasicBlock},Vararg{Any,N} where N})
    precompile(Tuple{typeof(Base.vect),Tuple{LLVM.AddInst,BasicBlock},Vararg{Any,N} where N})
    precompile(Tuple{typeof(Core.Compiler.eltype),Type{Array{Tuple{Instruction,BasicBlock},1}}})
    precompile(Tuple{typeof(Core.Compiler.eltype),Type{Array{Tuple{LLVM.User,BasicBlock},1}}})
    precompile(Tuple{typeof(DEBUG_METADATA_VERSION)})
    precompile(Tuple{typeof(GlobalContext)})
    precompile(Tuple{typeof(GlobalPassRegistry)})
    precompile(Tuple{typeof(InitializeAllTargetInfos)})
    precompile(Tuple{typeof(InitializeAllTargetMCs)})
    precompile(Tuple{typeof(InitializeAnalysis),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeCodeGen),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeCore),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeIPA),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeIPO),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeInstCombine),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeInstrumentation),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeNativeAsmPrinter)})
    precompile(Tuple{typeof(InitializeNativeTarget)})
    precompile(Tuple{typeof(InitializeObjCARCOpts),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeScalarOpts),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeTarget),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeTransformUtils),LLVM.PassRegistry})
    precompile(Tuple{typeof(InitializeVectorization),LLVM.PassRegistry})
    precompile(Tuple{typeof(LLVM.API.LLVMAddIncoming),Ptr{LLVM.API.LLVMOpaqueValue},Array{Ptr{LLVM.API.LLVMOpaqueValue},1},Array{Ptr{LLVM.API.LLVMOpaqueValue},1},Int64})
    precompile(Tuple{typeof(LLVM.API.LLVMBuildAggregateRet),Ptr{LLVM.API.LLVMOpaqueBuilder},Array{Any,1},Int64})
    precompile(Tuple{typeof(LLVM.API.LLVMBuildCall),Ptr{LLVM.API.LLVMOpaqueBuilder},Ptr{LLVM.API.LLVMOpaqueValue},Array{Any,1},Int64,String})
    precompile(Tuple{typeof(LLVM.API.LLVMBuildCall),Ptr{LLVM.API.LLVMOpaqueBuilder},Ptr{LLVM.API.LLVMOpaqueValue},Array{Ptr{LLVM.API.LLVMOpaqueValue},1},Int64,String})
    precompile(Tuple{typeof(LLVM.API.LLVMCountIncoming),Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{typeof(LLVM.API.LLVMCreateFunctionPass),String,Function})
    precompile(Tuple{typeof(LLVM.API.LLVMCreateModulePass),String,Function})
    precompile(Tuple{typeof(LLVM.API.LLVMFunctionType),Ptr{LLVM.API.LLVMOpaqueType},Array{Any,1},Int64,Int32})
    precompile(Tuple{typeof(LLVM.API.LLVMGetFirstUse),Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{typeof(LLVM.API.LLVMGetMetadata),Ptr{LLVM.API.LLVMOpaqueValue},LLVM.MD})
    precompile(Tuple{typeof(LLVM.API.LLVMGetNumOperands),Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{typeof(LLVM.API.LLVMGetNumSuccessors),Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{typeof(LLVM.API.LLVMGetOperand),Ptr{LLVM.API.LLVMOpaqueValue},Int64})
    precompile(Tuple{typeof(LLVM.API.LLVMGetSuccessor),Ptr{LLVM.API.LLVMOpaqueValue},Int64})
    precompile(Tuple{typeof(LLVM.API.LLVMHasMetadata),Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{typeof(LLVM.API.LLVMSetMetadata),Ptr{LLVM.API.LLVMOpaqueValue},LLVM.MD,Ptr{LLVM.API.LLVMOpaqueValue}})
    precompile(Tuple{typeof(LLVM.API.LLVMSetSuccessor),Ptr{LLVM.API.LLVMOpaqueValue},Int64,Ptr{LLVM.API.LLVMOpaqueBasicBlock}})
    precompile(Tuple{typeof(LLVM.API.LLVMStructSetBody),Ptr{LLVM.API.LLVMOpaqueType},Array{Ptr{LLVM.API.LLVMOpaqueType},1},Int64,Int32})
    precompile(Tuple{typeof(LLVM.API.LLVMStructTypeInContext),Ptr{LLVM.API.LLVMOpaqueContext},Array{Ptr{LLVM.API.LLVMOpaqueType},1},Int64,Int32})
    precompile(Tuple{typeof(LLVM.DoubleType)})
    precompile(Tuple{typeof(LLVM.Int1Type)})
    precompile(Tuple{typeof(LLVM.Interop.JuliaContext)})
    precompile(Tuple{typeof(LLVM.Interop.call_function),LLVM.Function,Type{T} where T,Type{T} where T,Expr})
    precompile(Tuple{typeof(LLVM.Interop.create_function),LLVM.IntegerType,Array{LLVM.IntegerType,1}})
    precompile(Tuple{typeof(LLVM.Interop.create_function),LLVM.IntegerType,Array{LLVMType,1}})
    precompile(Tuple{typeof(LLVM.Interop.create_function),LLVM.StructType,Array{LLVMType,1}})
    precompile(Tuple{typeof(LLVM.Interop.create_function),LLVM.VoidType,Array{LLVMType,1}})
    precompile(Tuple{typeof(LLVM.Interop.isboxed),Type{T} where T})
    precompile(Tuple{typeof(LLVM.Interop.isghosttype),Type})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMAShr}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMAddrSpaceCast}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMAdd}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMAlloca}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMAnd}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMBitCast}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMBr}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMCall}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFAdd}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFCmp}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFDiv}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFMul}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFPExt}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFPToSI}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFPToUI}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFPTrunc}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFRem}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFSub}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMFence}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMGetElementPtr}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMICmp}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMIntToPtr}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMLShr}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMLoad}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMMul}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMOr}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMPHI}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMPtrToInt}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMResume}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMRet}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMSDiv}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMSExt}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMSIToFP}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMSRem}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMSelect}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMShl}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMStore}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMSub}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMTrunc}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMUDiv}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMUIToFP}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMURem}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMUnreachable}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMXor}})
    precompile(Tuple{typeof(LLVM.identify),Type{Instruction},Val{LLVM.API.LLVMZExt}})
    precompile(Tuple{typeof(LLVM.identify),Type{LLVMType},Val{LLVM.API.LLVMArrayTypeKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{LLVMType},Val{LLVM.API.LLVMFloatTypeKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{LLVMType},Val{LLVM.API.LLVMIntegerTypeKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{LLVMType},Val{LLVM.API.LLVMPointerTypeKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{LLVMType},Val{LLVM.API.LLVMStructTypeKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{LLVMType},Val{LLVM.API.LLVMVoidTypeKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{Value},Val{LLVM.API.LLVMArgumentValueKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{Value},Val{LLVM.API.LLVMConstantAggregateZeroValueKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{Value},Val{LLVM.API.LLVMConstantExprValueKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{Value},Val{LLVM.API.LLVMConstantIntValueKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{Value},Val{LLVM.API.LLVMFunctionValueKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{Value},Val{LLVM.API.LLVMGlobalVariableValueKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{Value},Val{LLVM.API.LLVMInstructionValueKind}})
    precompile(Tuple{typeof(LLVM.identify),Type{Value},Val{LLVM.API.LLVMMetadataAsValueValueKind}})
    precompile(Tuple{typeof(LLVM.incoming),LLVM.PHIInst})
    precompile(Tuple{typeof(LLVM.parent),LLVM.BrInst})
    precompile(Tuple{typeof(MemoryBufferFile),String})
    precompile(Tuple{typeof(add!),Builder,LLVM.AddInst,ConstantInt})
    precompile(Tuple{typeof(alignment!),LLVM.LoadInst,Int64})
    precompile(Tuple{typeof(alignment),LLVM.LoadInst})
    precompile(Tuple{typeof(all),Function,LLVM.StructTypeElementSet})
    precompile(Tuple{typeof(any),Function,Array{Target,1}})
    precompile(Tuple{typeof(append!),PhiIncomingSet,Array{Tuple{Instruction,BasicBlock},1}})
    precompile(Tuple{typeof(append!),PhiIncomingSet,Array{Tuple{LLVM.User,BasicBlock},1}})
    precompile(Tuple{typeof(br!),Builder,LLVM.FCmpInst,BasicBlock,BasicBlock})
    precompile(Tuple{typeof(br!),Builder,LLVM.ICmpInst,BasicBlock,BasicBlock})
    precompile(Tuple{typeof(called_value),LLVM.CallInst})
    precompile(Tuple{typeof(collect),LLVM.TargetSet})
    precompile(Tuple{typeof(collect),Tuple{Ptr{LLVM.API.LLVMOpaqueValue},Ptr{LLVM.API.LLVMOpaqueValue}}})
    precompile(Tuple{typeof(condition!),LLVM.BrInst,Argument})
    precompile(Tuple{typeof(condition),LLVM.BrInst})
    precompile(Tuple{typeof(context),LLVM.AllocaInst})
    precompile(Tuple{typeof(context),LLVM.IntegerType})
    precompile(Tuple{typeof(context),LLVM.LabelType})
    precompile(Tuple{typeof(context),LLVM.StructType})
    precompile(Tuple{typeof(context),LLVM.VoidType})
    precompile(Tuple{typeof(convert),Type{Bool},Int32})
    precompile(Tuple{typeof(convert),Type{Float32},GenericValue,LLVM.LLVMDouble})
    precompile(Tuple{typeof(convert),Type{Float64},GenericValue,LLVM.LLVMDouble})
    precompile(Tuple{typeof(convert),Type{Int32},ConstantInt})
    precompile(Tuple{typeof(convert),Type{Int64},GenericValue})
    precompile(Tuple{typeof(convert),Type{LLVM.Bool},Bool})
    precompile(Tuple{typeof(convert),Type{LLVMType},Type{T} where T})
    precompile(Tuple{typeof(convert),Type{Ptr{Nothing}},GenericValue})
    precompile(Tuple{typeof(convert),Type{UInt64},GenericValue})
    precompile(Tuple{typeof(copy),Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Nothing,typeof(LLVM.ref),Tuple{Tuple{BasicBlock,BasicBlock}}}})
    precompile(Tuple{typeof(copy),Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Nothing,typeof(LLVM.ref),Tuple{Tuple{ConstantFP,LLVM.FAddInst}}}})
    precompile(Tuple{typeof(copy),Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple},Nothing,typeof(LLVM.ref),Tuple{Tuple{LLVM.AddInst,LLVM.SubInst}}}})
    precompile(Tuple{typeof(copyto!),Array{Tuple{Instruction,BasicBlock},1},Tuple{Tuple{LLVM.AddInst,BasicBlock},Tuple{LLVM.SubInst,BasicBlock}}})
    precompile(Tuple{typeof(copyto!),Array{Tuple{LLVM.User,BasicBlock},1},Tuple{Tuple{ConstantFP,BasicBlock},Tuple{LLVM.FAddInst,BasicBlock}}})
    precompile(Tuple{typeof(debuglocation!),Builder,LLVM.RetInst})
    precompile(Tuple{typeof(delete!),BasicBlock,LLVM.RetInst})
    precompile(Tuple{typeof(description),Target})
    precompile(Tuple{typeof(dispose),Context})
    precompile(Tuple{typeof(dispose),GenericValue})
    precompile(Tuple{typeof(dispose),MemoryBuffer})
    precompile(Tuple{typeof(dispose),ModulePassManager})
    precompile(Tuple{typeof(dispose),PassManagerBuilder})
    precompile(Tuple{typeof(dispose),TargetMachine})
    precompile(Tuple{typeof(eltype),LLVM.TargetSet})
    precompile(Tuple{typeof(fadd!),Builder,LLVM.CallInst,LLVM.CallInst,String})
    precompile(Tuple{typeof(fadd!),Builder,LLVM.FAddInst,LLVM.LoadInst,String})
    precompile(Tuple{typeof(fadd!),Builder,LLVM.LoadInst,ConstantFP,String})
    precompile(Tuple{typeof(fadd!),Builder,LLVM.LoadInst,LLVM.LoadInst,String})
    precompile(Tuple{typeof(fcmp!),Builder,LLVM.API.LLVMRealPredicate,LLVM.LoadInst,ConstantFP,String})
    precompile(Tuple{typeof(fcmp!),Builder,LLVM.API.LLVMRealPredicate,LLVM.LoadInst,LLVM.LoadInst,String})
    precompile(Tuple{typeof(fcmp!),Builder,LLVM.API.LLVMRealPredicate,LLVM.UIToFPInst,ConstantFP,String})
    precompile(Tuple{typeof(fcmp!),Builder,LLVM.API.LLVMRealPredicate,LLVM.UIToFPInst,ConstantFP})
    precompile(Tuple{typeof(first),LLVM.TargetSet})
    precompile(Tuple{typeof(fsub!),Builder,LLVM.LoadInst,ConstantFP,String})
    precompile(Tuple{typeof(get),LLVM.TargetSet,String,String})
    precompile(Tuple{typeof(getindex),LLVM.TargetSet,String})
    precompile(Tuple{typeof(getindex),Type{LLVMType},LLVM.IntegerType})
    precompile(Tuple{typeof(hasasmparser),Target})
    precompile(Tuple{typeof(hasjit),Target})
    precompile(Tuple{typeof(haskey),LLVM.TargetSet,String})
    precompile(Tuple{typeof(hastargetmachine),Target})
    precompile(Tuple{typeof(in),BasicBlock,LLVM.FunctionBlockSet})
    precompile(Tuple{typeof(in),GlobalVariable,LLVM.ModuleGlobalSet})
    precompile(Tuple{typeof(in),LLVM.BrInst,LLVM.BasicBlockInstructionSet})
    precompile(Tuple{typeof(in),LLVM.Function,LLVM.ModuleFunctionSet})
    precompile(Tuple{typeof(in),LLVM.RetInst,LLVM.BasicBlockInstructionSet})
    precompile(Tuple{typeof(initializer!),GlobalVariable,ConstantAggregateZero})
    precompile(Tuple{typeof(initializer!),GlobalVariable,ConstantFP})
    precompile(Tuple{typeof(intwidth),GenericValue})
    precompile(Tuple{typeof(isconditional),LLVM.BrInst})
    precompile(Tuple{typeof(isconstant),LLVM.AllocaInst})
    precompile(Tuple{typeof(isempty),InstructionMetadataDict})
    precompile(Tuple{typeof(isempty),LLVM.ArrayType})
    precompile(Tuple{typeof(isempty),LLVM.BasicBlockInstructionSet})
    precompile(Tuple{typeof(isempty),LLVM.FunctionBlockSet})
    precompile(Tuple{typeof(isempty),LLVM.FunctionParameterSet})
    precompile(Tuple{typeof(isempty),LLVM.ModuleFunctionSet})
    precompile(Tuple{typeof(isempty),LLVM.ModuleGlobalSet})
    precompile(Tuple{typeof(isempty),LLVMType})
    precompile(Tuple{typeof(ismultithreaded)})
    precompile(Tuple{typeof(isnull),ConstantInt})
    precompile(Tuple{typeof(isterminator),LLVM.AddInst})
    precompile(Tuple{typeof(isterminator),LLVM.BrInst})
    precompile(Tuple{typeof(isundef),LLVM.AllocaInst})
    precompile(Tuple{typeof(llvmtype),LLVM.AllocaInst})
    precompile(Tuple{typeof(load!),Builder,GlobalVariable,String})
    precompile(Tuple{typeof(load!),Builder,LLVM.AllocaInst,String})
    precompile(Tuple{typeof(metadata),LLVM.BrInst})
    precompile(Tuple{typeof(metadata),LLVM.RetInst})
    precompile(Tuple{typeof(name!),LLVM.AllocaInst,String})
    precompile(Tuple{typeof(name),LLVM.AllocaInst})
    precompile(Tuple{typeof(name),LLVM.Module})
    precompile(Tuple{typeof(name),Target})
    precompile(Tuple{typeof(opcode),LLVM.BrInst})
    precompile(Tuple{typeof(opcode),LLVM.RetInst})
    precompile(Tuple{typeof(operands),LLVM.AddInst})
    precompile(Tuple{typeof(operands),LLVM.RetInst})
    precompile(Tuple{typeof(parse),Type{LLVM.Module},Array{UInt8,1}})
    precompile(Tuple{typeof(parse),Type{LLVM.Module},String})
    precompile(Tuple{typeof(position!),Builder,LLVM.AllocaInst})
    precompile(Tuple{typeof(push!),Array{Instruction,1},LLVM.BrInst})
    precompile(Tuple{typeof(push!),Array{Value,1},ConstantFP})
    precompile(Tuple{typeof(push!),Array{Value,1},LLVM.FSubInst})
    precompile(Tuple{typeof(replace_uses!),LLVM.AddInst,LLVM.AddInst})
    precompile(Tuple{typeof(ret!),Builder,LLVM.AddInst})
    precompile(Tuple{typeof(ret!),Builder,LLVM.CallInst})
    precompile(Tuple{typeof(ret!),Builder,LLVM.FAddInst})
    precompile(Tuple{typeof(ret!),Builder,LLVM.LoadInst})
    precompile(Tuple{typeof(ret!),Builder,LLVM.PHIInst})
    precompile(Tuple{typeof(select!),Builder,LLVM.ICmpInst,Argument,Argument})
    precompile(Tuple{typeof(setindex!),Array{LLVM.AddInst,1},LLVM.AddInst,Int64})
    precompile(Tuple{typeof(setindex!),Array{Value,1},ConstantInt,Int64})
    precompile(Tuple{typeof(setindex!),Array{Value,1},LLVM.MetadataAsValue,Int64})
    precompile(Tuple{typeof(show),Base.DevNull,LLVM.AllocaInst})
    precompile(Tuple{typeof(show),Base.DevNull,LLVM.IntegerType})
    precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(LLVM.ref),Tuple{Base.Broadcast.Extruded{Array{LLVMType,1},Tuple{Bool},Tuple{Int64}}}},Type{Ptr{LLVM.API.LLVMOpaqueType}}})
    precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(LLVM.ref),Tuple{Base.Broadcast.Extruded{Array{Value,1},Tuple{Bool},Tuple{Int64}}}},Type{Ptr{LLVM.API.LLVMOpaqueValue}}})
    precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(convert),Tuple{Base.RefValue{Type{LLVMType}},Base.Broadcast.Extruded{Array{DataType,1},Tuple{Bool},Tuple{Int64}}}},Type{LLVM.IntegerType}})
    precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(user),Tuple{Base.Broadcast.Extruded{Array{Use,1},Tuple{Bool},Tuple{Int64}}}},Type{LLVM.AddInst}})
    precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1},Tuple{Base.OneTo{Int64}},typeof(value),Tuple{Base.Broadcast.Extruded{Array{Use,1},Tuple{Bool},Tuple{Int64}}}},Type{LLVM.AddInst}})
    precompile(Tuple{typeof(store!),Builder,Argument,LLVM.AllocaInst})
    precompile(Tuple{typeof(store!),Builder,ConstantFP,LLVM.AllocaInst})
    precompile(Tuple{typeof(store!),Builder,LLVM.FAddInst,LLVM.AllocaInst})
    precompile(Tuple{typeof(store!),Builder,LLVM.LoadInst,LLVM.AllocaInst})
    precompile(Tuple{typeof(string),ConstantExpr})
    precompile(Tuple{typeof(string),GlobalVariable})
    precompile(Tuple{typeof(string),LLVM.AShrInst})
    precompile(Tuple{typeof(string),LLVM.AddInst})
    precompile(Tuple{typeof(string),LLVM.AddrSpaceCastInst})
    precompile(Tuple{typeof(string),LLVM.AllocaInst})
    precompile(Tuple{typeof(string),LLVM.AndInst})
    precompile(Tuple{typeof(string),LLVM.BitCastInst})
    precompile(Tuple{typeof(string),LLVM.BrInst})
    precompile(Tuple{typeof(string),LLVM.CallInst})
    precompile(Tuple{typeof(string),LLVM.FAddInst})
    precompile(Tuple{typeof(string),LLVM.FCmpInst})
    precompile(Tuple{typeof(string),LLVM.FDivInst})
    precompile(Tuple{typeof(string),LLVM.FMulInst})
    precompile(Tuple{typeof(string),LLVM.FPExtInst})
    precompile(Tuple{typeof(string),LLVM.FPToSIInst})
    precompile(Tuple{typeof(string),LLVM.FPToUIInst})
    precompile(Tuple{typeof(string),LLVM.FPTruncInst})
    precompile(Tuple{typeof(string),LLVM.FRemInst})
    precompile(Tuple{typeof(string),LLVM.FSubInst})
    precompile(Tuple{typeof(string),LLVM.FenceInst})
    precompile(Tuple{typeof(string),LLVM.GetElementPtrInst})
    precompile(Tuple{typeof(string),LLVM.ICmpInst})
    precompile(Tuple{typeof(string),LLVM.IntToPtrInst})
    precompile(Tuple{typeof(string),LLVM.LShrInst})
    precompile(Tuple{typeof(string),LLVM.LoadInst})
    precompile(Tuple{typeof(string),LLVM.MulInst})
    precompile(Tuple{typeof(string),LLVM.OrInst})
    precompile(Tuple{typeof(string),LLVM.PHIInst})
    precompile(Tuple{typeof(string),LLVM.PtrToIntInst})
    precompile(Tuple{typeof(string),LLVM.ResumeInst})
    precompile(Tuple{typeof(string),LLVM.RetInst})
    precompile(Tuple{typeof(string),LLVM.SDivInst})
    precompile(Tuple{typeof(string),LLVM.SExtInst})
    precompile(Tuple{typeof(string),LLVM.SIToFPInst})
    precompile(Tuple{typeof(string),LLVM.SRemInst})
    precompile(Tuple{typeof(string),LLVM.SelectInst})
    precompile(Tuple{typeof(string),LLVM.ShlInst})
    precompile(Tuple{typeof(string),LLVM.StoreInst})
    precompile(Tuple{typeof(string),LLVM.SubInst})
    precompile(Tuple{typeof(string),LLVM.TruncInst})
    precompile(Tuple{typeof(string),LLVM.UDivInst})
    precompile(Tuple{typeof(string),LLVM.UIToFPInst})
    precompile(Tuple{typeof(string),LLVM.URemInst})
    precompile(Tuple{typeof(string),LLVM.UnreachableInst})
    precompile(Tuple{typeof(string),LLVM.XorInst})
    precompile(Tuple{typeof(string),LLVM.ZExtInst})
    precompile(Tuple{typeof(successors),LLVM.BrInst})
    precompile(Tuple{typeof(targets)})
    precompile(Tuple{typeof(triple)})
    precompile(Tuple{typeof(uitofp!),Builder,LLVM.FCmpInst,LLVM.LLVMDouble,String})
    precompile(Tuple{typeof(unsafe_delete!),BasicBlock,LLVM.BrInst})
    precompile(Tuple{typeof(uses),LLVM.AddInst})
    precompile(Tuple{typeof(version)})
    precompile(Tuple{typeof(zip),Tuple{ConstantFP,BasicBlock},Vararg{Any,N} where N})
    precompile(Tuple{typeof(zip),Tuple{LLVM.AddInst,BasicBlock},Vararg{Any,N} where N})
end