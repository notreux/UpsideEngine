local AssetService = game:GetService("AssetService")
local classes = script.Parent.Parent.Parent.Parent.Classes
local EventEmitter = require(classes.Internal.EventEmitter)

local cache = {}
local loading = {}
local events = EventEmitter.new()
local exports = {
	cache = cache,
	events = events,
	loading = loading,
}

function exports.loadImage(id)
	if cache[id] then
		return cache[id]
	elseif loading[id] then
		return events:Once("imageLoaded:" .. id):Wait()
	end

	local image = exports.createSafeEditableImage(id)
	cache[id] = image

	return image
end

function exports.createSafeEditableImage(id)
	local canvas, sucess, message = nil, nil, nil
	local content = Content.fromUri(id)
	loading[id] = id

	for retries = 1, 10 do
		sucess, canvas = pcall(
			AssetService.CreateEditableImageAsync,
			AssetService,
			content --Target content
		)

		if typeof(canvas) == "string" then
			message = canvas:lower()
			canvas = nil
		end

		if sucess then
			events:Fire("imageLoaded:" .. id, canvas)
			loading[id] = nil
			break
		elseif message and message:match("memory") then
			warn(("[SHADER INFO] Maximum memory reached, the shader for %s will not be applied"):format(id))
			break
		elseif message and message:match("too many") then
			warn(("[SHADER INFO] Too many requests for %s retrying in 5s"):format(id))
			task.wait(5)
		else
			warn("[SHADER INFO] Unmanaged error: " .. message)
		end

		warn("[SHADER INFO] Retrying to load image: " .. id .. " (" .. retries .. "/10)")
		warn("[SHADER INFO] If you are loading shaders when the client is still loading, it's recommended to wait some seconds before trying to load shaders")
		task.wait(0.1)
	end

	return canvas
end

return exports
