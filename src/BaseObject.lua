local self, properties, methods, data = {}, {}, {}, require(script.Parent:WaitForChild("data"));

properties.name = "Base";
properties.class = "BaseObject";

properties.rotation = 0;
properties.zIndex = 0;

properties.loaded = false;
properties.canCollide = true;
properties.visible = true;

properties.size = Vector2.new();
properties.position = Vector2.new();
properties.hitbox = Vector2.new();

self.index = math.random();

self.functions = {};
self.properties = properties;
self.methods = methods;
self.base = true;

self.inherited = { properties.class };
data.space[self.index] = self;

return setmetatable({}, data.getMetaData(self));
