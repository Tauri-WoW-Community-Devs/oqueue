local addonName, OQ = ...
local oq = OQ:mod()
local _

local AceGUI = LibStub('AceGUI-3.0')

function OQ:Init_MainFrame()local frame = AceGUI:Create("Frame")
    frame:SetTitle(OQ.TITLE_LEFT .. OQUEUE_VERSION .. OQ.TITLE_RIGHT)
    frame:SetStatusText("Premades: 0/0")
    frame:SetLayout("Fill")
    frame:Hide()

    frame:SetCallback('OnShow', function(widget) oq.onShow(widget) end)

    local function OnTabChange(container, event, group)
        container:ReleaseChildren()
        if (group == "tabPremadeMy") then
            OQ:InitTab_PremadeMy(container)
        elseif (group == "tabPremadeList") then
            OQ:InitTab_PremadeList(container)
        elseif (group == "tabPremadeCreate") then
            OQ:InitTab_PremadeCreate(container)
        elseif (group == "tabScore") then
            OQ:InitTab_Score(container)
        elseif (group == "tabSettings") then
            OQ:InitTab_Settings(container)
        elseif (group == "tabBanList") then
            OQ:InitTab_BanList(container)
        elseif (group == "tabWaitList") then
            OQ:InitTab_WaitList(container)
        end
    end

    -- Create the TabGroup
    local tab =  AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    -- Setup which tabs to show
    tab:SetTabs({
        {text="Premade", value="tabPremadeMy"}, 
        {text="Find premade", value="tabPremadeList"},
        {text="Create premade", value="tabPremadeCreate"},
        {text="Score", value="tabScore"},
        {text="Settings", value="tabSettings"},
        {text="Ban list", value="tabBanList"},
        {text="Waitlist", value="tabWaitList"},
    })
    
    -- Register callback
    tab:SetCallback("OnGroupSelected", OnTabChange)
    -- Set initial Tab (this will fire the OnGroupSelected callback)
    tab:SelectTab("tabPremadeCreate")
    -- add to the frame container
    frame:AddChild(tab)
end