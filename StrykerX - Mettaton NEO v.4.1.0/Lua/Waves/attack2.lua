--This attack was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--[[

Normal Mode changes:
None, actually. I quite like this attack.

]]

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
Arena.Resize(245,180)
Player.MoveTo(0,0+25,true)
--Length: 8, Arena size: 245, 180
--Thin gaster blasters are 42 pixels long
--Three along the top, then three along the left, two along the bottom, two along the right
table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = 510, endX = 420, endY = 340, time = ourTime+0.2, rotation = 0, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = 510, endX = 320, endY = 340, time = ourTime+0.2, rotation = 0, size = THIN, laserDelay = 0.77, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = 510, endX = 220, endY = 340, time = ourTime+0.2, rotation = 0, size = NORMAL, laserDelay = 0.79, laserLength = 0.55, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 130, endY = 280, time = ourTime+0.7, rotation = 270, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 130, endY = 182, time = ourTime+0.7, rotation = 270, size = THIN, laserDelay = 0.77, laserLength = 0.55, s1 = true, s2 = true }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 130, endY = 85, time = ourTime+0.7, rotation = 270, size = NORMAL, laserDelay = 0.79, laserLength = 0.55, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = -30, endX = 245, endY = 30, time = ourTime+1.5, rotation = 180, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = -30, endX = 395, endY = 30, time = ourTime+1.5, rotation = 180, size = NORMAL, laserDelay = 0.77, laserLength = 0.55, s1 = true, s2 = true }))

table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = -30, endX = 510, endY = 128, time = ourTime+2.0, rotation = 90, size = NORMAL, laserDelay = 0.75, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = -30, endX = 510, endY = 240, time = ourTime+2.0, rotation = 90, size = NORMAL, laserDelay = 0.77, laserLength = 0.55, s1 = true, s2 = true }))

--Blue lasers here, as well as -42 gaster blasters
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 700, startY = 300,  time = ourTime+2.8, xspeed = -200, rotation = 0, color = BLUE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = -50, startY = 70,  time = ourTime+3.6, xspeed = 200, rotation = 180, color = BLUE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 480, startY = 600,  time = ourTime+4.4, yspeed = -200, rotation = 90, color = BLUE }))
table.insert(bots, oblib.LaserBot.new( { simple = true, startX = 160, startY = -100,  time = ourTime+5.2, yspeed = 200, rotation = 270, color = BLUE }))

table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = 510, endX = PX, endY = 340, time = ourTime+3.6, rotation = 0, size = THIN, laserDelay = 0.8, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = 510, endX = 130, endY = PY, time = ourTime+4.4, rotation = 270, size = THIN, laserDelay = 0.8, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = -30, startY = -30, endX = PX, endY = 30, time = ourTime+5.2, rotation = 180, size = THIN, laserDelay = 0.8, laserLength = 0.55, s1 = false, s2 = false }))
table.insert(gbs, oblib.GasterBlaster.new({ startX = 670, startY = -30, endX = 510, endY = PY, time = ourTime+6, rotation = 90, size = THIN, laserDelay = 0.8, laserLength = 0.55, s1 = false, s2 = false }))

function Update()
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
		if (ourTime > bots[i].time) then bots[i].Update() end
		if (bots[i].dead) then
			bots[i].bullet.Remove()
			if (bots[i].laser ~= nil) then
				bots[i].laser.Remove()
			end
			table.remove(bots,i)
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