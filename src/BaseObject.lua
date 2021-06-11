local data = require(script.Parent:WaitForChild("data"));

return function()

	local self, properties = {}, {};

	properties.name = "Base";
	self.class = "BaseObject";

	properties.rotation = 0;
	properties.zIndex = 0;

	properties.canCollide = true;
	properties.visible = true;

	properties.size = Vector2.new(0.2,0.2);
	properties.position = Vector2.new(0.5,0.5);
	
	self.loaded = false;
	self.index = math.random();

	self.functions = {};
	self.properties = properties;
	
	self.base = true;
	
	self.collisions = {};
	
	self.events = {};
	self.tags = {};
	
	self.inherited = "BaseObject, ";
	
	local meta = setmetatable({}, data.getMetaData(self));
	
	data.space[self.index] = meta;
	data.workspace[self.properties.name] = meta;
	
	return meta;
	
end;
