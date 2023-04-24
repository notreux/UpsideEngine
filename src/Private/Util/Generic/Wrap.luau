return function(f, ...)
	local args = { ... }
	return function(...)
		f(unpack(args), ...)
	end
end
