return function(scene)
	local lighting = scene.LightingEnvironment
	local shaders = scene.ShaderEnvironment
	lighting.__actrees:SetVariable("lights", lighting.Content)
	shaders.__actor:SetVariable("shadable", shaders.Content)
end
