local addonName, OQ = ...
local oq = OQ:mod()
local _

local AceGUI = LibStub('AceGUI-3.0')

function OQ:InitTab_Settings(tab)
    local scroll = OQ:InitScroll(tab)

    local table = AceGUI:Create("SimpleGroup")
    table:SetLayout("Table")
    table:SetUserData("table", {
        columns = {
            0.5,
            0.5
        },
        -- space = 2,
        align = "TOPLEFT"
    })
    table:SetFullHeight(true)
    table:SetFullWidth(true)
    scroll:AddChild(table)

    -- Left side
    local gLeft = AceGUI:Create("InlineGroup")
    gLeft:SetLayout("List")
    gLeft:SetTitle("?")
    -- gLeft:SetRelativeWidth(0.5)
    -- gLeft:SetFullHeight(true)
    gLeft:SetFullWidth(true)
    table:AddChild(gLeft)

    local txtPlayerId = AceGUI:Create("EditBox")
    txtPlayerId:SetLabel("Battle-tag")
    txtPlayerId:SetRelativeWidth(1)
    -- txtPlayerId:SetText(form.title)
    txtPlayerId:SetCallback("OnEnterPressed", function(_, _, value)
        -- form.title = value
    end)
    txtPlayerId:SetDisabled(true)
    gLeft:AddChild(txtPlayerId)

    -- Right side
    local gRight = AceGUI:Create("SimpleGroup")
    gRight:SetLayout("List")
    gRight:SetFullWidth(true)
    table:AddChild(gRight)

    local gToggles = AceGUI:Create("InlineGroup")
    gToggles:SetTitle("Options")
    gToggles:SetLayout("List")
    gToggles:SetFullWidth(true)
    gRight:AddChild(gToggles)

    gToggles:AddChild(OQ:CreateCheckbox(OQ.SETUP_CLASSPORTRAIT))
    gToggles:AddChild(OQ:CreateCheckbox(OQ.AUTO_INSPECT))
    gToggles:AddChild(OQ:CreateCheckbox(OQ.SETUP_SHOUTADS))
    gToggles:AddChild(OQ:CreateCheckbox(OQ.SETUP_SHOUTCONTRACTS))
    gToggles:AddChild(OQ:CreateCheckbox(OQ.SETUP_SHOW_CONTROLLED))
    gToggles:AddChild(OQ:CreateCheckbox(OQ.SETUP_AUTOHIDE_FRIENDREQS))
    gToggles:AddChild(OQ:CreateCheckbox(OQ.SETUP_LOOT_ACCEPTANCE))

    local gDebug = AceGUI:Create("InlineGroup")
    gDebug:SetTitle("Debug info")
    gDebug:SetLayout("List")
    gDebug:SetFullWidth(true)
    gRight:AddChild(gDebug)

    gDebug:AddChild(OQ:CreateCheckbox("Test 1"))
    gDebug:AddChild(OQ:CreateCheckbox("Test 2"))
    gDebug:AddChild(OQ:CreateCheckbox("Test 3"))
    gDebug:AddChild(OQ:CreateCheckbox("Test 4"))
end
