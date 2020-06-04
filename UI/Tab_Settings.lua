local addonName, OQ = ...
local oq = OQ:mod()
local _

local AceGUI = LibStub('AceGUI-3.0')

function OQ:InitTab_Settings(tab)
    local scroll = OQ:InitScroll(tab)

    scroll:AddChild(OQ:CreateCheckbox("Test 1"))
    scroll:AddChild(OQ:CreateCheckbox("Test 2"))
    scroll:AddChild(OQ:CreateCheckbox("Test 3"))
    scroll:AddChild(OQ:CreateCheckbox("Test 4"))
end