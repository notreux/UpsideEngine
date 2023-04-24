local function collide(self, object)
	local distance = self.AbsolutePosition - object.AbsolutePosition
	local radius = self.AbsoluteSiz.Y / 2 + object.AbsoluteSize.Y / 2

	local distanceSq = distance * distance
	local radiusSq = radius * radius

	return distanceSq <= radiusSq, distance - radius
end

return collide
