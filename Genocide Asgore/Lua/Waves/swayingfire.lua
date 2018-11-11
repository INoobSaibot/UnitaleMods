bullets = {}
Encounter.SetVar("wavetimer", 10)
starttime = Time.time
currenttime = Time.time - starttime

bulletspawn = 0.2
bulletspawner = 0.2

bulletsway = 22
bulletswayspeed = 3.2

bulletspawnportion = 2

bulletcount = 9

function Update()
	currenttime = Time.time - starttime
	if currenttime > bulletspawner then
		bulletspawner = bulletspawner + bulletspawn
		for i = 1, bulletcount do
			if (-340 + ((680/bulletcount)*i)) <= Arena.width/2 and (-340 + ((680/bulletcount)*i)) >= -Arena.width/2 then
				local bullet = SpawnBullet(Time.time, -340 + ((680/bulletcount)*i), Arena.height*1.6, math.sin(Time.time)*bulletsway, bulletswayspeed)
				bullet.MoveToAbs(bullet.absx, GetGlobal("speary"))
			end
		end
	end
	
	for i = 1, #bullets do
		local bullet = bullets[i]
		if bullet.isactive then
			bullet.MoveTo(bullet.GetVar("startingx")+(math.sin((Time.time-bullet.GetVar("spawntime"))*bullet.GetVar("swayspeed"))*bullet.GetVar("sway")),bullet.y+(bullet.GetVar("vely")*Time.mult))
			if bullet.absy < -5 then
				bullet.Remove()
			end
		end
	end
end

function SpawnBullet(key, x, y, sway, swayspeed)
	local bullet = CreateProjectile("firebullet0", x, y)
	bullet.SetVar("startingx", bullet.x)
	bullet.SetVar("vely", -3)
	bullet.SetVar("spawntime", key)
	bullet.SetVar("sway", sway)
	bullet.SetVar("swayspeed", swayspeed)
	table.insert(bullets, bullet)
	return bullet
end

function SpawnBulletAbs(key, x, y, sway, swayspeed)
	local bullet = CreateProjectileAbs("firebullet0", x, y)
	bullet.SetVar("startingx", bullet.x)
	bullet.SetVar("vely", -3)
	bullet.SetVar("spawntime", key)
	bullet.SetVar("sway", sway)
	bullet.SetVar("swayspeed", swayspeed)
	table.insert(bullets, bullet)
	return bullet
end

function OnHit(bullet)
		Player.Hurt(GetGlobal("atk"),0.1)
end