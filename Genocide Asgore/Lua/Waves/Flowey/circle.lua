timer = 0
circle = {}
pelletShots = {}
startRadius = 303
radiusSpeed = 0.9


frames_alive = 0
function Update()
    frames_alive = frames_alive + 1
    timer = timer + 1
    if timer == 1 then
        SetGlobal("pelletstop", false)
        CreateCircle()
    end
    Movepellets()
    if timer == 350 then
       SetGlobal("pelletstop", true)
    end
	for i=1,#pelletShots do
		local pellet = pellets[i]
		local frames_alive = pellet.GetVar('frames_alive')
		frames_alive = frames_alive + 1
		if frames_alive % 8 == 0 then
			pellet.sprite.Set('pellet')
		elseif frames_alive %8 == 4 then
			pellet.sprite.Set('pellet2')
		end
		pellet.SetVar('frames_alive', frames_alive)
                      end
end

function CreateCircle()
    circle['radius'] = startRadius
    local speed = 2 * math.pi / 60 / 4
    circle['speed'] = speed
    circle['grow'] = -radiusSpeed
    local pellets = {}
    for i = 1, 6 do
        local angle = 2 * math.pi / 6 * i
        local x = startRadius * math.cos(angle)
        local y = startRadius * math.sin(angle)
        local pellet = CreateProjectile('pellet2', x, y)
        pellet.SetVar('angle', angle)
        pellet.SetVar('frames_alive', 0)
            --pellet.sprite.SetAnimation({'pellet', 'pellet2'}, 1 / 12)


        if Encounter.GetVar('playerInvert') then
            pellet.sprite.color = {64/255, 252/255, 64/255}
        end
        table.insert(pellets, pellet)
    end
    circle['pellets'] = pellets
end

function CreatepelletShot(x, y, xSpeed, ySpeed)
    local pellet = CreateProjectile('pellet', x, y)
    pellet.SetVar('xSpeed', xSpeed)
    pellet.SetVar('ySpeed', ySpeed)
    pellet.sprite.SetAnimation({'pellet', 'pellet2'}, 1 / 12)
    if Encounter.GetVar('playerInvert') then
        pellet.sprite.color = {64/255, 252/255, 64/255}
    end
    table.insert(pelletShots, pellet)
end

function Movepellets()
    local radius = circle['radius']
    local grow = circle['grow']
    radius = radius + grow
    if radius <= 0 then
        circle['grow'] = radiusSpeed
    elseif radius >= 120 then
        circle['grow'] = -radiusSpeed
    end
    circle['radius'] = radius
    local speed = circle['speed']
    local pellets = circle['pellets']
    for j = 1, #pellets do
        local pellet = pellets[j]
        if pellet.isactive then
            local angle = pellet.GetVar('angle')
            angle = angle + speed
            pellet.SetVar('angle', angle)
            local x = radius * math.cos(angle)
            local y = radius * math.sin(angle)
            pellet.MoveTo(x, y)
        end
    end
    for j = 1, #pelletShots do
        local pellet = pelletShots[j]
        if pellet.isactive then
            local xSpeed = pellet.GetVar('xSpeed')
            local ySpeed = pellet.GetVar('ySpeed')
            pellet.Move(xSpeed, ySpeed)
            xSpeed = xSpeed * 1.02
            ySpeed = ySpeed * 1.02
            pellet.SetVar('xSpeed', xSpeed)
            pellet.SetVar('ySpeed', ySpeed)
        end
    end
end

function OnHit(pellet)
    Player.Hurt(5, 1)
end
