--Holds the player in place during pauses in the intro.

--playerbullet = CreateProjectile("heartred", Player.x, Player.y)
--playerbullet.SetVar('tile', 1)

Encounter.SetVar("wavetimer", 7)

arenasize = {155, 130}

Player.MoveTo(0,0,true)
Player.SetControlOverride(true)

chasingbullet1 = CreateProjectile('screenfade/white', 0, 200)

function Update()
	Player.MoveTo(0,0,true)
	--playerbullet.MoveTo(Player.x, Player.y)
	--playerbullet.SendToTop()
end

function OnHit(bullet)
	if(bullet.GetVar('tile')) == 0 then
    		Player.Hurt(0)
	end
end