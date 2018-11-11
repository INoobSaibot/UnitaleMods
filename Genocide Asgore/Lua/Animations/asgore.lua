require "Libraries/colortoys"

M_PI = 3.14159265359
SetGlobal("Hide", false)
whitefade = CreateSprite("screenfade/white")
whitefade.alpha = 0

background1 = CreateSprite("background_block")
--background2 = CreateSprite("background_block")
--background3 = CreateSprite("background_block")
--background4 = CreateSprite("background_block")
--background5 = CreateSprite("background_block")
background6 = CreateSprite("background_block")

flowey = CreateSprite("asgore/flowey")
asgorecape = CreateSprite("asgore/asgorecape0")
asgorefeet = CreateSprite("asgore/asgorefeet")
asgorelegs = CreateSprite("asgore/asgorelegs")
asgoredress = CreateSprite("asgore/asgoredress")
asgoretorso = CreateSprite("asgore/asgoretorso")
asgorehead = CreateSprite("asgore/asgorehead")

asgorespear = CreateSprite("asgore/asgorespear")

asgorearmr = CreateSprite("asgore/asgorearmright")
asgorearml = CreateSprite("asgore/asgorearmleft")
asgoreupperarmr = CreateSprite("asgore/asgoreballarm")
asgoreupperarml = CreateSprite("asgore/asgoreballarm")
asgorehandr = CreateSprite("asgore/asgorehandr")
asgorehandl = CreateSprite("asgore/asgorehandl")


flowey.SetParent(asgoretorso)
asgorelegs.SetParent(asgorefeet)
asgoredress.SetParent(asgorelegs)
asgoretorso.SetParent(asgoredress)
asgorehead.SetParent(asgoretorso)

asgorearmr.SetParent(asgoretorso)
asgorearml.SetParent(asgoretorso)
asgoreupperarmr.SetParent(asgorearmr)
asgoreupperarml.SetParent(asgorearml)

asgorespear.SetParent(asgoreupperarml)

asgorehandl.SetParent(asgorespear)
asgorehandr.SetParent(asgorespear)

flowey.y = 52
flowey.x = 90
flowey.SendToBottom()

asgorelegs.y = 2
asgoredress.y = -2
asgoretorso.y = -2
asgorefeet.y = 246
asgorefeet.x = 320
asgorehead.y = -4

asgorearml.y = -50
asgorearmr.y = -50

asgorearml.x = -95
asgorearmr.x = 95

asgoreupperarml.y = -40
asgoreupperarmr.y = -55

asgoreupperarml.x = -18
asgoreupperarmr.x = 0

asgorehandl.y = -15
asgorehandr.y = 11

asgorespear.x = -10
asgorespear.y = 68
asgorespear.rotation = -22

asgorehandl.x = -173
asgorehandr.x = 12


asgoreupperarml.xscale = 1
asgoreupperarml.yscale = 1.25
asgoreupperarml.rotation = 2

asgoreupperarmr.xscale = 0.8
asgoreupperarmr.yscale = 1
asgoreupperarmr.rotation = 12

asgorehandl.rotation = -13
asgorehandr.rotation = -25

asgorefeet.SetPivot(0.5, 0)
asgorelegs.SetPivot(0.5, 0)
asgoredress.SetPivot(0.5, 0)
asgoretorso.SetPivot(0.5, 0)
asgorecape.SetPivot(0.5, 0)
--asgorehead.SetPivot(0.5, 0.10)
asgorehead.SetPivot(0.5, 0)

asgorearml.SetPivot(0, 0)
asgorearmr.SetPivot(1, 0)
asgoreupperarml.SetPivot(0.5, 0)
asgoreupperarmr.SetPivot(0.5, 0)
asgorespear.SetPivot(0.1, 0.86)
asgorehandl.SetPivot(0.4, 0)
asgorehandr.SetPivot(0.7, 1)

asgorecapemark1mark = 0.5
asgorecapemark2mark = 0.5
asgorecapemark1 = 0.5
asgorecapemark2 = 1
          --timer = timer + math.pi / 120 -- will cycle through 2pi every second
             -- if timer >= 2 * math.pi then
                --  timer = timer - math.pi * 2 -- subtract 2 pi from the scale... should reset it to zero.
              --end

timer = 0
flowtimer = 0

--flowey.SetAnimation({"asgore/flowey", "asgore/flowey2"}, 1)

function UpdateAsgore()
	if GetGlobal("dodge") ~= nil then
		if GetGlobal("dodge")  and GetGlobal("dodgeit") == 3 then
			asgorefeet.x = asgorefeet.x + (200 - asgorefeet.x) / 10
			if asgorefeet.x < 200.1 then
				SetGlobal("dodge", false)
			end
		elseif asgorefeet.x ~= 320 and not GetGlobal("dodge") then
			asgorefeet.x = asgorefeet.x + (320 - asgorefeet.x) / 10
			if asgorefeet.x > 319.9 then
				SetGlobal("dodge", false)
                                                                                      SetGlobal("dodgeit", 1)
				asgorefeet.x = 320
			end
		end
	end
     flowtimer = flowtimer + 1
    timer = timer + math.pi / 60 -- will cycle through 2pi every second
    if timer >= 2 * math.pi then
        timer = timer - math.pi * 2 -- subtract 2 pi from the scale... should reset it to zero.
    end
                     if GetGlobal("hurtframes") ~= nil and GetGlobal("dodgeit") < 3 then
		if GetGlobal("hurtframes") > 0 then
                                                                whitefade.Set("screenfade/white")
                                                                whitefade.alpha = whitefade.alpha + 0.09*Time.mult
                                                                whitefade.SendToTop()
                                                                flowey.Set("asgore/floweyhurt")
                                                                flowtimer = -30
			asgorefeet.x = 320 + math.sin(Time.time * 30 * M_PI) * GetGlobal("hurtframes") ^0.8
			SetGlobal("hurtframes", GetGlobal("hurtframes") - 1)
                                          else
                                                                --whitefade.alpha = 0
                                                                whitefade.alpha = whitefade.alpha - 0.09*Time.mult
                                          end
                     end
                     if flowtimer == 0 then
                         flowey.Set("asgore/flowey")
                     elseif flowtimer == 60 then
                         flowey.Set("asgore/flowey2")
                     elseif flowtimer >= 110 then
                         flowtimer = -1  
                     end     
                   
	if currenttime > asgorecapemark1 then
		asgorecape.Set("asgore/asgorecape0")
		asgorecapemark1 = asgorecapemark1 + (asgorecapemark1mark*2)
	end
	if currenttime > asgorecapemark2 then
		asgorecape.Set("asgore/asgorecape1")
		asgorecapemark2 = asgorecapemark2 + (asgorecapemark2mark*2)
	end
	background1.MoveTo(70,(math.sin((Time.time*1.65) + 0)*10) + 380)
	--background2.MoveTo(170,(math.sin((Time.time*1.65) + 1)*10) + 380)
	--background3.MoveTo(270,(math.sin((Time.time*1.65) + 2)*10) + 380)
	--background4.MoveTo(370,(math.sin((Time.time*1.65) + 3)*10) + 380)
	--background5.MoveTo(470,(math.sin((Time.time*1.65) + 4)*10) + 380)
	background6.MoveTo(570,(math.sin((Time.time*1.65) + 5)*10) + 380)




	asgoredress.MoveTo(asgoredress.x,-8+(math.sin(Time.time*1.4)*1.5))
	asgoretorso.MoveTo(asgoretorso.x,14+(math.cos(Time.time*1.7)*1.2))
	asgorecape.MoveTo(asgorefeet.x,asgorefeet.y+(math.sin(Time.time*1.7)*1.2))
	asgorehead.MoveTo(asgorehead.x,-4+(math.sin(Time.time*1.35)*1.5))
	asgoreupperarml.MoveTo(asgoreupperarml.x,-40+(math.sin(Time.time*1.2)*1.6))
	asgoreupperarmr.MoveTo(asgoreupperarmr.x,-55+(math.sin(Time.time*1.2)*1.6))
	asgorespear.MoveTo(asgorespear.x,68+(math.sin(Time.time*1.35)*1.5))
                     if GetGlobal("Hide") == false then
                        background1.color = hsv_to_rgb(timer, 1.0, 0.5)
                        --background2.color = hsv_to_rgb(timer, 1.0, 0.5)
                        --background3.color = hsv_to_rgb(timer, 1.0, 0.5)
                        --background4.color = hsv_to_rgb(timer, 1.0, 0.5)
                       -- background5.color = hsv_to_rgb(timer, 1.0, 0.5)
                        background6.color = hsv_to_rgb(timer, 1.0, 0.5)
                             asgorespear.color = hsv_to_rgb(timer, 1.0, 0.5) -- full vivid rainbow wheel
                     else
                     end



	
	SetGlobal("speary", asgorespear.y)
end

function HideAsgore()
SetGlobal("Hide", true)
                     flowey.alpha = 0
	asgorecape.alpha = 0
	asgorefeet.alpha = 0
	asgorelegs.alpha = 0
	asgoredress.alpha = 0
	asgoretorso.alpha = 0
	asgorehead.alpha = 0

	asgorespear.alpha = 0

	asgorearmr.alpha = 0
	asgorearml.alpha = 0
	asgoreupperarmr.alpha = 0
	asgoreupperarml.alpha = 0
	asgorehandr.alpha = 0
	asgorehandl.alpha = 0

                     background1.alpha = 0
                     --background2.alpha = 0
                     --background3.alpha = 0
                     --background4.alpha = 0
                     --background5.alpha = 0
                     background6.alpha = 0
end

function ShowAsgore()
SetGlobal("Hide", false)
                     flowey.alpha = 1
	asgorecape.alpha = 1
	asgorefeet.alpha = 1
	asgorelegs.alpha = 1
	asgoredress.alpha = 1
	asgoretorso.alpha = 1
	asgorehead.alpha = 1

	asgorespear.alpha = 1

	asgorearmr.alpha = 1
	asgorearml.alpha = 1
	asgoreupperarmr.alpha = 1
	asgoreupperarml.alpha = 1
	asgorehandr.alpha = 1
	asgorehandl.alpha = 1

                     background1.alpha = 1
                     --background2.alpha = 1
                     --background3.alpha = 1
                     --background4.alpha = 1
                     --background5.alpha = 1
                     background6.alpha = 1
end

