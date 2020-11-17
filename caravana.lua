-- Make Campfire = 312370
-- Return to Camp = 312372

if select(2, UnitRace('player')) ~= "Vulpera" then
    DisableAddOn("Caravana")
    return
end

local db
local events = {}

local HBD = LibStub("HereBeDragons-2.0")
local Pins = LibStub("HereBeDragons-Pins-2.0")
local iconRef = true

local f = CreateFrame("Frame")

local icon = CreateFrame("Frame")
icon:SetSize(16,16)
icon.texture = icon:CreateTexture()
icon.texture:SetAtlas("poi-town")
icon.texture:SetAllPoints()
icon.texture:SetVertexColor(247/255, 160/255, 160/255)
icon:Hide()
icon:SetScript("OnEnter", function(self)
    local camp = GetSpellInfo(312372)
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
    local _,_,spellID = ...
    if spellID == 312370 then
        local subzone, zone = GetSubZoneText(), GetZoneText()
        db.place = subzone == "" and zone or format("%s, %s", subzone, zone)
        Pins:RemoveAllWorldMapIcons(iconRef)
        db.x, db.y, db.instance = HBD:GetPlayerWorldPosition()
        Pins:AddWorldMapIconWorld(iconRef, icon, db.instance, db.x, db.y, HBD_PINS_WORLDMAP_SHOW_WORLD)
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
    if SpellID == 312372 and db.place then
        self:AddLine("@ " .. db.place,0.94,0.9,0.55,true)
    end
end)