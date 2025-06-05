local UserInputService = game:GetService("UserInputService")
local upsideEngine = script.Parent.Parent.Parent
local CrossPlatformService = require(script.Parent.Parent.Parent.Services.CrossPlatformService)
local SceneManager = require(upsideEngine.Services.SceneManager)
local Sprite = require(upsideEngine.Classes.Public.Sprite)

local proximityPrompt2d = {}
proximityPrompt2d.__index = proximityPrompt2d

function proximityPrompt2d.new(): ProximityPrompt2D
	local self = Sprite.new()
	self:SetClassName(script.Name)
	self.Range = 100
	self.ActionName = "Interact"
	self.Enabled = true
	self.IsClosest = false
	self.InRange = false
	self.ShowIfClosest = true
	self.FadeDuration = 0.1
	self.Label = Instance.new("TextLabel")
	self.HitboxButton = Instance.new("TextButton")
	self.SecondsPerFrame = 0.5
	self.Instance.Name = "ProximityPrompt2D"
	self.LabelPositions = {
		UDim2.new(0.5, 0, 0.45, 0),
		UDim2.new(0.5, 0, 0.45, -20),
	}

	local hitbox = self.HitboxButton
	hitbox.Name = "Hitbox"
	hitbox.Text = ""
	hitbox.BackgroundTransparency = 1
	hitbox.Size = UDim2.new(1, 0, 1, 0)
	hitbox.Position = UDim2.new(0.5, 0, 0.5, 0)
	hitbox.AnchorPoint = Vector2.new(0.5, 0.5)
	hitbox.Parent = self.Instance

	local label = self.Label
	label.Name = "Label"
	label.Text = ""
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0.4, 0, 0.4, 0)
	label.Position = UDim2.new(0.5, 0, 0.45, 0)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.TextScaled = true
	label.Font = Enum.Font.Arcade
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Parent = self.Instance

	self.HitboxButton.Activated:Connect(function()
		self:Fire("Triggered")
	end)

	self.HitboxButton.MouseButton1Up:Connect(function()
		self:Fire("TriggerEnded")
	end)

	self:On("FrameChanging", function(currentFrame)
		local labelPositions = self.LabelPositions
		local actionName = self.ActionName
		local labelPosition = labelPositions[currentFrame.X + 1] or Vector2.new(0, 0)
		label.Position = labelPosition
		label.Text = CrossPlatformService:GetTargetActionKey(actionName) or ""
		hitbox.Visible = UserInputService.TouchEnabled
	end)

	local instance = self.Instance
	instance.ImageRectSize = Vector2.new(19, 21)
	instance.Size = UDim2.new(0, 100, 0, 100)
	self:SetSpriteSheet("idle", "http://www.roblox.com/asset/?id=128407262269576", Vector2.new(2, 0))

	return setmetatable(self, proximityPrompt2d)
end

function proximityPrompt2d:Attach(object: StaticObject)
	self.Instance.Parent = object.Instance
end

function proximityPrompt2d:Detach()
	local scene = SceneManager:Get(self.Scene)
	if scene then
		self.Instance.Parent = scene.Instance.GameFrame
	end
end

--[[={
	@desc The proximity prompt is a UI element that will show a prompt when the player is close to it, this is used to interact with objects in the game, it will show a label and a hitbox that will be used to detect when the player is close to it
	@about
		@Label The text label of the prompt, this will be shown when the prompt is active
        @Range The range of the prompt, this will be used to detect when the prompt should be shown
        @Enabled If the prompt is enabled or not, if it is not enabled the prompt will not be shown
		@InRange True if the proximity prompt is visible on the player's screen. Useful for detecting when the prompt is within interaction range
        @IsClosest True if the proximity prompt is the closest one to the player
		@FadeDuration The duration of the fade in and out of the prompt, this will be used to make the prompt appear and disappear smoothly
		@LabelPositions A table containing the positions(as UDim2) of the label, this will be used to adjust the text to the proximity prompt sprites, position 0 will be the position on the first frame, position 1 will be the position on the second frame, etc.
		@HitboxButton The button that will be used to trigger the proximity prompt on mobile devices
		@ActionName The action name of the prompt, this will be used to detect when the 
        prompt is triggered, if you change the default action name you should change or 
        add a new action in the CrossPlatformService, 'Interact' by default
		@ShowIfClosest Determines whether this proximity prompt should only be shown when it is the closest one to the player.
		If set to true, the prompt will only appear if it is the nearest among all prompts within interaction range.
		If set to false, the prompt will be shown as long as it is within range, regardless of other nearby prompts.
		The property is enabled by default
	@events
		@Triggered Fired when the proximity prompt is triggered. This occurs when the player begins interacting with the prompt.
		@TriggerEnded Fired when the proximity prompt interaction ends. This occurs when the player releases the interaction.
}=]]

return setmetatable(proximityPrompt2d, Sprite)
