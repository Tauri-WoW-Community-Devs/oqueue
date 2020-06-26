local addonName, OQ = ...

if (string.sub(GetCVar('realmList'), 1, 2) ~= 'hu') then
    return
end

OQ.REGION = 'hu'
OQ.DEFAULT_PREMADE_TEXT = ''

OQ.REALMS = {
    -- Those 3 are only used to get realm ID from GetRealmName()
    ['[EN] Evermoon'] = 'evermoon',
    ['[HU] Tauri WoW Server'] = 'tauri',
    ['[HU] Warriors of Darkness'] = 'wod',

    -- Those are actually used
    ['evermoon'] = 1,
    ['tauri'] = 2,
    ['wod'] = 3,
    [1] = 'evermoon',
    [2] = 'tauri',
    [3] = 'wod'
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
