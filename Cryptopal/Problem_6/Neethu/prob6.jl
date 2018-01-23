include("../../Problem_4/Neethu/xor.jl")

function hamming_distance(a, b)
    c = xor.(a, b)
    d = [count(x-> x=='1', bits(k)) for k in c]
    return sum(d)
end


hamming_distance(map(Int, collect("this is a test")), map(Int, collect("wokka wokka!!!")))


open("input.txt") do io
    str = readstring(io)
    process(base64decode(str))
end

function process(soup)
    dist = [(avgHammingDistance(soup, i), i) for i=2:40]
    v = view(sort(dist, by=x->x[1]), 1:5)
    len = v[1][2]

    blocks = breakCipher(Cipher(soup), len);
    a = [single_letter_xor_analysis(b) for b in blocks];
    writeOutput(joinCipher(a))
end

function avgHammingDistance(soup, i)
    return (sum([hamming_distance(soup[(2i*m + 1):(2i*m + i)], soup[(2i*m + i+1):(2i*m + 2i)]) for m=0:6])/i)
end

function breakCipher(c::Cipher, len::Int64)
    blocks = [[] for i=1:len];
    for i=0:(length(c.list)-1)
        push!(blocks[((i%len) + 1)],c.list[i + 1])
    end
    return [Cipher(i) for i in blocks]
end

function joinCipher(blocks::Array{Cipher})
    list = [];
    len  = sum(length(i.list) for i in blocks)
    key = [];
    blLen = length(blocks)
    for i=0:(len - 1)
        push!(list, shift!(blocks[((i%blLen) + 1)].list))
    end
    for i=0:(blLen-1)
        push!(key, blocks[i + 1].key)
    end
    return Cipher(list, key)
end


function writeOutput(c::Cipher)
    open("output_julia.txt", "w") do io
        write(io, "Key: ")
        write(io, String(join(map(Char,collect(c.key)))))
        write(io, "\nSecret Message: \n")
        write(io, String(join(map(Char, c.list))))
    end
end
