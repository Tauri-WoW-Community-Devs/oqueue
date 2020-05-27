local addonName, OQ = ...

if (string.sub(GetCVar('realmList'), 1, 2) ~= 'hu') then
    return
end

OQ.REGION = 'hu'
OQ.SK_BTAG = 'Maczuga'
OQ.SK_NAME = 'Maczuga'
OQ.SK_REALM = '[EN] Evermoon'
OQ.DEFAULT_PREMADE_TEXT = ''

OQ.BGROUP_ICON = {['Tauri Cross Realm'] = 'Interface\\Icons\\Spell_Shadow_Misery'}

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

OQ.gbl = {}
