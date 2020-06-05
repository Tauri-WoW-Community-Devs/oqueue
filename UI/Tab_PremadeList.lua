local addonName, OQ = ...
local oq = OQ:mod()
local _

local AceGUI = LibStub('AceGUI-3.0')

local function queueBtnWidth()
    local btn = AceGUI:Create("Button")
    btn:SetText("Queue")
    btn.text:SetFont(STANDARD_TEXT_FONT, 10, nil)
    return btn.text:GetStringWidth() + 30
end

local function xBtnWidth()
    local btn = AceGUI:Create("Button")
    btn:SetText("x")
    btn.text:SetFont(STANDARD_TEXT_FONT, 10, nil)
    return btn.text:GetStringWidth() + 30
end

function OQ:InitTab_PremadeList(tab)
    local scroll = OQ:InitScroll(tab)

    local table = AceGUI:Create("SimpleGroup")
    table:SetLayout("Table");
    table:SetUserData("table", {
        columns = {
            16,
            5,
            4,
            50,
            50,
            50,
            {
                width = 50,
                alignH = "middle"
            },
            queueBtnWidth(),
            xBtnWidth()
        },
        space = 3,
        align = "CENTERLEFT"
    })
    table:SetFullHeight(true);
    table:SetFullWidth(true);
    scroll:AddChild(table)

    table:AddChild(OQ:ClickableLabel("", Sort, "spec"))
    table:AddChild(OQ:ClickableLabel("Premade name", Sort, "name"))
    table:AddChild(OQ:ClickableLabel("Leader", Sort, "leader"))

    local lLevel = OQ:ClickableLabel("Level", Sort, "lvl");
    lLevel = OQ:TableLabelAlign(lLevel, "RIGHT")
    table:AddChild(lLevel)

    local lILvl = OQ:ClickableLabel("iLvl", Sort, "ilvl");
    lILvl = OQ:TableLabelAlign(lILvl, "RIGHT")
    table:AddChild(lILvl)

    local lStat1 = OQ:ClickableLabel("Stat 1", Sort, "stat1");
    lStat1 = OQ:TableLabelAlign(lStat1, "RIGHT")
    table:AddChild(lStat1)

    local lStat2 = OQ:ClickableLabel("Stat 2", Sort, "stat2");
    lStat2 = OQ:TableLabelAlign(lStat2, "RIGHT")
    table:AddChild(lStat2)

    table:AddChild(OQ:ClickableLabel("Action", Sort, "action"))
    table:AddChild(OQ:ClickableLabel("", Sort, ""))

    -- Temp stuff for layout testing
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)

    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)

    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)

    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)

    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
    PremadeItem(table, "SH", "Premade test", "Maczuga-evermoon", 90, 553, 25, 20)
end

function Sort(...)
    print(...)
end

function PremadeItem(parent, classOrSpec, name, character, level, iLvl, stat1, stat2)
    local icon = oq.get_class_icon(classOrSpec or "SH", 16, 16)

    local lIcon = OQ:SimpleLabel(parent, icon)
    local lName = OQ:SimpleLabel(parent, name)
    local lChar = OQ:SimpleLabel(parent, character)
    local lLevel = OQ:SimpleLabel(parent, level)
    lLevel = OQ:TableLabelAlign(lLevel, "RIGHT")
    local lILvl = OQ:SimpleLabel(parent, iLvl)
    lILvl = OQ:TableLabelAlign(lILvl, "RIGHT")
    local lStat1 = OQ:SimpleLabel(parent, stat1)
    lStat1 = OQ:TableLabelAlign(lStat1, "RIGHT")
    local lStat2 = OQ:SimpleLabel(parent, stat2)
    lStat2 = OQ:TableLabelAlign(lStat2, "RIGHT")

    local bQueue = AceGUI:Create("Button")
    bQueue:SetText("Queue")
    bQueue.text:SetFont(STANDARD_TEXT_FONT, 10, nil)
    local bHide = AceGUI:Create("Button")
    bHide:SetText("x")
    bHide:SetAutoWidth(false)
    bHide.text:SetFont(STANDARD_TEXT_FONT, 10, nil)

    parent:AddChild(lIcon);
    parent:AddChild(lName);
    parent:AddChild(lChar);
    parent:AddChild(lLevel);
    parent:AddChild(lILvl);
    parent:AddChild(lStat1);
    parent:AddChild(lStat2);
    parent:AddChild(bQueue);
    parent:AddChild(bHide);
end
