export type Sound = BaseObject & {
InstanceType: string,
Subject: Character,
Range: number,
MaxVolume: number,
DistanceFading: boolean,
SetSubject: (self: Sound, subject: Character, useSceneSoundGroup: boolean?) -> nil,
}


return {}