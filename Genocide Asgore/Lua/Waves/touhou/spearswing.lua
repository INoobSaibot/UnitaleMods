--Asgore attack made painstakingly exact on timing and animation details by DeeDoubs
--Initial version was provided by Travoos

Timers = require "timer"

Encounter.SetVar("wavetimer", 999999)
Encounter.Call("HideAsgore")

asgore = CreateSprite("asgore/silhouette")

cyan = CreateSprite("SOULS/spr_heartaqua_1")

orange = CreateSprite("SOULS/spr_heartorange_1")

cyan.x = 200
cyan.y = 400
orange.x = 445
orange.y = 400

asgore.SetPivot(0.5, 0)

asgore_base_x = 320
asgore_base_y = 250

asgore.MoveTo(asgore_base_x, asgore_base_y)

current_turn = GetGlobal("current_turn")

Arena.Resize(225, Arena.height)

--first comes on turn 4 (difficulty 1)
--second comes on turn 8 (difficulty 2)
--third comes on turn 12 (difficulty 2)
--fourth comes on turn 

if current_turn < 5 then
	difficulty = 1
elseif current_turn < 13 then
	difficulty = 2
elseif current_turn < 19 then
    difficulty = 3
else
	difficulty = 4
end

difficulty = 99

from_flash_to_blink = 58

if difficulty == 1 then
	numflashes = 3
	between_blinks = 24
	from_blink_to_pose = 54
	from_pose_to_step = 12
	from_step_to_return_step = 4
	from_return_step_to_raise_spear = 4
	from_spear_to_lunge = 4 -- could be further divided into raising the weapon and swinging
	from_lunge_to_slash = 4
	from_slash_to_after_slash = 4
	from_after_slash_to_opposite = 2
	next_step = 6
	-- followed by repeat of from_step_to_return_step
	
	slash_frames = 4
	backslash_frames = 2
elseif difficulty == 2 then
	numflashes = 4
	between_blinks = 18
	from_blink_to_pose = 46
	from_pose_to_step = 18
	from_step_to_return_step = 4
	from_return_step_to_raise_spear = 4
	from_spear_to_lunge = 4 -- could be further divided into raising the weapon and swinging
	from_lunge_to_slash = 4
	from_slash_to_after_slash = 4
	from_after_slash_to_opposite = 2
	next_step = 2
elseif difficulty == 3 then
	numflashes = 4
	between_blinks = 14
	from_blink_to_pose = 42
	from_pose_to_step = 8
	from_step_to_return_step = 2
	from_return_step_to_raise_spear = 2
	from_spear_to_lunge = 2 -- could be further divided into raising the weapon and swinging
	from_lunge_to_slash = 2
	from_slash_to_after_slash = 2
	from_after_slash_to_opposite = 2
	next_step = 6
else
	numflashes = 6
	between_blinks = 12
	from_blink_to_pose = 42
	from_pose_to_step = 6
	from_step_to_return_step = 2
	from_return_step_to_raise_spear = 2
	from_spear_to_lunge = 2 -- could be further divided into raising the weapon and swinging
	from_lunge_to_slash = 2
	from_slash_to_after_slash = 2
	from_after_slash_to_opposite = 2
	next_step = 6
end
swing_multiplier = 1


flashc = {}
for i=1,numflashes do
	flashc[i] = math.random(1, 2)
end
flashcolors = {{1.0, 0.65, 0.0}, {0.25, 1.0, 1.0}}

eyeflash = nil
spear = nil

flashes = 0
swingss = 0
swings = 0
asstage = 0
starttime = Time.time

init = false
escape = true
timer = 0
pellets = {}
whichFirst = 5 * math.random(2) - 5
function Update()
    if not init then
        init = true
    end
    timer = timer + 1
        if timer <= 60 then
            CreateEscape()
        elseif timer >= 70 then

        end
        if timer >= 130 then
            MoveHalfpellets(true)
        end
        if timer >= 180 then
            MoveHalfpellets(false)
        end
	for i=1,#pellets do
		local pellet = pellets[i]
		local frames_alive = pellet.GetVar('frames_alive')
		frames_alive = frames_alive + 1
		if frames_alive % 8 == 0 then
			pellet.sprite.Set('pellet')
		elseif frames_alive %8 == 4 then
			pellet.sprite.Set('pellet2')
		end
		pellet.SetVar('frames_alive', frames_alive)
                      end


	Timers.UpdateTimers()
	if(asstage == 0) then
		if Time.time - starttime >= 4 / 60 then
			Audio.PlaySound("blink")
			whiteover = CreateProjectileAbs("bgwhite", 320, 240)
			whiteover.sprite.alpha = 0.9
			starttime = Time.time
			asstage = 1
		end
	elseif(asstage == 1) then
		if(whiteover.isactive) then
			whiteover.sprite.alpha = whiteover.sprite.alpha - 0.045
			if(whiteover.sprite.alpha == 0) then
				whiteover.Remove()
			end
		end
		if(Time.time - starttime >= from_flash_to_blink / 60) then
			starttime = Time.time
			asstage = 2
		end
    elseif(asstage == 2) then
    	if(Time.time - starttime >= between_blinks / 60 and flashes < numflashes) then
    		starttime = Time.time
    		flashes = flashes + 1
			if flashes == numflashes then
				Audio.PlaySound("eyeflash_final")
				eyeflash = CreateSprite("asgore/eyeflash1")
			else
				Audio.PlaySound("eyeflash")
				eyeflash = CreateSprite("asgore/normal_eyeflash1")
			end
    		
    		eyeflash.SetParent(asgore)
    		eyeflash.SetAnchor(0.5, 0)
    		eyeflash.Scale(1, 1)
    		eyeflash.color = flashcolors[flashc[flashes]]
    		if(flashes % 2 == 0) then
    			eyeflash.MoveTo(12, 170)
    		else
    			eyeflash.MoveTo(-12, 170)
    		end
			
			if flashes == numflashes then
				eyeflash.SetAnimation({"asgore/eyeflash1", "asgore/eyeflash2", "asgore/eyeflash3", "asgore/eyeflash3",
				                       "asgore/eyeflash4", "asgore/eyeflash5"}, 0.0333)
                                                                                if(flashc[flashes] == 2) then
				   cyan.SetAnimation({"SOULS/spr_heartaqua_0", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1"}, 0.2)
                                                                                end
                                                                                if(flashc[flashes] == 1) then
		                                              orange.SetAnimation({"SOULS/spr_heartorange_0", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1"}, 0.2)
                                                                                end
			else
				eyeflash.SetAnimation({"asgore/normal_eyeflash1", "asgore/normal_eyeflash2", "asgore/normal_eyeflash3",
				                       "asgore/normal_eyeflash3", "asgore/normal_eyeflash4", "asgore/normal_eyeflash5"}, 0.0333)
                                                                                if(flashc[flashes] == 2) then
				   cyan.SetAnimation({"SOULS/spr_heartaqua_0", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1", "SOULS/spr_heartaqua_1"}, 0.2)
                                                                               end
                                                                                if(flashc[flashes] == 1) then
				   orange.SetAnimation({"SOULS/spr_heartorange_0", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1", "SOULS/spr_heartorange_1"}, 0.2)
                                                                               end
			end
    		
    		local stopFlash = Timers.CreateTimer("stopFlash", 0.03 * 5, false)
    		function stopFlash.OnComplete()
    			eyeflash.Remove()
    		end
    	elseif(Time.time - starttime >= from_blink_to_pose / 60 and flashes == numflashes) then
    		starttime = Time.time
			asstage = 3
                                           cyan.Remove()
                                           orange.Remove()
	    	asgore.Remove()
	    	asgore = CreateSprite("asgore/asgore_spearholdleft")
	    	asgore.Scale(2, 2)
	    	asgore.SetPivot(0.5, 0)
	    	asgore.MoveTo(asgore_base_x, asgore_base_y - 30)
	    	spear = CreateSprite("asgore/spear_spearholdleft")
	    	spear.Scale(2, 2)
	    	spear.SetPivot(0.5, 0)
	    	spear.MoveTo(asgore_base_x, asgore_base_y - 30)
	    	spear.color = flashcolors[flashc[1]]
			hands = CreateSprite("asgore/asgore_spearhold_handsleft")
			hands.Scale(2, 2)
			hands.SetPivot(0.5, 0)
			hands.MoveTo(asgore_base_x, asgore_base_y - 30)
		end
    elseif(asstage == 3) then
		if(swingss == 0 and Time.time - starttime >= from_pose_to_step / 60) then
			swingss = 1
			asgore.MoveTo(asgore.x - 2 * swing_multiplier, asgore.y + 2)  -- needs to account for left/right
			spear.MoveTo(spear.x - 2 * swing_multiplier, spear.y + 2)
			hands.MoveTo(hands.x - 2 * swing_multiplier, hands.y + 2)
			starttime = Time.time
		-- everything below here needs to drop by one --
    	elseif(swingss == 1 and Time.time - starttime >= from_step_to_return_step / 60) then
    		swingss = 2
			asgore.MoveTo(asgore.x + 2 * swing_multiplier, asgore.y - 2)
			spear.MoveTo(spear.x + 2 * swing_multiplier, spear.y - 2)
			hands.MoveTo(hands.x + 2 * swing_multiplier, hands.y - 2)
    		starttime = Time.time
		elseif(swingss == 2 and Time.time - starttime >= from_return_step_to_raise_spear / 60) then
			swingss = 3
			spear.MoveTo(spear.x - 2 * swing_multiplier, spear.y + 4)
			hands.MoveTo(hands.x - 2 * swing_multiplier, hands.y + 4)
			starttime = Time.time
		elseif(swingss == 3 and Time.time - starttime >= from_spear_to_lunge / 60) then
			swingss = 4
			asgore.MoveTo(asgore.x + 2 * swing_multiplier, asgore.y - 2)
			spear.MoveTo(spear.x + 4 * swing_multiplier, spear.y - 6)
			hands.MoveTo(hands.x + 4 * swing_multiplier, hands.y - 6)
			starttime = Time.time
		elseif(swingss == 4 and Time.time - starttime >= from_lunge_to_slash / 60) then 
			Audio.PlaySound("spearswing")
    		asgore.Set("asgore/asgore_spearswing")
    		spear.Remove()
			hands.Remove()
		    spear = CreateProjectileAbs("asgore/spear_spearswing", 314, asgore.y + asgore.height - 64)
		    spear.sprite.color = flashcolors[flashc[swings + 1]]
		    Player.sprite.SendToTop()
		    starttime = Time.time
		    swingss = 5
		elseif(swingss == 5 and Time.time - starttime >= from_slash_to_after_slash / 60) then
			asgore.Set("asgore/asgore_spearswing" .. GetDirection(swings + 1))
			spear.sprite.Set("asgore/spear_spearswing" .. GetDirection(swings + 1))
			starttime = Time.time
			swingss = 6
		elseif(swingss == 6 and Time.time - starttime >= from_after_slash_to_opposite / 60) then
			swings = swings + 1
			if swings % 2 == 0 then
			    swing_multipler = -1
			else
				swing_multiplier = 1
			end
			asgore.Set("asgore/asgore_spearhold" .. GetDirection(swings))
			asgore.MoveTo(asgore_base_x, asgore_base_y - 30)
			spear.Remove()
			spear = CreateSprite("asgore/spear_spearhold" .. GetDirection(swings))
			spear.Scale(2, 2)
			spear.SetPivot(0.5, 0)
			spear.MoveTo(asgore_base_x, asgore_base_y - 30)
			spear.color = flashcolors[flashc[swings]]
			hands = CreateSprite("asgore/asgore_spearhold_hands" .. GetDirection(swings))
			hands.Scale(2, 2)
			hands.SetPivot(0.5, 0)
			hands.MoveTo(asgore_base_x, asgore_base_y - 30)
			
			swingss = 7
			starttime = Time.time
		elseif(swingss == 7) then
			if(Time.time - starttime >= next_step / 60 and swings < numflashes) then
				swingss = 3
				asgore.MoveTo(asgore.x - 2 * swing_multiplier, asgore.y + 2)
				spear.MoveTo(spear.x - 2 * swing_multiplier, spear.y + 2)
				hands.MoveTo(hands.x - 2 * swing_multiplier, hands.y + 2)
				starttime = Time.time
			elseif(Time.time - starttime >= 1.25 and swings == numflashes) then
				asgore.Remove()
				spear.Remove()
				hands.Remove()
				Encounter.Call("ShowAsgore")
				EndWave()
			end
		end

		if(swingss == 4) then
			if(flashc[swings + 1] == 1) then
				if not Player.isMoving then
					Player.Hurt(15)
				end
			elseif(flashc[swings + 1] == 2) then
				if Player.isMoving then
					Player.Hurt(15)
				end
			end
		end
    end
end

function GetDirection(swing)
	if(swing % 2 == 0) then
		return "left"
	else
		return "right"
	end
end

function OnHit(bullet)
	--none
          if bullet.GetVar("aeiou") == true then
             Player.Hurt(5, 1)
          end
end

function CreateEscape()
    if timer % 5 == 0 then
        local angle = 2 * math.pi * ((timer - 240) / 60)
        local x = 100 * math.cos(angle)
        local y = 100 * math.sin(angle)
        local pellet = CreateProjectile('pellet', x, y)
        pellet.SetVar('speedX', -x / 100)
        pellet.SetVar('speedY', -y / 100)
        pellet.SetVar('aeiou', true)
        pellet.SetVar('first', timer % 10 == whichFirst)
        pellet.sprite.SetAnimation({'pellet', 'pellet2'}, 1 / 12)
        table.insert(pellets, pellet)
        Audio.PlaySound("pellet")
        pellet.SetVar('frames_alive', 0)
    end
end

function Movepellets()
    for i = 1, #pellets do
        local pellet = pellets[i]
        local speedX = pellet.GetVar('speedX')
        local speedY = pellet.GetVar('speedY')
        pellet.Move(speedX, speedY)
    end
end

function MoveHalfpellets(first)
    for i = 1, #pellets do
        local pellet = pellets[i]
        if pellet.GetVar('first') == first then
            local speedX = pellet.GetVar('speedX') * 1.03
            local speedY = pellet.GetVar('speedY') * 1.03
            pellet.SetVar('speedX', speedX)
            pellet.SetVar('speedY', speedY)
            pellet.Move(speedX, speedY)
            pellet.sprite.StopAnimation()
        end
    end
end

function Deletepellets()
    for i = 1, #pellets do
        local pellet = pellets[i]
        pellet.Remove()
    end
    pellets = {}
end
