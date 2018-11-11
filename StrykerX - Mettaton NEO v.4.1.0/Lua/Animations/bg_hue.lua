require "Libraries/colortoys"

backwave = CreateSprite("back_grad")
backwave.SetPivot(0, 0)
backwave.MoveTo(0, 0)

back_gradient = Gradient.new({{1, 0, 0}, {1, 1, 0}, {0, 1, 0}, {0, 1, 1}, {0, 0, 1}, {1, 0, 1}, {1, 0, 0}})
background_enabled = true

hue = 0
intensity = 1.0

base_intensity = 0
fade_to_black = 0
fade_to_black_frames = 0

unfade = 0
unfade_frames = 0

frames_elapsed = 0

function UpdateBG()
	frames_elapsed = frames_elapsed + 1

	if fui_initialized then
		if background_enabled then
			backwave.yscale = 1 + math.sin(Time.time * 0.50) * 0.5
			hue = hue + math.pi / 180
			if hue > math.pi * 2 then
				hue = hue - math.pi * 2
			end
		
			if fade_to_black > 0 then
				intensity = base_intensity * (fade_to_black / fade_to_black_frames)
				fade_to_black = fade_to_black - 1
				if fade_to_black == 0 then
					background_enabled = false
				end
			end
		
			if unfade > 0 then
				intensity = base_intensity * (1 - (unfade / unfade_frames))
				unfade = unfade - 1
			end

			backwave.color = color_multiply(hsv_to_rgb(hue, 1.0, 0.70), 1.0) --pastel
			--backwave.color = hue_to_rgb(hue, intensity)
			--backwave.color = color_multiply(back_gradient:getColorAt(hue / (2 * math.pi)), intensity)
			backwave.SendToBottom()
			end
			
		fui_mask.SendToBottom()
		fui_update()
	end
	
	--if frames_elapsed == 600 then
	--	disableBG(60)
	--end
	
	--if frames_elapsed == 1200 then
	--	enableBG(60, 0.5)
	--	frames_elapsed = 0
	--end
end

function enableBG(duration, target_intensity)
	unfade = duration
	unfade_frames = duration
	base_intensity = target_intensity
	background_enabled = true
end

function disableBG(duration)
	fade_to_black = duration
	fade_to_black_frames = duration
	base_intensity = intensity
end