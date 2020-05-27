local addonName, OQ = ...

if (string.sub(GetCVar('realmList'), 1, 2) ~= 'us') then
    return
end

OQ.REGION = 'us'
OQ.SK_BTAG = 'OQSK#1855'
OQ.SK_NAME = 'Scorekeeper'
OQ.SK_REALM = 'Magtheridon'
OQ.DEFAULT_PREMADE_TEXT = 'vent:  wow.publicvent.org : 4135\nroom: '

OQ.OCEANIC = {
    ["Aman'Thul"] = 1,
    ['Barthilas'] = 1,
    ['Caelestrasz'] = 1,
    ["Dath'Remar"] = 1,
    ['Dreadmaul'] = 1,
    ['Frostmourne'] = 1,
    ["Khaz'goroth"] = 1,
    ['Nagrand'] = 1,
    ['Gundrak'] = 1,
    ["Jubei'Thos"] = 1,
    ['Saurfang'] = 1,
    ['Thaurissan'] = 1
}
-- brazilian servers
OQ.BRALIZIAN = {
    ['Goldrinn'] = 1,
    ['Gallywix'] = 1,
    ['Azralon'] = 1,
    ['Nemesis'] = 1
}

OQ.BGROUP_ICON = {
    ['Bloodlust'] = 'Interface\\Icons\\Spell_Nature_Bloodlust',
    ['Cyclone'] = 'Interface\\Icons\\Spell_Nature_Earthbind',
    ['Emberstorm'] = 'Interface\\Icons\\Spell_Fire_SelfDestruct',
    ['Nightfall'] = 'Interface\\Icons\\Spell_Shadow_Twilight',
    ['Rampage'] = 'Interface\\Icons\\Ability_Warrior_Rampage',
    ['Reckoning'] = 'Interface\\Icons\\Spell_Holy_BlessingOfStrength',
    ['Retaliation'] = 'Interface\\Icons\\Ability_Warrior_Challange',
    ['Ruin'] = 'Interface\\Icons\\Spell_Shadow_ShadowWordPain',
    ['Shadowburn'] = 'Interface\\Icons\\Spell_Shadow_ScourgeBuild',
    ['Stormstrike'] = 'Interface\\Icons\\Spell_Holy_SealOfMight',
    ['Vengeance'] = 'Interface\\Icons\\Ability_Racial_Avatar',
    ['Vindication'] = 'Interface\\Icons\\Spell_Holy_Vindication',
    ['Whirlwind'] = 'Interface\\Icons\\Ability_Whirlwind'
}

OQ.BGROUPS = {
    ['Bloodlust'] = {
        "Aman'Thul",
        'Barthilas',
        'Blackrock',
        'Caelestrasz',
        "Dath'Remar",
        'Dreadmaul',
        'Frostmourne',
        'Frostwolf',
        "Khaz'goroth",
        "Kil'jaeden",
        'Kilrogg',
        'Nagrand',
        "Ner'zhul",
        'Proudmoore',
        "Sen'jin",
        'Silver Hand',
        'Thaurissan',
        'Tichondrius',
        "Vek'nilash"
    },
    ['Cyclone'] = {
        'Azjol-Nerub',
        'Bloodscalp',
        'Boulderfist',
        'Bronzebeard',
        'Crushridge',
        'Daggerspine',
        'Darkspear',
        'Draenor',
        'Dragonblight',
        'Dunemaul',
        'Feathermoon',
        'Perenolde',
        'Stonemaul',
        'Stormscale',
        'Suramar',
        'Uldum'
    },
    ['Emberstorm'] = {
        'Antonidas',
        'Borean Tundra',
        'Cairne',
        "Drak'Tharon",
        'Drenden',
        'Farstriders',
        'Garrosh',
        'Hydraxis',
        "Mok'Nathal",
        'Moon Guard',
        'Nazgrel',
        'Nesingwary',
        'Nordrassil',
        "Quel'dorei",
        'Rivendare',
        'Shandris',
        'Tortheldrin',
        'Wyrmrest Accord'
    },
    ['Nightfall'] = {
        'Aerie Peak',
        'Altar of Storms',
        'Alterac Mountains',
        'Anvilmar',
        'Arygos',
        'Blackwing Lair',
        'Deathwing',
        'Demon Soul',
        'Doomhammer',
        'Gnomeregan',
        'Icecrown',
        'Jaedenar',
        "Kel'Thuzad",
        'Lethon',
        'Onyxia',
        'Sentinels',
        'Tanaris',
        'The Venture Co',
        'Uldaman',
        'Undermine'
    },
    ['Rampage'] = {
        'Alexstrasza',
        'Alleria',
        'Balnazzar',
        'Blackhand',
        "Cho'gall",
        'Destromath',
        'Dethecus',
        'Garona',
        'Goldrinn',
        'Gorgonnash',
        "Gul'dan",
        'Hellscream',
        'Illidan',
        "Kael'thas",
        'Kirin Tor',
        'Nemesis',
        'Ravencrest',
        'Spinebreaker',
        'Stormreaver',
        'Whisperwind'
    },
    ['Reckoning'] = {
        'Arathor',
        'Bonechewer',
        'Dragonmaw',
        "Eldre'Thalas",
        'Firetree',
        'Frostmane',
        'Gurubashi',
        'Nathrezim',
        'Scarlet Crusade',
        'Shadow Council',
        'Shadowsong',
        'Silvermoon',
        'Skywall',
        'Smolderthorn',
        'Spirestone',
        'Terenas',
        'Windrunner'
    },
    ['Retaliation'] = {
        'Area 52',
        'Auchindoun',
        'Azuremyst',
        "Blade's Edge",
        'Blood Furnace',
        'Coilfang',
        'Dawnbringer',
        'Exodar',
        'Fizzcrank',
        'Galakrond',
        'Ghostlands',
        'Grizzly Hills',
        'Shattered Halls',
        'Terokkar',
        'The Scryers',
        'The Underbog',
        'Velen',
        'Zangarmarsh'
    },
    ['Ruin'] = {
        'Argent Dawn',
        'Arthas',
        'Azgalor',
        'Bleeding Hollow',
        'Bloodhoof',
        'Durotan',
        'Elune',
        'Gallywix',
        'Lothar',
        'Madoran',
        'Magtheridon',
        'Mannoroth',
        'Medivh',
        'Shattered Hand',
        'Skullcrusher',
        'Stormrage',
        'Trollbane',
        'Warsong',
        "Zul'jin"
    },
    ['Shadowburn'] = {
        'Agamaggan',
        'Azralon',
        'Azshara',
        'Baelgun',
        'Dark Iron',
        'Detheroc',
        'Emerald Dream',
        'Greymane',
        'Kalecgos',
        'Lightninghoof',
        'Maelstrom',
        'Malfurion',
        'Moonrunner',
        'Nazjatar',
        'Sargeras',
        'Staghelm',
        'Tol Barad',
        'Twisting Nether',
        'Ursin',
        'Wildhammer'
    },
    ['Stormstrike'] = {
        'Andorhal',
        'Anetheron',
        'Archimonde',
        'Black Dragonflight',
        'Dalaran',
        'Dalvengyr',
        'Dentarg',
        'Duskwood',
        'Executus',
        'Haomarush',
        'Khadgar',
        "Mal'Ganis",
        'Norgannon',
        'Scilla',
        'Steamwheedle Cartel',
        'Thrall',
        'Turalyon',
        'Ysera',
        'Ysondre',
        'Zuluhed'
    },
    ['Vengeance'] = {
        'Aegwynn',
        'Akama',
        'Chromaggus',
        "Drak'thul",
        'Draka',
        'Eitrigg',
        'Garithos',
        'Gundrak',
        'Hakkar',
        "Jubei'Thos",
        'Khaz Modan',
        'Korgath',
        'Kul Tiras',
        'Malorne',
        "Mug'thol",
        'Muradin',
        'Rexxar',
        'Runetotem',
        'Saurfang',
        'Thorium Brotherhood'
    },
    ['Vindication'] = {
        'Aggramar',
        'Burning Blade',
        'Burning Legion',
        'Drakkari',
        'Earthen Ring',
        'Eonar',
        'Eredar',
        'Gilneas',
        'Gorefiend',
        'Kargath',
        'Laughing Skull',
        "Lightning's Blade",
        'Llane',
        'Malygos',
        "Quel'Thalas",
        'Ragnaros',
        'Shadowmoon',
        'Thunderhorn',
        'Thunderlord'
    },
    ['Whirlwind'] = {
        "Anub'arak",
        'Blackwater Raiders',
        'Bladefist',
        'Cenarion Circle',
        'Cenarius',
        'Darrowmere',
        'Echo Isles',
        'Fenris',
        'Hyjal',
        'Korialstrasz',
        'Lightbringer',
        'Maiev',
        'Misha',
        'Ravenholdt',
        "Shu'halo",
        'Sisters of Elune',
        'The Forgotten Coast',
        'Uther',
        'Vashj',
        'Winterhoof'
    },
    ['Mists'] = {
        'Lost Isles (US)',
        'Gilneas (US)',
        'Hamuul (KR)',
        'Mekkatorque (EU)',
        'Anasterian (US)'
    }
}

OQ.REALMNAMES_SPECIAL = {
    ['korgath'] = 'Korgath',
    ['Area52'] = 'Area 52',
    ['TheForgottenCoast'] = 'The Forgotten Coast',
    ['SistersofElune'] = 'Sisters of Elune',
    ['TheVentureCo'] = 'The Venture Co',
    ['AltarofStorms'] = 'Altar of Storms',
    ['AzjolNerub'] = 'Azjol-Nerub'
}

OQ.SHORT_BGROUPS = {
    'Aegwynn', -- [1]
    'Akama', -- [2]
    'Chromaggus', -- [3]
    "Drak'thul", -- [4]
    'Draka', -- [5]
    'Eitrigg', -- [6]
    'Garithos', -- [7]
    'Gundrak', -- [8]
    'Hakkar', -- [9]
    "Jubei'Thos", -- [10]
    'Khaz Modan', -- [11]
    'Korgath', -- [12]
    'Kul Tiras', -- [13]
    'Malorne', -- [14]
    "Mug'thol", -- [15]
    'Muradin', -- [16]
    'Rexxar', -- [17]
    'Runetotem', -- [18]
    'Saurfang', -- [19]
    'Thorium Brotherhood', -- [20]
    'Arathor', -- [21]
    'Bonechewer', -- [22]
    'Dragonmaw', -- [23]
    "Eldre'Thalas", -- [24]
    'Firetree', -- [25]
    'Frostmane', -- [26]
    'Gurubashi', -- [27]
    'Nathrezim', -- [28]
    'Scarlet Crusade', -- [29]
    'Shadow Council', -- [30]
    'Shadowsong', -- [31]
    'Silvermoon', -- [32]
    'Skywall', -- [33]
    'Smolderthorn', -- [34]
    'Spirestone', -- [35]
    'Terenas', -- [36]
    'Windrunner', -- [37]
    "Anub'arak", -- [38]
    'Blackwater Raiders', -- [39]
    'Bladefist', -- [40]
    'Cenarion Circle', -- [41]
    'Cenarius', -- [42]
    'Darrowmere', -- [43]
    'Echo Isles', -- [44]
    'Fenris', -- [45]
    'Hyjal', -- [46]
    'Korialstrasz', -- [47]
    'Lightbringer', -- [48]
    'Maiev', -- [49]
    'Misha', -- [50]
    'Ravenholdt', -- [51]
    "Shu'halo", -- [52]
    'Sisters of Elune', -- [53]
    'The Forgotten Coast', -- [54]
    'Uther', -- [55]
    'Vashj', -- [56]
    'Winterhoof', -- [57]
    'Aggramar', -- [58]
    'Burning Blade', -- [59]
    'Burning Legion', -- [60]
    'Drakkari', -- [61]
    'Earthen Ring', -- [62]
    'Eonar', -- [63]
    'Eredar', -- [64]
    'Gilneas', -- [65]
    'Gorefiend', -- [66]
    'Kargath', -- [67]
    'Laughing Skull', -- [68]
    "Lightning's Blade", -- [69]
    'Llane', -- [70]
    'Malygos', -- [71]
    "Quel'Thalas", -- [72]
    'Ragnaros', -- [73]
    'Shadowmoon', -- [74]
    'Thunderhorn', -- [75]
    'Thunderlord', -- [76]
    "Aman'Thul", -- [77]
    'Barthilas', -- [78]
    'Blackrock', -- [79]
    'Caelestrasz', -- [80]
    "Dath'Remar", -- [81]
    'Dreadmaul', -- [82]
    'Frostmourne', -- [83]
    'Frostwolf', -- [84]
    "Khaz'goroth", -- [85]
    "Kil'jaeden", -- [86]
    'Kilrogg', -- [87]
    'Nagrand', -- [88]
    "Ner'zhul", -- [89]
    'Proudmoore', -- [90]
    "Sen'jin", -- [91]
    'Silver Hand', -- [92]
    'Thaurissan', -- [93]
    'Tichondrius', -- [94]
    "Vek'nilash", -- [95]
    'Area 52', -- [96]
    'Auchindoun', -- [97]
    'Azuremyst', -- [98]
    "Blade's Edge", -- [99]
    'Blood Furnace', -- [100]
    'Coilfang', -- [101]
    'Dawnbringer', -- [102]
    'Exodar', -- [103]
    'Fizzcrank', -- [104]
    'Galakrond', -- [105]
    'Ghostlands', -- [106]
    'Grizzly Hills', -- [107]
    'Shattered Halls', -- [108]
    'Terokkar', -- [109]
    'The Scryers', -- [110]
    'The Underbog', -- [111]
    'Velen', -- [112]
    'Zangarmarsh', -- [113]
    'Argent Dawn', -- [114]
    'Arthas', -- [115]
    'Azgalor', -- [116]
    'Bleeding Hollow', -- [117]
    'Bloodhoof', -- [118]
    'Durotan', -- [119]
    'Elune', -- [120]
    'Lothar', -- [121]
    'Madoran', -- [122]
    'Magtheridon', -- [123]
    'Mannoroth', -- [124]
    'Medivh', -- [125]
    'Shattered Hand', -- [126]
    'Skullcrusher', -- [127]
    'Stormrage', -- [128]
    'Trollbane', -- [129]
    'Warsong', -- [130]
    "Zul'jin", -- [131]
    'Agamaggan', -- [132]
    'Azshara', -- [133]
    'Baelgun', -- [134]
    'Dark Iron', -- [135]
    'Detheroc', -- [136]
    'Emerald Dream', -- [137]
    'Greymane', -- [138]
    'Kalecgos', -- [139]
    'Lightninghoof', -- [140]
    'Maelstrom', -- [141]
    'Malfurion', -- [142]
    'Moonrunner', -- [143]
    'Nazjatar', -- [144]
    'Sargeras', -- [145]
    'Staghelm', -- [146]
    'Twisting Nether', -- [147]
    'Ursin', -- [148]
    'Wildhammer', -- [149]
    'Antonidas', -- [150]
    'Borean Tundra', -- [151]
    'Cairne', -- [152]
    "Drak'Tharon", -- [153]
    'Drenden', -- [154]
    'Farstriders', -- [155]
    'Garrosh', -- [156]
    'Hydraxis', -- [157]
    "Mok'Nathal", -- [158]
    'Moon Guard', -- [159]
    'Nazgrel', -- [160]
    'Nesingwary', -- [161]
    'Nordrassil', -- [162]
    "Quel'dorei", -- [163]
    'Rivendare', -- [164]
    'Shandris', -- [165]
    'Tortheldrin', -- [166]
    'Wyrmrest Accord', -- [167]
    'Andorhal', -- [168]
    'Anetheron', -- [169]
    'Archimonde', -- [170]
    'Black Dragonflight', -- [171]
    'Dalaran', -- [172]
    'Dalvengyr', -- [173]
    'Dentarg', -- [174]
    'Duskwood', -- [175]
    'Executus', -- [176]
    'Haomarush', -- [177]
    'Khadgar', -- [178]
    "Mal'Ganis", -- [179]
    'Norgannon', -- [180]
    'Scilla', -- [181]
    'Steamwheedle Cartel', -- [182]
    'Thrall', -- [183]
    'Turalyon', -- [184]
    'Ysera', -- [185]
    'Ysondre', -- [186]
    'Zuluhed', -- [187]
    'Alexstrasza', -- [188]
    'Alleria', -- [189]
    'Balnazzar', -- [190]
    'Blackhand', -- [191]
    "Cho'gall", -- [192]
    'Destromath', -- [193]
    'Dethecus', -- [194]
    'Garona', -- [195]
    'Gorgonnash', -- [196]
    "Gul'dan", -- [197]
    'Hellscream', -- [198]
    'Illidan', -- [199]
    "Kael'thas", -- [200]
    'Kirin Tor', -- [201]
    'Ravencrest', -- [202]
    'Spinebreaker', -- [203]
    'Stormreaver', -- [204]
    'Whisperwind', -- [205]
    'Aerie Peak', -- [206]
    'Altar of Storms', -- [207]
    'Alterac Mountains', -- [208]
    'Anvilmar', -- [209]
    'Arygos', -- [210]
    'Blackwing Lair', -- [211]
    'Deathwing', -- [212]
    'Demon Soul', -- [213]
    'Doomhammer', -- [214]
    'Gnomeregan', -- [215]
    'Icecrown', -- [216]
    'Jaedenar', -- [217]
    "Kel'Thuzad", -- [218]
    'Lethon', -- [219]
    'Onyxia', -- [220]
    'Sentinels', -- [221]
    'Tanaris', -- [222]
    'The Venture Co', -- [223]
    'Uldaman', -- [224]
    'Undermine', -- [225]
    'Azjol-Nerub', -- [226]
    'Bloodscalp', -- [227]
    'Boulderfist', -- [228]
    'Bronzebeard', -- [229]
    'Crushridge', -- [230]
    'Daggerspine', -- [231]
    'Darkspear', -- [232]
    'Draenor', -- [233]
    'Dragonblight', -- [234]
    'Dunemaul', -- [235]
    'Feathermoon', -- [236]
    'Perenolde', -- [237]
    'Stonemaul', -- [238]
    'Stormscale', -- [239]
    'Suramar', -- [240]
    'Uldum', -- [241]
    'Lost Isles (US)', -- [242]
    'Gilneas (US)', -- [243]
    'Hamuul (KR)', -- [244]
    'Mekkatorque (EU)', -- [245]
    'Azralon', -- [246]
    'Goldrinn', -- [247]
    'Nemesis', -- [248]
    'Gallywix', -- [249]
    'Tol Barad', -- [250]
    'Anasterian (US)', -- [251]
    ['Lost Isles (US)'] = 242,
    ['Gilneas (US)'] = 243,
    ['Hamuul (KR)'] = 244,
    ['Mekkatorque (EU)'] = 245,
    ['Azralon'] = 246,
    ['Goldrinn'] = 247,
    ['Nemesis'] = 248,
    ['Gallywix'] = 249,
    ['Tol Barad'] = 250,
    ['Anasterian (US)'] = 251,
    ['Nordrassil'] = 162,
    ['Silvermoon'] = 32,
    ['Akama'] = 2,
    ['Hyjal'] = 46,
    ["Kael'thas"] = 200,
    ['Terokkar'] = 109,
    ['Bloodhoof'] = 118,
    ["Mug'thol"] = 15,
    ["Kil'jaeden"] = 86,
    ['Andorhal'] = 168,
    ['Frostwolf'] = 84,
    ['Nazgrel'] = 160,
    ['Boulderfist'] = 228,
    ['Uldum'] = 241,
    ['Baelgun'] = 134,
    ['Maelstrom'] = 141,
    ["Jubei'Thos"] = 10,
    ['Deathwing'] = 212,
    ['Sentinels'] = 221,
    ['Gilneas'] = 65,
    ['Stormscale'] = 239,
    ['Stonemaul'] = 238,
    ['Agamaggan'] = 132,
    ['Perenolde'] = 237,
    ['Gundrak'] = 8,
    ['Feathermoon'] = 236,
    ['Blackwing Lair'] = 211,
    ["Quel'Thalas"] = 72,
    ['Azgalor'] = 116,
    ['Ursin'] = 148,
    ['Dalaran'] = 172,
    ['Rivendare'] = 164,
    ['Blackrock'] = 79,
    ['Dragonblight'] = 234,
    ['Stormrage'] = 128,
    ['Archimonde'] = 170,
    ['Darkspear'] = 232,
    ['Daggerspine'] = 231,
    ['Eonar'] = 63,
    ['Crushridge'] = 230,
    ['Skywall'] = 33,
    ['Madoran'] = 122,
    ['Malorne'] = 14,
    ['Thaurissan'] = 93,
    ['Trollbane'] = 129,
    ['Bronzebeard'] = 229,
    ['Bloodscalp'] = 227,
    ['Tortheldrin'] = 166,
    ['Argent Dawn'] = 114,
    ['Staghelm'] = 146,
    ['Kargath'] = 67,
    ['Borean Tundra'] = 151,
    ['The Scryers'] = 110,
    ['Spinebreaker'] = 203,
    ['The Venture Co'] = 223,
    ['Executus'] = 176,
    ['Nazjatar'] = 144,
    ["Shu'halo"] = 52,
    ['Tanaris'] = 222,
    ['Dentarg'] = 174,
    ['Coilfang'] = 101,
    ['Sargeras'] = 145,
    ["Kel'Thuzad"] = 218,
    ['Muradin'] = 16,
    ['Jaedenar'] = 217,
    ['Icecrown'] = 216,
    ['Lightninghoof'] = 140,
    ['Anvilmar'] = 209,
    ['Doomhammer'] = 214,
    ['Demon Soul'] = 213,
    ['Earthen Ring'] = 62,
    ['Dragonmaw'] = 23,
    ['Dreadmaul'] = 82,
    ['Gnomeregan'] = 215,
    ['Winterhoof'] = 57,
    ['Shadowmoon'] = 74,
    ['Dawnbringer'] = 102,
    ['Malfurion'] = 142,
    ["Blade's Edge"] = 99,
    ['Grizzly Hills'] = 107,
    ['Aerie Peak'] = 206,
    ['Altar of Storms'] = 207,
    ['Windrunner'] = 37,
    ['Stormreaver'] = 204,
    ['Garrosh'] = 156,
    ['Khaz Modan'] = 11,
    ['Area 52'] = 96,
    ['Kirin Tor'] = 201,
    ['Mannoroth'] = 124,
    ["Ner'zhul"] = 89,
    ["Eldre'Thalas"] = 24,
    ['Greymane'] = 138,
    ["Gul'dan"] = 197,
    ['Thrall'] = 183,
    ['Khadgar'] = 178,
    ['Dethecus'] = 194,
    ['Destromath'] = 193,
    ['Ragnaros'] = 73,
    ["Cho'gall"] = 192,
    ['Thunderlord'] = 76,
    ['Korialstrasz'] = 47,
    ["Lightning's Blade"] = 69,
    ['Medivh'] = 125,
    ['Blackhand'] = 191,
    ['Galakrond'] = 105,
    ['Nesingwary'] = 161,
    ['Balnazzar'] = 190,
    ['Laughing Skull'] = 68,
    ['Runetotem'] = 18,
    ["Dath'Remar"] = 81,
    ['Dark Iron'] = 135,
    ["Aman'Thul"] = 77,
    ['Nagrand'] = 88,
    ['Moon Guard'] = 159,
    ['Drakkari'] = 61,
    ['Smolderthorn'] = 34,
    ['Bleeding Hollow'] = 117,
    ['Elune'] = 120,
    ['Garithos'] = 7,
    ['Ysondre'] = 186,
    ['Ysera'] = 185,
    ['Spirestone'] = 35,
    ['Kilrogg'] = 87,
    ['Velen'] = 112,
    ['Tichondrius'] = 94,
    ['The Underbog'] = 111,
    ['Alexstrasza'] = 188,
    ['Skullcrusher'] = 127,
    ['Arathor'] = 21,
    ['Scarlet Crusade'] = 29,
    ['Gorefiend'] = 66,
    ['Sisters of Elune'] = 53,
    ['Lothar'] = 121,
    ['Fenris'] = 45,
    ['Lightbringer'] = 48,
    ['Anetheron'] = 169,
    ['Blackwater Raiders'] = 39,
    ['Undermine'] = 225,
    ["Drak'thul"] = 4,
    ['Garona'] = 195,
    ['Ravencrest'] = 202,
    ['Draenor'] = 233,
    ['Alleria'] = 189,
    ['Kalecgos'] = 139,
    ['Steamwheedle Cartel'] = 182,
    ['Twisting Nether'] = 147,
    ['Scilla'] = 181,
    ['Bonechewer'] = 22,
    ['The Forgotten Coast'] = 54,
    ['Norgannon'] = 180,
    ['Cenarius'] = 42,
    ['Aegwynn'] = 1,
    ['Caelestrasz'] = 80,
    ['Blood Furnace'] = 100,
    ['Lethon'] = 219,
    ['Vashj'] = 56,
    ['Durotan'] = 119,
    ['Detheroc'] = 136,
    ['Gorgonnash'] = 196,
    ['Terenas'] = 36,
    ['Fizzcrank'] = 104,
    ['Korgath'] = 12,
    ['Drenden'] = 154,
    ['Misha'] = 50,
    ['Haomarush'] = 177,
    ['Burning Blade'] = 59,
    ['Dalvengyr'] = 173,
    ['Warsong'] = 130,
    ['Shattered Hand'] = 126,
    ['Suramar'] = 240,
    ["Drak'Tharon"] = 153,
    ['Farstriders'] = 155,
    ['Burning Legion'] = 60,
    ['Maiev'] = 49,
    ["Vek'nilash"] = 95,
    ['Eredar'] = 64,
    ['Magtheridon'] = 123,
    ['Wyrmrest Accord'] = 167,
    ['Azjol-Nerub'] = 226,
    ["Sen'jin"] = 91,
    ['Nathrezim'] = 28,
    ['Shandris'] = 165,
    ['Aggramar'] = 58,
    ['Hakkar'] = 9,
    ['Saurfang'] = 19,
    ['Kul Tiras'] = 13,
    ['Shattered Halls'] = 108,
    ['Shadowsong'] = 31,
    ['Gurubashi'] = 27,
    ['Thunderhorn'] = 75,
    ['Zuluhed'] = 187,
    ['Azuremyst'] = 98,
    ['Bladefist'] = 40,
    ['Barthilas'] = 78,
    ['Onyxia'] = 220,
    ['Cairne'] = 152,
    ['Dunemaul'] = 235,
    ['Frostmourne'] = 83,
    ['Black Dragonflight'] = 171,
    ['Arthas'] = 115,
    ["Zul'jin"] = 131,
    ['Eitrigg'] = 6,
    ['Rexxar'] = 17,
    ['Antonidas'] = 150,
    ["Khaz'goroth"] = 85,
    ['Frostmane'] = 26,
    ['Shadow Council'] = 30,
    ['Hydraxis'] = 157,
    ['Alterac Mountains'] = 208,
    ['Silver Hand'] = 92,
    ['Thorium Brotherhood'] = 20,
    ["Anub'arak"] = 38,
    ['Exodar'] = 103,
    ['Duskwood'] = 175,
    ['Cenarion Circle'] = 41,
    ['Uther'] = 55,
    ['Uldaman'] = 224,
    ['Ghostlands'] = 106,
    ['Zangarmarsh'] = 113,
    ['Llane'] = 70,
    ['Hellscream'] = 198,
    ['Wildhammer'] = 149,
    ['Auchindoun'] = 97,
    ['Moonrunner'] = 143,
    ['Whisperwind'] = 205,
    ['Emerald Dream'] = 137,
    ["Mal'Ganis"] = 179,
    ['Firetree'] = 25,
    ['Arygos'] = 210,
    ['Darrowmere'] = 43,
    ['Turalyon'] = 184,
    ['Draka'] = 5,
    ["Mok'Nathal"] = 158,
    ['Azshara'] = 133,
    ['Illidan'] = 199,
    ['Echo Isles'] = 44,
    ['Malygos'] = 71,
    ['Ravenholdt'] = 51,
    ['Proudmoore'] = 90,
    ['Chromaggus'] = 3,
    ["Quel'dorei"] = 163
}

OQ.gbl = {
    ['tts#1959'] = 'exploiting', -- OQ exploiter
    ['humiliation#1231'] = 'behavior', -- nazi symbol in OQ names
    ['peaceandlove#1473'] = 'behavior', -- bandit
    ['mokkthemadd#1462'] = 'behavior', -- flamed out, hard
    ['fr0st#1118'] = 'behavior', -- n-word to scorekeeper
    ['drunkhobo15#1211'] = 'exploiting', -- exploit/hack
    ['bradley#1957'] = 'behavior', -- spamming the scorekeeper, douchery
    ['thetcer#1446'] = 'exploiting', -- OQ exploiter
    --           ["pawnstar#1571"    ] = "exploiting",  -- exploit helm; 'f-you f*ggot' - chumlee (probation - 20may2014)
    ['cory#1801'] = 'exploiting', -- OQ exploiter; gold dragon
    ['adolph#1897'] = 'behavior', -- douchery; toolbag; RL name + c-word to insult player
    ['flucz#1635'] = 'behavior', -- douchery; "who the f* are you; n***a off my friends list;b*tch;dont pop enough molly for me;pussy;now;im gonna go f* yur betch;an pop molly" ... that's swell.  have a nice day
    ['cscird#1889'] = 'exploiting', -- OQ exploiter; gold dragon
    ['goddess#2851'] = 'exploiting', -- OQ exploiter; silver dragon (rbg)
    ['royal#1104'] = 'exploiting', -- OQ exploiter; gold dragon
    ['oden#1613'] = 'exploiting', -- OQ exploiter; silver dragon
    --           ["bryan732#1470"    ] = "exploiting",  -- OQ exploiter; silver dragon (rbg)  ; probation(10dec2013a)
    ['omg#1793'] = 'exploit-fraud', -- impersonating another's btag; gold dragon; spamming; etc
    ['oqsk#1984'] = 'exploit-spammer', -- mesh flooding
    ['madara#1945'] = 'exploiting', -- OQ exploiter; gold dragon
    --
    -- guys, i'm watching.  don't ruin it for everyone.  probation... for now. -- tiny (03apr2014)
    --
    --           [ "igmorph#1302"    ] = "exploiting",  -- OQ exploiter; false reporting ; probation(03apr2014)
    --           [ "haptix#6426"     ] = "exploiting",  -- OQ exploiter; false reporting ; probation(03apr2014)
    --           [ "andrast#1204"    ] = "exploiting",  -- OQ exploiter; false reporting ; probation(03apr2014)
    --           [ "deadlysin#1380"  ] = "exploiting",  -- OQ exploiter; false reporting ; probation(03apr2014)
    --           [ "tatt2d#1471"     ] = "exploiting",  -- OQ exploiter; false reporting ; probation(03apr2014)
    --           [ "brandon#12598"   ] = "exploiting",  -- OQ exploiter; false reporting ; probation(03apr2014)
    --           [ "drcoffee#1492"   ] = "exploiting",  -- OQ exploiter; false reporting ; probation(03apr2014)
    --           [ "alucardxx#1341"  ] = "exploiting",  -- OQ exploiter; false reporting ; probation(03apr2014)
    --           [ "matt#11112"      ] = "exploiting",  -- OQ exploiter; false reporting ; (04apr2014)
    ['soldado65#1481'] = 'exploiting', -- OQ exploiter; false reporting ; (04apr2014)
    ['akjcl#1433'] = 'behavior', --
    ['mcmaster#1691'] = 'exploiting', -- OQ exploiter; gold dragon
    ['botnet#1120'] = 'exploiting', -- OQ exploiter; silver dragon
    ['doctord#1742'] = 'exploiting', -- OQ exploiter; rbg general
    --           [ "datagrams#1697"  ] = "exploiting",  -- OQ exploiter; silver dragon; probation (14apr2014)
    ['hellstribute#1423'] = 'exploiting', -- OQ exploiter; gold dragon (25may2014)
    ['one#1308'] = 'exploiting', -- OQ exploiter; gold dragon (10jun2014)
    ['loren#1128'] = 'exploiting', -- gold seller
    --           ["danbopes#1222"    ] = "exploiting",  -- OQ exploiter; gold dragon (17jun2014); probation 18jun2014
    ['calyistis#1146'] = 'exploiting', -- OQ exploiter; gold dragon (21jun2014)
    ['logiiii#1198'] = 'exploiting', -- OQ exploiter; gold dragon (22jun2014)
    ['aeshur#1775'] = 'exploiting' -- OQ exploiter; gold dragon (29jun2014)
}
