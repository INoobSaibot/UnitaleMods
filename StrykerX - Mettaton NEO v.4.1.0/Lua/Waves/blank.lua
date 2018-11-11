--Holds the player in place during pauses in the intro.

--playerbullet = CreateProjectile("heartred", Player.x, Player.y)
--playerbullet.SetVar('tile', 1)

arenasize = {175, 175}

Player.MoveTo(0,0,true)
Player.SetControlOverride(true)

function Update()
	Player.MoveTo(0,0,true)
	--playerbullet.MoveTo(Player.x, Player.y)
	--playerbullet.SendToTop()
end

function OnHit(bullet)
	if(bullet.GetVar('tile')) == 0 then
    		Player.Hurt(1)
	end
end