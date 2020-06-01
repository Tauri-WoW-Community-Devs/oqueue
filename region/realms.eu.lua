local addonName, OQ = ...

if (string.sub(GetCVar('realmList'), 1, 2) ~= 'hu') then
    return
end

OQ.REGION = 'hu'
OQ.SCOREKEEPER_BATTLE_TAG = 'maczuga-evermoon'
OQ.SCOREKEEPER_NAME = 'Maczuga'
OQ.SCOREKEEPER_REALM = '[EN] Evermoon'
OQ.DEFAULT_PREMADE_TEXT = ''

OQ.BGROUP_ICON = {['Tauri Cross Realm'] = 'Interface\\Icons\\achievement_character_tauren_male'}

OQ.REALMNAMES_SPECIAL = {}

OQ.BGROUPS = {
    ['Tauri Cross Realm'] = {
        '[EN] Evermoon',
        '[HU] Tauri WoW Server',
        '[HU] Warriors of Darkness'
    }
}

OQ.SHORT_BGROUPS = {
    ['[EN] Evermoon'] = 1, -- [1]
    ['[HU] Tauri WoW Server'] = 2, -- [2]
    ['[HU] Warriors of Darkness'] = 3, -- [3]
    [1] = '[EN] Evermoon',
    [2] = '[HU] Tauri WoW Server',
    [3] = '[HU] Warriors of Darkness'
}

-- Used for whispers, invites etc.
OQ.REALMNAMES_SHORTCUTS = {
    ['[EN] Evermoon'] = "evermoon", -- [1]
    ['[HU] Tauri WoW Server'] = "tauri", -- [2]
    ['[HU] Warriors of Darkness'] = "wod", -- [3]
    [1] = 'evermoon',
    [2] = 'tauri',
    [3] = 'wod'
}

OQ.gbl = {}
