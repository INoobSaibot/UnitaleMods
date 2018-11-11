-- The bouncing bullets attack from the documentation example.
spawntimer = 0
bullets = {}
Arena.Resize(200, 200)
Encounter.SetVar("wavetimer", 10)

-- Yes this is the bullettest_bouncy attack.

function Update()
    spawntimer = spawntimer + 1
    if spawntimer%7 == 0 then
        local posx = math.random(-90,90)
        local posy = Arena.height/2 - 5
        local bullet = CreateProjectile('firebullet0', posx, posy)
        if math.random(2) == 1 then
             bullet.SetVar('velx', -0.1)
        else
             bullet.SetVar('velx', 0.1)
        end
        bullet.SetVar('vely', -0.5)
        table.insert(bullets, bullet)
    end
    
    for i=1,#bullets do
        local bullet = bullets[i]
        local velx = bullet.GetVar('velx')
        local vely = bullet.GetVar('vely')
        local newposx = bullet.x + velx
        local newposy = bullet.y + vely

        vely = vely - 0.05
        bullet.MoveTo(newposx, newposy)
        bullet.SetVar('vely', vely)
                     if bullet.x <= -Arena.width/2 or bullet.x >= Arena.width/2 or bullet.y <= -Arena.height/2 or bullet.y >= Arena.height/2 then
	       bullet.sprite.alpha = bullet.sprite.alpha - 0.50*Time.mult
                     end

         if math.random(2) == 1 then
                 velx = velx - 0.03
         else
                 velx = velx + 0.03
         end

         if (math.floor(bullet.y / 15)) % 2 == 0 then
                       bullet.sprite.set("firebullet0")
         else
	  bullet.sprite.set("firebullet1")
         end
    end
end