-- Make Campfire = 312370
-- Return to Camp = 312372

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:SetScript("OnEvent", function(self, event, ...)
	local _,_,spellID = ...
	if spellID == 312370 then
		local subzone, zone = GetSubZoneText(), GetZoneText()
		if subzone == "" then
			CaravanDB = zone
		else
			CaravanDB = string.format("%s, %s", subzone, zone)
		end
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local _,SpellID = self:GetSpell()
	if SpellID == 312372 and CaravanDB then
		self:AddLine("@ " .. CaravanDB,0.94,0.9,0.55,true)
	end
end)