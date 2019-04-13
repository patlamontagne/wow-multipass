local naxx10_id = 576
local uld10_id = 2894
local toc10_id = 3917
local icc10_id = 4532
local rs10_id = 4817
local naxx25_id = 577
local uld25_id = 2895
local toc25_id = 3916
local icc25_id = 4608
local rs25_id = 4815
local multipass__requesting = false

function onMouseOver()
	TooltipName = GameTooltip:GetUnit()
	if ( CanInspect("mouseover") ) and ( UnitName("mouseover") == TooltipName ) and not ( TargetIsInCombat ) then

		if (LastTarget == TooltipName) then
			render()
		elseif (not multipass__requesting) then
			setPlayer()
		end

	end
end 

-- Set mouseover player as comparison unit
function setPlayer()
	LastTarget = TooltipName 
	resetAchievements()
	multipass__requesting = SetAchievementComparisonUnit("mouseover")
end

-- Event handler
function Multipass_OnEvent(Nil, EventName)
	-- Handles combatmode on target
	if ( EventName == "PLAYER_REGEN_DISABLED" ) then
		TargetIsInCombat = true
		return
	end
	
	if ( EventName == "PLAYER_REGEN_ENABLED" ) then
		TargetIsInCombat = false
	end

	-- Achi info is available, read from it
	if ( EventName == "INSPECT_ACHIEVEMENT_READY" ) then
		multipass__requesting = false
		setAchievements()
		render()
	end
end

function setAchievements()
	naxx10 = GetAchievementComparisonInfo(naxx10_id)
	uld10 = GetAchievementComparisonInfo(uld10_id)
	toc10 = GetAchievementComparisonInfo(toc10_id)
	icc10 = GetAchievementComparisonInfo(icc10_id)
	rs10 = GetAchievementComparisonInfo(rs10_id)
	naxx25 = GetAchievementComparisonInfo(naxx25_id)
	uld25 = GetAchievementComparisonInfo(uld25_id)
	toc25 = GetAchievementComparisonInfo(toc25_id)
	icc25 = GetAchievementComparisonInfo(icc25_id)
	rs25 = GetAchievementComparisonInfo(rs25_id)
	ClearAchievementComparisonUnit()
end

function getColor(achi)
	if (achi == "RS+") then
		-- red
		return  1,0,0
	end
	
	if (achi == "RS") then
		-- orange
		return 1,0.5,0
	end
	
	if (achi == "ICC") then
		-- purple
		return 0.7,0.2,1
	end
	
	if (achi == "TOC") then
		-- blue
		return 0.3,0.3,1
	end
	
	if (achi == "ULD") then
		-- green
		return 0,1,0
	end

	return 1,1,1
end

-- Display info on tooltip
function render()

	if (multipass__requesting) then return; end

	if (rs10) then
		achi10 = "RS+"
	elseif (icc10) then
		achi10 = "RS"
	elseif (toc10) then
		achi10 = "ICC"
	elseif (uld10) then
		achi10 = "TOC"
	elseif (naxx10) then
		achi10 = "ULD"
	else
		achi10 = false
	end

	if (rs25) then
		achi25 = "RS+"
	elseif (icc25) then
		achi25 = "RS"
	elseif (toc25) then
		achi25 = "ICC"
	elseif (uld25) then
		achi25 = "TOC"
	elseif (naxx25) then
		achi25 = "ULD"
	else
		achi25 = false
	end

	r1,g1,b1 = getColor(achi10)
	r2,g2,b2 = getColor(achi25)

	GameTooltip:AddDoubleLine(achi10 and achi10.."10" or " ", achi25 and achi25.."25" or " ", r1,g1,b1, r2,g2,b2)
	GameTooltip:Show()
end

function resetText()
	achi10 = ""
	achi25 = ""
end

function resetAchievements()
	naxx10 = false
	uld10 = false
	toc10 = false
	icc10 = false
	rs10 = false
	naxx25 = false
	uld25 = false
	toc25 = false
	icc25 = false
	rs25 = false
end

resetText()
resetAchievements()
------------------------ GUI PROGRAMS -------------------------------------------------------
local f = CreateFrame("Frame", "Multipass", UIParent)
f:SetScript("OnEvent", Multipass_OnEvent);
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
GameTooltip:HookScript("OnTooltipSetUnit", onMouseOver)
