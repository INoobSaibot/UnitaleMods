--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--[[

Normal Mode changes:
Metts stop above the arena instead of continuing to go down
Less metts, less shots, one less row of shootable blocks
Harder version of attack has the same everything as before, but no timeflow fast-forward

]]

oblib = require "objectdefs"

--(Change wavelength when mettaton orbitals are defeated)
waveStartTime = Time.time
waveLength = 8.0
ourTime = Time.time
timeMult = 1

playerbullet = CreateProjectile("yh0", Player.x, Player.y)
--"tile = 1" just means the onHit function ignores this bullet
playerbullet.SetVar('tile', 1)

blackbullet = CreateProjectileAbs("blackfade/black",325,230)
blackbullet.sprite.alpha = 0
blackbullet.SetVar('tile', 1)
blackbullet.SendToBottom()

NORMAL = 0
THIN = 1
LARGE = 2

ORANGE = 0
BLUE = 1

--When a Gaster Blaster's endX or endY equals -42, it'll instead change itself to be at the player's X or Y, once it's ready to appear.
--Easier than making it a new variable!
PX = -42
PY = -42


lastFireTime = 0
gbs = {}
bots = {}
pbs = {}
sboxes = {}
boxes = {}
bolts = {}
pbombs = {}
pmetts = {}
hearts = {}

--Timeflow commands
flow = {}
flowTime = Time.time
flowHUD = nil
flowHUDTime = Time.time

--With this array, I can set the radius of a given circle, and change it, without messing about with the objects connected to the circle
circles = {}

debugs = {}

oneFrameBullets = {}
--currentFrameBullet = CreateProjectileAbs("white",-50,-50)

--Here, I set up exactly what I want to spawn in and when (using the time variable)
--This lua file may as well be used for multiple attacks, just with a variable saying which set to load
--Colored tile puzzles can have their own file, as can yellow shooty sections

local shieldMetts = {}
local allMettsShot = 0

waveLength = 7.3
Encounter.SetVar("wavetimer", 7.3)
Arena.Resize(168,130)

if (GetGlobal("attackNum") > 100) then
	for i = 0,0.5,0.25 do
		--Column of metts on the left and right
		table.insert(pmetts, oblib.Parasol.new( { startX = 200, startY = 540+i*60, endX = 0, endY = -5000, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 80, speedTime = 1.2, time = ourTime + 2.6 + i, ammo = 2, delay = 1, firstShot = 1, flingDir = -1 }))
		table.insert(pmetts, oblib.Parasol.new( { startX = 440, startY = 540+i*60, endX = 0, endY = -5000, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 80, speedTime = 1.2, time = ourTime + 2.6 + i, ammo = 2, delay = 1, firstShot = 1, flingDir = 1 }))
	end
	for i = 250,382,44 do
		--Row of metts in front of you
		table.insert(pmetts, oblib.Parasol.new( { startX = i, startY = 540, endX = 0, endY = 260, bounce = false, xspeed = 0, yspeed = 100, xspeed2 = 0, yspeed2 = 60, speedTime = 1.2, time = ourTime + 3.8, ammo = 10, delay = 1, firstShot = 1.2, flingDir = -1 }))
	end

	--Line of bombs which are gonna get BLASTED
	for i = 248,392,24 do
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -60, time = ourTime + 5.4, fuse = 4.5 }))
	end

	table.insert(gbs, oblib.GasterBlaster.new( { startX = 670, startY = -30, endX = 510, endY = 268, time = ourTime+9, rotation = 90, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))

else
-- WALL 1 PART 1
	--This will create a line of 7 of the same object, spaced 24 pixels
	for i = 248,272,24 do
		--You may accidentally hit these bombs while shooting the wall of blocks~
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
		table.insert(sboxes, oblib.ShootableBox.new( {  simple = true, startX = 296, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
	end
-- WALL 1 PART 2
	for i = 320,392,24 do
                                           table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
                                           table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
                                           table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
                                           table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 0.1, bottomScreenDead = true }))
                     end
--METTS 1
                     for i = 270,316,23 do
		--Row of metts in front of you
		table.insert(pmetts, oblib.Parasol.new( { startX = i, startY = 540, endX = 0, endY = 110, bounce = false, xspeed = 0, yspeed = 100, xspeed2 = 0, yspeed2 = 60, speedTime = 2.9, time = ourTime + 0.5, ammo = 1, delay = 1, firstShot = 2.5, flingDir = -1 }))
	end
                     for i = 339,362,23 do
		--Row of metts in front of you 2
		table.insert(pmetts, oblib.Parasol.new( { startX = i, startY = 540, endX = 0, endY = 110, bounce = false, xspeed = 0, yspeed = 100, xspeed2 = 0, yspeed2 = 60, speedTime = 2.9, time = ourTime + 0.5, ammo = 1, delay = 1, firstShot = 2.5, flingDir = 1 }))
	end
-- WALL 2 PART 1
                     for i = 248,320,24 do
		--You may accidentally hit these bombs while shooting the wall of blocks~
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))
		table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))
	end
	for i = 368,392,24 do
                                           table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))
                                           table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))
                                           table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))
                                           table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = i, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))
                                           table.insert(sboxes, oblib.ShootableBox.new( {  simple = true, startX = 344, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = -120, time = ourTime + 2.5, bottomScreenDead = true }))		
                     end
                     table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX =500, startY = 510, endX = 344, endY = 320, time = ourTime+5.2, rotation = 0, size = NORMAL, laserDelay = 0.76, laserLength = 0.55, s1 = false, s2 = false }))
end

if (GetGlobal("attackNum") > 100) then
	--This only happens on the "harder" version of this wave.
	Encounter.SetVar("wavetimer", 12.75)
	waveLength = 12.75
	--table.insert(flow, { icon = "ff", start = 1.25, mult = 1.25, dir = 1, rate = 0.2, length = 18, blink = 2 })
	
	--Line of bombs which are gonna get BLASTED. one is missing (not the far left or right, too possibly unfair)
	local missing = math.random(1,5)
	for i = 0,6,1 do
		if (i ~= missing) then
			table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = 248+(i*24), startY = 540, xspeed = 0, yspeed = -100, time = ourTime + 9, fuse = 2.5 }))
		end
	end

	table.insert(gbs, oblib.GasterBlaster.new( { startX = 670, startY = -30, endX = 510, endY = 268, time = ourTime+10.6, rotation = 90, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))

	--Line on the side. one is missing
	missing = math.random(0,4)
	for i = 0,4,1 do
		if (i ~= missing) then
			table.insert(pbombs, oblib.PlusBomb.new( { simple = true, startX = -80, startY = 108+(i*26), xspeed = 100, yspeed = 0, time = ourTime + 9, fuse = 2.5 }))
		end
	end

	table.insert(gbs, oblib.GasterBlaster.new( { startX = -30, startY = -30, endX = 190, endY = 30, time = ourTime+10.6, rotation = 180, size = NORMAL, laserDelay = 0.75, laserLength = 0.55 }))

	
end

function Update()
	--Time flow shenanigans
	if (#flow > 0) then
		if (Time.time - flowTime < flow[1].length) then
			local timeDiff = Time.time - flowTime
			timeMult = flow[1].start + timeDiff * flow[1].rate
			if (flow[1].dir == 1) then timeMult = math.min(timeMult, flow[1].mult)
			else timeMult = math.max(timeMult, flow[1].mult) end
		else
			table.remove(flow,1)
			flowTime = Time.time
			for i=#gbs,1,-1 do
				if (gbs[i].rev == true) then
					--gbs[i].s1 = false
					--gbs[i].s2 = false
				end
			end
		end
	end

	ourTime = ourTime + (Time.dt * timeMult)
	--DEBUG(timeMult)
	--Audio.Pitch(math.max(1/12,timeMult))
	--if (Time.time - waveStartTime > 5) then timeMult = timeMult - 0.01 end

	--Remove bullets to be displayed only one frame
	for i=#oneFrameBullets,1,-1 do
		oneFrameBullets[i].Remove()
		table.remove(oneFrameBullets,i)
	end
	
	local waveTimeDiff = Time.time - waveStartTime
	local ourWaveTimeDiff = ourTime - waveStartTime
	
	
	--playerbullet.MoveTo(Player.x, Player.y)
	--Blink the heart at 15 fps if hurting
	local heartframe = 0
	if (Player.isHurting) then heartframe = math.floor((Time.time / (1/15)) % 2) end
	playerbullet.sprite.Set("yh" .. heartframe)
	playerbullet.MoveTo(Player.x,Player.y)
	playerbullet.SendToTop()
	
	--Check for firing bullets. Rule: Can fire if there's zero bullets out, or it's been half a second
	--It uses Time.time instead of ourTime because the player's bullets shouldn't be affected by timeflow shenanigans
	if (Input.Confirm == 1) then
		if (#pbs == 0 or (Time.time - lastFireTime > 0.5)) then
			--Fire a bullet
			lastFireTime = Time.time
			table.insert(pbs, { x = Player.absx, y = Player.absy, time = Time.time, lastY = Player.absy, lastH = 10 })
			Audio.PlaySound("pew")
			
		end
	end

	for i=#pbs,1,-1 do
		--Check for collision with collidable things here?
		local timeDiff = Time.time - pbs[i].time
		local curFrame = math.floor(timeDiff / (1/30))
		if (curFrame > 20) then curFrame = 20 end
		--Here, I'm just trying to be accurate. Your shots move about 16 pixels per (30fps) frame (hence the 1/60 * 8)
		--but they also pick up a slight amount of speed over time it seems
		--End result looks great!
		local by = pbs[i].y - 24 + (timeDiff/(1/60))*8 + timeDiff*60
		
		local knowsHowToMoveBoolet = false
		
		--Is boolet offscreen?
		if (by > 480) then
			table.remove(pbs,i)
		else
			--Last H represents the height of the bullet (increases over time)
			pbs[i].lastY = by
			pbs[i].lastH = 10 + (curFrame * 2)
			--Collision used to be here, but I moved it to the object update functions.
			--Less useless checks. Should run a lot better that way.
			local bullet = CreateProjectileAbs("bullet/" .. curFrame, pbs[i].x, by)
			bullet.SetVar('tile',1)
			bullet.SendToBottom()
			table.insert(oneFrameBullets, bullet)
		end
	end

	--Parasol Mettaton heart bullets (they need to be drawn below the mettatons)
	for i=#hearts,1,-1 do
		if (ourTime > hearts[i].time) then hearts[i].Update()
		else
			hearts[i].bullet.MoveToAbs(-500,-500)
			hearts[i].hitbox.MoveToAbs(-500,-500)
		end
		if (hearts[i].dead) then
			hearts[i].bullet.Remove()
			hearts[i].hitbox.Remove()
			table.remove(hearts,i)
		end
	end
	
	--Parasol Mettatons
	for i=#pmetts,1,-1 do
		if (ourTime > pmetts[i].time) then pmetts[i].Update() end
		if (pmetts[i].dead) then
			pmetts[i].bullet.Remove()
			table.remove(pmetts,i)
		end
	end
	
	
	--Shootable black boxes
	for i=#sboxes,1,-1 do
		if (ourTime > sboxes[i].time) then sboxes[i].Update() end
		if (sboxes[i].dead) then
			sboxes[i].bullet.Remove()
			table.remove(sboxes,i)
		end	
	end
	
	--Unshootable boxes
	for i=#boxes,1,-1 do
		if (ourTime > boxes[i].time) then boxes[i].Update() end
		if (boxes[i].dead) then
			boxes[i].bullet.Remove()
			table.remove(boxes,i)
		end
	end
	
	--Lightning bolts
	for i=#bolts,1,-1 do
		if (ourTime > bolts[i].time) then bolts[i].Update() end
		if (bolts[i].dead) then
			bolts[i].bullet.Remove()
			table.remove(bolts,i)
		end
	end
	
	--Plus bombs
	bombsound = false
	
	for i=#pbombs,1,-1 do
		if (ourTime > pbombs[i].time) then pbombs[i].Update() end
		--Pbombs remove their own bullet because blast
		if (pbombs[i].dead) then table.remove(pbombs,i) end
	end
	
	for i=#bots,1,-1 do
		if (ourTime > bots[i].time) then bots[i].Update() end
		if (bots[i].dead) then
			bots[i].bullet.Remove()
			if (bots[i].laser ~= nil) then
				bots[i].laser.Remove()
			end
			table.remove(bots,i)
		end
	end

	--Draw the HUD for record/rewind/etc
	--Gaster blasters get drawn on top of it, cause, blasters don't care bout no GUI!
	if (#flow > 0) then
		if (flowHUD ~= nil) then flowHUD.SendToTop() end
		local sprite = "timeflow/" .. flow[1].icon
		
		local freq = 1/3
		if (flow[1].blink ~= nil) then freq = freq / flow[1].blink end
		--...I have no idea if this will work
		if (Time.time - flowHUDTime > freq) then
			flowHUDTime = Time.time
			if (flowHUD == nil) then
				flowHUD = CreateProjectile(sprite, math.floor(Arena.width/2) - 41, -math.floor(Arena.height/2) + 11)
				flowHUD.SetVar('tile',1)
			else
				flowHUD.Remove()
				flowHUD = nil
			end
		end
		
	end
	
	for i=#gbs,1,-1 do
		if (ourTime > gbs[i].time) then gbs[i].Update() end
		if (gbs[i].dead) then
			gbs[i].bullet.Remove()
			table.remove(gbs,i)
		end
	end
	
	
	--Draw the black translucent bullet that goes over everything but the arena (fades in/out at start/end of wave)
	--I want to go from 0% to 50% opacity in a third of a second
	if (Time.time - waveStartTime < 0.5) then
		local timeDiff = Time.time - waveStartTime
		blackbullet.sprite.alpha = math.min(0.5, timeDiff / (2/3))
	elseif (Time.time - waveStartTime > waveLength - (1/3)) then
		local timeDiff = Time.time - waveStartTime - (waveLength - (1/3))
		blackbullet.sprite.alpha = 0.5 - math.min(0.5, timeDiff / (2/3))
	end
	blackbullet.SendToBottom()
	
	--playerbullet.SendToTop()

end

function OnHit(bullet)
	--"Tile" bullets shouldn't collide with the player. Board tiles, fading lasers, whatever else
	if(bullet.GetVar('tile') ~= 1) then
		if (bullet.GetVar('color') == BLUE) then
			if (Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage'))
			end
		elseif (bullet.GetVar('color') == ORANGE) then
			if (not Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage'))
			end
		else
			Player.Hurt(bullet.GetVar('damage'))
		end
	end
end