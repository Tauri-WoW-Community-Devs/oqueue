local addonName, OQ = ...
OQ._T = {} -- used for literal string conversations
local function defaultFunc(L, key)
    -- If this function was called, we have no localization for this key.
    -- We could complain loudly to allow localizers to see the error of their ways,
    -- but, for now, just return the key as its own localization. This allows you to�avoid writing the default localization out explicitly.
    return key
end
setmetatable(OQ._T, {__index = defaultFunc})
local L = OQ._T

OQ.FONT = 'Fonts\\FRIZQT__.TTF'
if (string.sub(GetCVar('realmList'), 1, 2) == 'eu') then
    -- force to unicode supported font, allowing cyrillic fonts to render properly
    OQ.FONT = 'Interface\\Addons\\oqueue\\fonts\\ARIALB.TTF'
end

OQ.FACTION_ICON = {}
OQ.FACTION_ICON['H'] = '|TInterface\\BattlefieldFrame\\Battleground-Horde.blp:20:20:0:0|t'
OQ.FACTION_ICON['A'] = '|TInterface\\BattlefieldFrame\\Battleground-Alliance.blp:20:20:0:0|t'
OQ.LOCK = '|TInterface\\BUTTONS\\UI-Button-KeyRing.blp:28:20:0:0:20:24:0:16:0:16|t'
OQ.KEY = 'Interface\\BUTTONS\\UI-Button-KeyRing'
OQ.LILREDX_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:8:8:0:0:64:64:32:48:16:32|t'
OQ.LILSKULL_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:10:10:0:0:64:64:48:64:16:32|t'
OQ.LILTRIANGLE_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:8:8:0:0:64:64:48:64:0:16|t'
OQ.LILDIAMOND_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:8:8:0:0:64:64:32:48:0:16|t'
OQ.LILSTAR_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:8:8:0:0:64:64:0:16:0:16|t'
OQ.LILREDX_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:8:8:0:0:64:64:32:48:16:32|t'
OQ.LILSKULL_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:10:10:0:0:64:64:48:64:16:32|t'
OQ.LILCIRCLE_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:8:8:0:0:64:64:16:32:0:16|t'
OQ.GREEN_DOT = '|TINTERFACE\\COMMON\\Indicator-Green.blp:12:12:0:0:32:32|t'
OQ.RED_DOT = '|TINTERFACE\\COMMON\\Indicator-Red.blp:12:12:0:0:32:32|t'
OQ.BIGDIAMOND_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:16:16:0:0:64:64:32:48:0:16|t'
OQ.STAR_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:16:16:0:0:64:64:0:16:0:16|t'
OQ.CIRCLE_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:16:16:0:0:64:64:16:32:0:16|t'
OQ.DIAMOND_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:10:10:0:0:64:64:32:48:0:16|t'
OQ.TRIANGLE_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:16:16:0:0:64:64:48:64:0:16|t'
OQ.MOON_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:16:16:0:0:64:64:0:16:16:32|t'
OQ.SQUARE_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:16:16:0:0:64:64:16:32:16:32|t'
OQ.REDX_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:16:16:0:0:64:64:32:48:16:32|t'
OQ.SKULL_ICON = '|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcons.blp:16:16:0:0:64:64:48:64:16:32|t'
OQ.PENDING_NOTE_UP = 'INTERFACE/BUTTONS/UI-GuildButton-OfficerNote-Up.png'
OQ.PENDING_NOTE_DN = 'INTERFACE/BUTTONS/UI-GuildButton-PublicNote-Up.png'
OQ.PENDING_NOTE_OFF = 'INTERFACE/BUTTONS/UI-GuildButton-OfficerNote-Disabled.png'

OQ.ICON_NONE = 0
OQ.ICON_STAR = 1
OQ.ICON_CIRCLE = 2
OQ.ICON_DIAMOND = 3
OQ.ICON_TRIANGLE = 4
OQ.ICON_MOON = 5
OQ.ICON_SQUARE = 6
OQ.ICON_REDX = 7
OQ.ICON_SKULL = 8

OQ.ICON_STRINGS = {
    [OQ.ICON_NONE] = nil,
    [OQ.ICON_STAR] = OQ.STAR_ICON,
    [OQ.ICON_CIRCLE] = OQ.CIRCLE_ICON,
    [OQ.ICON_DIAMOND] = OQ.DIAMOND_ICON,
    [OQ.ICON_TRIANGLE] = OQ.TRIANGLE_ICON,
    [OQ.ICON_MOON] = OQ.MOON_ICON,
    [OQ.ICON_SQUARE] = OQ.SQUARE_ICON,
    [OQ.ICON_REDX] = OQ.REDX_ICON,
    [OQ.ICON_SKULL] = OQ.SKULL_ICON
}

OQ.ICON_COORDS = {
    [OQ.ICON_NONE] = {0.00, 0.00, 0.00, 0.00},
    [OQ.ICON_STAR] = {0.00, 0.25, 0.00, 0.25},
    [OQ.ICON_CIRCLE] = {0.25, 0.50, 0.00, 0.25},
    [OQ.ICON_DIAMOND] = {0.50, 0.75, 0.00, 0.25},
    [OQ.ICON_TRIANGLE] = {0.75, 1.00, 0.00, 0.25},
    [OQ.ICON_MOON] = {0.00, 0.25, 0.25, 0.50},
    [OQ.ICON_SQUARE] = {0.25, 0.50, 0.25, 0.50},
    [OQ.ICON_REDX] = {0.50, 0.75, 0.25, 0.50},
    [OQ.ICON_SKULL] = {0.75, 1.00, 0.25, 0.50}
}

OQ.CHK_VLIST_TM = 15

OQ.FLAG_ONLINE = 0x01
OQ.FLAG_DESERTER = 0x02
OQ.FLAG_QUEUED = 0x04
OQ.FLAG_BRB = 0x08
OQ.FLAG_TANK = 0x10
OQ.FLAG_HEALER = 0x20
OQ.FLAG_CLEAR = 0x00
OQ.FLAG_READY = 0x01
OQ.FLAG_NOTREADY = 0x02
OQ.FLAG_WAITING = 0x04

OQ.FONT_FIXED = 'Interface\\Addons\\oqueue\\fonts\\lucida_console.ttf'
OQ.BOUNTY_UP = 'INTERFACE/BUTTONS/UI-MICROBUTTON-SOCIALS-UP'
OQ.BOUNTY_DN = 'INTERFACE/BUTTONS/UI-MICROBUTTON-SOCIALS-DOWN'
OQ.NOBOUNTY_A = 'INTERFACE/BUTTONS/UI-MicroButton-Guild-Disabled-Alliance'
OQ.NOBOUNTY_H = 'INTERFACE/BUTTONS/UI-MicroButton-Guild-Disabled-Horde'
OQ.LOGBUTTON_UP = 'INTERFACE/BUTTONS/UI-MicroButton-Spellbook-Up'
OQ.LOGBUTTON_DN = 'INTERFACE/BUTTONS/UI-MicroButton-Spellbook-Down'
OQ.X_BUTTON_UP = 'INTERFACE/BUTTONS/UI-Panel-MinimizeButton-Up'
OQ.X_BUTTON_DN = 'INTERFACE/BUTTONS/UI-Panel-MinimizeButton-Down'
OQ.RND = 0
OQ.TP = 1
OQ.BFG = 2
OQ.WSG = 3
OQ.AB = 4
OQ.EOTS = 5
OQ.AV = 6
OQ.SOTA = 7
OQ.IOC = 8
OQ.SSM = 9
OQ.TOK = 10
OQ.DWG = 11
OQ.NONE = 15
OQ.DKP = 16

OQ.TYPE_NONE = 'X'
OQ.TYPE_BG = 'B'
OQ.TYPE_RBG = 'A'
OQ.TYPE_RAID = 'R'
OQ.TYPE_DUNGEON = 'D'
OQ.TYPE_SCENARIO = 'S'
OQ.TYPE_ARENA = 'a'
OQ.TYPE_QUESTS = 'Q'
OQ.TYPE_LADDER = 'L'
OQ.TYPE_CHALLENGE = 'C'
OQ.TYPE_MISC = 'M'
OQ.TYPE_ROLEPLAY = 'P'

OQ.VOIP_DISCORD = 'd'
OQ.VOIP_DOLBYAXON = 'D'
OQ.VOIP_MUMBLE = 'M'
OQ.VOIP_NOVOICE = '0'
OQ.VOIP_RAIDCALL = 'R'
OQ.VOIP_RAZOR = 'r'
OQ.VOIP_SKYPE = 'S'
OQ.VOIP_TEAMSPEAK = 'T'
OQ.VOIP_UNSPECIFIED = '-'
OQ.VOIP_VENTRILO = 'V'
OQ.VOIP_WOWVOIP = 'W'

OQ.VOIP_ICON = {
    [OQ.VOIP_VENTRILO] = 'Interface\\Addons\\oqueue\\art\\voip_ventrilo.tga',
    [OQ.VOIP_SKYPE] = 'Interface\\Addons\\oqueue\\art\\voip_skype.tga',
    [OQ.VOIP_TEAMSPEAK] = 'Interface\\Addons\\oqueue\\art\\voip_teamspeak.tga',
    [OQ.VOIP_DOLBYAXON] = 'Interface\\Addons\\oqueue\\art\\voip_axon.tga',
    [OQ.VOIP_DISCORD] = 'Interface\\Addons\\oqueue\\art\\voip_discord.tga',
    [OQ.VOIP_RAIDCALL] = 'Interface\\Addons\\oqueue\\art\\voip_raidcall.tga',
    [OQ.VOIP_RAZOR] = 'Interface\\Addons\\oqueue\\art\\voip_razor.tga',
    [OQ.VOIP_MUMBLE] = 'Interface\\Addons\\oqueue\\art\\voip_mumble.tga',
    [OQ.VOIP_UNSPECIFIED] = nil,
    [OQ.VOIP_NOVOICE] = 'Interface\\Addons\\oqueue\\art\\voip_novoice.tga',
    [OQ.VOIP_WOWVOIP] = 'Interface\\Addons\\oqueue\\art\\voip_wowvoip.tga'
}

OQ.LANG_UNSPECIFIED = 'A'
OQ.LANG_US_ENGLISH = 'B'
OQ.LANG_UK_ENGLISH = 'C'
OQ.LANG_OC_ENGLISH = 'D'
OQ.LANG_FRENCH = 'E'
OQ.LANG_GERMAN = 'F'
OQ.LANG_ITALIAN = 'G'
OQ.LANG_ES_SPANISH = 'H'
OQ.LANG_MX_SPANISH = 'I'
OQ.LANG_BR_PORTUGUESE = 'J'
OQ.LANG_PT_PORTUGUESE = 'K'
OQ.LANG_RUSSIAN = 'L'
OQ.LANG_TURKISH = 'M'
OQ.LANG_EURO = 'N'
OQ.LANG_GREEK = 'O'
OQ.LANG_DUTCH = 'P'
OQ.LANG_SWEDISH = 'Q'
OQ.LANG_ARABIC = 'R'
OQ.LANG_KOREAN = 'S'

OQ.LANG_ICON = {
    [OQ.LANG_UNSPECIFIED] = nil,
    [OQ.LANG_US_ENGLISH] = 'Interface\\Addons\\oqueue\\art\\lang_us.tga',
    [OQ.LANG_UK_ENGLISH] = 'Interface\\Addons\\oqueue\\art\\lang_uk.tga',
    [OQ.LANG_OC_ENGLISH] = 'Interface\\Addons\\oqueue\\art\\lang_oc.tga',
    [OQ.LANG_RUSSIAN] = 'Interface\\Addons\\oqueue\\art\\lang_ru.tga',
    [OQ.LANG_GERMAN] = 'Interface\\Addons\\oqueue\\art\\lang_de.tga',
    [OQ.LANG_ES_SPANISH] = 'Interface\\Addons\\oqueue\\art\\lang_es.tga',
    [OQ.LANG_MX_SPANISH] = 'Interface\\Addons\\oqueue\\art\\lang_mx.tga',
    [OQ.LANG_BR_PORTUGUESE] = 'Interface\\Addons\\oqueue\\art\\lang_br.tga',
    [OQ.LANG_PT_PORTUGUESE] = 'Interface\\Addons\\oqueue\\art\\lang_pt.tga',
    [OQ.LANG_FRENCH] = 'Interface\\Addons\\oqueue\\art\\lang_fr.tga',
    [OQ.LANG_ITALIAN] = 'Interface\\Addons\\oqueue\\art\\lang_it.tga',
    [OQ.LANG_TURKISH] = 'Interface\\Addons\\oqueue\\art\\lang_tr.tga',
    [OQ.LANG_EURO] = 'Interface\\Addons\\oqueue\\art\\lang_euro.tga',
    [OQ.LANG_GREEK] = 'Interface\\Addons\\oqueue\\art\\lang_greek.tga',
    [OQ.LANG_DUTCH] = 'Interface\\Addons\\oqueue\\art\\lang_nl.tga',
    [OQ.LANG_SWEDISH] = 'Interface\\Addons\\oqueue\\art\\lang_swedish.tga',
    [OQ.LANG_ARABIC] = 'Interface\\Addons\\oqueue\\art\\lang_arabic.tga',
    [OQ.LANG_KOREAN] = 'Interface\\Addons\\oqueue\\art\\lang_kr.tga'
}

OQ.PREMADE_TYPES = {
    [OQ.TYPE_NONE] = 1,
    [OQ.TYPE_BG] = 1,
    [OQ.TYPE_RBG] = 1,
    [OQ.TYPE_RAID] = 1,
    [OQ.TYPE_DUNGEON] = 1,
    [OQ.TYPE_SCENARIO] = 1,
    [OQ.TYPE_ARENA] = 1,
    [OQ.TYPE_QUESTS] = 1,
    [OQ.TYPE_LADDER] = 1,
    [OQ.TYPE_CHALLENGE] = 1,
    [OQ.TYPE_MISC] = 1,
    [OQ.TYPE_ROLEPLAY] = 1
}

OQ.DD_NONE = 'None'
OQ.DD_STAR = 'Star'
OQ.DD_CIRCLE = 'Circle'
OQ.DD_DIAMOND = 'Diamond'
OQ.DD_TRIANGLE = 'Triangle'
OQ.DD_MOON = 'Moon'
OQ.DD_SQUARE = 'Square'
OQ.DD_REDX = 'Cross'
OQ.DD_SKULL = 'Skull'

OQ.RACE_UNKNOWN = 0
OQ.RACE_DWARF = 1
OQ.RACE_DRAENEI = 2
OQ.RACE_GNOME = 3
OQ.RACE_HUMAN = 4
OQ.RACE_NIGHTELF = 5
OQ.RACE_WORGEN = 6
OQ.RACE_BLOODELF = 7
OQ.RACE_GOBLIN = 8
OQ.RACE_ORC = 9
OQ.RACE_TAUREN = 10
OQ.RACE_TROLL = 11
OQ.RACE_SCOURGE = 12
OQ.RACE_PANDAREN = 13

OQ.RACE = {
    ['Dwarf'] = OQ.RACE_DWARF,
    ['Draenei'] = OQ.RACE_DRAENEI,
    ['Gnome'] = OQ.RACE_GNOME,
    ['Human'] = OQ.RACE_HUMAN,
    ['NightElf'] = OQ.RACE_NIGHTELF,
    ['Worgen'] = OQ.RACE_WORGEN,
    ['BloodElf'] = OQ.RACE_BLOODELF,
    ['Goblin'] = OQ.RACE_GOBLIN,
    ['Orc'] = OQ.RACE_ORC,
    ['Tauren'] = OQ.RACE_TAUREN,
    ['Troll'] = OQ.RACE_TROLL,
    ['Scourge'] = OQ.RACE_SCOURGE,
    ['Pandaren'] = OQ.RACE_PANDAREN,
    ['Unknown'] = OQ.RACE_UNKNOWN
}

OQ.SHORT_RACE = {
    [OQ.RACE_DWARF] = 'Dw',
    [OQ.RACE_DRAENEI] = 'Dr',
    [OQ.RACE_GNOME] = 'Gn',
    [OQ.RACE_HUMAN] = 'Hu',
    [OQ.RACE_NIGHTELF] = 'Ne',
    [OQ.RACE_WORGEN] = 'Wo',
    [OQ.RACE_BLOODELF] = 'Be',
    [OQ.RACE_GOBLIN] = 'Go',
    [OQ.RACE_ORC] = 'Or',
    [OQ.RACE_TAUREN] = 'Ta',
    [OQ.RACE_TROLL] = 'Tr',
    [OQ.RACE_SCOURGE] = 'Un',
    [OQ.RACE_PANDAREN] = 'Pa',
    [OQ.RACE_UNKNOWN] = 'xx'
}

OQ.WOW_RACE_ID = {
    [OQ.RACE_DWARF] = 3,
    [OQ.RACE_DRAENEI] = 11,
    [OQ.RACE_GNOME] = 7,
    [OQ.RACE_HUMAN] = 1,
    [OQ.RACE_NIGHTELF] = 4,
    [OQ.RACE_WORGEN] = 22,
    [OQ.RACE_BLOODELF] = 10,
    [OQ.RACE_GOBLIN] = 9,
    [OQ.RACE_ORC] = 2,
    [OQ.RACE_TAUREN] = 6,
    [OQ.RACE_TROLL] = 8,
    [OQ.RACE_SCOURGE] = 5,
    [OQ.RACE_PANDAREN] = 24,
    [OQ.RACE_UNKNOWN] = 0
}

OQ.FACTION = {
    ['Dwarf'] = 'A',
    ['Draenei'] = 'A',
    ['Gnome'] = 'A',
    ['Human'] = 'A',
    ['NightElf'] = 'A',
    ['Worgen'] = 'A',
    ['BloodElf'] = 'H',
    ['Goblin'] = 'H',
    ['Orc'] = 'H',
    ['Tauren'] = 'H',
    ['Troll'] = 'H',
    ['Scourge'] = 'H',
    ['Pandaren'] = 'X'
}

OQ.SHORT_LEVEL_RANGE = {
    ['UNK'] = 1,
    ['10 - 14'] = 2,
    ['15 - 19'] = 3,
    ['20 - 24'] = 4,
    ['25 - 29'] = 5,
    ['30 - 34'] = 6,
    ['35 - 39'] = 7,
    ['40 - 44'] = 8,
    ['45 - 49'] = 9,
    ['50 - 54'] = 10,
    ['55 - 59'] = 11,
    ['60 - 64'] = 12,
    ['65 - 69'] = 13,
    ['70 - 74'] = 14,
    ['75 - 79'] = 15,
    ['80 - 84'] = 16,
    ['85'] = 17,
    ['85 - 89'] = 18,
    ['90'] = 19,
    [1] = 'UNK',
    [2] = '10 - 14',
    [3] = '15 - 19',
    [4] = '20 - 24',
    [5] = '25 - 29',
    [6] = '30 - 34',
    [7] = '35 - 39',
    [8] = '40 - 44',
    [9] = '45 - 49',
    [10] = '50 - 54',
    [11] = '55 - 59',
    [12] = '60 - 64',
    [13] = '65 - 69',
    [14] = '70 - 74',
    [15] = '75 - 79',
    [16] = '80 - 84',
    [17] = '85',
    [18] = '85 - 89',
    [19] = '90'
}

OQ.CLASS_COLORS = {
    ['DK'] = {r = 0.77, g = 0.12, b = 0.23},
    ['DR'] = {r = 1.00, g = 0.49, b = 0.04},
    ['HN'] = {r = 0.67, g = 0.83, b = 0.45},
    ['MG'] = {r = 0.41, g = 0.80, b = 0.94},
    ['MK'] = {r = 0.00, g = 1.00, b = 0.59},
    ['PA'] = {r = 0.96, g = 0.55, b = 0.73},
    ['PR'] = {r = 1.00, g = 1.00, b = 1.00},
    ['RO'] = {r = 1.00, g = 0.96, b = 0.41},
    ['SH'] = {r = 0.00, g = 0.44, b = 0.87},
    ['LK'] = {r = 0.58, g = 0.51, b = 0.79},
    ['WA'] = {r = 0.78, g = 0.61, b = 0.43},
    ['XX'] = {r = 0.20, g = 0.20, b = 0.00},
    ['YY'] = {r = 0.20, g = 0.20, b = 0.00},
    ['ZZ'] = {r = 0.20, g = 0.20, b = 0.00}
}

OQ.ROLES = {
    ['DAMAGER'] = 1,
    ['HEALER'] = 2,
    ['NONE'] = 3,
    ['TANK'] = 4,
    [1] = 'DAMAGER',
    [2] = 'HEALER',
    [3] = 'NONE',
    [4] = 'TANK',
    ['D'] = 1,
    ['H'] = 2,
    ['N'] = 3,
    ['T'] = 4
}

OQ.ROLE_FLAG = {
    ['dps'] = 0x0001,
    ['heal'] = 0x0002,
    ['tank'] = 0x0004
}

OQ.CLASS_TEXTCLR = {
    ['DK'] = '|cFFC41F3B',
    ['DR'] = '|cFFFF7D0A',
    ['HN'] = '|cFFABD473',
    ['MG'] = '|cFF69CCF0',
    ['PA'] = '|cFFF58CBA',
    ['PR'] = '|cFFFFFFFF',
    ['RO'] = '|cFFFFF569',
    ['SH'] = '|cFF0070DE',
    ['LK'] = '|cFF9482C9',
    ['WA'] = '|cFFC79C6E'
}

OQ.SHORT_CLASS = {
    ['DEATHKNIGHT'] = 'DK',
    ['DEATH KNIGHT'] = 'DK',
    ['DRUID'] = 'DR',
    ['HUNTER'] = 'HN',
    ['MAGE'] = 'MG',
    ['MONK'] = 'MK',
    ['PALADIN'] = 'PA',
    ['PRIEST'] = 'PR',
    ['ROGUE'] = 'RO',
    ['SHAMAN'] = 'SH',
    ['WARLOCK'] = 'LK',
    ['WARRIOR'] = 'WA',
    ['NONE'] = 'XX',
    ['UNKNOWN'] = 'ZZ'
}

OQ.LONG_CLASS = {
    ['DK'] = 'DEATHKNIGHT',
    ['DR'] = 'DRUID',
    ['HN'] = 'HUNTER',
    ['MG'] = 'MAGE',
    ['MK'] = 'MONK',
    ['PA'] = 'PALADIN',
    ['PR'] = 'PRIEST',
    ['RO'] = 'ROGUE',
    ['SH'] = 'SHAMAN',
    ['LK'] = 'WARLOCK',
    ['WA'] = 'WARRIOR',
    ['XX'] = 'NONE',
    ['YY'] = 'UNK',
    ['ZZ'] = 'UNK'
}

OQ.TINY_CLASS = {
    ['DK'] = 'A',
    ['DR'] = 'B',
    ['HN'] = 'C',
    ['MG'] = 'D',
    ['MK'] = 'E',
    ['PA'] = 'F',
    ['PR'] = 'G',
    ['RO'] = 'H',
    ['SH'] = 'I',
    ['LK'] = 'J',
    ['WA'] = 'K',
    ['XX'] = 'L',
    ['YY'] = 'M',
    ['ZZ'] = 'N',
    ['A'] = 'DK',
    ['B'] = 'DR',
    ['C'] = 'HN',
    ['D'] = 'MG',
    ['E'] = 'MK',
    ['F'] = 'PA',
    ['G'] = 'PR',
    ['H'] = 'RO',
    ['I'] = 'SH',
    ['J'] = 'LK',
    ['K'] = 'WA',
    ['L'] = 'XX',
    ['M'] = 'YY',
    ['N'] = 'ZZ'
}

OQ.CLASS_FLAG = {
    ['DK'] = 0x0001,
    ['DR'] = 0x0002,
    ['HN'] = 0x0004,
    ['MG'] = 0x0008,
    ['MK'] = 0x0010,
    ['PA'] = 0x0020,
    ['PR'] = 0x0040,
    ['RO'] = 0x0080,
    ['SH'] = 0x0100,
    ['LK'] = 0x0200,
    ['WA'] = 0x0400
}

OQ.RDPS = 1
OQ.MDPS = 2
OQ.CASTER = 3
OQ.TANK = 4

OQ.CLASS_SPEC = {
    [250] = {id = 1, type = OQ.TANK, n = 'DK.Blood', spy = 'Tank'},
    [251] = {id = 2, type = OQ.MDPS, n = 'DK.Frost', spy = 'Melee'},
    [252] = {id = 3, type = OQ.MDPS, n = 'DK.Unholy', spy = 'Melee'},
    [102] = {id = 4, type = OQ.RDPS, n = 'DR.Balance', spy = 'Knockback'},
    [103] = {id = 5, type = OQ.RDPS, n = 'DR.Feral', spy = 'Melee'},
    [104] = {id = 6, type = OQ.TANK, n = 'DR.Guardian', spy = 'Tank'},
    [105] = {id = 7, type = OQ.CASTER, n = 'DR.Restoration', spy = 'Healer'},
    [253] = {id = 8, type = OQ.RDPS, n = 'HN.Beast', spy = 'Knockback'},
    [254] = {id = 9, type = OQ.RDPS, n = 'HN.Marksmanship', spy = 'Ranged'},
    [255] = {id = 10, type = OQ.RDPS, n = 'HN.Survival', spy = 'Ranged'},
    [62] = {id = 11, type = OQ.CASTER, n = 'MG.Arcane', spy = 'Knockback'},
    [63] = {id = 12, type = OQ.CASTER, n = 'MG.Fire', spy = 'Ranged'},
    [64] = {id = 13, type = OQ.CASTER, n = 'MG.Frost', spy = 'Ranged'},
    [268] = {id = 14, type = OQ.MDPS, n = 'MK.Brewmaster', spy = 'Tank'},
    [269] = {id = 15, type = OQ.MDPS, n = 'MK.Windwalker', spy = 'Melee'},
    [270] = {id = 16, type = OQ.MDPS, n = 'MK.Mistweaver', spy = 'Healer'},
    [65] = {id = 17, type = OQ.RDPS, n = 'PA.Holy', spy = 'Healer'},
    [66] = {id = 18, type = OQ.TANK, n = 'PA.Protection', spy = 'Tank'},
    [70] = {id = 19, type = OQ.MDPS, n = 'PA.Retribution', spy = 'Melee'},
    [256] = {id = 20, type = OQ.CASTER, n = 'PR.Discipline', spy = 'Healer'},
    [257] = {id = 21, type = OQ.CASTER, n = 'PR.Holy', spy = 'Healer'},
    [258] = {id = 22, type = OQ.CASTER, n = 'PR.Shadow', spy = 'Ranged'},
    [259] = {id = 23, type = OQ.MDPS, n = 'RO.Assassination', spy = 'Melee'},
    [260] = {id = 24, type = OQ.MDPS, n = 'RO.Combat', spy = 'Melee'},
    [261] = {id = 25, type = OQ.MDPS, n = 'RO.Subtlety', spy = 'Melee'},
    [262] = {id = 26, type = OQ.RDPS, n = 'SH.Elemental', spy = 'Knockback'},
    [263] = {id = 27, type = OQ.MDPS, n = 'SH.Enhancement', spy = 'Melee'},
    [264] = {id = 28, type = OQ.CASTER, n = 'SH.Restoration', spy = 'Healer'},
    [265] = {id = 29, type = OQ.CASTER, n = 'LK.Affliction', spy = 'Knockback'},
    [266] = {id = 30, type = OQ.CASTER, n = 'LK.Demonology', spy = 'Knockback'},
    [267] = {id = 31, type = OQ.CASTER, n = 'LK.Destruction', spy = 'Knockback'},
    [71] = {id = 32, type = OQ.MDPS, n = 'WA.Arms', spy = 'Melee'},
    [72] = {id = 33, type = OQ.MDPS, n = 'WA.Fury', spy = 'Melee'},
    [73] = {id = 34, type = OQ.TANK, n = 'WA.Protection', spy = 'Tank'},
    [0] = {id = 0, type = OQ.MDPS, n = 'Lowbie', spy = 'Melee'}
}

OQ.QUEUE_STATUS = {
    ['none'] = '0',
    ['queued'] = '1',
    ['confirm'] = '2',
    ['active'] = '3',
    ['error'] = '4',
    [0] = '-',
    [1] = 'queued',
    [2] = 'CONFIRM',
    [3] = 'inside',
    [4] = 'error',
    ['0'] = '-',
    ['1'] = 'queued',
    ['2'] = 'CONFIRM',
    ['3'] = 'inside',
    ['4'] = 'error'
}

-- to be passed to SetTexture on queue pops
-- index is a rough scale from the leader
-- ie: member pops 350ms after leader, using 250ms breaks, this would rate the user a '1'
--     scale = floor(diff / time_break)
--
OQ.QUEUE_POPS = {
    [0] = 4, -- green #1
    [1] = 7, -- green #2
    [2] = 8, -- yellow #1
    [3] = 6, -- yellow #2
    [4] = 3, -- yellow #3
    [5] = 5, -- red #1
    [6] = 2, -- red #2
    [98] = 10, -- question mark
    [99] = 31, -- black
    ['green'] = 4,
    ['yellow'] = 8,
    ['red'] = 5,
    ['black'] = 31,
    ['nopop'] = 10
}

OQ.dragon_rank = {
    [0] = {y = 0, cx = 0, cy = 0, tag = nil},
    [1] = {y = 4, cx = 16, cy = 16, tag = 'Interface\\PvPRankBadges\\PvPRank06'}, -- bg knight
    [2] = {y = 4, cx = 16, cy = 16, tag = 'Interface\\PvPRankBadges\\PvPRank12'}, -- bg general
    [3] = {y = 0, cx = 32, cy = 32, tag = 'Interface\\Addons\\oqueue\\art\\silver_talpha.tga'}, -- bg silver dragon
    [4] = {y = 0, cx = 32, cy = 32, tag = 'Interface\\Addons\\oqueue\\art\\gold_talpha.tga'}, -- bg gold dragon
    [5] = {y = 4, cx = 16, cy = 16, tag = 'Interface\\PvPRankBadges\\PvPRank08'}, -- rbg knight
    [6] = {y = 4, cx = 16, cy = 16, tag = 'Interface\\PvPRankBadges\\PvPRank15'}, -- rbg general
    [7] = {y = 0, cx = 32, cy = 32, tag = 'Interface\\Addons\\oqueue\\art\\silver_talpha.tga'}, -- rbg silver dragon
    [8] = {y = 0, cx = 32, cy = 32, tag = 'Interface\\Addons\\oqueue\\art\\gold_talpha.tga'} -- rbg gold dragon
}

OQ._unit_type = {
    ['0'] = 'player',
    ['1'] = 'world object',
    ['3'] = 'npc',
    ['4'] = 'pet',
    ['5'] = 'vehicle'
}

OQ.rank_breaks = {
    ['pvp'] = {
        [1] = {r = 'knight', line = 100, rank = 1}, -- about 125 bgs  (about 20 hrs)
        [2] = {r = 'general', line = 500, rank = 2}, -- about 600 bgs
        [3] = {r = 'silver', line = 1000, rank = 3}, -- about 1200 bgs
        [4] = {r = 'golden', line = 3500, rank = 4} --
    },
    ['rated'] = {
        [1] = {r = 'knight', line = 100, rank = 1}, -- about 100-200 rbgs
        [2] = {r = 'general', line = 350, rank = 2}, -- about 600-700 rbgs
        [3] = {r = 'silver', line = 750, rank = 3}, -- about 1000-1500 rbgs
        [4] = {r = 'golden', line = 2000, rank = 4} --
    },
    ['pve'] = {
        [1] = {r = 'knight', line = 400, rank = 1}, -- roughly 4 pts per instance, 5 instances per hour, about 20 hrs
        [2] = {r = 'general', line = 2250, rank = 2},
        [3] = {r = 'silver', line = 5000, rank = 3},
        [4] = {r = 'golden', line = 12500, rank = 4}
    }
}

OQ.SCENARIO_BOSS_ID = 200000 -- generic id unused by anything else to report scenario completion

OQ._difficulty = {
    [1] = {n = 0.25, desc = L['5 player'], diff = L['normal']},
    [2] = {n = 1, desc = L['5 player (heroic)'], diff = L['heroic']},
    [3] = {n = 4, desc = L['10 player'], diff = L['normal']},
    [4] = {n = 8, desc = L['25 player'], diff = L['normal']},
    [5] = {n = 8, desc = L['10 player (heroic)'], diff = L['heroic']},
    [6] = {n = 10, desc = L['25 player (heroic)'], diff = L['heroic']},
    [7] = {n = 2, desc = L['LFR'], diff = L['LFR']},
    [8] = {n = 3, desc = L['challenge mode'], diff = L['challenge']},
    [9] = {n = 0, desc = L['40 player'], diff = L['normal']},
    [10] = {n = 0, desc = L['-'], diff = L['normal']},
    [11] = {n = 2, desc = L['scenario (heroic)'], diff = L['heroic']},
    [12] = {n = 1, desc = L['scenario'], diff = L['normal']},
    [14] = {n = 3, desc = L['flex raid'], diff = L['flex']}
}

OQ.difficulty_abbr = {
    [1] = '5m', -- 5 norm
    [2] = '5h', -- 5 heroic
    [3] = '10', -- 10 norm
    [4] = '25', -- 25 norm
    [5] = '10', -- 10 heroic
    [6] = '25', -- 25 heroic
    [7] = 'LFR', -- LFR
    [8] = '', -- challenge
    [9] = '%d', -- 40m
    [10] = '', --
    [11] = '', -- scenario heroic
    [12] = '', -- scenario
    [13] = '', -- --
    [14] = '' -- flex
}

OQ.DIFFICULTY_ICON = {
    [0] = 'Interface\\Addons\\oqueue\\art\\diff_unk.tga',
    [3] = 'Interface\\Addons\\oqueue\\art\\diff_10n.tga',
    [4] = 'Interface\\Addons\\oqueue\\art\\diff_25n.tga',
    [5] = 'Interface\\Addons\\oqueue\\art\\diff_10h.tga',
    [6] = 'Interface\\Addons\\oqueue\\art\\diff_25h.tga',
    [7] = 'Interface\\Addons\\oqueue\\art\\diff_lfr.tga',
    [14] = 'Interface\\Addons\\oqueue\\art\\diff_flex.tga'
}

OQ.difficulty_color = {
    [1] = '0000ff', -- 5 norm
    [2] = '0000ff', -- 5 heroic
    [3] = '00ff00', -- 10 norm
    [4] = '00ff00', -- 25 norm
    [5] = 'ff0000', -- 10 heroic
    [6] = 'ff0000', -- 25 heroic
    [7] = 'ffff00', -- LFR
    [8] = '0000ff', -- challenge
    [9] = '0000ff', -- 40m
    [10] = '0000ff', --
    [11] = '0000ff', -- scenario heroic
    [12] = '0000ff', -- scenario
    [13] = '0000ff', -- --
    [14] = 'FFFF40' -- flex
}

OQ.max_raid_bosses = {
    [1] = 9,
    [2] = 8,
    [3] = 10,
    [4] = 1,
    [5] = 6,
    [6] = 9,
    [7] = 2,
    [8] = 11,
    [9] = 1,
    [10] = 6,
    [11] = 4,
    [12] = 5,
    [13] = 6,
    [14] = 12,
    [15] = 15,
    [16] = 1,
    [17] = 1,
    [18] = 1,
    [19] = 1,
    [20] = 5,
    [21] = 14,
    [22] = 4,
    [23] = 3,
    [24] = 6,
    [25] = 8,
    [26] = 7,
    [27] = 5,
    [28] = 2,
    [29] = 6,
    [30] = 6,
    [31] = 14,
    [32] = 4,
    [33] = 13
}

OQ.gbl = {}
