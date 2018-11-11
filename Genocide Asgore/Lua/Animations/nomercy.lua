require "Libraries/colortoys"

nm_asgorefade = {}
nm_asgore = nil
nm_spearfade = {}
nm_spear = nil
nm_bgwhite = nil
nm_overwhite = nil
nm_overblack = nil

nm_fightleft = nil
nm_fightright = nil
nm_actleft = nil
nm_actright = nil
nm_itemleft = nil
nm_itemright = nil
nm_mercyleft = nil
nm_mercyright = nil
nm_bfight = nil
nm_bact = nil
nm_bitem = nil
nm_bmercy = nil

nm_gaster = nil
nm_laser = nil

nm_init = false
function InitNoMercy()
	nm_asgore = CreateProjectileAbs("anim/spear1", 160, 233)
	nm_asgore.sprite.SetPivot(0, 0)
	Audio.PlaySound("bwoar")
	nm_init = true
end

nm_fightvely = 4
nm_actvely = 5
nm_itemvely = 6
nm_mercyvely = 7

nm_buttonvelx = 10


nm_spearoff = 0
nm_gasteroff = 0
nm_gasteroff1 = 0

nm_stage = 0

timer = 0

function AnimNoMercy()

	if not nm_init then return end
	for i=1,#nm_asgorefade do
		if(nm_asgorefade[i].isactive) then
			nm_asgorefade[i].sprite.alpha = nm_asgorefade[i].sprite.alpha - 0.1
			if(nm_asgorefade[i].sprite.alpha == 0) then
				nm_asgorefade[i].Remove()
			end
		end
	end
	nm_asgore.SendToTop()
	for i=1,#nm_spearfade do
		if(nm_spearfade[i].isactive) then
			nm_spearfade[i].sprite.alpha = nm_spearfade[i].sprite.alpha - 0.1
			if(nm_spearfade[i].sprite.alpha == 0) then
				nm_spearfade[i].Remove()
			else
				nm_spearfade[i].SendToTop()
			end
		end
	end
	if(nm_spear ~= nil and nm_spear.isactive) then
		nm_spear.SendToTop()
	end
	if(nm_fightleft ~= nil and nm_fightleft.isactive) then
		nm_fightleft.Move(-5, 20)
		nm_fightleft.sprite.rotation = nm_fightleft.sprite.rotation + 6
		nm_fightright.Move(5, 20)
		nm_fightright.sprite.rotation = nm_fightright.sprite.rotation - 6
		nm_fightvely = nm_fightvely - 0.1
	end
	if(nm_actleft ~= nil and nm_actleft.isactive) then
		nm_actleft.Move(-5, nm_actvely)
		nm_actleft.sprite.rotation = nm_actleft.sprite.rotation + 5
		nm_actright.Move(5, nm_itemvely)
		nm_actright.sprite.rotation = nm_actright.sprite.rotation - 5
		nm_actvely = nm_itemvely - 0.1
	end
	if(nm_itemleft ~= nil and nm_itemleft.isactive) then
		nm_itemleft.Move(-6, nm_itemvely)
		nm_itemleft.sprite.rotation = nm_itemleft.sprite.rotation + 5
		nm_itemright.Move(6, nm_itemvely)
		nm_itemright.sprite.rotation = nm_itemright.sprite.rotation - 5
		nm_itemvely = nm_itemvely - 0.1
	end
	if(nm_mercyleft ~= nil and nm_mercyleft.isactive) then
		nm_mercyleft.Move(-7, nm_mercyvely)
		nm_mercyleft.sprite.rotation = nm_mercyleft.sprite.rotation + 5
		nm_mercyright.Move(7, nm_mercyvely)
		nm_mercyright.sprite.rotation = nm_mercyright.sprite.rotation - 5
		nm_mercyvely = nm_mercyvely - 0.1
                     end

	if(nm_stage == 1) then
		if(nm_bgwhite ~= nil) then
			nm_bgwhite.sprite.alpha = nm_bgwhite.sprite.alpha - 0.1
			if(nm_bgwhite.sprite.alpha == 0) then
				nm_bgwhite.Remove()
				nm_bgwhite = nil
			end
		end
	end
	if(nm_stage == 2) then
		if(nm_asgore.absx < 320) then
			local fade = CreateProjectileAbs("anim/basgore", nm_asgore.absx, nm_asgore.absy)
			fade.sprite.SetPivot(0, 0)
			fade.sprite.alpha = 0.5
			table.insert(nm_asgorefade, fade)
			nm_asgore.Move(-1, 0)
		end
		nm_spearoff = nm_spearoff + 1.5
		nm_gasteroff1 = nm_gasteroff1 - 4
		nm_spear.MoveTo(nm_asgore.x + 150, nm_asgore.y + 120 + nm_spearoff)
                                           nm_gaster.MoveTo(80, 340 + nm_gasteroff1)
                                           --nm_spear.MoveTo(nm_asgore.x + -1230, nm_asgore.y + 1120 + nm_spearoff)
                                 
		if(nm_spear.sprite.rotation ~= 270) then
			nm_spear.sprite.rotation = nm_spear.sprite.rotation - 2.5
		end
		nm_asgore.SendToTop()
		local fade = CreateProjectileAbs("anim/spear", nm_spear.absx, nm_spear.absy)
		fade.sprite.color = {1.0, 0, 0}
		fade.sprite.alpha = 0.5
		fade.sprite.rotation = nm_spear.sprite.rotation
		table.insert(nm_spearfade, fade)
		nm_spear.SendToTop()
		nm_gaster.SendToTop()
	end
	if(nm_stage >= 3) then
                                      if GetGlobal("gastered") == true then
                                           nm_gaster.sprite.SetAnimation({"anim/gb_1", "anim/gb_2", "anim/gb_3", "anim/gb_4", "anim/gb_5", "anim/gb_6", "anim/gb_5", "anim/gb_6", "anim/gb_5", "anim/gb_6", "anim/gb_5", "anim/gb_6", "anim/gb_5", "anim/gb_6", "anim/gb_5", "anim/gb_6", "anim/gb_5"}, 1/25)
                                           nm_gaster.SendToTop()
                                           SetGlobal("gastered", false)
                                      end
                                           nm_gasteroff = nm_gasteroff + 0.5
		nm_spear.Move(0, -40)
		--nm_spear.Move(0, 140)
		nm_gaster.Move(0, nm_gasteroff)
	end
	if(nm_stage == 4) then
		if(nm_overwhite.sprite.alpha < 1) then
			nm_overwhite.sprite.alpha = nm_overwhite.sprite.alpha + 0.02
		end
	end
	if(nm_stage == 5) then
		if(nm_overblack.sprite.alpha < 1) then
			nm_overblack.sprite.alpha = nm_overblack.sprite.alpha + 0.02
		end
	end
	if(nm_stage == 6) then
		if(Audio.playtime >= 1) then
			SetGlobal("EndWave", true)
		end
	end
	if(nm_stage == 0) then
		if(nm_asgore.absx > 40) then
			local fade = CreateProjectileAbs("anim/spear1", nm_asgore.absx, nm_asgore.absy)
			fade.sprite.SetPivot(0, 0)
			fade.sprite.alpha = 0.5
			table.insert(nm_asgorefade, fade)
			nm_asgore.SendToTop()
			nm_asgore.Move(-10, 0)
		else
			local timer = Timers.CreateTimer("speardraw", 1, false)
			function timer.OnComplete()
				Audio.PlaySound("speardraw")
				nm_asgore.sprite.SetAnimation({"anim/spear1", "anim/spear2", "anim/spear3", "anim/spear4", "anim/spear5", "anim/spear6", "anim/spear7", "anim/spear8", "anim/spear9", "anim/spear10", "anim/spear11", "anim/spear12"}, 1/12)
				nm_bgwhite = CreateProjectileAbs("bgwhite", 320, 240)
				local stopTimer = Timers.CreateTimer("speardrawstop", 1, false)
				function stopTimer.OnComplete()
					nm_asgore.sprite.Set("anim/spear12")
					nm_asgore.sprite.StopAnimation()
					local shTimer = Timers.CreateTimer("whiteman", 1, false)
					function shTimer.OnComplete()
                                                                                                                                Audio.PlaySound("gasterintro")
						Audio.PlaySound("bwoar")
						nm_stage = 2
						nm_bgwhite = CreateProjectileAbs("bgwhite", 320, 240)
						nm_asgore.Remove()
						nm_asgore = CreateProjectileAbs("anim/basgore", 40, 233)

						--nm_asgore.sprite.SetPivot(0, 0)
						nm_asgore.sprite.SetPivot(0, 0)

						nm_spear = CreateProjectileAbs("anim/spear", 280, 353)
						nm_gaster = CreateProjectileAbs("anim/gb_1", 500, 200)
						nm_spear.sprite.color = {1.0, 0, 0}
						FakeButtons()
                                                                                                                                nm_bmercy.Remove()
						local throwTimer = Timers.CreateTimer("throw", 1.5, false)
						function throwTimer.OnComplete()
							Audio.PlaySound("spearthrow")
                                                                                                                                                      Audio.PlaySound("gasterfire")
                                                                                                                                                     SetGlobal("gastered", true)
							nm_stage = 3
							local breakTimer = Timers.CreateTimer("break", 0.1, false)
							function breakTimer.OnComplete()
								Audio.PlaySound("break1")

								nm_fightleft = CreateProjectileAbs("anim/bfight_1", nm_bfight.absx + 32, nm_bmercy.absy + 21)
								nm_fightright = CreateProjectileAbs("anim/bfight_2", nm_bfight.absx + 65 + 29, nm_bmercy.absy + 21)

								--nm_actleft = CreateProjectileAbs("anim/bact_1", nm_bact.absx + 32, nm_bmercy.absy + 21)
								--nm_actright = CreateProjectileAbs("anim/bact_2", nm_bact.absx + 65 + 29, nm_bmercy.absy + 21)

								nm_itemleft = CreateProjectileAbs("anim/bitem_1", nm_bitem.absx + 32, nm_bmercy.absy + 21)
								nm_itemright = CreateProjectileAbs("anim/bitem_2", nm_bitem.absx + 65 + 29, nm_bmercy.absy + 21)

								--nm_mercyleft = CreateProjectileAbs("anim/bmercy_1", nm_bmercy.absx + 32, nm_bmercy.absy + 21)
								--nm_mercyright = CreateProjectileAbs("anim/bmercy_2", nm_bmercy.absx + 65 + 29, nm_bmercy.absy + 21)

								nm_bfight.Remove()
								--nm_bact.Remove()
								nm_bitem.Remove()
								--nm_bmercy.Remove()


								nm_overwhite = CreateProjectileAbs("bgwhitegaster", 320, 240)
								nm_overwhite.sprite.alpha = 0
								nm_overblack = CreateProjectileAbs("bgblack", 320, 240)
								nm_overblack.sprite.alpha = 0
								nm_stage = 4
								local blackTimer = Timers.CreateTimer("black", 2, false)
								function blackTimer.OnComplete()
									nm_stage = 5
									local startTimer = Timers.CreateTimer("start", 3, false)
									function startTimer.OnComplete()
										nm_stage = 6
                                                                                                                                                                                                                     if Input.Menu == 2 and Input.Up == 2 then
										     Audio.LoadFile("Power of our Perfect and Elegant Maid")
                                                                                                                                                                                                                     elseif Input.Menu == 2 and Input.Down == 2 then
										     Audio.LoadFile("Yellow")
                                                                                                                                                                                                                     elseif Input.Menu == 2 and Input.Confirm == 2 and Input.Cancel == 2 then
										     Audio.LoadFile("")
                                                                                                                                                                                                                     elseif Input.Menu == 2 then
										     Audio.LoadFile("asgore")
                                                                                                                                                                                                                     else
										     Audio.LoadFile("asgoreMANDO")
                                                                                                                                                                                                                     end
									end
								end
							end
						end
					end
				end
			end
			nm_stage = 1
		end
	end
	if(nm_overwhite ~= nil and nm_overwhite.isactive) then
		nm_overwhite.SendToTop()
		nm_overblack.SendToTop()
	end
end

function FakeButtons()
	nm_bfight = CreateProjectileAbs("anim/bfight", 32, 6)
	nm_bact = CreateProjectileAbs("anim/bact", 185, 6)
	nm_bitem = CreateProjectileAbs("anim/bitem", 345, 6)
	nm_bmercy = CreateProjectileAbs("anim/bmercy", 500, 6)
	nm_bfight.sprite.SetPivot(0, 0)
	nm_bact.sprite.SetPivot(0, 0)
	nm_bitem.sprite.SetPivot(0, 0)
	nm_bmercy.sprite.SetPivot(0, 0)
end