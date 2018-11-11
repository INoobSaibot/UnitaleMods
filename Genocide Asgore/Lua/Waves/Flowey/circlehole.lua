init = false
escape = true
timer = 0
pellets = {}
whichFirst = 5 * math.random(2) - 5

function Update()
    if not init then
        init = true
    end
    timer = timer + 1
        if timer <= 60 then
            CreateEscape()
        elseif timer >= 70 then

        end
        if timer >= 130 then
            MoveHalfpellets(true)
        end
        if timer >= 190 then
            MoveHalfpellets(false)
        end
        if timer >= 1000 then
            pellet.Remove()
            EndWave()
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

function CreateEscape()
    if timer % 5 == 0 then
        local angle = 2 * math.pi * ((timer - 240) / 60)
        local x = 100 * math.cos(angle)
        local y = 100 * math.sin(angle)
        local pellet = CreateProjectile('pellet', x, y)
        pellet.SetVar('speedX', -x / 100)
        pellet.SetVar('speedY', -y / 100)
        pellet.SetVar('first', timer % 10 == whichFirst)
        pellet.sprite.SetAnimation({'pellet', 'pellet2'}, 1 / 12)
        table.insert(pellets, pellet)
        Audio.PlaySound("pellet")
        pellet.SetVar('frames_alive', 0)
    end
end

function MoveHalfpellets(first)
    for i = 1, #pellets do
        local pellet = pellets[i]
        if pellet.GetVar('first') == first then
            local speedX = pellet.GetVar('speedX') * 1.03
            local speedY = pellet.GetVar('speedY') * 1.03
            pellet.SetVar('speedX', speedX)
            pellet.SetVar('speedY', speedY)
            pellet.Move(speedX, speedY)
            pellet.sprite.StopAnimation()
        end
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
    Player.Hurt(5, 1)
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
