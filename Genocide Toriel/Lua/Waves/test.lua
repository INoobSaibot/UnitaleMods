Arena.Resize(125, 200) spawntimer = 0
bullets = {}

Encounter.SetVar("wavetimer", 8.0)

function Update()
    spawntimer = spawntimer + 1
    if spawntimer%22 == 0 then
    	local posx = 10 * math.sin(Time.time)

    	if math.random() > 0.5 then
        	        local posy = Arena.height/2
        	        local bullet = CreateProjectile("firebullet0", posx, posy)
        	        --bullet.sprite.SetAnimation({"firebullet0","firebullet1"},1/12.5)
        	        bullet.SetVar("dir", 0)
        	        table.insert(bullets, bullet)
                     else
        	        local posy = Arena.height/2
        	        local bullet = CreateProjectile("firebullet1", posx, posy)
        	        --bullet.sprite.SetAnimation({"firebullet1","firebullet0"},1/12.5)
        	        bullet.SetVar("dir", 1)
        	        table.insert(bullets, bullet)
                     end
    end

    for i=1,#bullets do
           local bullet = bullets[i]
           local frames = bullet.GetVar("frames")
           if frames == nil then
                frames = 0
           end
           local newposy = bullet.y - 1
           if bullet.GetVar("dir") == 1 then
                  newposy = bullet.y - 1
           end
           local newposx = lerp(20, Arena.width/2 - 5, clamp(frames, 0, 120) / 120) * math.sin(Time.time * 3 + i)
           if newposy < -Arena.height/2 + 8 then
                 newposy = -Arena.height/2 + 8
           elseif newposy > Arena.height/2 - 8 then
                 newposy = Arena.height/2 - 8
           end
           frames = frames + 1
           bullet.MoveTo(newposx, newposy)
           bullet.SetVar("frames", frames)
         if (math.floor(bullet.y / 15)) % 2 == 0 then
                       bullet.sprite.set("firebullet0")
         else
	  bullet.sprite.set("firebullet1")
         end
    end
end


function OnHit(bullet)
           Player.Hurt(3)
end

function lerp(a, b, x)
          local nx = 1 - x
          return (a * nx) + (b * x)
end

function clamp(x, a, b)
          if x < a then
                   return a
          elseif x > b then
                   return b
          else return x
          end
end