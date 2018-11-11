--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

oblib = require "objectdefs"

waveStartTime = Time.time
waveLength = 8.0
ourTime = Time.time
timeMult = 1

playerbullet = CreateProjectile("yh0", Player.x, Player.y)
--"tile = 1" just means the onHit function ignores this bullet
playerbullet.SetVar('tile', 1)

blackbullet = CreateProjectileAbs("blackfade/asgoreblack",325,230)
blackbullet.sprite.alpha = 0
blackbullet.SetVar('tile', 1)
blackbullet.SendToBottom()

NORMAL = 0
THIN = 1
LARGE = 2

LAZYCOPIER = TRUE

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

local shieldMetts = {}
local allMettsShot = 0

local pianoMode = false
local pianoBullet = nil

local rand1 = math.random(0,1)
if (rand1 == 0) then rand1 = -1 end
local rand2 = math.random(0,1)
if (rand2 == 0) then rand2 = -1 end
local rand3 = math.random(0,1)
if (rand3 == 0) then rand3 = -1 end
local rand4 = math.random(0,1)
if (rand4 == 0) then rand4 = -1 end

--Mettaton circle of death wave
waveLength = 15
Encounter.SetVar("wavetimer", 15.0)
--Arena.Resize(155,130)
Arena.Resize(215,180)
Player.MoveTo(0,0+25,true)

--table.insert(flow, { icon = "rec", start = 1.0, mult = 1.0, dir = 1, rate = 0, length = 7.5 }))
--table.insert(flow, { icon = "rew", start = 1.0, mult = -1.0, dir = -1, rate = -1.5, length = 9 }))
for j = 0, 320, 40 do
	table.insert(pmetts, oblib.Parasol.new({ simple = true, circleID = 1, rotation = j, rspeed = 50, startX = 320, startY = 205, time = ourTime, ammo = 6, delay = 8.5, firstShot = math.random()*10+1, flingDir = -1 }))
                     table.insert(sboxes, oblib.ShootableBox.new( { simple = true, circleID = 1, rotation = j, rspeed = 50, startX = 320, startY = 180, endX = 0, endY = 300, xspeed = 0, yspeed = 0, speedTime = 1.5, time = ourTime, bounce = false }))
	table.insert(pbombs, oblib.PlusBomb.new( { simple = true, circleID = 1, rotation = j, rspeed = 75, startX = 320, startY = 160, endX = 0, endY = 300, xspeed = 0, yspeed = 0, speedTime = 1.5, time = ourTime, bounce = false }))
end

--Circles are better in this wave than the original waves with circles. In this case they have a time variable and what not
--and start radius/end radius. good for Asgore circles
--Circle 1: The metts belong to this one. Static
table.insert(circles, { startR = 440, endR = 200, shrinkSpeed = 220, time = ourTime, offset = 0 } )

--Asgore circle. The random here means it has a speed between 20-120, and might get flipped to negatives
local timer = 1.7
local randspeed = ((math.random() * 60) + 10)
if (math.random(0,1) == 0) then randspeed = randspeed * -1 end

local boltcount = 28
local boltmult = 9
local id = 2

for j = 0, boltcount, 1 do
	table.insert(bolts, oblib.Bolt.new({ simple = true, circleID = id, rotation = j*boltmult, rspeed = randspeed, startX = 320, startY = 185, time = ourTime + timer }))
end
table.insert(circles, { startR = 640, endR = 0, shrinkSpeed = 180, time = ourTime + timer, offset = math.random()*360 } )

--Asgore circle
timer = timer + 1.5
randspeed = ((math.random() * 100) + 15)
if (math.random(0,1) == 0) then randspeed = randspeed * -1 end
id = id+1
for j = 0, boltcount, 1 do
	table.insert(bolts, oblib.Bolt.new({ simple = true, circleID = id, rotation = j*boltmult, rspeed = randspeed, startX = 320, startY = 185, time = ourTime + timer }))
end
table.insert(circles, { startR = 640, endR = 0, shrinkSpeed = 200, time = ourTime + timer, offset = math.random()*360 } )

--Asgore circle
timer = timer + 1.5
randspeed = ((math.random() * 120) + 20)
if (math.random(0,1) == 0) then randspeed = randspeed * -1 end
id = id+1
for j = 0, boltcount+1, 1 do
	table.insert(bolts, oblib.Bolt.new({ simple = true, circleID = id, rotation = j*boltmult, rspeed = randspeed, startX = 320, startY = 185, time = ourTime + timer }))
end
table.insert(circles, { startR = 640, endR = 0, shrinkSpeed = 200, time = ourTime + timer, offset = math.random()*360 } )

--Asgore circle
timer = timer + 1.5
randspeed = ((math.random() * 90) + 30)
if (math.random(0,1) == 0) then randspeed = randspeed * -1 end
id = id+1
for j = 0, boltcount+1, 1 do
	table.insert(bolts, oblib.Bolt.new({ simple = true, circleID = id, rotation = j*boltmult, rspeed = randspeed, startX = 320, startY = 185, time = ourTime + timer }))
end
table.insert(circles, { startR = 640, endR = 0, shrinkSpeed = 210, time = ourTime + timer, offset = math.random()*360 } )

--Asgore circle
timer = timer + 1.5
randspeed = ((math.random() * 120) + 40)
if (math.random(0,1) == 0) then randspeed = randspeed * -1 end
id = id+1
for j = 0, boltcount+1, 1 do
	table.insert(bolts, oblib.Bolt.new({ simple = true, circleID = id, rotation = j*boltmult, rspeed = randspeed, startX = 320, startY = 185, time = ourTime + timer }))
end
table.insert(circles, { startR = 640, endR = 0, shrinkSpeed = 210, time = ourTime + timer, offset = math.random()*360 } )

--Asgore circle
timer = timer + 1.5
randspeed = ((math.random() * 140) + 45)
if (math.random(0,1) == 0) then randspeed = randspeed * -1 end
id = id+1
for j = 0, boltcount+1, 1 do
	table.insert(bolts, oblib.Bolt.new({ simple = true, circleID = id, rotation = j*boltmult, rspeed = randspeed, startX = 320, startY = 185, time = ourTime + timer }))
end
table.insert(circles, { startR = 640, endR = 0, shrinkSpeed = 220, time = ourTime + timer, offset = math.random()*360 } )

--Asgore circle
timer = timer + 1.5
randspeed = ((math.random() * 120) + 60)
if (math.random(0,1) == 0) then randspeed = randspeed * -1 end
id = id+1
for j = 0, boltcount+2, 1 do
	table.insert(bolts, oblib.Bolt.new({ simple = true, circleID = id, rotation = j*boltmult, rspeed = randspeed, startX = 320, startY = 185, time = ourTime + timer }))
end
table.insert(circles, { startR = 640, endR = 0, shrinkSpeed = 220, time = ourTime + timer, offset = math.random()*360 } )

--Asgore circle
timer = timer + 1.5
randspeed = ((math.random() * 80) + 40)
if (math.random(0,1) == 0) then randspeed = randspeed * -1 end
id = id+1
for j = 0, boltcount+2, 1 do
	table.insert(bolts, oblib.Bolt.new({ simple = true, circleID = id, rotation = j*boltmult, rspeed = randspeed, startX = 320, startY = 185, time = ourTime + timer }))
end
table.insert(circles, { startR = 640, endR = 0, shrinkSpeed = 230, time = ourTime + timer, offset = math.random()*360 } )

if (GetGlobal("justTaunted") == true) then
	--This only happens on the "harder" version of this wave.
	table.insert(flow, { icon = "rec", start = 1.25, mult = 1.25, dir = 1, rate = 0.2, length = 10.65, blink = 2 })
	table.insert(flow, { icon = "rew", start = 1.25, mult = -0.75, dir = -1, rate = -1.75, length = 20, blink = 0.5 })
	
end

--Default variables for circles
for i = #circles,1,-1 do
	circles[i].radius = circles[i].startR
	if (circles[i].endR == nil) then circles[i].endR = circles[i].startR end
	if (circles[i].shrinkSpeed == nil) then circles[i].shrinkSpeed = 0 end
	if (circles[i].offset == nil) then circles[i].offset = 0 end
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
	
	
	--Circles
	--local boxr = (36 * ourWaveTimeDiff) + circles[2].offset
	--circles[1].originX = 320 + (circles[2].radius * math.cos(math.rad(boxr)))
	--circles[1].originY = 160 + (circles[2].radius * math.sin(math.rad(boxr)))
	
	--circles[1].radius = math.max(-200, 200 - (ourWaveTimeDiff*2)^2)
	--Other objects will read the circle's radius in their update functions
	for i = #circles,1,-1 do
		local timeDiff = ourTime - circles[i].time
		if (timeDiff > 0) then
			local rmult = 1
			if (circles[i].startR > circles[i].endR) then rmult = -1 end
			circles[i].radius = circles[i].startR + math.min(circles[i].shrinkSpeed * timeDiff,math.abs(circles[i].endR - circles[i].startR)) * rmult
		else
			circles[i].radius = circles[i].startR
		end
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
	if (GetGlobal("justTaunted") == true) then
		for i=#hearts,1,-1 do
			--Since we'll be rewinding, we can't delete the hearts. Oh well, not a huge performance hit
			if (ourTime > hearts[i].time) then hearts[i].Update()
			else
				hearts[i].bullet.MoveToAbs(-500,-500)
				hearts[i].hitbox.MoveToAbs(-500,-500)
			end
		end
	else
		for i=#hearts,1,-1 do
			if (ourTime > hearts[i].time) then hearts[i].Update() end
			if (hearts[i].dead) then
				hearts[i].bullet.Remove()
				hearts[i].hitbox.Remove()
				table.remove(hearts,i)
			end
		end
	end
	
	--Parasol Mettatons
	for i=#pmetts,1,-1 do
		if (ourTime > pmetts[i].time) then pmetts[i].Update() end
		if (pmetts[i].dead) then
			pmetts[i].bullet.Remove()
			table.remove(pmetts,i)
			--Decrease the delay for all surviving metts
			for j=#pmetts,1,-1 do
				pmetts[j].firstShot = pmetts[j].firstShot - 0.4
				pmetts[j].delay = pmetts[j].delay - 0.3
			end
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
	if (GetGlobal("justTaunted") == true) then
		for i=#bolts,1,-1 do
			if (ourTime > bolts[i].time and circles[bolts[i].circleID].radius > 0) then bolts[i].Update() end
			if (bolts[i].dead) then
				bolts[i].bullet.Remove()
				table.remove(bolts,i)
			end
		end
	else
		for i=#bolts,1,-1 do
			if (ourTime > bolts[i].time) then bolts[i].Update() end
			if (bolts[i].dead) then
				bolts[i].bullet.Remove()
				table.remove(bolts,i)
			end
			--Special line to easily delete Asgore circles.
			if (circles[bolts[i].circleID].radius <= 0) then
				bolts[i].bullet.Remove()
				table.remove(bolts,i)
			end
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
	
	if (pianoBullet ~= nil) then pianoBullet.SendToBottom() end
	
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
