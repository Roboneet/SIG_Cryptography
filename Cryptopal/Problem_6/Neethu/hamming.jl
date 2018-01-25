function hamming_distance(a, b)
    c = xor.(a, b)
    d = [count(x-> x=='1', bits(k)) for k in c]
    return sum(d)
end
