export type Sound = {
InstanceType: string
Subject: Character
Range: number
MaxVolume: number
DistanceFading: boolean
SetSubject(self: Sound, subject: Character, useSceneSoundGroup: boolean?): null
}


module.exports = {}