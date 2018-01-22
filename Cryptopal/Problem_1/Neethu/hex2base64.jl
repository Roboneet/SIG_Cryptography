function converter(f::IOStream)
	writeOutput(base64encode(hex2bytes(String(read(f)))))
end

function writeOutput(a::String)
	f = open("./output.txt", "w")
	write(f, a)
	close(f)
end

open(converter, "./input.txt")
