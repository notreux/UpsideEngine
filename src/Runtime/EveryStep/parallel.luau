return function(scene)
	local lighting = scene.LightingEnvironment
	local objects = scene.Objects
	local shadable = {}

	for _, object in objects do
		if not object.Shader.Enabled then
			continue
		end

		shadable[object.Id] = object
	end

	lighting.__actrees:SetVariable("lights", lighting.Content)
	objects.__actor:SetVariable("shadable", shadable)
end
