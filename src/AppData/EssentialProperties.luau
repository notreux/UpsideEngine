local props = {
	StaticObject = {
		"Shader",
		"Tags",
		"ClassNameHistory",
	},
	Sprite = {
		"Sprites",
		"IsPlaying",
		"Active",
	},
	PhysicalObject = {
		"TrackCollisions",
		"HitboxScale",
		"Hitbox",
		"Shape",
		"Force",
		"Velocity",
		"Mass",
		"Friction",
		"CollisionGroup",
		"CanCollide",
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
export type BaseObjectPropes = typeof(props.StaticObject)
export type PhysicalObjectProps = typeof(props.PhysicalObject)

return props
