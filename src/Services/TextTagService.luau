local BaseClass = require(script.Parent.Parent.Classes.Internal.BaseClass)
local TextTagService = {}
TextTagService.__index = TextTagService

function TextTagService.new()
	local self = BaseClass.new()
	self:SetClassName(script.Name)
	self.TextTags = {}

	return setmetatable(self, TextTagService)
end

function TextTagService:AddTextTag(textTag)
	self.TextTags[textTag.TagName] = textTag
end

function TextTagService:RemoveTextTag(textTag)
	self.TextTags[textTag.TagName] = nil
end

return setmetatable(TextTagService, BaseClass).new()
