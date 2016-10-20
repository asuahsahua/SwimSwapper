local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

local IsSwimming = _G.IsSwimming
local InCombat = _G.InCombatLockdown
local Equip = _G.EquipItemByName
local GetInventoryItemID = _G.GetInventoryItemID

local holder = CreateFrame("Frame")
local dataobj = ldb:NewDataObject("SwimSwapper", {type = "data source", text = "Swim Swapper"})

local anglerItemId = 133755
local oldWeaponId = 0
local enabled = true

local function EquippedWeapon()
    return GetInventoryItemID("player", 16)
end

local function IsAnglerEquipped()
    return EquippedWeapon() == anglerItemId
end

local function EquipWeapon()
    if oldWeaponId ~= 0 and IsAnglerEquipped() then
        dataobj.text = "Weapon Equiped"
        Equip(oldWeaponId)
    end
end

local function EquipAngler()
    if not IsAnglerEquipped() then
        dataobj.text = "Angler Equiped"
        oldWeaponId = EquippedWeapon()
        Equip(anglerItemId)
    end
end

local function OnUpdate()
    if not enabled then
        return
    end

    local swimming = IsSwimming()

    -- we'd like to swap to weapon in combat, but turns out you're not allowed to do that!
    if not swimming then
        EquipWeapon()
    else
        EquipAngler()
    end
end

holder:RegisterEvent("PLAYER_REGEN_ENABLED")
holder:RegisterEvent("PLAYER_REGEN_DISABLED")
holder:SetScript("OnEvent", function(self, event)
    OnUpdate()
end)

-- not awesome, it'd be nice if I could find an event for when the player swims
holder:SetScript("OnUpdate", function(frame, tick)
    OnUpdate()
end)

function dataobj:OnTooltipShow()
    if enabled then
        self:AddLine("SwimSwapper Enabled")
    else
        self:AddLine("SwimSwapper Disabled")
    end
end

function dataobj:OnClick()
    enabled = not enabled
end