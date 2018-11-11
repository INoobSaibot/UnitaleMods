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

function UpdateAsgore()
	if currenttime > asgorecapemark1 then
		asgorecape.Set("asgore/asgorecape0")
		asgorecapemark1 = asgorecapemark1 + (asgorecapemark1mark*2)
	end
	if currenttime > asgorecapemark2 then
		asgorecape.Set("asgore/asgorecape1")
		asgorecapemark2 = asgorecapemark2 + (asgorecapemark2mark*2)
	end
	
	asgoredress.MoveTo(asgoredress.x,-8+(math.sin(Time.time*1.4)*1.5))
	asgoretorso.MoveTo(asgoretorso.x,14+(math.cos(Time.time*1.7)*1.2))
	asgorecape.MoveTo(asgorefeet.x,asgorefeet.y+(math.sin(Time.time*1.7)*1.2))
	asgorehead.MoveTo(asgorehead.x,-4+(math.sin(Time.time*1.35)*1.5))
	asgoreupperarml.MoveTo(asgoreupperarml.x,-40+(math.sin(Time.time*1.2)*1.6))
	asgoreupperarmr.MoveTo(asgoreupperarmr.x,-55+(math.sin(Time.time*1.2)*1.6))
	asgorespear.MoveTo(asgorespear.x,68+(math.sin(Time.time*1.35)*1.5))
	
	SetGlobal("speary", asgorespear.y)
end

function HideAsgore()
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
end

function ShowAsgore()
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
end