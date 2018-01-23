include("xor.jl")
# using __XOR_ANALYSIS__

# IO
function process(f::IOStream)
    str = readlines(f);
    ciphers = [(Cipher(hex2bytes(i))) for i in str]

    # print(cipher)
    store = [];
    for cipher in ciphers
        f = single_letter_xor_analysis(cipher)
        if( f != false)
            push!(store, f)
            # print(join(map(Char,f.list)))
        end
    end
    store = sort(store, by=x->x.score)
    a = store[end];
    writeOutput("String: " * join([Char(i) for i in a.list]) * "\nKey: " * Char(a.key))
end

function writeOutput(message)
    open("output.txt", "w") do io
        write(io, message)
    end
end

open(process, "input.txt")
