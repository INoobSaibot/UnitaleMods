-- Rotational Collision Library made by u/WD200019. Go check him out, as he's done some pretty cool stuff.

local self = {}
function self.GetCorners(object, pivot)
	local pivotx = 0.5 ; if pivot ~= nil then ; pivotx = pivot[1] ; end
	local pivoty = 0.5 ; if pivot ~= nil then ; pivoty = pivot[2] ; end
	local corners = {}
	local rot = math.rad(object.sprite.rotation)
	local center = {object.x, object.y}-- local center = {(object.x - object.sprite.width/2) + ((object.sprite.xscale * object.sprite.width) * pivotx), (object.y - object.sprite.height/2) + ((object.sprite.yscale * object.sprite.height) * pivoty)}
	local corner_coords = {
	{object.x - ((object.sprite.xscale*object.sprite.width)/2), object.y + ((object.sprite.yscale*object.sprite.height)/2)}, -- top left
	{object.x + ((object.sprite.xscale*object.sprite.width)/2), object.y + ((object.sprite.yscale*object.sprite.height)/2)}, -- top right
	{object.x + ((object.sprite.xscale*object.sprite.width)/2), object.y - ((object.sprite.yscale*object.sprite.height)/2)}, -- bottom right
	{object.x - ((object.sprite.xscale*object.sprite.width)/2), object.y - ((object.sprite.yscale*object.sprite.height)/2)} -- bottom left
	}
	for i, corner in ipairs(corner_coords) do
		local x = center[1] + (corner[1] - center[1]) * math.cos(rot) - (corner[2] - center[2]) * math.sin(rot)
		local y = center[2] + (corner[1] - center[1]) * math.sin(rot) + (corner[2] - center[2]) * math.cos(rot)
		corners[i] = {x, y}
	end
	return corners
end
function self.GetAxis(c1, c2)
	local axis = {}
	axis[1] = {(c1[2][1] - c1[1][1])/math.sqrt((c1[2][1] - c1[1][1])^2 + (c1[2][2] - c1[1][2])^2), (c1[2][2] - c1[1][2])/math.sqrt((c1[2][1] - c1[1][1])^2 + (c1[2][2] - c1[1][2])^2)}
	axis[2] = {(c1[4][1] - c1[1][1])/math.sqrt((c1[4][1] - c1[1][1])^2 + (c1[4][2] - c1[1][2])^2), (c1[4][2] - c1[1][2])/math.sqrt((c1[4][1] - c1[1][1])^2 + (c1[4][2] - c1[1][2])^2)}
	axis[3] = {(c2[2][1] - c2[1][1])/math.sqrt((c2[2][1] - c2[1][1])^2 + (c2[2][2] - c2[1][2])^2), (c2[2][2] - c2[1][2])/math.sqrt((c2[2][1] - c2[1][1])^2 + (c2[2][2] - c2[1][2])^2)}
	axis[4] = {(c2[4][1] - c2[1][1])/math.sqrt((c2[4][1] - c2[1][1])^2 + (c2[4][2] - c2[1][2])^2), (c2[4][2] - c2[1][2])/math.sqrt((c2[4][1] - c2[1][1])^2 + (c2[4][2] - c2[1][2])^2)}
	return axis
end
function self.collide(shape1, shape2)
	local c1, c2 = self.GetCorners(shape1), self.GetCorners(shape2)
	local axis = self.GetAxis(c1, c2)
	local scalars = {}
	for i=1,#axis do
		for j, set in pairs({c1, c2}) do -- set represents `{{x, y}, {x, y}, {x, y}, {x, y}}`
			scalars[j] = {}
			for k, point in pairs(set) do -- point represents `{x, y}`
				table.insert(scalars[j], point[1] * axis[i][1] + point[2] * axis[i][2])
			end
		end
		local s1max, s1min = math.max(unpack(scalars[1])), math.min(unpack(scalars[1]))
		local s2max, s2min = math.max(unpack(scalars[2])), math.min(unpack(scalars[2]))
		if s2min > s1max or s2max < s1min then
			return false
		end
	end
	return true
end
function self.CheckCollision(bullet1,bullet2)
	return self.collide(bullet1, bullet2)
end
return self