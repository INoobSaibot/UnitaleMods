chasingbullet1 = CreateProjectile('damnit/mttsheart1', 0, 250)
chasingbullet1.SetVar('xspeed', 0)
chasingbullet1.SetVar('yspeed', 0)

spawntimer = 0

function Update()
    local xdifference = Player.x - chasingbullet1.x
    local ydifference = Player.y - chasingbullet1.y
    local xspeed = chasingbullet1.GetVar('xspeed') / 2 + xdifference / 190
    local yspeed = chasingbullet1.GetVar('yspeed') / 2 + ydifference / 190
    chasingbullet1.Move(xspeed, yspeed)
    chasingbullet1.SetVar('xspeed', xspeed)
    chasingbullet1.SetVar('yspeed', yspeed)

end