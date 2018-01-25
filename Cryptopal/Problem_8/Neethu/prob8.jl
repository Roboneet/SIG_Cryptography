include("../../Problem_6/Neethu/hamming.jl")
open("input.txt") do io
    lines = map(hex2bytes, readlines(io))
    scores = [(score(lines[i]), i) for i=1:length(lines)]
    result = sort(scores, by=x->x[1])
    writeOutput(result[end][2])
    result[end]
end

function writeOutput(no::Int64)
    open("output_julia.txt", "w") do io
        write(io, "Line No : ")
        write(io, string(no))
    end
end

function score(line::Array{UInt8,1})
    blocks = [view(line, i:(i+15)) for i=1:16:(length(line) - 15)]
    distances = [hamming_distance(blocks[i], blocks[j]) for i=1:length(blocks), j=1:length(blocks)]
    return triuZeros(distances)
end


function triuZeros(arr::Array{Int64,2})
    (x, y) = size(arr)
    c = 0
    for i=1:1:x
        for j=(i + 1):1:y
            (arr[i*x + j] == 0)?(c = c + 1):"";
        end
    end
    return c
end
