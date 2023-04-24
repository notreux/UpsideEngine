--!nonstrict
local httpService = game:GetService("HttpService")
local encoder = {}

local encoders = {
	UDim2 = function(data)
		return {
			X = {
				Scale = data.X.Scale,
				Offset = data.X.Offset,
			},
			Y = {
				Scale = data.Y.Scale,
				Offset = data.Y.Offset,
			},
		}
	end,
	Vector2 = function(data)
		return {
			X = data.X,
			Y = data.Y,
		}
	end,
	EnumItem = function(data)
		return {
			EnumType = tostring(data.EnumType),
			Name = data.Name,
		}
	end,
}

local decoders = {
	UDim2 = function(data)
		return UDim2.new(data.X.Scale, data.X.Offset, data.Y.Scale, data.Y.Offset)
	end,
	Vector2 = function(data)
		return Vector2.new(data.X, data.Y)
	end,
	EnumItem = function(data: { EnumType: string, Name: string }): EnumItem
		local enum = Enum
		return enum[data.EnumType][data.Name]
	end,
}

local function encode(data)
	for index, value in pairs(data) do
		local datatype = typeof(value)
		local encoder = encoders[datatype]

		if datatype == "table" and not encoder then
			data[index] = encode(value)
			continue
		elseif not encoder then
			continue
		end

		local recovered = encoder(value)
		recovered.datatype = datatype

		data[index] = recovered
	end

	return data
end

local function decode(data)
	for index, value in pairs(data) do
		local datatype = typeof(value)

		if datatype == "table" and not value.datatype then
			data[index] = decode(value)
			continue
		elseif datatype ~= "table" or not value.datatype then
			continue
		end

		local decoder = decoders[value.datatype]
		data[index] = decoder(value)
	end

	return data
end

function encoder.Encode(data)
	return httpService:JSONEncode(encode(data))
end

function encoder.Decode(data)
	local result = httpService:JSONDecode(data)
	return decode(result)
end

return encoder
