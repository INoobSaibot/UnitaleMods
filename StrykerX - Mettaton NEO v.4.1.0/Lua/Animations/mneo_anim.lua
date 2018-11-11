--For usage, check out the encounter Lua's EncounterStarting() and Update() functions.
M_PI = 3.14159265359
ME_PI = 19

-- First, we can create the torso, legs and head.

mneoslightl = CreateSprite("slightLoff")
mneoslightr = CreateSprite("slightRoff")
mneolightl = CreateSprite("empty")
mneolightr = CreateSprite("empty")

mneolegs = CreateSprite("spr_mneo_legs_0")
mneotorso = CreateSprite("spr_mneo_body_0")
mneohead = CreateSprite("spr_mneo_face_0")
mneoarml = CreateSprite("spr_mneo_arml_0")
mneoarmr = CreateSprite("spr_mneo_armr_0")
mneoburstl = CreateSprite("spr_mneo_burstl_0")
mneoburstr = CreateSprite("spr_mneo_burstr_0")

whitefade = CreateSprite("screenfade/white")
whitefade.alpha = 0



--We parent the torso to the legs, so when you move the legs, the torso moves too. 
--We do the same for attaching the head to the torso.
mneolightl.SetParent(mneoslightl)
mneolightr.SetParent(mneoslightr)

mneoburstl.SetParent(mneolegs)
mneoburstr.SetParent(mneolegs)
--I KNOW the arms should be parented to the torso, but they draw over the body, wheich we don't want
mneoarml.SetParent(mneolegs)
mneoarmr.SetParent(mneolegs)
mneotorso.SetParent(mneolegs)
mneohead.SetParent(mneotorso)

--Now we adjust the height for the individual parts so they look more like a skeleton and less like a pile of bones.
mneoslightl.x = 40
mneoslightl.y = 576
mneoslightr.x = 600
mneoslightr.y = 576
--446
whitefade.y = 410

mneolegs.y = 235
mneotorso.y = -19 --The torso's height is relative to the legs they're parented to.
mneoburstl.x = -28
mneoburstl.y = 118
mneoburstr.x = 28
mneoburstr.y = 118

--We set the torso's pivot point to halfway horizontally, and on the bottom vertically, 
--so we can rotate it around the bottom instead of the center.
mneolightl.SetPivot(0.01, 0.99)
mneolightr.SetPivot(0.99, 0.99)

mneotorso.SetPivot(0.5, 0)
mneoburstl.SetPivot(1, 1)
mneoburstr.SetPivot(0, 1)


--We set the torso's anchor point to the top center. Because the legs are pivoted on the bottom (so rescaling them only makes them move up),
--we want the torso to move along upwards with them.
mneolightl.Scale(2, 2)
mneolightr.Scale(2, 2)
mneoslightl.Scale(2, 2)
mneoslightr.Scale(2, 2)

mneotorso.SetAnchor(0.5, 1)
mneolegs.SetPivot(0.5, -0.01)

mneolegs.Scale(2, 2)
mneohead.Scale(2, 2)
mneoarml.Scale(2, 2)
mneoarmr.Scale(2, 2)
mneoburstl.Scale(2, 2)
mneoburstr.Scale(2, 2)
mneotorso.Scale(2, 2)
mneoarml.SetPivot(1, 0.5)
mneoarmr.SetPivot(0, 0.5)


function Animate()
	if GetGlobal("hurtframes") ~= nil then
		if GetGlobal("hurtframes") > 60 then
                                                                    if GetGlobal("Lightss") == false then
                                                                            mneoslightl.y = mneoslightl.y + (435 - mneoslightl.y) / 5
                                                                            mneoslightr.y = mneoslightl.y + (435 - mneoslightl.y) / 5
                                                                    end
			mneohead.Set("spr_mneo_face_4")
			mneolegs.x = 320 + math.sin(Time.time * 30 * M_PI) * GetGlobal("hurtframes") ^0.8
			SetGlobal("hurtframes", GetGlobal("hurtframes") - 1)
		elseif GetGlobal("hurtframes") == 30 then   
                                                            if GetGlobal("fanclub") == true then                                              
			    mneohead.Set("spr_mneo_face_5")
                                                           elseif GetGlobal("Face") == 3 then
                                                                    mneohead.Set("spr_mneo_face_3")
                                                           elseif GetGlobal("Face") == 6 then
                                                                    mneohead.Set("spr_mneo_face_6")
                                                           else
                                                                    mneohead.Set("spr_mneo_face_4")
                                                           end
			mneolegs.x = 320 + math.sin(Time.time * 5 * ME_PI) * GetGlobal("hurtframes") ^0
                                                                mneoburstl.Set("empty")
                                                                mneoburstr.Set("empty")
                                           elseif GetGlobal("reallyded") == true then
                                                                whitefade.Set("screenfade/white")
                                                                whitefade.alpha = whitefade.alpha + 0.05*Time.mult
                                                                whitefade.SendToTop()
                                                                SetGlobal("reallyded1", true)
                                                                SetGlobal("reallyded2", true)
                                           elseif GetGlobal("reallyded1") == true then
                                                                whitefade.Set("dark")
                                           elseif GetGlobal("reallyded2") == true then
                                                                 mneolegs.Set("empty")
                                                                 mneotorso.Set("empty")
                                                                 mneohead.Set("empty")
                                                                 mneoarml.Set("empty")
                                                                 mneoarmr.Set("empty")
                                                                 mneoburstl.Set("empty")
                                                                 mneoburstr.Set("empty")
                                                                 mneohead.Set("empty")
                                           else
                                                                mneoburstl.Set("spr_mneo_burstl_0")
                                                                mneoburstr.Set("spr_mneo_burstr_0")                                                       
                                                                if GetGlobal("Face") == 1 then
			     mneohead.Set("spr_mneo_face_1")
                                                                elseif GetGlobal("Face") == 2 then
			     mneohead.Set("spr_mneo_face_2")
                                                                elseif GetGlobal("Face") == 3 then
			     mneohead.Set("spr_mneo_face_3")
                                                                elseif GetGlobal("Face") == 4 then
			     mneohead.Set("spr_mneo_face_4")
                                                                elseif GetGlobal("Face") == 5 then
			     mneohead.Set("spr_mneo_face_5")
                                                                elseif GetGlobal("Face") == 6 then
			     mneohead.Set("spr_mneo_face_6")
                                                                else
			     mneohead.Set("spr_mneo_face_0")
                                                                end
                                                  
			mneolegs.MoveTo(320, 235)
			
			mneolegs.Scale(2, 2 + 0.045 * math.sin(Time.time * 10))
			mneohead.MoveTo(-8, 38 + 0.8 * math.sin(Time.time * 10))
			mneoarml.MoveTo(-26 + 1.5 * math.sin(Time.time * 10 + 1.09), 84)
			mneoarmr.MoveTo(33 + -1.5 * math.sin(Time.time * 10 + 1.09), 84)
			mneoarml.rotation = -2 * math.sin(Time.time * 5 + 0.72)
			mneoarmr.rotation = 2 * math.sin(Time.time * 5 + 0.72)
			mneoburstl.rotation = 2 * math.sin(Time.time * 5 + 0.72)
			mneoburstr.rotation = -2 * math.sin(Time.time * 5 + 0.72)
			mneoburstl.alpha = -math.sin(Time.time * 15) / 8 + 0.75
			mneoburstr.alpha = -math.sin(Time.time * 15) / 8 + 0.75
                                                                if GetGlobal("Lighter") == true then
                                                                           Audio.PlaySound("snd_lightswitch")
                                                                           mneolightl.Set("lightL")
                                                                           mneolightr.Set("lightR")
                                                                           mneoslightl.Set("slightL")
                                                                           mneoslightr.Set("slightR")
                                                                           SetGlobal("Lighter", false) 
                                                                end
			mneolightl.alpha = -math.sin(Time.time * 15) / 8 + 0.75
			mneolightr.alpha = -math.sin(Time.time * 15) / 8 + 0.75
		end
	end
end