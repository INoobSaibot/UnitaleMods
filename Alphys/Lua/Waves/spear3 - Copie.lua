--[[ 

Undyne the Undying [Genocide Battle Recreation] made by u/Jetrocketboy
Original source/base lua made by u/Crystalwarrior and u/Moofins21
Animation made and provided by u/BOBtheman2000

Hope you enjoy the fight as much as I had fun making it.

]]--

Arena.resize(150, 150)
Player.sprite.color = {237/255, 0/255, 0/255}

bullets = {}
spawntimer = 0

collision = require "Libraries/rotational_collision"

speed = 1 --Initial speed
function Update()
	spawntimer = spawntimer + 0.5
	if(spawntimer % 20 == 0) then
		local bullet = CreateProjectile("spearright",math.random(Arena.width*0.7,Arena.width)*(2 * math.random(0,1)-1),math.random(Arena.height*0.7,Arena.height)*(2 * math.random(0,1)-1))
		bullet.SetVar('firing', 60)
		bullet.SetVar('fired', 0)
		local xdifference = Player.x - bullet.x
		local ydifference = Player.y - bullet.y
		bullet.sprite.rotation = 57.2958*math.atan2(ydifference,xdifference)
		bullet.SetVar("rtarget",bullet.sprite.rotation)
		local rotate = bullet.GetVar("rtarget")
		bullet.sprite.rotation = rotate + 180
		bullet.sprite.alpha = 0
		bullet.SetVar('xspeed', xdifference/math.sqrt(xdifference^2+ydifference^2)*4)
		bullet.SetVar('yspeed', ydifference/math.sqrt(xdifference^2+ydifference^2)*4)
		bullet.SetVar('velx', 1)
		bullet.SetVar('vely', 1)
		bullet.SetVar("ticker",0)
		table.insert(bullets,bullet)
		Audio.PlaySound('spawn')
	end

	for i=1, #bullets do
		local bullet = bullets[i]
		if bullet.isactive then
			local ticker = bullet.GetVar("ticker")
			local alpha = bullet.sprite.alpha
			local xspeed = bullet.GetVar('xspeed')
			local yspeed = bullet.GetVar('yspeed')
			local velx = bullet.GetVar('velx')
			local vely = bullet.GetVar('vely')
			local target = bullet.GetVar("rtarget")
			local rotate = bullet.sprite.rotation
			if bullet.sprite.rotation < target-3 or bullet.sprite.rotation > target+3 then
				bullet.sprite.rotation = rotate + (target-rotate)/10
			end
			if alpha >= 1 then
				bullet.SetVar('velx', velx+0.125)
				bullet.SetVar('vely', vely+0.125)
				bullet.Move(xspeed*velx/5, yspeed*vely/5)
			else
				bullet.sprite.alpha = alpha + 0.05
			end
			if ticker == 20 then
				Audio.PlaySound("toss")
			end
			bullet.SetVar("ticker",ticker+1)
			if bullet.y > 160 or bullet.x > 160 or bullet.y < -160 or bullet.x < -160 then
				bullet.sprite.alpha = bullet.sprite.alpha - 4/40*Time.mult
				bullet.Move(xspeed*velx/5, yspeed*vely/5)
				if bullet.sprite.alpha == 0 then
					bullet.Remove()
				end
			end

			if collision.CheckCollision(Player, bullets[i]) then
				Player.Hurt(3)
			end
		end
	end
end

function OnHit(bullet)
end