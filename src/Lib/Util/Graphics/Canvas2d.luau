local ContentManager = require(script.Parent.ContentManager)
local cache = {}
local exports = {}
exports.__index = exports

local function createCacheableImage(url)
	local editableImage = ContentManager.createSafeEditableImage(url) :: EditableImage
	local imageData = {
		image = editableImage,
		isFree = false,
	}

	cache[url] = cache[url] or imageData
	return imageData
end

function exports.new(): canvas2d
	return setmetatable({
		loading = false,
		url = "",
		position = Vector2.zero,
		image = (nil :: any) :: EditableImage,
		containers = {},
		primaryContainer = nil,
	}, exports)
end

function exports:setUrl(url: string)
	self.url = url
	self.loading = true

	local imageData = cache[url]
	local cantUseCache = not imageData or not imageData.isFree

	if cantUseCache then
		imageData = createCacheableImage(url)
	end

	if imageData.image == nil then
		self.loading = false
		return
	end

	imageData.isFree = false
	self.loading = false
	self:setImage(imageData.image)
end

function exports:setImage(targetImage: EditableImage)
	local cacheData = cache[self.url]
	local isUsingCache = if cacheData then cacheData.image == self.image else nil
	local content = Content.fromObject(targetImage)

	if isUsingCache then
		cacheData.isFree = true
	end

	for container in self.containers do
		container.ImageContent = content
	end

	self.image = targetImage
end

function exports:preloadSprites(sprites)
	for name, data in sprites do
		if not data.ImageContent and data.Url then
			local imageData = cache[data.Url] or createCacheableImage(data.Url)
			data.ImageContent = imageData.image

			continue
		end

		local imageContentList = data.ImageContentList or {}
		data.ImageContentList = imageContentList

		for i, url in imageContentList do
			if imageContentList[i] and cache[url] then
				continue
			end

			local imageData = cache[url] or createCacheableImage(url)
			imageContentList[i] = imageData.image
		end
	end
end

function exports:setPrimaryContainer(container)
	self.primaryContainer = container
end

function exports:addContainer(container)
	local containers = self.containers
	local image = self.image

	if containers[container] then
		return
	elseif image then
		container.ImageContent = Content.fromObject(image)
	end

	containers[container] = true
end

function exports:hasContainer(container)
	return self.containers[container]
end

export type canvas2d = typeof(exports.new())
return exports
