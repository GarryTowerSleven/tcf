EMOTION_HAPPY = 0
EMOTION_SAD = 1
EMOTION_WASTED = 2
EMOTION_ANGRY = 3
EMOTION_SLEEPY = 4
EMOTION_BORED = 5
EMOTION_PAIN = 6
EMOTION_EXCITED = 7

// Emotion Tree
// BASE - Happy
// All caps/Ending in ! - Angry
// Ending in multiple !s - Excited
// Spam Keys - Excited
// Drunk (BAL above 10) - Wasted
// Player does nothing for 30 seconds - Bored

plynet.Register( "Int", "Emotion" )

local meta = FindMetaTable("Player")

module( "Emotions", package.seeall )

function meta:GetEmotion()
	return self:GetNet( "Emotion" ) or EMOTION_HAPPY
end