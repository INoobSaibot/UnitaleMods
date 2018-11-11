--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--[[

Normal Mode changes:
Tweak the little bolt circle "bullets" in a lot of ways
Slightly increase gaster blaster laser delay
Slightly decrease fast forward speed

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

--Circle 1: constant radius
table.insert(circles, { radius = 82, offset = 0 } )
--Circle 2: radius will start to grow
table.insert(circles, { radius = 10, offset = 0 } )
--Circle 3: radius will start to grow
table.insert(circles, { radius = 10, offset = 0 } )
--Circle 4: constant, for mett shield
table.insert(circles, { radius = 45, offset = 0 } )
--Circle 5: constant, for mett shield
table.insert(circles, { radius = 45, offset = 0 } )
--Circle 6: constant, for mett shield
table.insert(circles, { radius = 45, offset = 0 } )
--Circle 7: constant, for mett shield
table.insert(circles, { radius = 45, offset = 0 } )

local shieldMetts = {}
local allMettsShot = 0

waveLength = 30
Encounter.SetVar("wavetimer", 30.0)
Arena.Resize(168,130)
--This wave lasts 30 seconds, or until the shield metts are dead.

--Circle of bolts with a hole in it, with a row of boxes above
for i = 0,280,20 do
	table.insert(bolts, oblib.Bolt.new( { simple = true, lifetime = 4, circleID = 1, rotation = i, rspeed = 160, startX = 320, startY = 440, endX = 0, endY = -5000, xspeed = 0, yspeed = -130, time = ourTime + 0 }))
end
for i = 248,392,24 do
	table.insert(sboxes, oblib.ShootableBox.new( { bottomScreenDead = true, simple = true, startX = i, startY = 545, endX = 0, endY = -5000, xspeed = 0, yspeed = -130, time = ourTime + 0 }))
end

--Little bolt circles being flung at you from above!
for i = 0,320,40 do
	table.insert(bolts, oblib.Bolt.new( { simple = true, lifetime = 3, circleID = 2, rotation = i, rspeed = 360, startX = 50, startY = 540, endX = 1000, endY = -5000, xspeed = 150, yspeed = -250, time = ourTime + 2 }))
	table.insert(bolts, oblib.Bolt.new( { simple = true, lifetime = 3, circleID = 3, rotation = i, rspeed = 360, startX = 590, startY = 540, endX = -1000, endY = -5000, xspeed = -140, yspeed = -250, time = ourTime + 2.8 }))
end

--Parasol metts protected by box shields
--The metts get tracked if they've been shot so the boxes can be flung
--They get created at different spots in the harder version of the wave, plus a fourth one

local d = 2.8

if (GetGlobal("attackNum") > 10) then
	Encounter.SetVar("wavetimer", 60)
	waveLength = 60
	table.insert(flow, { icon = "ff", start = 1.2, mult = 1.2, dir = 1, rate = 0.2, length = 60, blink = 2 })
	
	table.insert(pmetts, oblib.Parasol.new( { startX = 260 - 4, startY = 700+12, endX = 0, endY = 360+12, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, ammo = 99, delay = 2.5, firstShot = 1.5, flingDir = -1, bounce = false }))
	table.insert(shieldMetts, pmetts[#pmetts])
	for j = 0, 320, 40 do
		table.insert(sboxes, oblib.ShootableBox.new( { circleID = 4, rotation = j, rspeed = -90, startX = 260, startY = 700, endX = 0, endY = 360, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, bounce = false }))
	end

	table.insert(pmetts, oblib.Parasol.new( { startX = 320 - 4, startY = 640+12, endX = 0, endY = 300+12, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, ammo = 99, delay = 1, firstShot = 1.2, flingDir = -1, bounce = false }))
	table.insert(shieldMetts, pmetts[#pmetts])
	for j = 0, 320, 40 do
		table.insert(sboxes, oblib.ShootableBox.new( { circleID = 5, rotation = j, rspeed = 100, startX = 320, startY = 640, endX = 0, endY = 300, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, bounce = false }))
	end

	table.insert(pmetts, oblib.Parasol.new( { startX = 380 - 4, startY = 700+12, endX = 0, endY = 360+12, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, ammo = 99, delay = 2.5, firstShot = 1.5, flingDir = -1, bounce = false }))
	table.insert(shieldMetts, pmetts[#pmetts])
	for j = 0, 320, 40 do
		table.insert(sboxes, oblib.ShootableBox.new( { circleID = 6, rotation = j, rspeed = -90, startX = 380, startY = 700, endX = 0, endY = 360, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, bounce = false }))
	end
	
	table.insert(pmetts, oblib.Parasol.new( { startX = 320 - 4, startY = 760+12, endX = 0, endY = 420+12, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, ammo = 99, delay = 1.5, firstShot = 1.8, flingDir = -1, bounce = false }))
	table.insert(shieldMetts, pmetts[#pmetts])
	for j = 0, 320, 40 do
		table.insert(sboxes, oblib.ShootableBox.new( { circleID = 7, rotation = j, rspeed = 100, startX = 320, startY = 760, endX = 0, endY = 420, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, bounce = false }))
	end
	
else
	table.insert(pmetts, oblib.Parasol.new( { startX = 260 - 4, startY = 740+12, endX = 0, endY = 400+12, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, ammo = 99, delay = 2, firstShot = 1.5, flingDir = -1, bounce = false }))
	table.insert(shieldMetts, pmetts[#pmetts])
	for j = 0, 320, 40 do
		table.insert(sboxes, oblib.ShootableBox.new( { circleID = 4, rotation = j, rspeed = -90, startX = 260, startY = 740, endX = 0, endY = 400, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, bounce = false }))
	end

	table.insert(pmetts, oblib.Parasol.new( { startX = 320 - 4, startY = 640+12, endX = 0, endY = 300+12, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, ammo = 99, delay = 1, firstShot = 1.2, flingDir = -1, bounce = false }))
	table.insert(shieldMetts, pmetts[#pmetts])
	for j = 0, 320, 40 do
		table.insert(sboxes, oblib.ShootableBox.new( { circleID = 5, rotation = j, rspeed = 100, startX = 320, startY = 640, endX = 0, endY = 300, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, bounce = false }))
	end

	table.insert(pmetts, oblib.Parasol.new( { startX = 380 - 4, startY = 740+12, endX = 0, endY = 400+12, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, ammo = 99, delay = 2, firstShot = 1.5, flingDir = -1, bounce = false }))
	table.insert(shieldMetts, pmetts[#pmetts])
	for j = 0, 320, 40 do
		table.insert(sboxes, oblib.ShootableBox.new( { circleID = 6, rotation = j, rspeed = -90, startX = 380, startY = 740, endX = 0, endY = 400, xspeed = 0, yspeed = 200, xspeed2 = 0, yspeed2 = 60, speedTime = 1.5, time = ourTime + d, bounce = false }))
	end

end

--Create random things that come in and fuck with you until wave ends
for i = 1, 90, 4.2 do
	local nextSpawn = math.random(0,2)
	--nextSpawn = 2
	--Gaster
	if (nextSpawn == 0) then
		local pos = math.random(0,1)
		if (pos == 0) then
			table.insert(gbs, oblib.GasterBlaster.new( { lifetime = 5, startX = 670, startY = 510, endX = 468, endY = -42, time = ourTime+5.5+i, rotation = 90, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false }))
			table.insert(gbs, oblib.GasterBlaster.new( { lifetime = 5, startX = -30, startY = -30, endX = -42, endY = 50, time = ourTime+5.5+i, rotation = 180, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))
		else
			table.insert(gbs, oblib.GasterBlaster.new( { lifetime = 5, startX = -30, startY = 510, endX = 172, endY = -42, time = ourTime+5.5+i, rotation = 270, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false }))
			table.insert(gbs, oblib.GasterBlaster.new( { lifetime = 5, startX = 670, startY = -30, endX = -42, endY = 50, time = ourTime+5.5+i, rotation = 180, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))
		end
		
	--More metts
	elseif (nextSpawn == 1) then
		table.insert(pmetts, oblib.Parasol.new( { lifetime = 5, startX = 160, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = 220, xspeed2 = 0, yspeed2 = 80, speedTime = 1, time = ourTime + 5.5 + i, ammo = 2, delay = 1, firstShot = 0.8, flingDir = -1 }))
		table.insert(pmetts, oblib.Parasol.new( { lifetime = 5, startX = 480, startY = 540, endX = 0, endY = -5000, xspeed = 0, yspeed = 220, xspeed2 = 0, yspeed2 = 80, speedTime = 1, time = ourTime + 5.5 + i, ammo = 2, delay = 1, firstShot = 0.8, flingDir = 1 }))
	--Laserbots
	elseif (nextSpawn == 2) then
		local pos = math.random(0,1)
		if (pos == 0) then
			table.insert(bots, oblib.LaserBot.new( { lifetime = 5, simple = true, startX = 670, startY = 70, endX = -5000, endY = 70, time = ourTime+5.5+i, xspeed = -300, rotation = 180, color = math.random(0,1) }))
			table.insert(bots, oblib.LaserBot.new( { lifetime = 5, simple = true, startX = 780, startY = 70, endX = -5000, endY = 70, time = ourTime+5.5+i, xspeed = -300, rotation = 180, color = math.random(0,1) }))
		else
			table.insert(bots, oblib.LaserBot.new( { lifetime = 5, simple = true, startX = -30, startY = 70, endX = 5000, endY = 70, time = ourTime+5.5+i, xspeed = 300, rotation = 180, color = math.random(0,1) }))
			table.insert(bots, oblib.LaserBot.new( { lifetime = 5, simple = true, startX = -140, startY = 70, endX = 5000, endY = 70, time = ourTime+5.5+i, xspeed = 300, rotation = 180, color = math.random(0,1) }))
		end
	end
end

iStoleThisFromBlaze = true

shieldMettCount = #shieldMetts

	
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
	
	--Stuff exclusive to attack 4. Circles that expand, shielded mettatons ending the wave
	--Circles are done really stupid and hardcoded here. They're better in Circle Madness
	if (ourWaveTimeDiff > 2) then
		circles[2].radius = 10 + (ourWaveTimeDiff - 2) * 16
	end
	
	if (ourWaveTimeDiff > 2.8) then
		circles[3].radius = 10 + (ourWaveTimeDiff - 2.8) * 16
	end
	
	local shotMetts = 0
	
	--Make the shootable box circles fly out after a shield mett has been shot.
	for i=#shieldMetts,1,-1 do
		if (shieldMetts[i].shot) then
			shotMetts = shotMetts + 1
			circles[i+3].radius = 45 + (Time.time - shieldMetts[i].shotTime)*300
		end
	end
	
	--If all 3 shielded metts have been shot, end the wave after 1 second
	if (shotMetts >= shieldMettCount) then
		if (allMettsShot == 0) then
			allMettsShot = Time.time
			waveLength = Time.time - waveStartTime + 1
		end
		if (Time.time - allMettsShot > 1) then EndWave() end
	end

	
	
	
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
		--Hacky solution to gaster blasters being, like, the only object that is on screen pretty much the first frame they appear
		if (ourTime > gbs[i].time) then gbs[i].Update()
		else gbs[i].bullet.MoveToAbs(-500,-500) end
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