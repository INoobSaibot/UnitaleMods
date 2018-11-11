bullets = {}
Encounter.SetVar("wavetimer", 10)
starttime = Time.time
currenttime = Time.time - starttime

bulletspawn = 0.6
bulletspawner = 0.3
bulletspawner2 = 0.4
bulletspawner3 = 0.5

bulletsway = 26
bulletswayspeed = 3.2

bulletspawnportion = 6


function Update()
	currenttime = Time.time - starttime
	if currenttime > bulletspawner then
		bulletspawner = bulletspawner + bulletspawn
		SpawnBullet(Time.time)
	end
	if currenttime > bulletspawner2 then
		bulletspawner2 = bulletspawner2 + bulletspawn
		SpawnBullet(Time.time)
	end
	if currenttime > bulletspawner3 then
		bulletspawner3 = bulletspawner3 + bulletspawn
		SpawnBullet(Time.time)
	end
	
	for i = 1, #bullets do
		local bullet = bullets[i]
		if bullet.isactive then
			bullet.MoveTo(bullet.GetVar("startingx")+(math.sin((Time.time-bullet.GetVar("spawntime"))*bulletswayspeed)*bulletsway),bullet.y+(bullet.GetVar("vely")*Time.mult))
			if bullet.absy < -5 then
				bullet.Remove()
			end
		end
	end
end

function SpawnBullet(key)
	local bullet = CreateProjectile("firebullet0", math.sin(Time.time)*Arena.width/bulletspawnportion, Arena.height*1.6)
	bullet.SetVar("startingx", bullet.x)
	bullet.SetVar("vely", -3)
	bullet.SetVar("spawntime", key)
	table.insert(bullets, bullet)
end

function OnHit(bullet)
		Player.Hurt(GetGlobal("atk"),0.1)
end