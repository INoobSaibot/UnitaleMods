--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--[[

Normal Mode changes:
Slowed down the rewind to x1 instead of x1.25
Moved metts further away from the arena
Increase gaster laser delay slightly
Reduced bomb row speed

]]

oblib = require "objectdefs"

--This is the wave for yellow attacks that use rewinding. Yeah

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

--Circle 1: The metts belong to this one. Its origin point moves based on circle 2?
--table.insert(circles, { radius = 140, offset = 0, originX = 0, originY = 0 } )
--Circle 2: Circle 1 belongs to this one
--table.insert(circles, { radius = 30, offset = 0 } )


local shieldMetts = {}
local allMettsShot = 0

local pianoMode = false
local pianoBullet = nil


waveLength = 16
Encounter.SetVar("wavetimer", 16.0)
Arena.Resize(155,130)

damageMult = 1

if (GetGlobal("justTaunted") == true) then
	--This only happens on the "harder" version of this wave.
	--I know this is hard but the taunts are supposed to be. Also, the damage output is the same as it is in hard mode. I recommend against taunting.
	damageMult = 4/3
	waveLength = 21
	Encounter.SetVar("wavetimer", 21)
	table.insert(flow, { icon = "rec", start = 1.1, mult = 1.1, dir = 1, rate = 0, length = 11.7 })
	table.insert(flow, { icon = "rew", start = 1.1, mult = -1.25, dir = -1, rate = -2.1, length = 11, blink = 2 })
	--table.insert(flow, { icon = "ff", start = 1.3, mult = 1.3, dir = 1, rate = 0.2, length = 20, blink = 2 })
	
	local rand1 = math.random(0,1)
	if (rand1 == 0) then rand1 = -1 end
	local rand2 = math.random(0,1)
	if (rand2 == 0) then rand2 = -1 end
	local rand3 = math.random(0,1)
	if (rand3 == 0) then rand3 = -1 end
	local rand4 = math.random(0,1)
	if (rand4 == 0) then rand4 = -1 end

	--Blasties leaving only one corner open
	table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 172, endY = 160+(rand1*50), time = ourTime+9.8, rotation = 270, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))
	table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 320+(rand2*50), endY = 290, time = ourTime+9.8, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.55 }))
	
	table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = -30, endX = 468, endY = 160+(rand3*50), time = ourTime+11.3, rotation = 90, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = true, rs1 = false }))
	table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = -30, endX = 320+(rand4*50), endY = 30, time = ourTime+11.3, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 0.55 }))

	
else
	table.insert(flow, { icon = "rec", start = 1.0, mult = 1.0, dir = 1, rate = 0, length = 9.8 })
	table.insert(flow, { icon = "rew", start = 1.0, mult = -1.0, dir = -1, rate = -2.1, length = 9 })
end

--Corner metts
table.insert(pmetts, oblib.Parasol.new({ heartsDie = false, simple = true, startX = 180, startY = 290, time = ourTime, ammo = 99, delay = 4, firstShot = 2, flingDir = -1, bounce = false } ))
table.insert(pmetts, oblib.Parasol.new({ heartsDie = false, simple = true, startX = 460, startY = 290, time = ourTime, ammo = 99, delay = 4, firstShot = 3, flingDir = -1, bounce = false } ))

local s = -125
local d = 250

--Row of plus bombs. No shootable box!
for i = 256,386,26 do
	table.insert(pbombs, oblib.PlusBomb.new({ simple = true, startX = i-1, startY = 550, yspeed = s, time = ourTime } ))
	table.insert(pbombs, oblib.PlusBomb.new({ simple = true, startX = i-1, startY = 550+d, yspeed = s, time = ourTime } ))
	table.insert(pbombs, oblib.PlusBomb.new({ simple = true, startX = i-1, startY = 550+d*2, yspeed = s, time = ourTime } ))
end

--Some lasers on the bomb rows!
table.insert(bots, oblib.LaserBot.new({ simple = true, startX = 540, startY = 550-2, time = ourTime, yspeed = s, rotation = 90, color = BLUE }))
table.insert(bots, oblib.LaserBot.new({ simple = true, startX = 540, startY = 550-2+d, time = ourTime, yspeed = s, rotation = 90, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new({ simple = true, startX = 540, startY = 550-2+d*2, time = ourTime, yspeed = s, rotation = 90, color = math.random(0,1) }))

table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = 510, endX = 468, endY = -42, time = ourTime+6.9, rotation = 90, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = -30, endX = -42, endY = 30, time = ourTime+6.9, rotation = 180, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))
if (GetGlobal("justTaunted") == true) then
	table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 172, endY = -42, time = ourTime+8.2, rotation = 270, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false, rs1 = false, rs2 = false }))
else
	table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 172, endY = -42, time = ourTime+8.2, rotation = 270, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = true, rs1 = false }))
end
table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = -30, endX = -42, endY = 30, time = ourTime+8.2, rotation = 180, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))

--Walls of 1 or 2 shootable boxes and the rest are bombs
for i = 500,700,200 do
	local box1 = math.random(0,1)
	local box2 = math.random(2,3)
	for j = 0,3,1 do
		if (j == box1 or j == box2) then
			table.insert(pbombs, oblib.PlusBomb.new({ simple = true, startX = 282+26*j, startY = i, yspeed = -140, time = ourTime + 0 } ))
		else
			table.insert(sboxes, oblib.ShootableBox.new({ simple = true, startX = 282+26*j, startY = i, yspeed = -140, time = ourTime + 0 } ))
		end
	end
end

local box1 = 0

--Just one shootable box
--The box doesn't spawn in the same spot twice in a row, but also doesn't spawn 3 boxes away from the last spot (that's just unfair)
for i = 900,1300,200 do
	local tempbox = math.random(0,3)
	while (tempbox == box1 or math.abs(box1-tempbox) >= 3) do tempbox = math.random(0,3) end
	box1 = tempbox
	for j = 0,3,1 do
		if (j == box1) then
			table.insert(pbombs, oblib.PlusBomb.new({ simple = true, startX = 282+26*j, startY = i, yspeed = -140, time = ourTime + 0 } ))

		else
			table.insert(sboxes, oblib.ShootableBox.new({ simple = true, startX = 282+26*j, startY = i, yspeed = -140, time = ourTime + 0 } ))
		end
	end
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

	--Remove bullets to be displayed only one frame
	for i=#oneFrameBullets,1,-1 do
		oneFrameBullets[i].Remove()
		table.remove(oneFrameBullets,i)
	end
	
	local waveTimeDiff = Time.time - waveStartTime
	local ourWaveTimeDiff = ourTime - waveStartTime
	
	
	--So here, I'm playing a sound effect at a specific time, basically because
	--sound effects have no way to stop them or control their pitch
	--and this is the only way to have the blaster that fires just before time starts reversing, to sound right
	--I'm using the "allMettsShot" variable just cause it's there. whatever
	
	if (GetGlobal("justTaunted") == true) then
		if (allMettsShot == 0 and ourWaveTimeDiff > 12.2) then
			allMettsShot = 1
			Audio.PlaySound("attack8")
		end
	elseif (allMettsShot == 0 and waveTimeDiff > 9.1) then
		allMettsShot = 1
		Audio.PlaySound("attack8")
	end
	
	--playerbullet.MoveTo(Player.x, Player.y)
	--Blink the heart at 15 fps if hurting
	local heartframe = 0
	if (Player.isHurting) then heartframe = math.floor((Time.time / (1/15)) % 2) end
	playerbullet.sprite.Set("yh" .. heartframe)
	playerbullet.MoveTo(Player.x,Player.y)
	
	--Check for firing bullets. Rule: Can fire if there's zero bullets out, or it's been half a second
	--It uses Time.time instead of ourTime because the player's bullets shouldn't be affected by timeflow shenanigans
	if (Input.Confirm == 1) then
		if (#pbs == 0 or (Time.time - lastFireTime > 0.5)) then
			--Fire a bullet
			lastFireTime = Time.time
			table.insert(pbs, { x = Player.absx, y = Player.absy, time = Time.time })
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
	
	--Bots (drawn before bombs)
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
	
	--Plus bombs
	bombsound = false
	
	for i=#pbombs,1,-1 do
		if (ourTime > pbombs[i].time) then pbombs[i].Update() end
		--Pbombs remove their own bullet because blast
		if (pbombs[i].dead) then table.remove(pbombs,i) end
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
	
	if (pianoBullet ~= nil) then pianoBullet.SendToBottom() end
	
	--playerbullet.SendToTop()

end

function OnHit(bullet)
	--"Tile" bullets shouldn't collide with the player. Board tiles, fading lasers, whatever else
	if(bullet.GetVar('tile') ~= 1) then
		if (bullet.GetVar('color') == BLUE) then
			if (Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage') * damageMult)
			end
		elseif (bullet.GetVar('color') == ORANGE) then
			if (not Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage') * damageMult)
			end
		else
			Player.Hurt(bullet.GetVar('damage') * damageMult)
		end
	end
end
