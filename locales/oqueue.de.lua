--[[ 
  @file       oqueue.de.lua
  @brief      localization for oqueue addon (german)

  @author     rmcinnis
  @date       june 11, 2012
  @par        copyright (c) 2012 Solid ICE Technologies, Inc.  All rights reserved.
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;

OQ.TRANSLATED_BY["deDE"] = "Realm69" ;
if ( GetLocale() ~= "deDE" ) then
  return ;
end
local L = OQ._T ; -- for literal string translations

OQ.TITLE_LEFT = "oQueue v" ; --i can't translate this
OQ.TITLE_RIGHT = " - Premade finder" ; --i can't translate this
OQ.BNET_FRIENDS = "%d b-net Freunde" ;
OQ.PREMADE = "Premade" ;
OQ.FINDPREMADE = "Finde Premade" ;
OQ.CREATEPREMADE = "Erstelle Premade" ;
OQ.CREATE_BUTTON = "Erstelle Premade" ;
OQ.UPDATE_BUTTON = "aktualisiere Premade" ;
OQ.WAITLIST = "Warteschlange" ;
OQ.HONOR_BUTTON = "OQ Premade" ; --i can't translate this
OQ.SETUP = "Setup" ;
OQ.PLEASE_SELECT_BG = "Bitte such BG aus" ;
OQ.BAD_REALID = "Ungueltige real-id/battle-tag.n" ;
OQ.QUEUE1_SELECTBG = "<suche ein BG aus>" ;
OQ.NOLEADS_IN_RAID = "Es gibt keine Gruppenleiter in Schlachtzuegen" ;
OQ.NOGROUPS_IN_RAID = "Man kann Gruppen nicht direkt in einen Schlachtzug einladen" ;
OQ.BUT_INVITE = "einladen" ;
OQ.BUT_GROUPLEAD = "Gruppenleiter" ;
OQ.BUT_INVITEGROUP = "Gruppe (%d)" ;
OQ.BUT_WAITLIST = "Queue" ;
OQ.BUT_INGAME = "im Spiel" ;
OQ.BUT_PENDING = "anstehend" ;
OQ.BUT_INPROGRESS = "im Kampf" ;
OQ.BUT_NOTAVAILABLE = "anstehend" ;
OQ.BUT_FINDMESH = "find mesh" ; --i can't translate this
OQ.BUT_SUBMIT2MESH = "sende b-tag" ;
OQ.BUT_PULL_BTAG = "entferne b-tag" ;
OQ.BUT_BAN_BTAG = "banne b-tag" ;
OQ.TT_LEADER = "Leiter" ;
OQ.TT_REALM = "Realm" ;
OQ.TT_BATTLEGROUP = "Schlachtgruppe" ;
OQ.TT_MEMBERS = "Mitglieder" ;
OQ.TT_WAITLIST = "Warteschlange" ;
OQ.TT_RECORD = "Rekord (Sieg - Niederlage)" ;
OQ.TT_AVG_HONOR = "durchschnittliche Ehre/Spiel" ;
OQ.TT_AVG_HKS = "durchschnittliche Ehrenhafte Siege/Spiel" ;
OQ.TT_AVG_GAME_LEN = "durchschnittliche Spiell�nge" ;
OQ.TT_AVG_DOWNTIME = "durchschnittlich ungenutzte Zeit" ; --should be checked by someone else
OQ.TT_RESIL = "Abh" ;
OQ.TT_ILEVEL = "ilevel" ;
OQ.TT_MAXHP = "max hp" ;
OQ.TT_WINLOSS = "Sieg - Niederlage" ;
OQ.TT_HKS = "Ehrenhafte Siege - Gesamt" ;
OQ.TT_OQVERSION = "Version" ;
OQ.TT_TEARS = "Traenen" ;
OQ.TT_PVPPOWER = "pvp Macht" ;
OQ.TT_MMR = "rbg Wertung" ;
OQ.AUTO_INSPECT       = "Auto inspect (Strg + linke Maus)" ;
OQ.ANNOUNCE_CONTRACTS = "Sage Verträge an" ;
OQ.SETUP_SHOUTCONTRACTS = "Sage Verträge an" ;
OQ.SETUP_TIMERWIDTH   = "Timer breite" ;

OQ.JOIN_QUEUE = "Warteschlange beitreten" ;
OQ.LEAVE_QUEUE = "Warteschlange verlassen" ;
OQ.LEAVE_QUEUE_BIG = "WARTESCHLANGE VERLASSEN" ;
OQ.DAS_BOOT = "DAS BOOT !!" ; --dafuq is dis shit? >.<
OQ.DISBAND_PREMADE = "Premade aufloesen" ;
OQ.LEAVE_PREMADE = "Premade verlassen" ;
OQ.RELOAD = "Neu laden" ;
OQ.ILL_BRB = "gleich wieder da" ;
OQ.LUCKY_CHARMS = "Gluecksbringer" ;
OQ.IAM_BACK = "Bin wieder da" ;
OQ.ROLE_CHK = "Rollen�berpr�fung" ;
OQ.READY_CHK = "Bereitschaftscheck" ;
OQ.APPROACHING_CAP = "ANN�HERNDES CAP" ; --should be checked by someone else
OQ.CAPPED = "CAPPED" ; --i can't translate this
OQ.HDR_PREMADE_NAME = "Premade" ;
OQ.HDR_LEADER = "Leiter" ;
OQ.HDR_LEVEL_RANGE = "Level" ;
OQ.HDR_ILEVEL = "ilevel" ;
OQ.HDR_RESIL = "Abh" ;
OQ.HDR_TIME = "Zeit" ;
OQ.QUALIFIED = "qualifiziert" ;
OQ.PREMADE_NAME = "Name der Premade" ;
OQ.LEADERS_NAME = "Name des Leiters" ;
OQ.REALID = "Real-Id oder B-tag" ;
OQ.REALID_MOP = "Battle-tag" ;
OQ.MIN_ILEVEL = "Minimal iLevel" ;
OQ.MIN_RESIL = "Minimal Abhaert." ;
OQ.MIN_MMR = "Minimal BG Rating" ;
OQ.BATTLEGROUNDS = "Beschreibung" ;
OQ.ENFORCE_LEVELS = "enforce level bracket" ; --not sure how to translate this
OQ.NOTES = "Anmerkungen" ;
OQ.PASSWORD = "Passwort" ;
OQ.CREATEURPREMADE = "Erstelle deine eigene Premade" ;
OQ.LABEL_LEVEL = "Level" ;
OQ.LABEL_LEVELS = "Level" ;
OQ.HDR_BGROUP = "bgroup" ; --dunno how to translate
OQ.HDR_TOONNAME = "Name des Charakters" ;
OQ.HDR_REALM = "Realm" ;
OQ.HDR_LEVEL = "Level" ;
OQ.HDR_ILEVEL = "ilevel" ;
OQ.HDR_RESIL = "Abh" ;
OQ.HDR_MMR = "Wertung" ;
OQ.HDR_PVPPOWER = "Macht" ;
OQ.HDR_DATE = "Datum" ;
OQ.HDR_BTAG = "battle.tag" ;
OQ.HDR_REASON = "Grund" ;
OQ.RAFK_ENABLED = "rafk aktiviert" ;
OQ.RAFK_DISABLED = "rafk deaktiviert" ;
OQ.SETUP_HEADING = "Einstellungen und diverse Kommandos" ;
OQ.SETUP_BTAG = "Battlenet email Addresse" ;
OQ.SETUP_GODARK_LBL = "Tell all OQ friends you're going dark" ; --dunno
OQ.SETUP_CAPCHK = "Force OQ capability check" ; --dunno
OQ.SETUP_REMOQADDED = "Entferne durch OQ hinzugefuegte Freunde" ;
OQ.SETUP_REMOVEBTAG = "Entferne b-tag aus der Punktetabelle" ;
OQ.SETUP_ALTLIST = "Twinks dieses battle.net Accounts:n(nur fuer multi-boxer)" ;
OQ.SETUP_AUTOROLE = "Setze Rolle automatisch" ;
OQ.SETUP_CLASSPORTRAIT = "Klassenportraits verwenden" ;
OQ.SETUP_GARBAGE = "Garbage collection (30 sec intervals)" ;
OQ.SETUP_SHOUTKBS = "Todesstoesse ansagen" ;
OQ.SETUP_SHOUTCAPS = "BG Aufgaben ansagen" ;
OQ.SETUP_SHOUTADS = "Verkünde Premades" ; -- "Premades ansagen" ;

OQ.SETUP_AUTOACCEPT_MESH_REQ = "Auto accept b-tag mesh requests" ; --dunno
OQ.SETUP_ANNOUNCE_RAGEQUIT = "Rage-Quitter bekannt geben" ;
OQ.SETUP_OK2SUBMIT_BTAG = "B-Tag alle 4 Tage senden" ;
OQ.SETUP_ADD = "Hinzufuegen" ;
OQ.SETUP_MYCREW = "Mein Team" ;
OQ.SETUP_CLEAR = "Loeschen" ;
OQ.BN_FRIENDS = "OQ enabled friends" ; --dunno
OQ.LOCAL_OQ_USERS = "OQ enabled locals" ; --dunno
OQ.PPS_SENT = "pkts sent/sec" ; --dunno
OQ.PPS_RECVD = "pkts recvd/sec" ; --dunno
OQ.PPS_PROCESSED = "pkts processed/sec" ; --dunno
OQ.MEM_USED = "Speicherverbrauch (kB)" ;
OQ.BANDWIDTH_UP = "upload (kBps)" ;
OQ.BANDWIDTH_DN = "download (kBps)" ;
OQ.OQSK_DTIME = "Zeitabweichung" ;
OQ.SETUP_CHECKNOW = "pruefe jetzt" ;
OQ.SETUP_GODARK = "go dark" ; --dunno
OQ.SETUP_REMOVENOW = "jetzt entfernen" ;
OQ.STILL_IN_PREMADE = "Bitte verlasse deine aktuelle Premade bevor du eine neue erstellst" ;
OQ.DD_PROMOTE = "zum Gruppenleiter bef�rdern" ;
OQ.DD_KICK = "Mitglied entfernen" ;
OQ.DD_BAN = "Den battle.tag des Nutzers bannen" ;
OQ.DISABLED = "oQueue deaktiviert" ;
OQ.ENABLED = "oQueue aktiviert" ;
OQ.THETIMEIS = "die Zeit ist %d (GMT)" ; --slightly problematic, if not viable for dst. german time is gmt+1/+2
OQ.RAGEQUITSOFAR = " rage quit: %s nach %d:%02d (%d bis jetzt)" ;
OQ.RAGEQUITTERS = "%d rage quit �ber %d:%02d" ;
OQ.RAGELASTGAME = "%d rage quit letztes Spiel (bg ging %d:%02d lang)" ;
OQ.NORAGEQUITS = "du bist in keinem Schlachtfeld" ;
OQ.RAGEQUITS = "%d rage quit so far" ; --dunno
OQ.MSG_PREMADENAME = "Bitte trage einen Namen f�r die Premade ein" ;
OQ.MSG_MISSINGNAME = "Bitte gib deiner Gruppe einen Namen" ;
OQ.MSG_REJECT = "Warteschlange nicht angenommen.nGrund: %s" ;
OQ.MSG_CANNOTCREATE_TOOLOW = "Premade kann nicht erstellt werden. nDu musst mindestens Level 10 sein" ;
OQ.MSG_NOTLFG = "Bitte verwende OQueue nicht als LFG-Werbung. nEinige Spieler k�nnten dich sonst aus ihren Vorgefertigten Gruppen bannen" ;
OQ.TAB_PREMADE = "Premade" ;
OQ.TAB_FINDPREMADE = "Premade finden" ;
OQ.TAB_CREATEPREMADE = "Premade erstellen" ;
OQ.TAB_THESCORE = "Punktestand" ;
OQ.TAB_SETUP = "Setup" ;
OQ.TAB_BANLIST = "Bannlist" ;
OQ.TAB_WAITLIST = "Warteschlange" ;
OQ.TAB_WAITLISTN = "Warteschlange (%d)" ;
OQ.CONNECTIONS = "Verbindung %d - %d" ; --should be reviewed
OQ.ANNOUNCE_PREMADES= "%d Premaden verf�gbar" ;
OQ.NEW_PREMADE = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s |cFFC0C0C0%s|r" ;
OQ.PREMADE_NAMEUPD = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s |cFFC0C0C0%s|r" ;
OQ.DLG_OK = "ok" ;
OQ.DLG_YES = "Ja" ;
OQ.DLG_NO = "Nein" ;
OQ.DLG_CANCEL = "Abbrechen" ;
OQ.DLG_ENTER = "Kampf beitreten" ;
OQ.DLG_LEAVE = "Warteschlange verlassen" ;
OQ.DLG_READY = "Bereit" ;
OQ.DLG_NOTREADY = "NICHT bereit" ;
OQ.DLG_01 = "Bitte trage den Namen deines Charakters ein:" ;
OQ.DLG_02 = "Kampf beitreten" ;
OQ.DLG_03 = "Bitte benenne deine Premade:" ;
OQ.DLG_04 = "Bitte gib deine real-id ein:" ;
OQ.DLG_05 = "Passwort:" ;
OQ.DLG_06 = "Bitte gib die real-id oder den Namen des neuen Gruppenleiters ein:" ;
OQ.DLG_07 = "nNEUE VERSION JETZT verf�gbar !!nnoQueue v%s build %dn" ;
OQ.DLG_08 = "Bitte verlasse deine Gruppe, um der Warteschlange beizutreten odernbitte deinen Leiter als ganze Gruppe beizutreten" ;
OQ.DLG_09 = "Nur der Gruppenleiter kann eine OQ-Vorgefertigte-Gruppe erstellen" ;
OQ.DLG_10 = "Die Warteschlange ist aufgegangen.nnWas willst du tun?" ;
OQ.DLG_11 = "Deine Warteschlange ist aufgegangen. Warte auf die Entscheidung deines Gruppenleiters.nBitte warten." ;
OQ.DLG_12 = "Bist du sicher, dass du die Schlachtgruppe verlassen willst?" ;
OQ.DLG_13 = "Der Gruppenleiter hat einen Bereitschaftscheck gestartet" ;
OQ.DLG_14 = "Der Gruppenleiter hat ein Neuladen beatragt" ;
OQ.DLG_15 = "Banne: %s nBitte gib deinen Grund ein:" ;
OQ.DLG_16 = "Unable to select premade type.nToo many members (max. %d)" ; --dunno
OQ.DLG_17 = "Bitte gib den zu bannenden battle-tag ein:" ;
OQ.DLG_18a = "Version %d.%d.%d ist jetzt verf�gbar" ;
OQ.DLG_18b = "-- Update ben�tigt --" ;
OQ.DLG_19 = "Du musst dich f�r deine eigene Gruppe qualifizieren" ;
OQ.MENU_KICKGROUP = "Gruppe kicken" ;
OQ.MENU_SETLEAD = "Gruppenleiter einstellen" ;
OQ.HONOR_PTS = "Ehrenpunkte" ;
OQ.NOBTAG_01 = " battle-tag Information nicht rechtzeitig erhalten." ;
OQ.NOBTAG_02 = " Bitte versuch es nochmal." ;
OQ.MINIMAP_HIDDEN = "(OQ) Minimap Knopf ist versteckt" ;
OQ.MINIMAP_SHOWN = "(OQ) Minimap Knopf ist angezeigt" ;
OQ.FINDMESH_OK = "deine Verbindung ist gut. Premaden aktualisieren sich alle 30 Sekunden" ;
OQ.TIMEERROR_1 = "OQ: Deine Systemzeit ist deutlich asynchron (%s)." ;
OQ.TIMEERROR_2 = "OQ: Bitte aktualisiere deine Systemzeit und Zeitzone." ;
OQ.SYS_YOUARE_AFK = "Ihr seid jetzt nicht an der Tastatur: AFK" ;
OQ.SYS_YOUARENOT_AFK = "Ihr werdet nicht mehr mit 'Nicht an der Tastatur' angezeigt." ;
OQ.ERROR_REGIONDATA = "Regionaldaten wurden nicht richtig geladen." ;
OQ.TT_LEAVEPREMADE = "Linksklick: de-waitlistnright-click: ban premade leader" ; --dunno
OQ.TT_FINDMESH = "request battle-tags from the scorekeepernto get connected to the mesh" ; --dunno
OQ.TT_SUBMIT2MESH = "submit your battle-tag to the scorekeepernto help grow the mesh" ; --dunno
OQ.LABEL_TYPE = "|cFF808080type:|r %s" ;
OQ.LABEL_ALL = "alle Premaden" ;
OQ.LABEL_BGS = "Schlachtfelder" ;
OQ.LABEL_RBGS = "gewertete Schlachtfelder" ;
OQ.LABEL_DUNGEONS = "Dungeons" ;
OQ.LABEL_RAIDS = "Raids" ;
OQ.LABEL_SCENARIOS = "Szenarios" ;
OQ.LABEL_BG = "Schlachtfelder" ;
OQ.LABEL_RBG = "RBG" ;
OQ.LABEL_ARENAS = "Arena" ;
OQ.LABEL_ARENA = "Arena" ;
--OQ.LABEL_ARENAS = "Arena (no xRealm)" ;
--OQ.LABEL_ARENA = "Arena (no xRealm)" ;
OQ.LABEL_DUNGEON = "Dungeon" ;
OQ.LABEL_RAID = "Raid" ;
OQ.LABEL_SCENARIO = "Szenario" ;
OQ.PATTERN_CAPS = "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]" ; --���
OQ.TIMEVARIANCE_DLG = { "",
"Warnung:",
"",
" Deine Systemzeit unterscheidet sich deutlich ",
" von der des mesh. Du must", --what's mesh?
" sie korrigieren, um",
" Premaden zu erstellen.",
"",
" Zeitabweichung: %s",
"",
"- tiny",
} ;
OQ.LFGNOTICE_DLG = { "",
"Warnung:",
"",
" Do not use oQueue premade names for", --dunno
" LFG or other types of personal",
" advertisement. Many people will ban ",
" anyone using it as such. If you get",
" banned, you won't be able to join",
" their groups.",
"",
"- tiny",
} ;


OQ.BG_NAMES = { [ "Zuf�lliges Schlachtfeld" ] = { type_id = OQ.RND },
[ "Kriegshymnenschlucht" ] = { type_id = OQ.WSG },
[ "Zwillingsgipfel" ] = { type_id = OQ.TP },
[ "Die Schlacht um Gilneas" ] = { type_id = OQ.BFG },
[ "Arathi-Becken" ] = { type_id = OQ.AB },
[ "Auge des Sturms" ] = { type_id = OQ.EOTS },
[ "Strand of the Ancients" ] = { type_id = OQ.SOTA }, --forgot how it's called
[ "Insel der Eroberung" ] = { type_id = OQ.IOC },
[ "Alterac Tal" ] = { type_id = OQ.AV },
[ "Silvershard Mines" ] = { type_id = OQ.SSM }, --introduces after i switched to english client
[ "Temple of Kotmogu" ] = { type_id = OQ.TOK }, --same ^
[ "" ] = { type_id = OQ.NONE },
} ;

OQ.BG_SHORT_NAME = { [ "Arathi-Becken" ] = "AB",
[ "Alterac Tal" ] = "AV",
[ "Die Schlacht um Gilneas" ] = "BFG",
[ "Eye of the Storm" ] = "EotS",
[ "Insel der Eroberung" ] = "IoC",
[ "Strand of the Ancients" ] = "SotA",
[ "Zwillingsgipfel" ] = "TP",
[ "Kriegshymnenschlucht" ] = "WSG",
[ "Silvershard Mines" ] = "SSM",
[ "Temple of Kotmogu" ] = "ToK",

[ OQ.AB ] = "AB",
[ OQ.AV ] = "AV",
[ OQ.BFG ] = "BFG",
[ OQ.EOTS ] = "EotS",
[ OQ.IOC ] = "IoC",
[ OQ.SOTA ] = "SotA",
[ OQ.TP ] = "TP",
[ OQ.WSG ] = "WSG",
[ OQ.SSM ] = "SSM",
[ OQ.TOK ] = "ToK",

[ "AB" ] = OQ.AB,
[ "AV" ] = OQ.AV,
[ "BFG" ] = OQ.BFG,
[ "EotS" ] = OQ.EOTS,
[ "IoC" ] = OQ.IOC,
[ "SotA" ] = OQ.SOTA,
[ "TP" ] = OQ.TP,
[ "WSG" ] = OQ.WSG,
[ "SSM" ] = OQ.SSM,
[ "ToK" ] = OQ.TOK,
} ;

OQ.BG_STAT_COLUMN = { [ "Bases Assaulted" ] = "Base Assaulted", --dunno which one has to be translated
[ "Bases Defended" ] = "Base Defended",
[ "Demolishers Destroyed" ] = "Demolisher Destroyed",
[ "Flag Captures" ] = "Flag Captured",
[ "Flag Returns" ] = "Flag Returned",
[ "Gates Destroyed" ] = "Gate Destroyed",
[ "Graveyards Assaulted" ] = "Graveyard Assaulted",
[ "Graveyards Defended" ] = "Graveyard Defended",
[ "Towers Assaulted" ] = "Tower Assaulted",
[ "Towers Defended" ] = "Tower Defended",
} ;


local DK = {
["Blut"]       = "Tank",
["Frost"]      = "Melee",
["Unheilig"]   = "Melee",
}

local DRUID = {
["Gleichgewicht"]        = "Knockback",
["Wildheit"]             = "Melee",
["Wiederherstellung"]    = "Healer",
["W�chter"]              = "Tank",
}

local HUNTER = {
["Tierherrschaft"]   = "Knockback",
["Treffsicherheit"]  = "Ranged",
["�berleben"]        = "Ranged",
}

local MAGE = {
["Arkan"]         = "Knockback",
["Feuer"]         = "Ranged",
["Frost"]         = "Ranged",
}

local MONK = {
["Braumeister"]     = "Tank",
["Nebelwirker"]     = "Healer",
["Windl�ufer"]      = "Melee",
}

local PALADIN = {
["Heilig"]      = "Healer",
["Schutz"]      = "Tank",
["Vergeltung"]  = "Melee",
}

local PRIEST = {
["Disziplin"]       = "Healer",
["Heilig"]          = "Healer",
["Schatten"]        = "Ranged",
}

local ROGUE = {
["Meucheln"]      = "Melee",
["Kampf"]         = "Melee",
["T�uschung"]     = "Melee",
}

local SHAMAN = {
["Elementar"]           = "Knockback",
["Verst�rkung"]         = "Melee",
["Wiederherstellung"]   = "Healer",
}

local WARLOCK = {
["Gebrechen"]     = "Knockback",
["D�monologie"]   = "Knockback",
["Zerst�rung"]    = "Knockback",
}

local WARRIOR = {
["Waffen"]     = "Melee",
["Furor"]      = "Melee",
["Schutz"]     = "Tank",
}

OQ.BG_ROLES["DEATHKNIGHT" ] = DK ;
OQ.BG_ROLES["DRUID"       ] = DRUID ;
OQ.BG_ROLES["HUNTER"      ] = HUNTER ;
OQ.BG_ROLES["MAGE"        ] = MAGE ;
OQ.BG_ROLES["MONK"        ] = MONK ;
OQ.BG_ROLES["PALADIN"     ] = PALADIN ;
OQ.BG_ROLES["PRIEST"      ] = PRIEST ;
OQ.BG_ROLES["ROGUE"       ] = ROGUE ;
OQ.BG_ROLES["SHAMAN"      ] = SHAMAN ;
OQ.BG_ROLES["WARLOCK"     ] = WARLOCK ;
OQ.BG_ROLES["WARRIOR"     ] = WARRIOR ;

L["No Bounties Available"] = "Keine Kopfgelder vorhanden" ;
L["notes:"] = "notizen:" ;
L["Target: "] = "Ziel" ;
L["Rewards"] = "Belohnung" ;
L["Time left"] = "Zeit Übrig" ;

