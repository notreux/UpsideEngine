local upsideEngine = script.Parent.Parent.Parent
local BaseClass = require(upsideEngine.Classes.Internal.BaseClass)
local TextTagService = require(upsideEngine.Services.TextTagService)
local TextTag = {}
TextTag.__index = TextTag

function TextTag.new()
	local self = BaseClass.new()
	self:SetClassName(script.Name)
	self.TagName = "default"
	self.DisplayMode = "letter"
	self.TypingSoundId = "rbxassetid://92143495194538"
	self.TypingSoundVolume = 1
	self.WordsPerSecond = 0
	self.IdleTime = 0

	return setmetatable(self, TextTag)
end

--[[={
	@desc Sets the tag name and updates its registration in TextTagService.
	@link void.md
}=]]
function TextTag:SetTagName(tagName)
	assert(type(tagName) == "string", "Tag name must be a string.")
	self.TagName = tagName
	TextTagService:RemoveTextTag(self)
	TextTagService:AddTextTag(self)
end

--[[={
	@desc Sets the display mode with validation.
	@link void.md
}=]]
function TextTag:SetDisplayMode(displayMode)
	assert(displayMode == "letter" or displayMode == "word", "Invalid display mode. Use 'letter' or 'word'.")
	self.displayMode = displayMode
end

--[[={
	@desc Assigns a custom render function.
	@link void.md
}=]]
function TextTag:SetRenderFunction(renderFunction)
	assert(type(renderFunction) == "function", "Render function must be a function.")
	self.renderFunction = renderFunction
end

--[[={
	@desc Removes the TextTag instance from the TextTagService.
	@link void.md
}=]]
function TextTag:Destroy()
	TextTagService:RemoveTextTag(self)
end

--[[={
	@desc Class representing a text tag for UpsideEngine.
	@about
		@TagName The tag name that defines a rendering style.
		@DisplayMode Display mode, either "letter" (character by character) or "word" (word by word).
		@TypingSoundId The sound asset ID played during typing.
		@TypingSoundVolume Volume of the typing sound.
		@WordsPerSecond Typing speed expressed in words per second.
		@IdleTime Idle time.
		@SetTagName Updates the tag name and re-registers with the TextTagService.
		@SetDisplayMode Sets the display mode with validation.
		@SetRenderFunction Assigns a custom render function.
}=]]

return setmetatable(TextTag, BaseClass)
