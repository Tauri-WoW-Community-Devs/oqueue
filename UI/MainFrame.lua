local addonName, OQ = ...
local oq = OQ:mod()
local _

local AceGUI = LibStub('AceGUI-3.0')

OQ.TAB_ID_PREMADE_MY = 1
OQ.TAB_ID_PREMADE_LIST = 2
OQ.TAB_ID_PREMADE_CREATE = 3
OQ.TAB_ID_SCORE = 4
OQ.TAB_ID_SETTINGS = 5
OQ.TAB_ID_BAN_LIST = 6
OQ.TAB_ID_WAIT_LIST = 7
OQ.ActiveTab = nil

function Test()
    local data = {
        {
            "Sachmo",
            12,
            4
        },
        {
            "Josua",
            8,
            2
        }
    };

    local cols = {
        {
            ["name"] = "",
            ["width"] = 25,
            ["align"] = "CENTER",
            ["colorargs"] = nil,
            ["defaultsort"] = "dsc",
            ["sortnext"] = 4,
            ["comparesort"] = function(cella, cellb, column)
                return cella.value < cellb.value;
            end,
            ["DoCellUpdate"] = nil
        },
        {
            ["name"] = "Premade name",
            ["width"] = 200,
            ["align"] = "LEFT",
            ["colorargs"] = nil,
            ["defaultsort"] = "dsc",
            ["sortnext"] = 4,
            ["comparesort"] = function(cella, cellb, column)
                return cella.value < cellb.value;
            end,
            ["DoCellUpdate"] = nil
        },
        {
            ["name"] = "Leader",
            ["width"] = 150,
            ["align"] = "LEFT",
            ["colorargs"] = nil,
            ["defaultsort"] = "dsc",
            ["sortnext"] = 4,
            ["comparesort"] = function(cella, cellb, column)
                return cella.value < cellb.value;
            end,
            ["DoCellUpdate"] = nil
        },
        {
            ["name"] = "Level",
            ["width"] = 50,
            ["align"] = "RIGHT",
            ["colorargs"] = nil,
            ["defaultsort"] = "dsc",
            ["sortnext"] = 4,
            ["comparesort"] = function(cella, cellb, column)
                return cella.value < cellb.value;
            end,
            ["DoCellUpdate"] = nil
        },
        {
            ["name"] = "iLvl",
            ["width"] = 50,
            ["align"] = "RIGHT",
            ["colorargs"] = nil,
            ["defaultsort"] = "dsc",
            ["sortnext"] = 4,
            ["comparesort"] = function(cella, cellb, column)
                return cella.value < cellb.value;
            end,
            ["DoCellUpdate"] = nil
        },
        {
            ["name"] = "Stat 1",
            ["width"] = 50,
            ["align"] = "RIGHT",
            ["colorargs"] = nil,
            ["defaultsort"] = "dsc",
            ["sortnext"] = 4,
            ["comparesort"] = function(cella, cellb, column)
                return cella.value < cellb.value;
            end,
            ["DoCellUpdate"] = nil
        },
        {
            ["name"] = "Stat 2",
            ["width"] = 50,
            ["align"] = "RIGHT",
            ["colorargs"] = nil,
            ["defaultsort"] = "dsc",
            ["sortnext"] = 4,
            ["comparesort"] = function(cella, cellb, column)
                return cella.value < cellb.value;
            end,
            ["DoCellUpdate"] = nil
        },
        {
            ["name"] = "",
            ["width"] = 50,
            ["align"] = "RIGHT",
            ["colorargs"] = nil,
            ["defaultsort"] = "dsc",
            ["sortnext"] = 4,
            ["comparesort"] = function(cella, cellb, column)
                return cella.value < cellb.value;
            end,
            ["DoCellUpdate"] = nil
        }
    }

    local frame = AceGUI:Create("Frame")

    local ScrollingTable = LibStub("ScrollingTable");
    local table = ScrollingTable:CreateST(cols, 12, 15, nil, frame.frame);
    table.frame:SetPoint("TOPLEFT", 15, -40)
    table.frame:SetPoint("BOTTOMRIGHT", -15, 45)
    -- table.frame:SetFrameLevel(frame.frame:GetFrameLevel() + 10)
    -- frame:AddChild(table)
end
local tabControl
function OQ:Init_MainFrame()
    Test()
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(OQ.TITLE_LEFT .. "TODO VERSION" .. OQ.TITLE_RIGHT)
    frame:SetStatusText("Premades: 0/0")
    frame:SetLayout("Fill")
    frame:Hide()

    frame:SetCallback('OnShow', function(widget)
        oq.onShow(widget)
    end)

    local function OnTabChange(container, event, group)
        container:ReleaseChildren()
        OQ.ActiveTab = group
        if (group == OQ.TAB_ID_PREMADE_MY) then
            OQ:InitTab_PremadeMy(container)
        elseif (group == OQ.TAB_ID_PREMADE_LIST) then
            OQ:InitTab_PremadeList(container)
        elseif (group == OQ.TAB_ID_PREMADE_CREATE) then
            OQ:InitTab_PremadeCreate(container)
        elseif (group == OQ.TAB_ID_SCORE) then
            OQ:InitTab_Score(container)
        elseif (group == OQ.TAB_ID_SETTINGS) then
            OQ:InitTab_Settings(container)
        elseif (group == OQ.TAB_ID_SETTINGS) then
            OQ:InitTab_BanList(container)
        elseif (group == OQ.TAB_ID_WAIT_LIST) then
            OQ:InitTab_WaitList(container)
        end
    end

    -- Create the TabGroup
    tabControl = AceGUI:Create("TabGroup")
    tabControl:SetLayout("Flow")
    tabControl:SetCallback("OnGroupSelected", OnTabChange)
    tabControl:SelectTab(OQ.TAB_ID_SETTINGS)
    OQ:BuildTabs()
    -- tab:SelectTab(OQ.TAB_ID_PREMADE_LIST)

    frame:AddChild(tabControl)
    return frame
end

function OQ:BuildTabs()
    local base = {
        {
            text = "Premade",
            value = OQ.TAB_ID_PREMADE_MY
        },
        {
            text = "Find premade",
            value = OQ.TAB_ID_PREMADE_LIST
        },
        {
            text = "Create premade",
            value = OQ.TAB_ID_PREMADE_CREATE
        },
        {
            text = "Score",
            value = OQ.TAB_ID_SCORE
        },
        {
            text = "Settings",
            value = OQ.TAB_ID_SETTINGS
        },
        {
            text = "Ban list",
            value = OQ.TAB_ID_BAN_LIST
        },
        {
            text = "Waitlist",
            value = OQ.TAB_ID_WAIT_LIST
        }
    };

    -- Always work from the end to start so we can iterate `base` via TAB_ID_XXX

    if (oq.raid == nil) then
        base[OQ.TAB_ID_WAIT_LIST] = nil
    else
        local waiting = oq.n_waiting()
        base[OQ.TAB_ID_WAIT_LIST].text = string.format(OQ.TAB_WAITLISTN, waiting)
    end

    if (oq.rbgs_group == nil and oq.raid_group == nil and oq.tab1_group == nil) then
        base[OQ.TAB_ID_PREMADE_MY] = nil
    end

    if (base[OQ.ActiveTab] == nil) then
        -- tabControl:SelectTab(OQ.TAB_ID_PREMADE_LIST)
    end

    local tabs = {}
    local i = 1
    for _, v in pairs(base) do
        tabs[i] = v
        i = i + 1
    end

    tabControl:SetTabs(tabs)
end

function OQ:TabVisible(id)
    return OQ.ActiveTab == id
end
