bullets = {}

--Arena.Resize(200, 180)
--Arena.Resize(640, 180)
time = 0
starttime = Time.time
currenttime = Time.time - starttime

bulletspawn = 0.12
bulletspawner = 0
currentwave = 1

bulletspeed = 4

bulletwavex = 0
bulletwaves = 150
bulletcount = 20

bulletwavex1 = 640

Encounter.SetVar("wavetimer", 39)

darkness = CreateProjectileAbs("bgblack", 320, 240)
darkness.sprite.alpha = 0.25

Player.sprite.SendToTop()
aeiou = 0
function Update()
time = time + 1
	currenttime = Time.time - starttime
                     if time >= 60 and time < 100 then
                         bulletwavex = bulletwavex + 0.5
	    bulletwavex1 = bulletwavex1 - 0.5
                         bulletwaves = 0
                     elseif time >= 100 and time < 700 then
                         bulletspawn = 0.25 bulletwaves = 1000
                         bulletwavex = bulletwavex + 1 bulletwavex1 = bulletwavex1 - 1
                     elseif time >= 800 and time < 1200 then
	    bulletwavex = bulletwavex - 1.5 bulletwavex1 = bulletwavex1 + 1.5
                         bulletspawn = 0.3
                     elseif time >= 1200 and time < 1250 then
	    bulletwavex = bulletwavex + 1.5 bulletwavex1 = bulletwavex1 - 1.5    
                     elseif time > 1250 then
                         bulletspawn = 0.44 bulletcount = 15
                         bulletwavex = math.random(0,640) bulletwavex1 = math.random(0,640)
                     end
                     if aeiou == 1 then
                         --what the fuck is the purpose of this little bit of code?!?
                         aeiou = 0
                     end
	if (currenttime > bulletspawner and currentwave <= bulletwaves) then
                                          Audio.PlaySound("ATTACK3")
		bulletspawner = bulletspawner + bulletspawn
		for i=1,bulletcount+1 do
			SpawnBulletAbs(Time.time, bulletwavex, 480, (((2*math.pi)/bulletcount) * i - time))
			SpawnBulletAbs(Time.time, bulletwavex1, 480, (((2*math.pi)/bulletcount) * i + time))
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
end

function SpawnBulletAbs(key, x, y, ang)
	local bullet = CreateProjectileAbs("bullet/big_fire_collision", x, y)
	bullet.sprite.set("bigfirebullet0")
	bullet.SetVar("velx", bulletspeed * math.cos(ang))
	bullet.SetVar("vely", bulletspeed * math.sin(ang))
	table.insert(bullets, bullet)
	return bullet
end

function OnHit(bullet)
	if (bullet == darkness) then return end
		Player.Hurt(GetGlobal("atk"),0.1)
end