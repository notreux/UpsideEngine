local props = {
	NonReplicable = {
		-- BaseClass
		"ClassNameHistory",
		"ClassName",

		-- EventEmitter
		"EventsStorage",

		-- BaseObject
		"Instance",

		-- Particle
		"Units",
		"Clock",

		-- Physical Object
		"Collisions",
		"IsGrounded",

		-- Sprite
		"Active",

		-- Character
		"IsJumping",

		-- Scene
		"Camera",
		"Objects",
		"ParticleEnvironment",
		"SoundEnvironment",
		"ShaderEnvironment",

		-- Environment
		"Content",

		-- LightingEnvironment
		"__actrees",

		-- ProximityPrompt2d
		"Label",
		"HitboxButton",
		"IsClosest",
	},
	Instance = {
		"ZIndex",
		"Position",
		"ScaleType",
		"TileSize",
		"SliceScale",
		"ImageTransparency",
		"ImageRectSize",
		"ImageRectOffset",
		"Rotation",
		"ResampleMode",
		"ImageColor3",
		"Size",
		"Image",
		"SizeConstraint",
	},
}

export type InstanceProps = typeof(props.Instance)

return props
