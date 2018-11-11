animtimer = 0
background1 = CreateSprite("undyne/background_block")
background2 = CreateSprite("undyne/background_block")
background3 = CreateSprite("undyne/background_block")
background4 = CreateSprite("undyne/background_block")
background5 = CreateSprite("undyne/background_block")
background6 = CreateSprite("undyne/background_block")

local scale = 2 --1.87
legs = CreateSprite("undyne/legs")
legs.Scale(scale,scale)
legs.SetPivot(0.5,0.1)
legs.MoveTo(320,240)
pants = CreateSprite("undyne/pants")
pants.Scale(scale,scale)
pants.SetParent(legs)
pants.y = 20
armorfake = CreateSprite("undyne/armorfake")
armorfake.Scale(scale,scale)
armorfake.SetParent(pants)
armorfake.x = 4
armorfake.y = 50
armorfake2 = CreateSprite("undyne/armorfake")
armorfake2.Scale(scale,scale)
armorfake2.SetParent(pants)
armorfake2.x = 4
armorfake2.y = 50
leftarm = CreateSprite("undyne/leftarm")
leftarm.Scale(scale,scale)
leftarm.SetParent(armorfake)
leftarm.SendToBottom()
leftarm.x = -50
leftarm.y = -54
armor = CreateSprite("undyne/armor")
armor.Scale(scale,scale)
armor.SetParent(armorfake2)
armor.x = 1
armor.y = 0
pants.SendToTop()
rightarm = CreateSprite("undyne/rightarm")
rightarm.Scale(scale,scale)
rightarm.SetParent(armorfake2)
rightarm.SendToBottom()
rightarm.x = 50
rightarm.y = -20
head = CreateSprite("undyne/facefake")
head.Scale(scale,scale)
head.SetPivot(0.5,0.3)
head.SetParent(armor)
head.y = 26
hair = CreateSprite("undyne/hair_0")
hair.Scale(scale,scale)
hair.SetAnimation({"undyne/hair_0","undyne/hair_1","undyne/hair_2","undyne/hair_3"},1/7)
hair.SetParent(head)
hair.x = -52
hair.y = 32
face = CreateSprite("undyne/face")
face.Scale(scale,scale)
face.SetParent(head)
face.y = 20

function AnimateUndyne()
	animtimer = animtimer + (Time.mult/60)
	pants.y = (math.sin(animtimer*6)*1.5) + 20
	armorfake.x = (math.sin(animtimer*7)*2) - 4
	armorfake.y = (math.sin(animtimer*6.5)/1.25) + 50
	armor.y = math.sin(animtimer*6) - 8
	armor.x = - 6
	rightarm.x = (math.sin(animtimer*10)*4) + 34
	rightarm.y = (math.sin(animtimer*5)*2)-14
	leftarm.x = (math.sin(animtimer*10)*4) - 35
	leftarm.y = (math.sin(animtimer*5)*2)- 20
	head.y = (math.sin(animtimer*6.5)) + 23
	head.x = 3
	
	background1.MoveTo(70,(math.sin((Time.time*1.75) + 0)*20) + 350)
	background2.MoveTo(170,(math.sin((Time.time*1.75) + 1)*20) + 350)
	background3.MoveTo(270,(math.sin((Time.time*1.75) + 2)*20) + 350)
	background4.MoveTo(370,(math.sin((Time.time*1.75) + 3)*20) + 350)
	background5.MoveTo(470,(math.sin((Time.time*1.75) + 4)*20) + 350)
	background6.MoveTo(570,(math.sin((Time.time*1.75) + 5)*20) + 350)
end