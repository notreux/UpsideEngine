export type Character = {
Health: number
MaxHealth: number
WalkSpeed: number
JumpPower: number
UpdateHealth(self: Character, Health: number): null
Jump(self: Character, jumpPower: number?): null
MoveTo(self: Character, target: Vector2): null
}


module.exports = {}