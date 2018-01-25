include("aes_helpers.jl")

open("input.txt") do io
    str = readstring(io)
    key = map(UInt8, collect("YELLOW SUBMARINE"))
    writeOutput(join(map(Char, aesDecrypt(base64decode(str), key))))
end

function writeOutput(str)
    open("output_julia.txt", "w") do io
        write(io, str)
    end
end

function aesDecrypt(text::Array{UInt8}, key::Array{UInt8})
    keyList = inverseKeyExpansion(key)
    textList = [collect(view(text, i:(i+15))) for i=1:16:(length(text)-15)]
    decryptedBlocks = [aesDecryptBlock([collect(view(t, i:(i+3))) for i=1:4:13], keyList) for t in textList]
    return flattenBlocks(decryptedBlocks)
end

function flattenBlocks(blocks::Array{Array{Array{UInt8,1},1},1})
    k = hcat(blocks...)
    v = hcat(k...)
    return v
end

function aesDecryptBlock(block::Array{Array{UInt8,1},1}, keyList::Array{Array{Array{UInt8,1},1},1})
    state = addRoundKey(block, keyList[11]);
    for i=1:9
        state = inverseSubstituteBlock(state)
        state = inverseShiftRows(state)

        state = inverseMixColumns(state)
        state = addRoundKey(state, keyList[11 - i])
    end

    state = inverseShiftRows(state)
    state = inverseSubstituteBlock(state)

    state = addRoundKey(state, keyList[1])
    return state
end
