--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--[[

Normal Mode changes:
Removed orange lasers in the left/right areas outside of taunt version
Increased gaster delays slightly to my new standard of 0.9
Added orange lasers to the middle area (which you shouldn't be needing to stand still in anyway!) to make up for it
Some other tweaks to make up for it (I do want this to be a hard attack, it's the last non-repeat! Just not hard because keyboard players suck at moving in circles)

]]

oblib = require "objectdefs"

--Just blasters and bots in this
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

Encounter.SetVar("wavetimer", 12.0)
Arena.Resize(350,130)


--Patrol bots
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 245, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 230, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 260, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 215, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 275, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))


table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 395, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 380, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 410, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 365, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 425, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))


--These bots will turn on later to block you into the left/right side of screen
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 200, startY = 320, time = ourTime+8.5, rotation = 0, color = BLUE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 440, startY = 320, time = ourTime+8.5, rotation = 0, color = BLUE }))
--Laser firing in the middle, then going out to the sides (all symmetrical)
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 510, endX = 320, endY = 290, time = ourTime+0.2, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 2.1, s1 = false, s2 = false }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = -30, endX = 280, endY = 30, time = ourTime+0.82, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 1.5, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = -30, endX = 360, endY = 30, time = ourTime+0.82, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 1.5, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 510, endX = 240, endY = 290, time = ourTime+1.4, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.9, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 510, endX = 400, endY = 290, time = ourTime+1.4, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.9, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = -30, endX = 240, endY = 30, time = ourTime+2, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 1.2, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = -30, endX = 400, endY = 30, time = ourTime+2, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 1.2, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 510, endX = 90, endY = 290, time = ourTime+2, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 1.2, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 510, endX = 550, endY = 290, time = ourTime+2, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 1.2, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 510, endX = 160, endY = 290, time = ourTime+4, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 1.9, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 510, endX = 480, endY = 290, time = ourTime+4, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 1.9, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = -30, endX = 200, endY = 30, time = ourTime+4.6, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 1.3, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = -30, endX = 440, endY = 30, time = ourTime+4.6, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 1.3, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 510, endX = 250, endY = 290, time = ourTime+5.2, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false }))
probablyBlindlyCopiedAllThisCode = true
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 510, endX = 390, endY = 290, time = ourTime+5.2, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 510, endX = 320, endY = 290, time = ourTime+6, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 2.1, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = -30, endX = 320, endY = 30, time = ourTime+6, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 2.1, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = -30, endX = 280, endY = 30, time = ourTime+6.6, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 1.5, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = -30, endX = 360, endY = 30, time = ourTime+6.6, rotation = 180, size = NORMAL, laserDelay = 0.9, laserLength = 1.5, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 510, endX = 240, endY = 290, time = ourTime+7.2, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.9, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 510, endX = 400, endY = 290, time = ourTime+7.2, rotation = 0, size = NORMAL, laserDelay = 0.9, laserLength = 0.9, s1 = true, s2 = true }))

--Horizontal lasers firing as you're trapped by the blue
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 240, endX = 90, endY = 160, time = ourTime+8.8, rotation = 270, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 240, endX = 550, endY = 160, time = ourTime+8.8, rotation = 90, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 240, endX = 90, endY = 100, time = ourTime+9.7, rotation = 270, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 240, endX = 550, endY = 100, time = ourTime+9.7, rotation = 90, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 240, endX = 90, endY = 220, time = ourTime+9.7, rotation = 270, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 240, endX = 550, endY = 220, time = ourTime+9.7, rotation = 90, size = NORMAL, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 240, endX = 90, endY = 160, time = ourTime+10.6, rotation = 270, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 240, endX = 550, endY = 160, time = ourTime+10.6, rotation = 90, size = THIN, laserDelay = 0.9, laserLength = 0.55, s1 = true, s2 = true }))
	
damageMult = 1
if (GetGlobal("justTaunted") == true) then
	damageMult = 4/3
	--This only happens on the "harder" version of this wave.
	table.insert(flow, { icon = "ff", start = 1.3, mult = 1.3, dir = 1, rate = 0.2, length = 20, blink = 2 })
	
	--Patrol bots, oblib.LaserBot.new( creating orange walls on left and right
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 170, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 160, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 180, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 150, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 190, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))

	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 470, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 460, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 480, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 450, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 490, startY = 270, time = ourTime, rotation = 0, color = ORANGE }))
	
	for i = 0,1.4,0.2 do
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = 510, endX = 90, endY = 270-(i*80), time = ourTime+11.2+i, rotation = 270, size = THIN, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = 510, endX = 550, endY = 270-(i*80), time = ourTime+11.2+i, rotation = 90, size = THIN, laserDelay = 0.75, laserLength = 0.55, s1 = true, s2 = true }))
	end
	
	for i = 0,1.4,0.2 do
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = -30, startY = -30, endX = 90, endY = 50+(i*80), time = ourTime+12.8+i, rotation = 270, size = THIN, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
		table.insert(gbs, oblib.GasterBlaster.new({ lifetime = 4, startX = 670, startY = -30, endX = 550, endY = 50+(i*80), time = ourTime+12.8+i, rotation = 90, size = THIN, laserDelay = 0.75, laserLength = 0.55, s1 = true, s2 = true }))
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
	
	for i=#bots,1,-1 do
		bots[i].Update()
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
				Player.Hurt(bullet.GetVar('damage') * damageMult)
				SetGlobal("hit1",true)
			end
		elseif (bullet.GetVar('color') == ORANGE) then
			if (not Player.isMoving) then
				Player.Hurt(bullet.GetVar('damage') * damageMult)
				SetGlobal("hit1",true)
			end
		else
			Player.Hurt(bullet.GetVar('damage') * damageMult)
			SetGlobal("hit1",true)
		end
	end
end