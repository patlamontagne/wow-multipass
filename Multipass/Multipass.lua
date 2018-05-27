naxx10_id = 576
uld10_id = 2894
toc10_id = 3917
icc10_id = 4532

naxx25_id = 577
uld25_id = 2895
toc25_id = 3916
icc25_id = 4608

naxx10 = false
uld10 = false
toc10 = false
icc10 = false
naxx25 = false
uld25 = false
toc25 = false
icc25 = false

text10 = {"", ""}
text25 = {"", ""}

function resetTooltip()
	text10 = {"", ""}
	text25 = {"", ""}
	GameTooltip:Show()
end

function onMouseOver()
	resetTooltip()
	if(UnitIsPlayer("mouseover")) then
		Target = UnitName("mouseover")

		if(LastTarget == Target) then
			-- only display info from memory
			render()
		else
			setPlayer()
		end
	end
end 

-- Set mouseover player as comparison unit
function setPlayer()
	resetTooltip()
	resetPlayer()
	local success = SetAchievementComparisonUnit("mouseover")
end

function resetPlayer()
	LastTarget = Target
	ClearAchievementComparisonUnit()
end

-- Event handler
function Multipass_OnEvent(Nil, EventName)
	-- Handles combatmode on target
	if ( EventName == "PLAYER_REGEN_ENABLED" ) then TargetIsInCombat = false; return; end
	if ( EventName == "PLAYER_REGEN_DISABLED" ) then TargetIsInCombat = true; return; end

	-- Achi info is available, read from it
	if ( EventName == "INSPECT_ACHIEVEMENT_READY" ) then
		readAchievements()
	end
end

function readAchievements()
	resetTooltip()
	resetAchievements()
	setAchievements()
	render()
end

function resetAchievements()
	naxx10 = false
	uld10 = false
	toc10 = false
	icc10 = false
	naxx25 = false
	uld25 = false
	toc25 = false
	icc25 = false
end

function setAchievements()
	naxx10 = GetAchievementComparisonInfo(naxx10_id)
	uld10 = GetAchievementComparisonInfo(uld10_id)
	toc10 = GetAchievementComparisonInfo(toc10_id)
	icc10 = GetAchievementComparisonInfo(icc10_id)
	naxx25 = GetAchievementComparisonInfo(naxx25_id)
	uld25 = GetAchievementComparisonInfo(uld25_id)
	toc25 = GetAchievementComparisonInfo(toc25_id)
	icc25 = GetAchievementComparisonInfo(icc25_id)
end

-- Display info on tooltip
function render()
	if ( CanInspect("mouseover") ) and (LastTarget == Target) and not ( TargetIsInCombat ) then

		addText(text10, naxx10, "Naxx")
		addText(text10, uld10, "Uld")
		addText(text10, toc10, "TOC")
		addText(text10, icc10, "ICC")

		addText(text25, naxx25, "Naxx")
		addText(text25, uld25, "Uld")
		addText(text25, toc25, "TOC")
		addText(text25, icc25, "ICC")

		if(text10[1] == "") then text10[1] = "-" end
		if(text10[2] == "") then text10[2] = "-" end
		if(text25[1] == "") then text25[1] = "-" end
		if(text25[2] == "") then text25[2] = "-" end
		
		GameTooltip:AddLine("10-man:", 1,1,1)
		GameTooltip:AddDoubleLine(text10[1], text10[2], 0,1,0, 1,0,0)
		GameTooltip:AddLine("25-man:", 1,1,1)
		GameTooltip:AddDoubleLine(text25[1], text25[2], 0,1,0, 1,0,0)
		GameTooltip:Show()
	end
end

function addText(line, achi, string)
	if(achi) then
		if(line[1] == "") then 
			line[1] = line[1]..string
		else
			line[1] = line[1].." "..string
		end 
	else
		if(line[2] == "") then 
			line[2] = line[2]..string
		else
			line[2] = line[2].." "..string
		end 
	end
end



------------------------ GUI PROGRAMS -------------------------------------------------------
resetTooltip()
resetAchievements()
local f = CreateFrame("Frame", "Multipass", UIParent)
f:SetScript("OnEvent", Multipass_OnEvent);
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
GameTooltip:HookScript("OnTooltipSetUnit", onMouseOver)

-- print(GetAchievementInfo(576))
