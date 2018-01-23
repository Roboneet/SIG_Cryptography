using DataFrames

small_letters = [i for i=Int('a'):Int('z')]
capital_letters = [i for i=Int('A'):Int('Z')]
punctuation = map(Int, [',', ' ', '-', '!', '\''])
letters_code = union( small_letters, capital_letters, punctuation );
top_frequent = "EARIO"
top_frequent_codes = union([Int(i) for i in top_frequent], [Int(i) for i in lowercase(top_frequent)])

type Cipher
    list
    key
    score
end

Cipher(a, b) = Cipher(a, b, 0)
Cipher(a) = Cipher(a, missing)
Cipher(c::Cipher,x::Int) = Cipher(c.list, c.key, x)

valid(p::Cipher) = (length(union(p.list, letters_code)) == length(letters_code))

function score(p::Cipher)
    hist = Dict([(i, count(x-> x==i, p.list)) for i in p.list])
    hist = sort(collect(hist), by=x->x[2])
    l = length(hist)
    print(length(intersect([i[1] for i in view(hist, l-4:l)], top_frequent_codes)))
    return Cipher(p, (length(intersect([i[1] for i in view(hist, l-4:l)], top_frequent_codes))))
    # sort(collect(hist))
end

function single_letter_xor_analysis(c::Cipher)
    ciphers = filter(valid, [Cipher(xor.(i,c.list), i) for i=0:127])
    if(length(ciphers) == 1)
        return ciphers[1]
    end
    scored = [score(i) for i in ciphers]
    sorted = sort(scored, by=x->x.score)
    return sorted[1]
end

function process(f::IOStream)
    str = readlines(f)[1]
    cont = hex2bytes(str);
    a = single_letter_xor_analysis(Cipher(cont));
    writeOutput("String: " * join([Char(i) for i in a.list]) * "\nKey: " * Char(a.key))
end

function writeOutput(message)
    open("output.txt", "w") do io
        write(io, message)
    end
end

open(process, "input.txt")
