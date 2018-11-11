bullets = {}

--Arena.Resize(200, 180)

starttime = Time.time
currenttime = Time.time - starttime

bulletspawn = 0.4
bulletspawner = 0
currentwave = 1

bulletspeed = 3

bulletwavex = 0
bulletwaves = 20
bulletcount = 20

bulletwavex1 = 640

Encounter.SetVar("wavetimer", 7)

darkness = CreateProjectileAbs("bgblack", 320, 240)
darkness.sprite.alpha = 0.25

Player.sprite.SendToTop()

function Update()
	currenttime = Time.time - starttime
	if (currenttime > bulletspawner and currentwave <= bulletwaves) then
		bulletspawner = bulletspawner + bulletspawn
		for i=1,bulletcount do
			SpawnBulletAbs(Time.time, bulletwavex, 480, (360/bulletcount) * i)
			SpawnBulletAbs(Time.time, bulletwavex1, 480, (360/bulletcount) * i)
		end
		currentwave = currentwave + 1
	end
	for i = 1, #bullets do
		local bullet = bullets[i]
		if bullet.isactive then
			bullet.MoveTo(bullet.x + bullet.GetVar("velx"), bullet.y + bullet.GetVar("vely"))
			if bullet.absy < -5 or bullet.absx < -5 or bullet.absy > 500 or bullet.absx > 700 then
				bullet.Remove()
			end
			if (math.floor(bullet.y / 15)) % 2 == 0 then
			    bullet.sprite.set("bigfirebullet0")
			else
			    bullet.sprite.set("bigfirebullet1")
			end
		end
	end
	bulletwavex = bulletwavex + 2
	bulletwavex1 = bulletwavex1 - 2
end

function SpawnBulletAbs(key, x, y, ang)
	local bullet = CreateProjectileAbs("bullet/big_fire_collision", x, y)
	bullet.sprite.set("bigfirebullet0")
	bullet.SetVar("velx", bulletspeed * math.cos(math.rad(ang)))
	bullet.SetVar("vely", bulletspeed * math.sin(math.rad(ang)))
	table.insert(bullets, bullet)
	return bullet
end

function OnHit(bullet)
	if (bullet == darkness) then return end
		Player.Hurt(GetGlobal("atk"),0.1)
end