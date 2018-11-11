bullets = {}
num_bullets = 0

current_turn = GetGlobal('current_turn')
difficulty = 3

init_time = Time.time
time = 0
--if current_turn < 7 then
--	difficulty = 1
--elseif current_turn < 12 then
  --  difficulty = 2
--else
--    difficulty = 3
--end

Arena.Resize(225, 190)

--circle properties
fireballs_per_circle = 66
opening_degrees = (4 / 10) * math.pi --40 degrees
closed_degrees = math.pi * 2 - opening_degrees
spin_min_speed = 0
spin_max_speed = 0
radius_shrink_rate = 140 -- radius loses 140 pixels per second
radius_interval = 132 -- distance between two circles as far as radius goes.
initial_radius = 350
radius_threshold = 4 -- distance at which we just reset the circle
time_to_end = init_time + 10 -- end the wave after 6 seconds

--DEBUG
difficulty = 3

if difficulty == 2 then
	spin_min_speed = math.pi / 240
	spin_max_speed = math.pi / 240
	radius_interval = 160
elseif difficulty == 3 then
	spin_min_speed = math.pi / math.random(90, 180)
	spin_max_speed = math.pi / math.random(90, 180)
	radius_shrink_rate = 200
	radius_interval = 132
end


--There are three circles out at any given time... when one shrinks below the threshold, we realign them and move them outwards.
circles = {}

function circle_set_randoms(circle)
	local spin = math.random() * (spin_max_speed - spin_min_speed) + spin_min_speed
	if math.random(0, 1) == 0 then
		circle.spin = spin
	else
		circle.spin = -spin
	end
	circle.opening = math.random() * math.pi * 2
end

function create_bullets(circle)
	circle.bullets = {}
	for i = 1,36 do
		local bullet = CreateProjectile('firebullet0', -600, 0) -- out of sight
		table.insert(circle.bullets, bullet)
	end
end

for i=0,2 do
	local new_circle = {}
	circle_set_randoms(new_circle)
	new_circle.radius = initial_radius + i * radius_interval
	
	create_bullets(new_circle, true)
	previous_update = Time.time
	
    table.insert(circles, new_circle)
end

function update_bullets(circle)
	for i = 1, 36 do
		local bullet = circle.bullets[i]
		local spin = circle.opening + i * closed_degrees / 36.0
		bullet.MoveTo(circle.radius * math.cos(spin), circle.radius * math.sin(spin))
		if circle.radius < 500 then
			bullet.sprite.alpha = 1
		else
			bullet.sprite.alpha = 0
		end
	end
	
	
end

function update_circles()
	delta = Time.time - previous_update
	previous_update = Time.time
	for i = 1,#circles do
		local circle = circles[i]
		circle.radius = circle.radius - delta * radius_shrink_rate
		circle.opening = circle.opening + circle.spin
		update_bullets(circle)
		if circle.radius < radius_threshold then
			local outer_circle = circles[((i + 1) % 3) + 1]
			circle_set_randoms(circle)
			circle.radius = outer_circle.radius + radius_interval
                                           local cirbullets = 8
                                           for i=1,cirbullets do
                                                  local bullet = CreateProjectile("firebullet0", 0, 0)
                                                  local speed = 5
                                                  --local ang = theAngle
                                                  local ang = 360/cirbullets * i
                                                  bullet.SetVar('velx', speed * math.cos(math.rad(ang)))
                                                  bullet.SetVar('vely', speed * math.sin(math.rad(ang)))
                                                  table.insert(bullets, bullet)
		end
                                           end
	end
end

function Update()
time = time + 1
	update_circles()
                      for i=1, #bullets do
                      local bullet = bullets[i]
                           local velx = bullet.GetVar('velx')
      
                           local vely = bullet.GetVar('vely')
  
                           local newposx = bullet.x + velx
         
                           local newposy = bullet.y + vely
	      bullet.MoveTo(newposx, newposy)
                      end
	if Time.time > time_to_end then
		EndWave()
	end
end

function OnHit(bullet)
		Player.Hurt(GetGlobal("atk"),0.1)
end