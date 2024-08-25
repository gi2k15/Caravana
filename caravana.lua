-- Make Campfire  = 312370
-- Return to Camp = 312372

if select(2, UnitRace("player")) ~= "Vulpera" then return end

local db
local events    = {}
local iconCamp  = "poi-islands-table" -- change this to change the icons.
local atlasCamp = CreateAtlasMarkup(iconCamp, 20, 20)

local HBD     = LibStub("HereBeDragons-2.0")
local Pins    = LibStub("HereBeDragons-Pins-2.0")
local iconRef = true

local icon = CreateFrame("Frame")
icon:SetSize(20, 20)
icon.texture = icon:CreateTexture()
icon.texture:SetAtlas(iconCamp)
icon.texture:SetAllPoints()
icon:Hide()
icon:SetScript("OnEnter", function(self)
    local camp = C_Spell.GetSpellInfo(312372)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 5, 0)
    GameTooltip:SetText(format("%s\n|cFFFFFFFF%s", camp, db.place), _, _, _, _, true)
    GameTooltip:Show()
end)
icon:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

function events:PLAYER_LOGIN(...)
    db = CaravanaDB or {}
    if db.x and db.y and db.instance and db.place then
        Pins:AddWorldMapIconWorld(iconRef, icon, db.instance, db.x, db.y, HBD_PINS_WORLDMAP_SHOW_WORLD)
    end
end

function events:PLAYER_LOGOUT(...)
    CaravanaDB = db
end

function events:UNIT_SPELLCAST_SUCCEEDED(...)
    local _, _, spellID = ...
    if spellID == 312370 then
        local subzone, zone = GetSubZoneText(), GetZoneText()
        db.place = subzone == "" and zone or format("%s, %s", subzone, zone)
        Pins:RemoveAllWorldMapIcons(iconRef)
        db.x, db.y, db.instance = HBD:GetPlayerWorldPosition()
        Pins:AddWorldMapIconWorld(iconRef, icon, db.instance, db.x, db.y, HBD_PINS_WORLDMAP_SHOW_WORLD)
    end
end

local f = CreateFrame("Frame")

f:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...)
end)
for k, v in pairs(events) do
    f:RegisterEvent(k)
end

local function AddTooltipText(tooltip, spellID)
    if spellID == 312372 and db.place then
        tooltip:AddLine(atlasCamp .. " " .. db.place, 0.94, 0.9, 0.55, true)
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(self, data)
    local _, SpellID = self:GetSpell()
    AddTooltipText(self, SpellID)
end)

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, function(self, data)
    AddTooltipText(self, data.lines[1].tooltipID)
end)