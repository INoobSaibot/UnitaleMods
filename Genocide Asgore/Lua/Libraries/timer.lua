local this = {}

this.timers = {}

function this.CreateTimer(name,time,loop)
	local timer = {
		Name = name,
		Time = time,
		StartTime = Time.time,
		Loop = loop,
		OnComplete = nil
	}
	table.insert(this.timers, timer)
	return timer
end

function this.StopTimer(name)
	for i=1,#this.timers do
		if(this.timers[i].Name == name) then
			table.remove(this.timers, i)
			break
		end
	end
end

function this.UpdateTimers()
	for i=1,#this.timers do
		local timer = this.timers[i]
		if(timer ~= nil) then
			if(Time.time - timer.StartTime >= timer.Time) then
				if(timer.OnComplete ~= nil) then
					timer.OnComplete()
				end
				if(timer.Loop) then
					timer.StartTime = Time.time
				else
					table.remove(this.timers, i)
				end
			end
		end
	end
end

return this