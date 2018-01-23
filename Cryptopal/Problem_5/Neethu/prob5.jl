b = "ICE"

open("input.txt", "r") do io
    a = readstring(io)
    g = [b[i%3 + 1] for i=0:(length(a)-1)]
    h  = xor.(map(Int, collect(a)), map(Int, collect(g)))
    output = bytes2hex(map(UInt8, h))
    open("output.txt", "w") do f
        write(f, output)
    end
end
