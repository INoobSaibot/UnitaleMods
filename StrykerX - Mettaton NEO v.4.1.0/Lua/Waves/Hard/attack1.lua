--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

oblib = require "objectdefs"

--This bullet is for having the player heart blink properly
playerbullet = CreateProjectile("rh0", Player.x, Player.y)
playerbullet.SetVar('tile', 1)

waveStartTime = Time.time
ourTime = Time.time
timeMult = 1

NORMAL = 0
THIN = 1
LARGE = 2

ORANGE = 0
BLUE = 1

--When a Gaster Blaster's endX or endY equals -42, it'll instead change itself to be at the player's X or Y, once it's ready to appear.
--Easier than making it a new variable!
PX = -42
PY = -42

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

Encounter.SetVar("wavetimer", 8.0)
Arena.Resize(155,130)

--Square pattern
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = -30, startY = 510, endX = 180, endY = 220, time = ourTime+0.2, rotation = 270, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = -30, startY = 510, endX = 260, endY = 290, time = ourTime+0.2, rotation = 0, size = NORMAL, laserDelay = 0.76, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = 670, startY = -30, endX = 460, endY = 100, time = ourTime+0.2, rotation = 90, size = NORMAL, laserDelay = 0.77, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = 670, startY = -30, endX = 380, endY = 30, time = ourTime+0.2, rotation = 180, size = NORMAL, laserDelay = 0.78, laserLength = 0.55, s1 = true, s2 = true }))

--Plus pattern
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = 670, startY = 510, endX = 320, endY = 290, time = ourTime+1.5, rotation = 0, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = 670, startY = 510, endX = 460, endY = 160, time = ourTime+1.5, rotation = 90, size = NORMAL, laserDelay = 0.76, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = -30, startY = -30, endX = 320, endY = 30, time = ourTime+1.5, rotation = 180, size = NORMAL, laserDelay = 0.77, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = -30, startY = -30, endX = 180, endY = 160, time = ourTime+1.5, rotation = 270, size = NORMAL, laserDelay = 0.78, laserLength = 0.55, s1 = true, s2 = true }))

--Square pattern
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = -30, startY = 510, endX = 180, endY = 220, time = ourTime+2.8, rotation = 270, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = -30, startY = 510, endX = 260, endY = 290, time = ourTime+2.8, rotation = 0, size = NORMAL, laserDelay = 0.76, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = 670, startY = -30, endX = 460, endY = 100, time = ourTime+2.8, rotation = 90, size = NORMAL, laserDelay = 0.77, laserLength = 0.55, s1 = true, s2 = true }))
ctrlCandctrlVareTheOnlyCodeIKnow = true
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = 670, startY = -30, endX = 380, endY = 30, time = ourTime+2.8, rotation = 180, size = NORMAL, laserDelay = 0.78, laserLength = 0.55, s1 = true, s2 = true }))

--Big blaster on top of screen. Laserbots
table.insert(gbs, oblib.GasterBlaster.new({ startX = -90, startY = 240, endX = 90, endY = 240, time = ourTime+4.1, rotation = 270, size = LARGE, laserDelay = 0.8, laserLength = 0.9, s1 = false, s2 = false }))

table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 700, startY = 400,  time = ourTime+3.4, xspeed = -350, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 850, startY = 400,  time = ourTime+3.4, xspeed = -350, rotation = 0, color = math.random(0,1) }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 1000, startY = 400, time = ourTime+3.4, xspeed = -350, rotation = 0, color = math.random(0,1) }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 1150, startY = 400, time = ourTime+3.4, xspeed = -350, rotation = 0, color = BLUE }))
--Big blaster on bottom of screen. Laserbots
table.insert(gbs, oblib.GasterBlaster.new({ startX = 730, startY = 240, endX = 550, endY = 80, time = ourTime+5.4, rotation = 90, size = LARGE, laserDelay = 0.8, laserLength = 0.9, s1 = false, s2 = false }))

table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 700, startY = 400,  time = ourTime+5.6, xspeed = -450, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 825, startY = 400,  time = ourTime+5.6, xspeed = -450, rotation = 0, color = math.random(0,1) }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 950, startY = 400,  time = ourTime+5.6, xspeed = -450, rotation = 0, color = math.random(0,1) }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 1075, startY = 400, time = ourTime+5.6, xspeed = -450, rotation = 0, color = math.random(0,1) }))

if (GetGlobal("attackNum") > 10) then
	--This only happens on the "harder" version of this wave.
	Encounter.SetVar("wavetimer", 8.5)
	table.insert(flow, { icon = "ff", start = 1.25, mult = 1.25, dir = 1, rate = 0.2, length = 12, blink = 2 })
	for i = 0,1.6,0.2 do
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = -30, startY = 510, endX = 190+(i*100), endY = 290, time = ourTime+6.2+(i*0.8), rotation = 0, size = THIN, laserDelay =0.75, laserLength = 0.55, s1 = false, s2 = false }))
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = -30, startY = -30, endX = 180, endY = 50+(i*80), time = ourTime+6.2+(i*0.8), rotation = 270, size = THIN, laserDelay = 0.75, laserLength = 0.55, s1 = true, s2 = true }))
	end
	
	for i = 0,1.6,0.2 do
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = 670, startY = 510, endX = 450-(i*100), endY = 30, time = ourTime+7.9+(i*0.8), rotation = 180, size = THIN, laserDelay =0.75, laserLength = 0.55, s1 = false, s2 = false }))
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 3, startX = 670, startY = -30, endX = 460, endY = 270-(i*80), time = ourTime+7.9+(i*0.8), rotation = 90, size = THIN, laserDelay = 0.75, laserLength = 0.55, s1 = true, s2 = true }))
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

	--Blink the heart at 15 fps if hurting
	local heartframe = 0
	if (Player.isHurting) then heartframe = math.floor((Time.time / (1/15)) % 2) end
	playerbullet.sprite.Set("rh" .. heartframe)
	playerbullet.MoveTo(Player.x,Player.y)
	playerbullet.SendToTop()
	--playerbullet.Remove()
	--playerbullet = CreateProjectile("rh" .. heartframe, Player.x, Player.y)
	--playerbullet.SetVar('tile', 1)
	
	
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
	
end

function OnHit(bullet)
	--"Tile" bullets shouldn't collide with the player. Board tiles, fading lasers, whatever else
	if(bullet.GetVar('tile') ~= 1) then
		if (bullet.GetVar('color') == BLUE) then
			if (Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage'))
				SetGlobal("hit1",true)
			end
		elseif (bullet.GetVar('color') == ORANGE) then
			if (not Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage'))
				SetGlobal("hit1",true)
			end
		else
			Player.Hurt(bullet.GetVar('damage'))
			SetGlobal("hit1",true)
		end
	end
end