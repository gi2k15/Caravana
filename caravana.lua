-- Make Campfire = 312370
-- Return to Camp = 312372

local f = CreateFrame("Frame")

local events = {}

function events:UNIT_SPELLCAST_SUCCEEDED(...)
	local _,_,spellID = ...
	if spellID == 312370 then
		local subzone, zone = GetSubZoneText(), GetZoneText()
		if subzone == "" then
			CaravanaDB = zone
		else
			CaravanaDB = string.format("%s, %s", subzone, zone)
		end
	end
end

f:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...)
end)
for k, v in pairs(events) do
	f:RegisterEvent(k)
end

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local _,SpellID = self:GetSpell()
	if SpellID == 312372 and CaravanaDB then
		self:AddLine("@ " .. CaravanaDB,0.94,0.9,0.55,true)
	end
end)