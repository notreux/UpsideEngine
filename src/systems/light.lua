local data = require(script.Parent.Parent:WaitForChild("data"));

return function(this)
	
	this.on("changed", function(property)
		
		if property == "range" then
			
			this.size = UDim2.new(this.range / 100, 0, this.range / 100, 0);
			
			data.robloxSpace[this.index].Size = this.size;
			
		elseif property == "zIndex" and this.zIndex ~= 999999999 then
			
			this.zIndex = 999999999;
			
		elseif property == "size" and this.size.X ~= this.range/100 then
			
			this.size = Vector2.new(this.range / 100, this.range / 100)
			
		end
		
	end)
	
	this.on("loaded"):wait();

	Instance.new("UIAspectRatioConstraint").Parent = data.robloxSpace[this.index];
	
end
