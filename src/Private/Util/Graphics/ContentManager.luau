local AssetService = game:GetService("AssetService")
local cache = {}
local exports = {
	cache = cache,
}

function exports.loadImage(id)
	local image = cache[id] or exports.createSafeEditableImage(id)
	if not cache[id] then
		cache[id] = image
	end

	return image
end

function exports.createSafeEditableImage(id)
	local canvas, sucess = nil, nil
	local content = Content.fromUri(id)

	for retries = 1, 10 do
		sucess, canvas = pcall(
			AssetService.CreateEditableImageAsync,
			AssetService,
			content --Target content
		)

		if sucess then
			return canvas
		elseif typeof(canvas) == "string" and canvas:match("memory") then
			warn(("Maximum memory for shaders reached, the shader for %s will not be applied"):format(id))
		end
	end

	return nil
end

return exports
