local internal, data = setmetatable({}, {}), require(script.Parent:WaitForChild("data"));

local function getAxis(c1, c2)

	local axis = {};

	axis[1] = (c1[2] - c1[1]).Unit;
	axis[2] = (c1[4] - c1[1]).Unit;
	axis[3] = (c2[2] - c2[1]).Unit;
	axis[4] = (c2[4] - c2[1]).Unit;

	return axis;

end

local function getCorners(object)

	local corners, rot, ap, as = {}, math.rad(object.rotation),
		  object.absolutePosition, object.absoluteSize;

	local center, wc = object.absolutePosition + object.absoluteSize/2, {

		Vector2.new(ap.X, ap.Y);
		Vector2.new(ap.X + as.X, ap.Y);
		Vector2.new(ap.X + as.X, ap.Y + as.Y);
		Vector2.new(ap.X, ap.Y + as.Y);

	};

	for i, corner in ipairs(wc) do

		corners[i] = Vector2.new(

			center.X + (corner.X - center.X) * math.cos(rot) - (corner.Y - center.Y) * math.sin(rot),
			center.Y + (corner.X - center.X) * math.sin(rot) + (corner.Y - center.Y) * math.cos(rot)

		);

	end

	return corners;

end

function internal.updateSpace(this)

	for _, meta in pairs(data.space) do

		if meta.canCollide and meta.loaded and this.index ~= meta.index then
			
			local c1, c2, collision = getCorners(this), getCorners(meta), true;
			local axis = getAxis(c1, c2);
			
			for i = 1, #axis do
				
				local s1, s2 = {}, {};
				
				for n = 1, 4 do

					table.insert(s1, axis[i]:Dot(c1[n]));
					table.insert(s2, axis[i]:Dot(c2[n]));

				end

				local s1max, s1min = math.max(unpack(s1)), math.min(unpack(s1));
				local s2max, s2min = math.max(unpack(s2)), math.min(unpack(s2));

				if s2min > s1max or s2max < s1min then collision = false; break; end;

			end
			
			
			if collision and not this.collisions[meta.index] then

				this:fire("collision", meta);
				meta:fire("collision", this);

				meta.collisions[this.index] = this;
				this.collisions[meta.index] = meta;

			elseif not collision and this.collisions[meta.index] then

				this:fire("collisionEnded", meta);
				meta:fire("collisionEnded", this);

				meta.collisions[this.index] = nil;
				this.collisions[meta.index] = nil;

			end

		end

	end

end

return internal;
