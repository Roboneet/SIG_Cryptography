xorHex(a, b) = bytes2hex(xor.(hex2bytes(a), hex2bytes(b)))

function writeOutput(s::String)
    f = open("output.txt", "w")
    write(f, s)
    close(f)
end

function process(f::IOStream)
    lines = readlines(f)
    writeOutput(xorHex(lines[1], lines[2]))
end

open(process, "input.txt")
