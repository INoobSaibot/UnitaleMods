-- First, we can create the torso, legs and head.
M_PI = 3.14159265359

BG = CreateSprite("a_bg")
Toriel = CreateSprite("a_toriel0")
LeftBall = CreateSprite("a_torielflameL0")
RightBall = CreateSprite("a_torielflameR0")

Toriel.MoveToAbs(0, 110)

LeftBall.x = 225
LeftBall.y = 385

RightBall.x = 420
RightBall.y = 385

LeftBall.Scale(2, 2)
RightBall.Scale(2, 2)

LeftBall.SetAnimation({"a_torielflameL0", "a_torielflameL1"}, 0.4)
RightBall.SetAnimation({"a_torielflameR1", "a_torielflameR0"}, 0.4)
 

function Animate()
	if GetGlobal("hurtframes") ~= nil then
		if GetGlobal("hurtframes") > 0 then
			Toriel.Set("a_toriel1")
			Toriel.x = 320 + math.sin(Time.time * 30 * M_PI) * GetGlobal("hurtframes") ^0.8
			SetGlobal("hurtframes",  GetGlobal("hurtframes") - 1)
		elseif GetGlobal("hurtframes") < 1 then
			Toriel.Set("a_toriel0")
                                                                LeftBall.MoveTo(225, 385 + 30 * math.sin(Time.time * 3))
                                                                RightBall.MoveTo(420, 385 - 30 * math.sin(Time.time * 3))
                                                          if GetGlobal("DEAD") == 1 or GetGlobal("DEAD") == 2 then

                                                          else
                                                                    LeftBall.alpha = -math.sin(Time.time * 15) / 8 + 0.90
                                                                    RightBall.alpha = -math.sin(Time.time * 15) / 9 + 0.90
                                                          end
		elseif GetGlobal("hurtframes") == 100 then

		end
	end
end

function HideToriel()
     Toriel.alpha = 0
     --LeftBall.alpha = 0
     --RightBall.alpha = 0
     LeftBall.alpha = LeftBall.alpha - 0.03*Time.mult
     RightBall.alpha = RightBall.alpha - 0.03*Time.mult
end

function HideBG()
      BG.alpha = 0
end