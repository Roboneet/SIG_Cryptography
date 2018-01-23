using DataFrames

small_letters = [i for i=Int('a'):Int('z')]
capital_letters = [i for i=Int('A'):Int('Z')]
punctuation = map(Int, [',', ' ', '-', '!', '\'', ':', '_', '.', '(', ')' ,'#', '"', '?', ';', '\n'])
letters_code = union( small_letters, capital_letters, punctuation);
# letters_code = [i for i=0:127]
top_frequent = "EARIOTNSLC"
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
function printText(p::Cipher)
    println(join(map(Char, p.list)) * "   " , p.score)
end

function score(p::Cipher)
    hist = Dict([(i, count(x-> x==i, p.list)) for i in p.list])
    hist = sort(collect(hist), by=x->x[2])
    l = length(hist)
    # print(length(intersect([i[1] for i in view(hist, l-4:l)], top_frequent_codes)))
    return Cipher(p, (length(intersect([i[1] for i in view(hist, l-4:l)], top_frequent_codes))))
end

function single_letter_xor_analysis(c::Cipher)
    # print("eee")
    xor__ = [Cipher(xor.(i,c.list), i) for i=0:127];
    # for i in xor__
    #     printText(i)
    # end
    ciphers = filter(valid, xor__)
    if(length(ciphers) == 0)
        return false
    elseif(length(ciphers) == 1)
        return ciphers[1]
    end
    scored = [score(i) for i in ciphers]
    sorted = sort(scored, by=x->x.score)
    # for i in sorted
    #     printText(i)
    # end
    return sorted[end]
end
