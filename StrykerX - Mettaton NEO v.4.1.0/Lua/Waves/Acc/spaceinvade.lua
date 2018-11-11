spawntimer = 0
bullets = {}
yOffset = 250
xOffset = 0
mult = 0.5
speed = 2
xOffsetTypes = {20, 0, -20}
function Update()
    spawntimer = spawntimer + 1
	if(spawntimer > 200) then
	if speed < 11 then
		speed = speed + 0
	end
	spawntimer = 0
	xOffset = math.random(0,0)
	end
    if(spawntimer % 200 == 0 and spawntimer <30) then
        local bullet = CreateProjectile('damnit/mttsheart2', xOffset, yOffset)
        local xdifference = Player.x - bullet.x
		local ydifference = Player.y - bullet.y
		local length = math.abs(math.sqrt(xdifference^2 + ydifference^2))
		
		bullet.SetVar('xspeed', (xdifference/length)*speed)
        bullet.SetVar('yspeed', (ydifference/length)*speed)   
        table.insert(bullets, bullet)
    end

    for i=1,#bullets do
        local bullet = bullets[i]
        local xspeed = bullet.GetVar('xspeed')
        local yspeed = bullet.GetVar('yspeed')
        bullet.Move(xspeed, yspeed)
    end
end