export type Character = Sprite & {
Health: number,
MaxHealth: number,
WalkSpeed: number,
JumpPower: number,
UpdateHealth: (self: Character, Health: number) -> nil,
Jump: (self: Character, jumpPower: number?) -> nil,
MoveTo: (self: Character, target: Vector2) -> nil,
}


return {}