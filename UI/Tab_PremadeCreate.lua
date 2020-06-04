local addonName, OQ = ...
local oq = OQ:mod()

local AceGUI = LibStub('AceGUI-3.0')

local allClasses = {}
for id in pairs(OQ.CLASSES) do
    if (id ~= "XX") then
        allClasses[id] = 1
    end
end

local allRoles = {}
for i = 1, 3 do
    allRoles[i] = OQ.ROLES[i]
end
-- for id, label in pairs(OQ.CLASSES) do
--     allClasases[id] = 1
-- end

if (oq.PremadeData == nil) then
    oq.PremadeData = {}
    oq.PremadeData.activity = OQ.TYPE_RAID
    oq.PremadeData.roles = allRoles
    oq.PremadeData.classes = allClasses
    oq.PremadeData.voip = OQ.VOIP_UNSPECIFIED
    oq.PremadeData.language = OQ.LANG_UNSPECIFIED
end
local form = oq.PremadeData

local dActivity, dSubType, dDifficulty, dRoles, dClasses, groupPvP, bSubmit

function OQ:InitTab_PremadeCreate(tab)
    local scroll = OQ:InitScroll(tab)

    dActivity = OQ:CreateDropdown(OQ._premade_types, ChangePremadeType)
    dActivity:SetLabel('Activity')
    dActivity:SetText("Select activity...")
    dActivity:SetFullWidth(true)
    dActivity:SetValue(form.activity)
    scroll:AddChild(dActivity)

    local gTypeDiff = AceGUI:Create("SimpleGroup")
    gTypeDiff:SetLayout("Flow")
    gTypeDiff:SetFullWidth(true)
    scroll:AddChild(gTypeDiff)

    dSubType = OQ:CreateDropdown(OQ.raids, ChangeLocation)
    dSubType:SetRelativeWidth(0.7)
    dSubType:SetValue(form.subType)
    gTypeDiff:AddChild(dSubType)

    dDifficulty = OQ:CreateDropdown(OQ.difficulty_selections, ChangeDifficulty)
    -- dDifficulty:SetLabel('Difficulty')
    dDifficulty:SetRelativeWidth(0.3)
    dDifficulty:SetValue(form.difficulty)
    gTypeDiff:AddChild(dDifficulty)

    UpdateLocationDropdown()
    UpdatedDifficulty()

    local gRoleClassVoipLang = AceGUI:Create("SimpleGroup")
    gRoleClassVoipLang:SetLayout("Flow")
    gRoleClassVoipLang:SetFullWidth(true)
    scroll:AddChild(gRoleClassVoipLang)

    dRoles = OQ:CreateDropdown(RolesFormatValues(), ChangeRoles)
    dRoles:SetLabel("Roles")
    dRoles:SetMultiselect(true)
    dRoles:SetRelativeWidth(0.25)
    dRoles:SetMSValue(form.roles)
    UpdateRolesDropdown();
    gRoleClassVoipLang:AddChild(dRoles)

    dClasses = OQ:CreateDropdown(ClassesFormatValues(), ChangeClasses)
    dClasses:SetLabel("Classes")
    dClasses:SetMultiselect(true)
    dClasses:SetRelativeWidth(0.25)
    dClasses:SetMSValue(form.classes)
    UpdateClassesDropdown();
    gRoleClassVoipLang:AddChild(dClasses)

    local dVOIP = OQ:CreateDropdown(VOIPFormatValues(), ChangeVOIP)
    dVOIP:SetLabel("VOIP")
    dVOIP:SetRelativeWidth(0.25)
    dVOIP:SetValue(form.voip)
    gRoleClassVoipLang:AddChild(dVOIP)

    local dLanguage = OQ:CreateDropdown(LanguageFormatValues(), ChangeLanguage)
    dLanguage:SetLabel("Language")
    dLanguage:SetRelativeWidth(0.25)
    dLanguage:SetValue(form.language)
    gRoleClassVoipLang:AddChild(dLanguage)

    local gTitlePass = AceGUI:Create("SimpleGroup")
    gTitlePass:SetLayout("Flow")
    gTitlePass:SetFullWidth(true)
    scroll:AddChild(gTitlePass)

    local txtTitle = AceGUI:Create("EditBox")
    txtTitle:SetLabel("Title")
    txtTitle:SetRelativeWidth(0.75)
    txtTitle:SetText(form.title)
    txtTitle:SetCallback("OnEnterPressed", function (_, _, value)
        form.title = value
    end)
    gTitlePass:AddChild(txtTitle)

    local txtPassword = AceGUI:Create("EditBox")
    txtPassword:SetLabel("Password")
    txtPassword:SetRelativeWidth(0.25)
    txtPassword:SetText(form.password)
    txtPassword:SetCallback("OnEnterPressed", function (_, _, value)
        form.password = value
    end)
    gTitlePass:AddChild(txtPassword)

    local txtDesc = AceGUI:Create("MultiLineEditBox")
    txtDesc:SetLabel("Description")
    txtDesc:SetNumLines(4)
    txtDesc:SetFullWidth(true)
    txtDesc:SetText(form.description or "")
    txtDesc:SetCallback("OnEnterPressed", function (_, _, value)
        form.description = value
    end)
    scroll:AddChild(txtDesc)

    local txtILvl = AceGUI:Create("EditBox")
    txtILvl:SetLabel("Min. item level")
    txtILvl:SetText(form.ilvl)
    txtILvl:SetCallback("OnEnterPressed", function (_, _, value)
        form.ilvl = value
    end)
    scroll:AddChild(txtILvl)

    groupPvP = AceGUI:Create("SimpleGroup")
    groupPvP:SetLayout("Flow")
    groupPvP:SetFullWidth(true)
    scroll:AddChild(groupPvP)

    local txtPvPPower = AceGUI:Create("EditBox")
    txtPvPPower:SetLabel("PvP Power")
    txtPvPPower:SetRelativeWidth(0.5)
    txtPvPPower:SetText(form.pvpPower)
    txtPvPPower:SetCallback("OnEnterPressed", function (_, _, value)
        form.pvpPower = value
    end)
    groupPvP:AddChild(txtPvPPower)

    local txtMMR = AceGUI:Create("EditBox")
    txtMMR:SetLabel("MMR")
    txtMMR:SetRelativeWidth(0.5)
    txtMMR:SetText(form.mmr)
    txtMMR:SetCallback("OnEnterPressed", function (_, _, value)
        form.mmr = value
    end)
    groupPvP:AddChild(txtMMR)

    bSubmit = AceGUI:Create("Button")
    bSubmit:SetText("Create premade")
    bSubmit:SetRelativeWidth(1)
    bSubmit:SetCallback('OnClick', SubmitPremade)
    scroll:AddChild(bSubmit)
end

function ChangePremadeType(id)
    form.activity = id
    UpdateLocationDropdown()
    UpdatedDifficulty()
    UpdatePvPFields()
end

function ChangeLocation(id)
    form.subType = id
end

function UpdateLocationDropdown()
    local activityId = form.activity
    local disable = activityId ~= OQ.TYPE_CHALLENGE and activityId ~= OQ.TYPE_DUNGEON and activityId ~= OQ.TYPE_RAID

    dSubType:SetDisabled(disable)
    dSubType:SetValue(nil)
    ChangeLocation(nil)
    if (not disable) then
        dSubType:SetText('Select raid/dungeon')
    end
end

function ChangeDifficulty(id)
    form.difficulty = id
end

function UpdatedDifficulty()
    local activityId = form.activity
    local disable = activityId ~= OQ.TYPE_DUNGEON and activityId ~= OQ.TYPE_RAID

    dDifficulty:SetDisabled(disable)
    dDifficulty:SetValue(nil)
    ChangeDifficulty(nil)
    if (not disable) then
        dDifficulty:SetText('Select difficulty')
    end
end

function ChangeRoles(value)
    form.roles = value
    UpdateRolesDropdown()
end

function UpdateRolesDropdown()
    if (OQ:TableLength(form.roles) == OQ:TableLength(allRoles)) then
        dRoles:SetText("All roles")
    end
end

function RolesFormatValues()
    return {
        [1] = oq.get_role_icon("T", 16, 16) .. OQ.ROLES[1],
        [2] = oq.get_role_icon("H", 16, 16) .. OQ.ROLES[2],
        [3] = oq.get_role_icon("D", 16, 16) .. OQ.ROLES[3],
    }
end

function ChangeClasses(value)
    form.classes = value
    UpdateClassesDropdown();
end

function UpdateClassesDropdown()
    -- For some reason this doesn't work
    if (OQ:TableLength(form.classes) == OQ:TableLength(allClasses)) then
        dClasses:SetText("All classes")
    end
end

function ClassesFormatValues()
    local result = {}
    for id, label in pairs(OQ.CLASSES) do
        if (id ~= "XX") then
            result[id] = oq.get_class_icon(id, 16, 16) .. label
        end
    end
    return result
end

function ChangeVOIP(id)
    form.voip = id or OQ.VOIP_UNSPECIFIED
end

function VOIPFormatValues()
    local result = {}
    for id, label in pairs(OQ.voip_selections) do
        local t = '|T'
        if (OQ.VOIP_ICON[id]) then
            t = t .. OQ.VOIP_ICON[id]
        else
            t = t .. 'Interface\\Addons\\oqueue\\art\\voip_unk.tga'
        end
        t = t .. '12:12:0:0|t  ' .. label
        result[id] = t
    end
    return result
end

function ChangeLanguage(id)
    form.language = id or OQ.LANG_UNSPECIFIED
end

function LanguageFormatValues()
    local result = {}
    for id, label in pairs(OQ.lang_selections) do
        local t = '|T'
        if (OQ.LANG_ICON[id]) then
            t = t .. OQ.LANG_ICON[id]
        else
            t = t .. 'Interface\\Addons\\oqueue\\art\\lang_unk.tga'
        end
        t = t .. '12:12:0:0|t  ' .. label
        result[id] = t
    end
    return result
end

function UpdatePvPFields()
    local activityId = form.activity
    local isPvP = activityId == OQ.TYPE_ARENA or activityId == OQ.TYPE_BG or activityId == OQ.TYPE_RBG

    if (isPvP) then
        groupPvP.frame:Show();
    else
        groupPvP.frame:Hide();
    end
end

function SubmitPremade()
    -- oq.debug(form)

    local rc = nil
    if (oq.raid == nil) then
        rc = oq.raid_create()
        if (rc) then
            rc = oq.update_premade_note()
            bSubmit:SetText(OQ.UPDATE_BUTTON)
        end
    else
        rc = oq.update_premade_note()
    end
end
