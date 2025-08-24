local SoundService = game:GetService("SoundService")
local upsideEngine = script.Parent.Parent.Parent
local TextTagService = require(script.Parent.Parent.Parent.Services.TextTagService)
local TextTag = require(script.Parent.TextTag)
local baseObject = require(upsideEngine.Classes.Internal.BaseObject)

local reactiveLabel = {}
reactiveLabel.__index = reactiveLabel

local defaultTypingSoundId = TextTag.new().TypingSoundId
local typingSound = Instance.new("Sound")
typingSound.Parent = SoundService

local function createUIListLayout(self: Frame)
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = self
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.Wraps = true
	uiListLayout.Padding = UDim.new(0, 0)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
end

local function trim(s: string): string | nil
	return s:match("^%s*(.-)%s*$")
end

local function parseTags(s: string, currentTags: { any }?): { [any]: any }
	currentTags = currentTags or {}
	local results = {}
	local i = 1

	while i <= #s do
		local j, k, tag, argsStr = s:find("<(%w+)(.-)>", i)
		if j then
			local preText = s:sub(i, j - 1)
			local trimmed = trim(preText)
			if trimmed ~= "" then
				table.insert(results, { text = trimmed, tags = currentTags })
			end

			local closeTag = "</" .. tag .. ">"
			local closeStart, closeEnd = s:find(closeTag, k + 1)
			if not closeStart then
				break
			end

			local argTable = {}
			if argsStr and argsStr ~= "" then
				for key, value in argsStr:gmatch("(%w+)%s*=%s*[\"'](.-)[\"']") do
					argTable[key] = value
				end

				for key, value in argsStr:gmatch("(%w+)%s*=%s*([%d%.%-]+)") do
					if not argTable[key] then
						argTable[key] = tonumber(value) or value
					end
				end
			end

			local inner = s:sub(k + 1, closeStart - 1)
			local newTags = currentTags and { table.unpack(currentTags) } or {}
			table.insert(newTags, { name = tag, args = argTable })

			local innerResults = parseTags(inner, newTags)
			for _, elem in innerResults do
				table.insert(results, elem)
			end

			i = closeEnd + 1
		else
			local remainder = s:sub(i)
			local trimmed = trim(remainder)
			if trimmed ~= "" then
				table.insert(results, { text = trimmed, tags = currentTags })
			end
			break
		end
	end

	return results
end

local function validateTags(s: string): boolean
	local stack = {}
	for slash, tagName in s:gmatch("<(/?)(%w+)(.-)>") do
		if slash == "" then
			table.insert(stack, tagName)
		else
			local last = table.remove(stack)
			if last ~= tagName then
				return false
			end
		end
	end
	return #stack == 0
end

function reactiveLabel.new(): Sound
	local self = baseObject.new("Frame")
	self:SetClassName(script.Name)
	self.Font = Enum.Font.Arial
	self.FontSize = 32
	self.Text = ""
	self.TextTransparency = 0
	self.TextColor3 = Color3.new(1, 1, 1)
	self.TextScaled = false
	self.Animated = true
	self.TextStrokeColor3 = Color3.new(0, 0, 0)
	self.TextStrokeTransparency = 1
	self.TextStrokeThickness = 0
	self.CharactersPerSecond = 20
	self.TypingSoundId = "rbxassetid://92143495194538"
	self.TypingSoundVolume = 1
	self.StopSoundOnFinish = true
	self.PauseDelays = {
		[","] = 0.25,
		["."] = 0.5,
		["?"] = 0.5,
	}
	self.Instance.Size = UDim2.new(0, 400, 0, 400)
	self.Instance.BackgroundTransparency = 1

	createUIListLayout(self.Instance)
	return setmetatable(self, reactiveLabel)
end

--[[={
	@desc Renders the label text with a typewriter effect, yielding during animations.
	@link void.link
}=]]

function reactiveLabel:Render()
	if not validateTags(self.Text) then
		error("Invalid tag syntax in text")
	end

	self.Instance:ClearAllChildren()
	createUIListLayout(self.Instance)

	local elements = parseTags(self.Text, {})
	for _, data in elements do
		for word in data.text:gmatch("%S+") do
			local wordFrame = Instance.new("Frame")
			wordFrame.BackgroundTransparency = 1
			wordFrame.Size = UDim2.new(0, 0, 0, self.FontSize)
			wordFrame.AutomaticSize = Enum.AutomaticSize.X
			wordFrame.Parent = self.Instance
			createUIListLayout(wordFrame)

			local letters = {}
			local displayMode = "letter"
			local charactersDelay = (1 / math.max(1, self.CharactersPerSecond))

			local typingSoundId = self.TypingSoundId
			local typingSoundVolume = self.TypingSoundVolume
			local wordsPerSecond = 0

			local localWordsPerSecond = 0
			local useLocalCharsPerSecond = false

			for _, tag in data.tags do
				local args = tag.args or {}
				local textTag = TextTagService.TextTags[tag.name] or {}
				typingSoundId = if textTag.TypingSoundId ~= defaultTypingSoundId and textTag.TypingSoundId
					then textTag.TypingSoundId
					else typingSoundId
				typingSoundVolume = textTag.TypingSoundVolume or typingSoundVolume
				wordsPerSecond = if textTag.WordsPerSecond and textTag.WordsPerSecond > 0
					then textTag.WordsPerSecond
					else wordsPerSecond

				if args.wordsPerSecond and args.wordsPerSecond > localWordsPerSecond then
					localWordsPerSecond = args.idleTime
					useLocalCharsPerSecond = true
				end

				if textTag.displayMode == "word" then
					displayMode = "word"
				end
			end

			if useLocalCharsPerSecond then
				wordsPerSecond = localWordsPerSecond
			end

			typingSound.SoundId = typingSoundId
			typingSound.Volume = typingSoundVolume

			for i = 1, #word do
				local letter = word:sub(i, i)
				local wrappedLetter = letter
				for _, tag in data.tags do
					local argsStr = ""
					for key, value in (tag.args or {}) do
						argsStr ..= (" %s='%s'"):format(key, tostring(value))
					end

					wrappedLetter = ("<%s%s>%s</%s>"):format(tag.name, argsStr, wrappedLetter, tag.name)
				end

				local letterFrame = Instance.new("Frame")
				letterFrame.BackgroundTransparency = 1
				letterFrame.Size = UDim2.new(0, 0, 0, self.FontSize)
				letterFrame.AutomaticSize = Enum.AutomaticSize.X
				letterFrame.ZIndex = self.Instance.ZIndex
				letterFrame.Parent = wordFrame

				local letterLabel = Instance.new("TextLabel")
				letterLabel.BackgroundTransparency = 1
				letterLabel.Name = letter
				letterLabel.Text = if i == #word then wrappedLetter .. " " else wrappedLetter
				letterLabel.RichText = true
				letterLabel.Font = self.Font
				letterLabel.TextSize = self.FontSize
				letterLabel.TextColor3 = self.TextColor3
				letterLabel.TextTransparency = 1
				letterLabel.TextScaled = self.TextScaled
				letterLabel.AutomaticSize = Enum.AutomaticSize.X
				letterLabel.Size = UDim2.new(0, 0, 0, self.FontSize)
				letterLabel.ZIndex = self.Instance.ZIndex
				letterLabel.Parent = letterFrame

				local stroke = Instance.new("UIStroke")
				stroke.Parent = letterLabel
				stroke.Color = self.TextStrokeColor3
				stroke.Transparency = 1
				stroke.Thickness = self.TextStrokeThickness

				table.insert(letters, {
					label = letterLabel,
					stroke = stroke,
					letter = letter,
					tags = data.tags,
				})

				letterFrame.Size = UDim2.fromOffset(letterFrame.AbsoluteSize.X, self.FontSize)
				letterFrame.AutomaticSize = Enum.AutomaticSize.None
			end

			for i, lettersData in letters do
				local pauseDelay = self.PauseDelays[lettersData.letter]
				local delayTime = pauseDelay or charactersDelay

				for _, tag in data.tags do
					local textTag = TextTagService.TextTags[tag.name]
					local args = tag.args or {}

					if textTag and textTag.renderFunction then
						task.defer(textTag.renderFunction, lettersData.label, i, args)
					end
				end

				lettersData.label.TextTransparency = self.TextTransparency
				lettersData.stroke.Transparency = self.TextStrokeTransparency

				if self.Animated and displayMode == "letter" then
					task.wait(delayTime)
					typingSound:Play()
				end
			end

			if self.Animated and displayMode == "word" then
				typingSound:Play()
				task.wait(charactersDelay)
			end

			if wordsPerSecond > 0 and self.Animated then
				task.wait(1 / wordsPerSecond)
			end

			if self.StopSoundOnFinish then
				typingSound:Stop()
			end
		end

		local maxIdleTime = 0
		for _, tag in data.tags do
			local idle = tonumber(tag.args and tag.args.idleTime) or 0
			if idle > maxIdleTime then
				maxIdleTime = idle
			end
		end
		if maxIdleTime > 0 then
			task.wait(maxIdleTime)
		end
	end
end

--[[={
	@desc UI element that renders text with a typewriter effect, text animations and supports roblox rich text. 
	@about
		@Text The text content to be rendered.
		@Font The font used for displaying text.
		@FontSize The font size of the text.
		@TextColor3 The color of the text.
		@TextScaled Determines if the text scales automatically.
		@Animated If true, renders text progressively like a typewriter.
		@CharactersPerSecond  The number of characters rendered per second.
		@TypingSoundId The sound asset ID played during typing.
		@TypingSoundVolume The volume of the typing sound.
		@StopSoundOnFinish If true, stops the typing sound once rendering is complete.
		@TextStrokeColor3 The stroke (outline) color for the text.
		@TextStrokeTransparency Transparency of the text stroke.
		@TextStrokeThickness Thickness of the text stroke.
		@PauseDelays A table defining additional pause durations after certain characters (e.g., comma, period).
		-- Example of PauseDelays usage:
		{
			[","] = 0.25, -- pause 0.25 seconds after a comma
			["."] = 0.5,  -- pause 0.5 seconds after a period
			["?"] = 0.5,  -- pause 0.5 seconds after a question mark
		}
}=]]

return setmetatable(reactiveLabel, baseObject)
