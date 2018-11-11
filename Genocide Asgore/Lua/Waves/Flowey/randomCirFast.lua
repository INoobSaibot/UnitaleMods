init = false
escape = true
timer = 0
pellets = {}
whichFirst = 5 * math.random(2) - 5
--Too hard
function Update()
    if not init then
        init = true
    end
    timer = timer + 1
        if timer <= 60 then
            CreateTrap()
        elseif timer >= 100 then
            Movepellets()
        end

	for i=1,#pellets do
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

function CreateTrap()
    if timer == 1 then
        --Audio.PlaySound("snd_floweylaugh")
    end
    local angle = 2 * math.pi * (timer / 60)
    local x = 100 * math.cos(angle)
    local y = 100 * math.sin(angle)
    local pellet = CreateProjectile('pellet', x, y)
    pellet.SetVar('speedX', -x / 10)
    pellet.SetVar('speedY', -y / 10)
    --pellet.sprite.SetAnimation({'pellet', 'pellet2'}, 1 / 12)

    table.insert(pellets, pellet)
    if timer % 2 == 0 then
        Audio.PlaySound("pellet")
    end
        pellet.SetVar('frames_alive', 0)
        pellet_type = math.random(1,3)
        if pellet_type == 1 then
               pellet.SetVar('type', 1)
               pellet.sprite.color = {252/255, 166/255, 0/255}
        elseif pellet_type == 2 then
               pellet.SetVar('type', 2)
               pellet.sprite.color = {66/255, 252/255, 255/255}
        elseif pellet_type == 3 then
               pellet.SetVar('type', 3)
               pellet.sprite.color = {93/255, 93/255, 93/255}
        end
end

function Movepellets()
    for i = 1, #pellets do
        local pellet = pellets[i]
        local speedX = pellet.GetVar('speedX') * 1.03
        local speedY = pellet.GetVar('speedY') * 1.03
            pellet.SetVar('speedX', speedX)
            pellet.SetVar('speedY', speedY)
            pellet.Move(speedX, speedY)
    end
end

function Deletepellets()
    for i = 1, #pellets do
        local pellet = pellets[i]
        pellet.Remove()
    end
    pellets = {}
end

function OnHit(pellet)
    if pellet.GetVar('type') == 1 then
           if not Player.isMoving then
                   Player.Hurt(5, 1)
           end
    end
    if pellet.GetVar('type') == 2 then
           if Player.isMoving then
                   Player.Hurt(5, 1)
           end
    end
    if pellet.GetVar('type') == 3 then
    end
end

function ResetAnimation(file)
    Encounter.GetVar("enemies")[1].Call("ResetAnimation", file)
end

function SetAnimation(sprites, length)
    local enemy = Encounter.GetVar("enemies")[1]
    enemy.Call("ResetAnimation", sprites[1])
    for i = 2, #sprites do
        enemy.Call("AddAnimation", sprites[i])
    end
    enemy.Call("SetFrameLength", length)
end
