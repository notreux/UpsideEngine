local data = require(script.Parent:WaitForChild("data"));

return function()

	local self, properties, methods = {}, {}, {};

	properties.name = "Base";
	properties.class = "BaseObject";

	properties.rotation = 0;
	properties.zIndex = 0;

	properties.canCollide = true;
	properties.visible = true;

	properties.size = Vector2.new();
	properties.position = Vector2.new();
	
	self.loaded = false;
	self.index = math.random();

	self.functions = {};
	self.properties = properties;
	self.methods = methods;
	self.base = true;
	
	self.events = {};
	self.tags = {};
	
	self.inherited = "";
	data.space[self.index] = self;

	return setmetatable({}, data.getMetaData(self));
	
end;
