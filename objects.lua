local self, base = {}, require(script.Parent.Parent.BaseObject);

return function(obj)
	
	if obj == "static" then
		
		base.image = "";
		base("basics", "static");
		
	elseif obj == "sprite" then
		
		base({"basics", "layers"}, "sprite");
		
	elseif obj == "particles" then
		
		if obj == nil then return error("For now, u can't use the particles object, instead use sprite to make particles"); end;
		
		base.texture = "";
		base.canCollide = nil;
		base.speed = 0;
		base.angle = Vector2.new();
		base.gravity = 0;
		base.transparency = 0;
		base.lightEmission = 0;
		base.rate = 10;
		base.enabled = true;
		base.rotationSpeed = 0;
		
		base({"basics", "layers"}, "particles");
		
	elseif obj == "light" then
		
		base.opacity = 0.5;
		base.range = 5;
		base.image = "rbxassetid://6904405933";
		base.zIndex = 999999999;
		
		base({"basics", "light"}, "light");

	else
		
		return error("Invalid object!");
		
	end
	
	base.base = nil;
	
	return base;
	
end;
