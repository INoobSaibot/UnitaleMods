--Holds the player in place during pauses in the intro.

--playerbullet = CreateProjectile("heartred", Player.x, Player.y)
--playerbullet.SetVar('tile', 1)

wavetimer = 0
arenasize = {155, 130}

Player.MoveTo(0,0,false)
Player.SetControlOverride(true)
Audio.LoadFile("spear of justice")
function Update()
	Player.MoveTo(0,0,false)
	--playerbullet.MoveTo(Player.x, Player.y)
	--playerbullet.SendToTop()
end

function OnHit(bullet)
    		Player.Hurt(0)

end