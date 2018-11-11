bullets = {}
num_bullets = 0

current_turn = GetGlobal('current_turn')
difficulty = 1
Encounter.SetVar("wavetimer", 8)
init_time = Time.time

Arena.Resize(215, 180)
--(4 / 10) * math.pi --40 degrees
--circle properties
fireballs_per_circle = 37
opening_degrees = (4 / 10) * math.pi --40 degrees
closed_degrees = math.pi * 2 - opening_degrees
spin_min_speed = 0
spin_max_speed = 0
radius_shrink_rate = 100 -- radius loses 140 pixels per second
radius_interval = 150 -- distance between two circles as far as radius goes.
initial_radius = 150
radius_threshold = 6 -- distance at which we just reset the circle
time_to_end = init_time + 6 -- end the wave after 6 seconds

--DEBUG
difficulty = 0

if difficulty == 2 then
	spin_min_speed = math.pi / 240
	spin_max_speed = math.pi / 240
	radius_interval = 160
elseif difficulty == 3 then
	spin_min_speed = math.pi / 240
	spin_max_speed = math.pi / 240
	radius_shrink_rate = 190
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
                                           if (math.floor(bullet.y / 15)) % 2 == 0 then
                                                      bullet.sprite.set("firebullet0")
                                          else
	                                 bullet.sprite.set("firebullet1")
                                          end
		if circle.radius < 300 then
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
		end
	end
end

function Update()
	update_circles()
	
	if Time.time > time_to_end then
		EndWave()
	end
end

function OnHit(bullet)
	if (Player.hp - GetGlobal("atk") < 1 and Player.hp <= GetGlobal("atk")) and Player.isHurting == false then
		Player.Hurt(3)
	else
		Player.Hurt(3)
	end
end