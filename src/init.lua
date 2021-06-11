local self, data, HTTPS, indexs, ambient, new, rs = {}, require(script.data), game:GetService("HttpService"), {}, nil, require(script.objects), game:GetService("RunService");

function self.new(object, properties)

	object = new(object);

	for index, value in pairs(properties or {}) do

		object[index] = value;

	end

	return object;

end

function self:start(renderIn)

	rs.Stepped:Wait();

	if renderIn:FindFirstChild("Main") then renderIn.Main:Destroy();end

	local main = Instance.new("Frame");
	main.BackgroundTransparency = 1
	main.Position = UDim2.new(0.5, 0, 0.5, 0);
	main.Size = UDim2.new(1,0,1.05)
	main.AnchorPoint = Vector2.new(0.5, 0.525)
	main.Name = "Main"
	main.Parent = renderIn;

	ambient = Instance.new("Frame");
	ambient.BorderSizePixel = 0;
	ambient.Parent = main;
	ambient.AnchorPoint = Vector2.new(0.5, 0.5);
	ambient.Position = UDim2.new(0.5, 0, 0.5, 0);
	ambient.Size = UDim2.new(1,0,1,0)
	ambient.BackgroundTransparency = 0.8;
	ambient.BackgroundColor3 = Color3.fromRGB(255,255,255);
	ambient.ZIndex = 999999998;
	ambient.Name = "___________Ambient";

	for index, val in pairs(indexs) do

		pcall(function()

			ambient[index] = val;

		end)

	end	

	local storage = rs:IsClient() and game.ReplicatedStorage:FindFirstChild("UpsideEngineDataBase")
		or game.ServerStorage:FindFirstChild("UpsideEngineDataBase");

	if storage then

		local rebuilded = self.rebuildSpace(HTTPS:JSONDecode(storage and #storage.Value > 1 and storage.Value or {}));

		for index, value in pairs(rebuilded) do

			self.workspace[index] = value;

		end

	end

	for _, obj in pairs(data.space) do

		if not obj.loaded then

			obj:build(main);

		end

	end

end

function self.rebuildSpace(wkspace)

	local space = {};

	for name, object in pairs(wkspace) do

		local co = self.new(object.class);
		co(object.modules);
		co.properties = object.properties;

		space[co.index] = co;

	end

	return space;

end

function self:robloxGuiEnabler(array, state)

	array = typeof(array) == "table" and array or {array};

	for i = 1, 15 do 

		if pcall(function() for _, core in pairs(array) do game:GetService('StarterGui'):SetCoreGuiEnabled(core, state) end end) then

			break;

		end 

	end

end

self.ambient = setmetatable({

	getAmbient = function()

		return ambient;

	end,

}, { 

	__index = function(_, index)

		return pcall(function() return ambient and ambient[index] or nil; end);

	end,

	__newindex = function(_, index, value)


		pcall(function()

			if not ambient then

				indexs[index] = value;

			else

				ambient[index] = value;

			end

		end)

	end});

self.workspace = data.workspace;

self:robloxGuiEnabler(Enum.CoreGuiType.All, false)

return self;
