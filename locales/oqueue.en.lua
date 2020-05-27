--[[ 
  @file       oqueue.en.lua
  @brief      localization for oqueue addon (english - default)

  @author     rmcinnis
  @date       june 11, 2012
  @par        copyright (c) 2012 Solid ICE Technologies, Inc.  All rights reserved.
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;

local L = OQ._T ; -- for literal string translations

BINDING_HEADER_OQUEUE           = "oQueue";
BINDING_NAME_TOGGLE_OQUEUE      = "Toggle oQueue";
BINDING_NAME_AUTO_INSPECT       = "Auto Inspect";
BINDING_NAME_WAITLIST_INVITEALL = "Invite All";

OQ.TITLE_LEFT         = "oQueue v" ;
OQ.TITLE_RIGHT        = " - Premade finder" ;
OQ.BNET_FRIENDS       = "%d  b-net friends" ;
OQ.PREMADE            = "Premade" ;
OQ.FINDPREMADE        = "Find Premade" ;
OQ.CREATEPREMADE      = "Create Premade" ;
OQ.CREATE_BUTTON      = "create premade" ;
OQ.UPDATE_BUTTON      = "update premade" ;
OQ.WAITLIST           = "Wait List" ;
OQ.HONOR_BUTTON       = "OQ premade" ;
OQ.SETUP              = "Setup" ;
OQ.PLEASE_SELECT_BG   = "Please select a battleground" ;
OQ.BAD_REALID         = "Invalid real-id or battle-tag.\n" ;
OQ.QUEUE1_SELECTBG    = "<select a battleground>" ;
OQ.NOLEADS_IN_RAID    = "There are no group leads in a raid" ;
OQ.NOGROUPS_IN_RAID   = "Cannot invite group into a raid directly" ;
OQ.BUT_INVITE         = "invite" ;
OQ.BUT_GROUPLEAD      = "group lead" ;
OQ.BUT_INVITEGROUP    = "group (%d)" ;
OQ.BUT_WAITLIST       = "wait list" ;
OQ.BUT_INGAME         = "in game" ;
OQ.BUT_PENDING        = "pending" ;
OQ.BUT_INPROGRESS     = "in battle" ;
OQ.BUT_NOTAVAILABLE   = "pending" ;
OQ.BUT_FINDMESH       = "find mesh" ;
OQ.BUT_CLEARFILTERS   = "clear filters" ;
OQ.BUT_SUBMIT2MESH    = "submit b-tag" ;
OQ.BUT_PULL_BTAG      = "remove b-tag" ;
OQ.BUT_BAN_BTAG       = "ban b-tag" ;
OQ.BUT_INVITE_ALL     = "invite " ;
OQ.BUT_REMOVE_OFFLINE = "remove offline" ;
OQ.TT_LEADER          = "leader" ;
OQ.TT_REALM           = "realm" ;
OQ.TT_BATTLEGROUP     = "battlegroup" ;
OQ.TT_MEMBERS         = "members" ;
OQ.TT_WAITLIST        = "wait list" ;
OQ.TT_RECORD          = "record (win - loss)" ;
OQ.TT_AVG_HONOR       =  "avg honor/game" ;
OQ.TT_AVG_HKS         = "avg hks/game" ;
OQ.TT_AVG_GAME_LEN    = "avg game length" ;
OQ.TT_AVG_DOWNTIME    = "avg down time" ;
OQ.TT_RESIL           = "resil" ;
OQ.TT_ILEVEL          = "ilevel" ;
OQ.TT_MAXHP           = "max hp" ;
OQ.TT_WINLOSS         = "win - loss" ;
OQ.TT_HKS             = "total hks" ;
OQ.TT_OQVERSION       = "version" ;
OQ.TT_TEARS           = "tears" ;
OQ.TT_PVPPOWER        = "pvp power" ;
OQ.TT_MMR             = "pvp rating" ;
OQ.JOIN_QUEUE         = "join queue" ;
OQ.LEAVE_QUEUE        = "leave queue" ;
OQ.LEAVE_QUEUE_BIG    = "LEAVE QUEUE" ;
OQ.DAS_BOOT           = "DAS BOOT !!" ;
OQ.DISBAND_PREMADE    = "disband premade group" ;
OQ.LEAVE_PREMADE      = "leave premade group" ;
OQ.RELOAD             = "reload" ;
OQ.ILL_BRB            = "be right back" ;
OQ.LUCKY_CHARMS       = "lucky charms" ;
OQ.IAM_BACK           = "I'm back" ;
OQ.ROLE_CHK           = "role check" ;
OQ.READY_CHK          = "ready check" ;
OQ.KARMA_ALL          = "karma all" ;
OQ.APPROACHING_CAP    = "APPROACHING CAP" ;
OQ.CAPPED             = "CAPPED" ;
OQ.HDR_PREMADE_NAME   = "premades" ;
OQ.HDR_LEADER         = "leader" ;
OQ.HDR_LEVEL_RANGE    = "level(s)" ;
OQ.HDR_ILEVEL         = "ilevel" ;
OQ.HDR_RESIL          = "resil" ;
OQ.HDR_POWER          = "pvp power" ;
OQ.HDR_TIME           = "time" ;
OQ.QUALIFIED          = "qualified" ;
OQ.PREMADE_NAME       = "Premade name" ;
OQ.LEADERS_NAME       = "Leader's name" ;
OQ.REALID             = "Real-Id or B-tag" ;
OQ.REALID_MOP         = "Battle-tag" ;
OQ.MIN_ILEVEL         = "Minimum ilevel" ;
OQ.MIN_RESIL          = "Minimum resil" ;
OQ.MIN_MMR            = "Minimum BG rating" ;
OQ.BATTLEGROUNDS      = "Description" ;
OQ.ENFORCE_LEVELS     = "enforce level bracket" ;
OQ.NOTES              = "Notes" ;
OQ.PASSWORD           = "Password" ;
OQ.CREATEURPREMADE    = "Create your own premade" ;
OQ.LABEL_LEVEL        = "Level" ;
OQ.LABEL_LEVELS       = "Levels" ;
OQ.HDR_BGROUP         = "bgroup" ;
OQ.HDR_TOONNAME       = "toon name" ;
OQ.HDR_REALM          = "realm" ;
OQ.HDR_LEVEL          = "level" ;
OQ.HDR_ILEVEL         = "ilevel" ;
OQ.HDR_RESIL          = "resil" ;
OQ.HDR_MMR            = "rating" ;
OQ.HDR_PVPPOWER       = "power" ;
OQ.HDR_HASTE          = "haste" ;
OQ.HDR_MASTERY        = "mastery" ;
OQ.HDR_HIT            = "hit" ;
OQ.HDR_DATE           = "date" ;
OQ.HDR_BTAG           = "battle.tag" ;
OQ.HDR_REASON         = "reason" ;
OQ.RAFK_ENABLED       = "rafk enabled" ;
OQ.RAFK_DISABLED      = "rafk disabled" ;
OQ.SETUP_HEADING      = "Setup and various commands" ;
OQ.SETUP_BTAG         = "Battlenet email address" ;
OQ.SETUP_GODARK_LBL   = "Tell all OQ friends you're going dark" ;
OQ.SETUP_CAPCHK       = "Force OQ capability check" ;
OQ.SETUP_REMOQADDED   = "Remove OQ-added B.net friends" ;
OQ.SETUP_REMOVEBTAG   = "Remove b-tag from scorekeeper" ;
OQ.SETUP_ALTLIST      = "list of alts on this battle.net account:\n(only for multi-boxers)" ;
OQ.SETUP_AUTOROLE     = "Auto set role" ;
OQ.SETUP_CLASSPORTRAIT = "Use class portraits" ;
OQ.SETUP_GARBAGE      = "garbage collect (30 sec intervals)" ;
OQ.SETUP_SHOUTADS     = "Announce premades" ;
OQ.SETUP_AUTOACCEPT_MESH_REQ = "Auto accept b-tag mesh requests" ;
OQ.SETUP_OK2SUBMIT_BTAG      = "Submit b-tag every 4 days" ;
OQ.SETUP_AUTOJOIN_OQGENERAL  = "Auto join oqgeneral channel" ;
OQ.SETUP_AUTOHIDE_FRIENDREQS = "Auto hide friend requests" ;
OQ.SETUP_LOOT_ACCEPTANCE     = "Notify on loot method change" ;
OQ.SETUP_ADD          = "add" ;
OQ.SETUP_MYCREW       = "my crew" ;
OQ.SETUP_CLEAR        = "clear" ;
OQ.BN_FRIENDS         = "OQ enabled friends" ;
OQ.LOCAL_OQ_USERS     = "OQ enabled locals" ;
OQ.TIME_DRIFT         = "time drift" ;
OQ.PPS_SENT           = "pkts sent/sec" ;
OQ.PPS_RECVD          = "pkts recvd/sec" ;
OQ.PPS_PROCESSED      = "pkts processed/sec" ;
OQ.MEM_USED           = "memory used (kB)" ;
OQ.BANDWIDTH_UP       = "upload (kBps)" ;
OQ.BANDWIDTH_DN       = "download (kBps)" ;
OQ.OQSK_DTIME         = "time variance" ;
OQ.SETUP_CHECKNOW     = "check now" ;
OQ.SETUP_GODARK       = "go dark" ;
OQ.SETUP_REMOVENOW    = "remove now" ;
OQ.STILL_IN_PREMADE   = "please leave your current premade before creating a new one" ;
OQ.DD_PROMOTE         = "promote to group lead" ;
OQ.DD_KICK            = "remove member" ;
OQ.DD_BAN             = "BAN user's battle.tag" ;
OQ.DD_REFORM          = "reform group" ;
OQ.DISABLED           = "oQueue disabled" ;
OQ.ENABLED            = "oQueue enabled" ;
OQ.THETIMEIS          = "the time is %d (GMT)" ;
OQ.MSG_PREMADENAME    = "please enter a name for the premade" ;
OQ.MSG_MISSINGNAME    = "\nplease name your premade" ;
OQ.MSG_MISSINGVOIP    = "\nplease select which VoIP will be used, if any" ;
OQ.MSG_MISSINGTYPE    = "\nplease select premade type" ;
OQ.MSG_REJECT         = "waitlist request not accepted.\nreason: %s" ;
OQ.MSG_CANNOTCREATE_TOOLOW   = "Cannot create premade.  \nYou must be level 10 or higher" ;
OQ.MSG_NOTLFG         = "Please do not use oQueue as LookingForGroup advertisement. \nSome players may ban you from their premade if you do." ;
OQ.TAB_PREMADE        = "Premade" ;
OQ.TAB_FINDPREMADE    = "Find Premade" ;
OQ.TAB_CREATEPREMADE  = "Create Premade" ;
OQ.TAB_THESCORE       = "The Score" ;
OQ.TAB_SETUP          = "Setup" ;
OQ.TAB_BANLIST        = "Ban List" ;
OQ.TAB_WAITLIST       = "Wait List" ;
OQ.TAB_WAITLISTN      = "Wait List (%d)" ;
OQ.CONNECTIONS        = "connection  %d - %d" ;
OQ.ANNOUNCE_PREMADES  = "%d premades available" ;
OQ.NEW_PREMADE        = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r" ;
OQ.PREMADE_NAMEUPD    = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r" ;
OQ.DLG_OK             = "ok" ;
OQ.DLG_YES            = "yes" ;
OQ.DLG_NO             = "no" ;
OQ.DLG_CANCEL         = "cancel" ;
OQ.DLG_ENTER          = "Enter Battle" ;
OQ.DLG_LEAVE          = "Leave Queue" ;
OQ.DLG_READY          = "Ready" ;
OQ.DLG_NOTREADY       = "NOT Ready" ;
OQ.DLG_01             = "Please enter toon name:" ;
OQ.DLG_02             = "Enter Battle" ;
OQ.DLG_03             = "Please name your premade:" ;
OQ.DLG_04             = "Please enter your real-id:" ;
OQ.DLG_05             = "Password:" ;
OQ.DLG_06             = "Please enter real-id or name of new group leader:" ;
OQ.DLG_07             = "\nNEW VERSION Now Available !!\n\noQueue  v%s  build  %d\n" ;
OQ.DLG_08             = "Please leave your party to join the wait list or \nAsk your group leader to queue the whole party" ;
OQ.DLG_09             = "Only the group leader may create an OQ Premade" ;
OQ.DLG_10             = "The queue has popped.\n\nWhat is your decision?" ;
OQ.DLG_11             = "Your queue has popped.  Waiting for Raid Leader to make a decision.\nPlease stand by." ;
OQ.DLG_12             = "Are you sure you want to leave the raid group?" ;
OQ.DLG_13             = "The premade leader has initiated a ready check" ;
OQ.DLG_14             = "The raider leader has requested a reload" ;
OQ.DLG_15             = "Banning: %s \nPlease enter your reason:" ;
OQ.DLG_16             = "Unable to select premade type.\nToo many members (max. %d)" ;
OQ.DLG_17             = "Please enter the battle-tag to ban:" ;
OQ.DLG_18a            = "Version %d.%d.%d is now available" ;
OQ.DLG_18b            = "--  Required Update  --" ;
OQ.DLG_19             = "You must qualify for your own premade" ;
OQ.DLG_20             = "No groups allowed for this premade type" ;
OQ.DLG_21             = "Leave your premade before wait listing" ;
OQ.DLG_21a            = "You are already in a premade. Leave your current group?" ;
OQ.DLG_22             = "Disband your premade before wait listing" ;
OQ.DLG_22a            = "You are already in a premade. Disband and leave your current group?" ;
OQ.DLG_23             = "Armory link:\n\n  ctrl+C to copy the link \n  then paste it into your browser with ctrl+V\n" ;
OQ.MENU_KICKGROUP     = "kick group" ;
OQ.MENU_SETLEAD       = "set group leader" ;
OQ.HONOR_PTS          = "Honor Points" ;
OQ.NOBTAG_01          = " battle-tag information not received in time." ;
OQ.NOBTAG_02          = " please try again." ;
OQ.MINIMAP_HIDDEN     = "(OQ) minimap button hidden" ;
OQ.MINIMAP_SHOWN      = "(OQ) minimap button shown" ;
OQ.FINDMESH_OK        = "your connection is fine.  premades refresh on 30 second cycles" ;
OQ.TIMEERROR_1        = "OQ: your system time is significantly out of sync (%s)." ;
OQ.TIMEERROR_2        = "OQ: please update your system time and timezone." ;
OQ.SYS_YOUARE_AFK     = "You are now Away" ;
OQ.SYS_YOUARENOT_AFK  = "You are no longer Away" ;
OQ.ERROR_REGIONDATA   = "Region data has not loaded properly." ;
OQ.TT_LEAVEPREMADE    = "left-click:  de-waitlist\nright-click:  ban premade leader" ;
OQ.TT_FINDMESH        = "request battle-tags from the scorekeeper\nto get connected to the mesh" ;
OQ.TT_SUBMIT2MESH     = "submit your battle-tag to the scorekeeper\nto help grow the mesh" ;
OQ.LABEL_TYPE         = "|cFF808080type:|r  %s" ;
OQ.LABEL_ALL          = "all premades" ;
OQ.LABEL_BGS          = "battlegrounds" ;
OQ.LABEL_RBGS         = "rated bgs" ;
OQ.LABEL_DUNGEONS     = "dungeons" ;
OQ.LABEL_LADDERS      = "ladders" ;
OQ.LABEL_RAIDS        = "raids" ;
OQ.LABEL_SCENARIOS    = "scenarios" ;
OQ.LABEL_CHALLENGES   = "challenges" ;
OQ.LABEL_BG           = "battleground" ;
OQ.LABEL_RBG          = "rated bg" ;
OQ.LABEL_ARENAS       = "arenas" ;
OQ.LABEL_ARENA        = "arena" ;
OQ.LABEL_DUNGEON      = "dungeon" ;
OQ.LABEL_LADDER       = "ladder" ;
OQ.LABEL_RAID         = "raid" ;
OQ.LABEL_SCENARIO     = "scenario" ;
OQ.LABEL_CHALLENGE    = "challenge" ;
OQ.LABEL_MISC         = "miscellaneous" ;
OQ.LABEL_ROLEPLAY     = "roleplay" ;
OQ.PATTERN_CAPS       = "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]" ;
OQ.MATCHUP            = "match up" ;
OQ.NODIPFORYOU        = "You have more then %d bnet friends.  no dip for you." ;
OQ.GAINED             = "gained" ;
OQ.LOST               = "lost" ;
OQ.PERHOUR            = "per hour" ;
OQ.NOW                = "now" ;
OQ.WITH               = "with" ;
OQ.RAID_TOES          = "ToES" ;
OQ.RAID_HOF           = "HoF" ;
OQ.RAID_MV            = "MSV" ;
OQ.RAID_TOT           = "ToT" ;
OQ.RAID_RA_DEN        = "Ra-den" ;
OQ.RAID_SOO           = "SoO" ;
OQ.RBG_HRANK_1        = "Scout" ;
OQ.RBG_HRANK_2        = "Grunt" ;
OQ.RBG_HRANK_3        = "Sergeant" ;
OQ.RBG_HRANK_4        = "Senior Sergeant" ;
OQ.RBG_HRANK_5        = "First Sergeant" ;
OQ.RBG_HRANK_6        = "Stone Guard" ;
OQ.RBG_HRANK_7        = "Blood Guard" ;
OQ.RBG_HRANK_8        = "Legionnaire" ;
OQ.RBG_HRANK_9        = "Centurion" ;
OQ.RBG_HRANK_10       = "Champion" ;
OQ.RBG_HRANK_11       = "Lieutenant General" ;
OQ.RBG_HRANK_12       = "General" ;
OQ.RBG_HRANK_13       = "Warlord" ;
OQ.RBG_HRANK_14       = "High Warlord" ;
OQ.RBG_ARANK_1        = "Private" ;
OQ.RBG_ARANK_2        = "Corporal" ;
OQ.RBG_ARANK_3        = "Sergeant" ;
OQ.RBG_ARANK_4        = "Master Sergeant" ;
OQ.RBG_ARANK_5        = "Sergeant Major" ;
OQ.RBG_ARANK_6        = "Knight" ;
OQ.RBG_ARANK_7        = "Knight-Lieutenant" ;
OQ.RBG_ARANK_8        = "Knight-Captain" ;
OQ.RBG_ARANK_9        = "Knight-Champion" ;
OQ.RBG_ARANK_10       = "Lieutenant Commander" ;
OQ.RBG_ARANK_11       = "Commander" ;
OQ.RBG_ARANK_12       = "Marshal" ;
OQ.RBG_ARANK_13       = "Field Marshal" ;
OQ.RBG_ARANK_14       = "Grand Marshal" ;
OQ.TITLES             = "titles" ;
OQ.CONQUEROR          = "conqueror" ;
OQ.BLOODTHIRSTY       = "bloodthirsty" ;
OQ.BATTLEMASTER       = "battlemaster" ;
OQ.HERO               = "hero" ;
OQ.WARBRINGER         = "warbringer" ;
OQ.KHAN               = "khan" ;
OQ.RANAWAY            = "deserter.  loss registered"
OQ.TT_KARMA           = "karma"  ;
OQ.UP                 = "up" ;
OQ.DOWN               = "down" ;
OQ.BAD_KARMA_BTAG     = "OQ: selected group member's battle-tag is invalid" ;
OQ.MAX_KARMA_TODAY    = "OQ: %s has already received karma from you today" ;
OQ.YOUVE_GOT_KARMA    = "you've gained %d karma point." ;
OQ.YOUVE_LOST_KARMA   = "you've lost %d karma point." ;
OQ.YOUVE_LOST_KARMAS  = "you've lost %d karma points." ;
OQ.INSTANCE_LASTED    = "instance lasted" ;
OQ.SHOW_ILEVEL        = "show ilevel" ;
OQ.SOCKET             = " Socket" ;
OQ.SHA_TOUCHED        = "Sha--Touched" 
OQ.TT_BATTLE_TAG      = "battle-tag" ;
OQ.TT_REGULAR_BG      = "regular bgs" ;
OQ.TT_PERSONAL        = "as member" ;
OQ.TT_ASLEAD          = "as lead" ;
OQ.AVG_ILEVEL         = "avg ilevel: %d" ;
OQ.ENCHANTED          = "Enchanted:" ;
OQ.ENABLE_FOG         = "fog of war" ;
OQ.AUTO_INSPECT       = "Auto inspect (ctrl left-click)" ;
OQ.TIMELEFT           = "Time left:" ;
OQ.HORDE              = "Horde" ;
OQ.ALLIANCE           = "Alliance" ;
OQ.SETUP_TIMERWIDTH   = "Timer width" ;
OQ.BG_BEGINS          = " begin!" -- partial text of start msg
OQ.BG_BEGUN           = " begun!" -- partial text of start msg
OQ.SETUP_SHOW_CONTROLLED   = "Show controlled nodes" ;
OQ.MM_OPTION1         = "toggle main UI" ;
OQ.MM_OPTION2         = "toggle marquee" ;
OQ.MM_OPTION3         = "toggle timers" ;
OQ.MM_OPTION4         = "toggle threat UI" ;
OQ.MM_OPTION5         = "clear timers" ;
OQ.MM_OPTION6         = "show mesh time" ;
OQ.MM_OPTION7         = "fix UI" ;
OQ.MM_OPTION8         = "where am i?" ;
OQ.MM_OPTION9         = "go dark" ;
OQ.LABEL_QUESTING     = "questing" ;
OQ.LABEL_QUESTERS     = "quest groups" ;
OQ.ACTIVE_LASTPERIOD  = "# active last 7days" ;
OQ.SCORE_NLEADERS     = "# leaders" ;
OQ.SCORE_NGAMES       = "# games" ;
OQ.SCORE_NBOSSES      = "# bosses" ;
OQ.TT_PVERECORD       = "record (bosses - wipes)" ;
OQ.TT_5MANS           = "leader: 5 mans" ;
OQ.TT_RAIDS           = "leader: raids" ;
OQ.TT_CHALLENGES      = "leader: challenge runs" ;
OQ.TT_LEADER_DKP      = "leader: dragon kill pts" ;
OQ.TT_DKP             = "dragon kill pts" ;
OQ.SCORE_DKP          = "# dragon kill pts" ;
OQ.ERR_NODURATION     = "Unknown instance duration.  Unable to calculate currency changes" ;
OQ.DRUNK              = "..hic!" ;
OQ.MM_OPTION2a        = "toggle bounty board" ;
OQ.ANNOUNCE_CONTRACTS = "Announce contracts" ;
OQ.SETUP_SHOUTCONTRACTS = "Announce contracts" ;
OQ.CONTRACT_ARRIVED   = " Contract #%s just arrived!  Target: %s  Reward: |h%s" ;
OQ.CONTRACT_CLAIMED01 = "%s %s claimed contract #%s and won %s" ;
OQ.CONTRACT_CLAIMED02 = "%s claimed contract #%s and won %s" ;
OQ.TARGET_MARK        = "You've targeted a bounty target! (contract#%s)" ;
OQ.BOUNTY_TARGET      = "You've killed a bounty target! (contract#%s)" ;
OQ.DEATHMATCH_SCORE   = "Score!" ;
OQ.FRIEND_REQUEST     = "%s-%s wants to be your friend" ;
OQ.ALREADY_FRIENDED   = "you're already battle-net friends with %s" ;
OQ.TT_FRIEND_REQUEST  = "friend request" ;
OQ.DEATHMATCH_BEGINS  = "WPvP Death Match has begun!  Get to the spine in Pandaria and defend your pvp vendors!" ;
OQ.WONTHEMATCH        = "won the match!" ;

OQ.LABEL_VENTRILO     = "Ventrilo" ;
OQ.LABEL_SKYPE        = "Skype" ;
OQ.LABEL_TEAMSPEAK    = "Teamspeak" ;
OQ.LABEL_DOLBYAXON    = "Dolby Axon" ;
OQ.LABEL_RAIDCALL     = "RaidCall" ;
OQ.LABEL_RAZOR        = "Razer" ;
OQ.LABEL_MUMBLE       = "Mumble" ;
OQ.LABEL_UNSPECIFIED  = "Unspecified" ;
OQ.LABEL_NOVOICE      = "No voice" ;
OQ.LABEL_WOWVOIP      = "WoW in-game voip" ;

OQ.LABEL_US_ENGLISH   = "English (US)" ;
OQ.LABEL_UK_ENGLISH   = "English (UK)" ;
OQ.LABEL_OC_ENGLISH   = "English (Oceanic)" ;
OQ.LABEL_EURO         = "Euro (General)" ;
OQ.LABEL_RUSSIAN      = "Russian" ;
OQ.LABEL_GERMAN       = "German" ;
OQ.LABEL_ES_SPANISH   = "Spanish (ES)" ;
OQ.LABEL_MX_SPANISH   = "Spanish (MX)" ;
OQ.LABEL_BR_PORTUGUESE= "Portuguese (BR)" ;
OQ.LABEL_PT_PORTUGUESE= "Portuguese (PT)" ;
OQ.LABEL_FRENCH       = "French" ;
OQ.LABEL_ITALIAN      = "Italian" ;
OQ.LABEL_TURKISH      = "Turkish" ;
OQ.LABEL_GREEK        = "Greek" ;
OQ.LABEL_DUTCH        = "Dutch" ;
OQ.LABEL_SWEDISH      = "Swedish" ;
OQ.LABEL_ARABIC       = "Arabic" ;
OQ.LABEL_KOREAN       = "Korean" ;

OQ.ARENA_RANKS = { [ 0 ] = "",
                   [ 1 ] = "challenger",
                   [ 2 ] = "rival",
                   [ 3 ] = "duelist",
                   [ 4 ] = "gladiator"
                 } ;
OQ.TIMEVARIANCE_DLG = { "",
                        "Warning:",
                        "",
                        "  Your system time is significantly ",
                        "  different from the mesh.  You must",
                        "  correct it before being allowed to",
                        "  create a premade.",
                        "",
                        "  time variance:  %s",
                        "",
                        "- tiny",
                      } ;
OQ.LFGNOTICE_DLG = { "",
                        "Warning:",
                        "",
                        "  Do not use oQueue premade names for",
                        "  LFG or other types of personal",
                        "  advertisement.  Many people will ban ",
                        "  anyone using it as such.  If you get",
                        "  banned, you won't be able to join",
                        "  their groups.",
                        "",
                        "- tiny",
                      } ;


OQ.BG_NAMES     = { [ "Random Battleground"    ] = { type_id = OQ.RND  },
                    [ "Warsong Gulch"          ] = { type_id = OQ.WSG  },
                    [ "Twin Peaks"             ] = { type_id = OQ.TP   },
                    [ "The Battle for Gilneas" ] = { type_id = OQ.BFG  },
                    [ "Arathi Basin"           ] = { type_id = OQ.AB   },
                    [ "Eye of the Storm"       ] = { type_id = OQ.EOTS },
                    [ "Strand of the Ancients" ] = { type_id = OQ.SOTA },
                    [ "Isle of Conquest"       ] = { type_id = OQ.IOC  },
                    [ "Alterac Valley"         ] = { type_id = OQ.AV   },
                    [ "Silvershard Mines"      ] = { type_id = OQ.SSM  },
                    [ "Temple of Kotmogu"      ] = { type_id = OQ.TOK  },
                    [ "Deepwind Gorge"         ] = { type_id = OQ.DWG  },
                    [ "Dragon Kill Points"     ] = { type_id = OQ.DKP  },
                    [ ""                       ] = { type_id = OQ.NONE },
                  } ;
                  
OQ.BG_SHORT_NAME = { [ "Arathi Basin"           ] = "AB",
                     [ "Alterac Valley"         ] = "AV",
                     [ "The Battle for Gilneas" ] = "BFG",
                     [ "Eye of the Storm"       ] = "EotS",
                     [ "Isle of Conquest"       ] = "IoC",
                     [ "Strand of the Ancients" ] = "SotA",
                     [ "Wildhammer Stronghold"  ] = "TP",
                     [ "Dragonmaw Stronghold"   ] = "TP",
                     [ "Twin Peaks"             ] = "TP",
                     [ "Silverwing Hold"        ] = "WSG",
                     [ "Warsong Gulch"          ] = "WSG",
                     [ "Warsong Lumber Mill"    ] = "WSG",
                     [ "Silvershard Mines"      ] = "SSM",
                     [ "Temple of Kotmogu"      ] = "ToK",
                     [ "Deepwind Gorge"         ] = "DWG",
                     
                     [ OQ.AB                    ] = "AB",
                     [ OQ.AV                    ] = "AV",
                     [ OQ.BFG                   ] = "BFG",
                     [ OQ.EOTS                  ] = "EotS",
                     [ OQ.IOC                   ] = "IoC",
                     [ OQ.SOTA                  ] = "SotA",
                     [ OQ.TP                    ] = "TP",
                     [ OQ.WSG                   ] = "WSG",
                     [ OQ.SSM                   ] = "SSM",
                     [ OQ.TOK                   ] = "ToK",
                     [ OQ.DWG                   ] = "DWG",
                     
                     [ "AB"                     ] = OQ.AB,
                     [ "AV"                     ] = OQ.AV,
                     [ "BFG"                    ] = OQ.BFG,
                     [ "EotS"                   ] = OQ.EOTS,
                     [ "IoC"                    ] = OQ.IOC,
                     [ "SotA"                   ] = OQ.SOTA,
                     [ "TP"                     ] = OQ.TP,
                     [ "WSG"                    ] = OQ.WSG,
                     [ "SSM"                    ] = OQ.SSM,
                     [ "ToK"                    ] = OQ.TOK,
                     [ "DWG"                    ] = OQ.DWG,
                   } ;
                   
OQ.BG_STAT_COLUMN = { [ "Bases Assaulted"       ] = "Base Assaulted",
                      [ "Bases Defended"        ] = "Base Defended",
                      [ "Demolishers Destroyed" ] = "Demolisher Destroyed",
                      [ "Flag Captures"         ] = "Flag Captured",
                      [ "Flag Returns"          ] = "Flag Returned",
                      [ "Gates Destroyed"       ] = "Gate Destroyed",
                      [ "Graveyards Assaulted"  ] = "Graveyard Assaulted",
                      [ "Graveyards Defended"   ] = "Graveyard Defended",
                      [ "Towers Assaulted"      ] = "Tower Assaulted",
                      [ "Towers Defended"       ] = "Tower Defended",
                    } ;

OQ.TRANSLATED_BY = {} ;

-- Class talent specs
local DK    = { ["Blood"]          = "Tank",
                ["Frost"]          = "Melee",
                ["Unholy"]         = "Melee",
              } ;
local DRUID = { ["Balance"]        = "Knockback",
                ["Feral Combat"]   = "Melee",
                ["Restoration"]    = "Healer",
                ["Guardian"]       = "Tank",
              } ;
local HUNTER = { ["Beast Mastery"] = "Knockback",
                 ["Marksmanship"]  = "Ranged",
                 ["Survival"]      = "Ranged",
               } ;
local MAGE = {  ["Arcane"]         = "Knockback",
                ["Fire"]           = "Ranged",
                ["Frost"]          = "Ranged",
             } ; 
local MONK = {  ["Brewmaster"]     = "Tank",
                ["Mistweaver"]     = "Healer",
                ["Windwalker"]     = "Melee",
             } ; 
local PALADIN = { ["Holy"]         = "Healer",
                  ["Protection"]   = "Tank",
                  ["Retribution"]  = "Melee",
                } ; 
local PRIEST = { ["Discipline"]    = "Healer",
                 ["Holy"]          = "Healer",
                 ["Shadow"]        = "Ranged",
               } ; 
local ROGUE = { ["Assassination"]  = "Melee",
                ["Combat"]         = "Melee",
                ["Subtlety"]       = "Melee",
              } ; 
local SHAMAN = { ["Elemental"]     = "Knockback",
                 ["Enhancement"]   = "Melee",
                 ["Restoration"]   = "Healer",
               } ; 
local WARLOCK = { ["Affliction"]   = "Knockback",
                  ["Demonology"]   = "Knockback",
                  ["Destruction"]  = "Knockback",
                } ; 
local WARRIOR = { ["Arms"]         = "Melee",
                  ["Fury"]         = "Melee",
                  ["Protection"]   = "Tank",
                } ; 

OQ.BG_ROLES = {} ;
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

-- some bosses do not 'die'... their defeat must be detected by watching their yell emotes
-- this table maps a defeat emote to the boss-id (it'd be better if it was mapped to the name, but names aren't necessarily localized)
--
OQ.DEFEAT_EMOTES = {} ;
OQ.DEFEAT_EMOTES["The Sha of Hatred has fled my body... and the monastery, as well. I must thank you, strangers. The Shado-Pan are in your debt. Now, there is much work to be done..."] = 56884 ; -- Taran Zhu
OQ.DEFEAT_EMOTES["I am bested. Give me a moment and we will venture together to face the Sha."] = 60007 ; -- Master Snowdrift
OQ.DEFEAT_EMOTES["Even together... we failed..."] = 56747 ; -- Gu Cloudstrike
OQ.DEFEAT_EMOTES["Impossible! Our might is the greatest in all the empire!"] = 61445 ; -- Haiyan the Unstoppable, Trial of the King
OQ.DEFEAT_EMOTES["The haze has been lifted from my eyes... forgive me for doubting you..."] = 56732 ; -- Liu Flameheart


-- contract toon names; to translate, replace 'nil' with the translation
--
L["Doom Lord Kazzak"        ] = nil ;
L["Hogger"                  ] = nil ; 
L["Lord Overheat"           ] = nil ;
L["Randolph Moloch"         ] = nil ;
L["Adarogg"                 ] = nil ;
L["Slagmaw"                 ] = nil ;
L["Lava Guard Gordoth"      ] = nil ;
L["Newton Burnside"         ] = nil ;
L["Auctioneer Chilton"      ] = nil ;
L["Alchemist Mallory"       ] = nil ; 
L["Toddrick"                ] = nil ;  
L["Remen Marcot"            ] = nil ;
L["Goldtooth"               ] = nil ; 
L["Auctioneer Fazdran"      ] = nil ; 
L["Kixa"                    ] = nil ; 
L["Gor the Enforcer"        ] = nil ; 
L["Tarshaw Jaggedscar"      ] = nil ;
L["Rokar Bladeshadow"       ] = nil ; 
L["Kor'kron Spotter"        ] = nil ; 
L["Falstad Wildhammer"      ] = nil ;
L["Baine Bloodhoof"         ] = nil ; 
L["Fel Reaver"              ] = nil ; 
L["Brewmaster Roland"       ] = nil ; 
L["Reeler Uko"              ] = nil ; 
L["Sulik'shor"              ] = nil ; 
L["Qu'nas"                  ] = nil ; 
L["Nal'lak the Ripper"      ] = nil ;
L["Bonobos"                 ] = nil ;
L["Muerta"                  ] = nil ; 
L["Disha Fearwarden"        ] = nil ; 
L["Bonestripper Buzzard"    ] = nil ; 
L["Fulgorge"                ] = nil ; 
L["Sahn Tidehunter"         ] = nil ; 
L["Moldo One-Eye"           ] = nil ; 
L["Omnis Grinlok"           ] = nil ; 
L["Armsmaster Holinka"      ] = nil ; 
L["Roo Desvin"              ] = nil ; 
L["Hiren Loresong"          ] = nil ;
L["Vasarin Redmorn"         ] = nil ;
L["Grumbol Grimhammer"      ] = nil ;
L["Usha Eyegouge"           ] = nil ;
L["Bartlett the Brave"      ] = nil ; 
L["Anette Williams"         ] = nil ; 
L["Auctioneer Vizput"       ] = nil ; 
L["Lady Sylvanas Windrunner"] = nil ;
L["Devrak"                  ] = nil ; 
L["Felicia Maline"          ] = nil ; 
L["Radulf Leder"            ] = nil ; 
L["The Black Bride"         ] = nil ; 
L["Shan'ze Battlemaster"    ] = nil ; 
L["Holgar Stormaxe"         ] = nil ; 
L["Ruskan Goreblade"        ] = nil ; 
L["Maginor Dumas"           ] = nil ; 
L["High Sorcerer Andromath" ] = nil ;
L["Captain Dirgehammer"     ] = nil ; 
L["Keryn Sylvius"           ] = nil ; 
L["Bizmo's Brawlpub Bouncer"] = nil ; 
L["Myolor Sunderfury"       ] = nil ; 
L["Golnir Bouldertoe"       ] = nil ; 
L["Auctioneer Lympkin"      ] = nil ; 
L["Jarven Thunderbrew"      ] = nil ; 
L["Mistblade Scale-Lord"    ] = nil ; 
L["Major Nanners"           ] = nil ; 
L["Doris Chiltonius"        ] = nil ; 
L["Lucan Malory"            ] = nil ; 
L["Acon Deathwielder"       ] = nil ; 
L["Ethan Natice"            ] = nil ; 
L["Kri'chon"                ] = nil ; 
L["Warlord Bloodhilt"       ] = nil ; 
L["High Marshal Twinbraid"  ] = nil ;
L["Krol the Blade"          ] = nil ;
L["Ik-Ik the Nimble"        ] = nil ; 
L["Ai-Li Skymirror"         ] = nil ; 
L["Gar'lok"                 ] = nil ; 
L["Omnis Grinlok"           ] = nil ; 
L["Dak the Breaker"         ] = nil ; 
L["Karr the Darkener"       ] = nil ; 
L["Nalash Verdantis"        ] = nil ; 
L["Ai-Ran the Shifting Cloud"] = nil ; 
L["Major Nanners"           ] = nil ; 
L["Yorik Sharpeye"          ] = nil ; 
L["Kang the Soul Thief"     ] = nil ; 
L["Kal'tik the Blight"      ] = nil ; 
L["Scritch"                 ] = nil ; 
L["Sele'na"                 ] = nil ; 
L["Blackhoof"               ] = nil ; 
L["Nasra Spothide"          ] = nil ; 
L["Jonn-Dar"                ] = nil ; 
L["Ahone the Wanderer"      ] = nil ; 
L["Norlaxx"                 ] = nil ; 
L["Ski'thik"                ] = nil ; 
L["Havak"                   ] = nil ; 
L["Nessos the Oracle"       ] = nil ; 
L["Korda Torros"            ] = nil ; 
L["Borginn Darkfist"        ] = nil ; 

L["Krol the Blade"          ] = nil ;
L["Ik-Ik the Nimble"        ] = nil ;
L["Ai-Li Skymirror"         ] = nil ;
L["Gar'lok"                 ] = nil ;
L["Omnis Grinlok"           ] = nil ;
L["Dak the Breaker"         ] = nil ;
L["Karr the Darkener"       ] = nil ;
L["Nalash Verdantis"        ] = nil ;
L["Ai-Ran the Shifting Cloud"] = nil ;
L["Major Nanners"           ] = nil ;
L["Yorik Sharpeye"          ] = nil ;
L["Kang the Soul Thief"     ] = nil ;
L["Kal'tik the Blight"      ] = nil ;
L["Scritch"                 ] = nil ;
L["Sele'na"                 ] = nil ;
L["Blackhoof"               ] = nil ;
L["Nasra Spothide"          ] = nil ;
L["Jonn-Dar"                ] = nil ;
L["Ahone the Wanderer"      ] = nil ;
L["Norlaxx"                 ] = nil ;
L["Ski'thik"                ] = nil ;
L["Havak"                   ] = nil ;
L["Nessos the Oracle"       ] = nil ;
L["Korda Torros"            ] = nil ;
L["Borginn Darkfist"        ] = nil ;

L["Garnia"                  ] = nil ;
L["Leafmender"              ] = nil ;
L["Urdur the Cauterizer"    ] = nil ;
L["Rock Moss"               ] = nil ;
L["Spirit of Jadefire"      ] = nil ;
L["Tsavo'ka"                ] = nil ;
L["Spelurk"                 ] = nil ;
L["Cinderfall"              ] = nil ;
L["Golganarr"               ] = nil ;
L["Cranegnasher"            ] = nil ;
L["Scary Sprite"            ] = nil ;
L["Zhu-Gon the Sour"        ] = nil ;
L["Gu'chi the Swarmbringer" ] = nil ;
L["Watcher Osu"             ] = nil ;
L["Jakur of Ordon"          ] = nil ;
L["Rattleskew"              ] = nil ;
L["Stinkbraid"              ] = nil ;
L["Karkanos"                ] = nil ;
L["Cursed Hozen Swabby"     ] = nil ;
L["Zesqua"                  ] = nil ;
L["Dread Ship Vazuvius"     ] = nil ;
L["Chelon"                  ] = nil ;
L["Spectral Pirate"         ] = nil ;
--
OQ.raid_ids = { [L["Ahn'Qiraj Temple"           ]] =  1,
                [L["Blackwing Lair"             ]] =  2,
                [L["Molten Core"                ]] =  3,
                [L["Onyxia's Lair"              ]] =  4,
                [L["Ruins of Ahn'Qiraj"         ]] =  5,
                [L["Black Temple"               ]] =  6,
                [L["Gruul's Lair"               ]] =  7,
                [L["Karazhan"                   ]] =  8,
                [L["Magtheridon's Lair"         ]] =  9,
                [L["Serpentshrine Cavern"       ]] = 10,
                [L["Tempest Keep"               ]] = 11,
                [L["The Battle for Mount Hyjal" ]] = 12,
                [L["The Sunwell"                ]] = 13,
                [L["Icecrown Citadel"           ]] = 14,
                [L["Naxxramas"                  ]] = 15,
                [L["Onyxia's Lair"              ]] = 16,
                [L["The Eye of Eternity"        ]] = 17,
                [L["The Obsidian Sanctum"       ]] = 18,
                [L["The Ruby Sanctum"           ]] = 19,
                [L["Trial of the Crusader"      ]] = 20,
                [L["Ulduar"                     ]] = 21,
                [L["Vault of Archavon"          ]] = 22,
                [L["Baradin Hold"               ]] = 23,
                [L["Blackwing Descent"          ]] = 24,
                [L["Dragon Soul"                ]] = 25,
                [L["Firelands"                  ]] = 26,
                [L["The Bastion of Twilight"    ]] = 27,
                [L["Throne of the Four Winds"   ]] = 28,
                [L["Heart of Fear"              ]] = 29,
                [L["Mogu'shan Vaults"           ]] = 30,
                [L["Siege of Orgrimmar"         ]] = 31,
                [L["Terrace of Endless Spring"  ]] = 32,
                [L["Throne of Thunder"          ]] = 33,
                [L["World Boss"                 ]] = 63,
              } ;
              
OQ.raid_abbrevation = { [ 1] = L["AQ"], -- Ahn'Qiraj temple
                        [ 2] = L["BWL"], -- blackwing lair
                        [ 3] = L["MC"], -- molten core
                        [ 4] = L["Ony"], -- onyxia's lair
                        [ 5] = L["AQ20"], -- ruins of ahn'qiraj
                        [ 6] = L["BT"], -- black temple
                        [ 7] = L["Gruul"], -- gruul's lair
                        [ 8] = L["Kara"], -- karazhan
                        [ 9] = L["Mag"], -- magtheridon's lair
                        [10] = L["SSC"], -- serpentshrine cavern
                        [11] = L["TK"], -- tempest keep
                        [12] = L["Hyjal"], -- the battle for mount hyjal
                        [13] = L["SWP"], -- the sunwell
                        [14] = L["ICC"], -- icecrown citadel
                        [15] = L["Naxx"], -- naxxramas
                        [16] = L["Ony"], -- onyxia's lair
                        [17] = L["EoE"], -- the eye of eternity
                        [18] = L["OS"], -- the obsidian sanctum
                        [19] = L["RS"], -- the ruby sanctum
                        [20] = L["ToC"], -- trail of the crusader
                        [21] = L["Uld"], -- ulduar
                        [22] = L["VoA"], -- vault of archavon
                        [23] = L["BH"], -- baradin hold
                        [24] = L["BWD"], -- blackwing descent
                        [25] = L["DS"], -- dragon soul
                        [26] = L["FL"], -- firelands
                        [27] = L["BoT"], -- the bastion of twilight
                        [28] = L["4Winds"], -- throne of the four winds
                        [29] = L["HoF"], -- heart of fear
                        [30] = L["MSV"], -- mogu'shan vaults
                        [31] = L["SoO"], -- siege of orgrimmar
                        [32] = L["ToES"], -- terrace of endless spring
                        [33] = L["ToT"], -- throne of thunder
                        [63] = L["Boss"], -- world boss
                      } ;
                      
OQ.raid_bosses = { [ 1] = { [ 1] = L["The Prophet Skeram"],
                            [ 2] = L["Silithid Royalty"],
                            [ 3] = L["Battlegaurd Sartura"],
                            [ 4] = L["Fankriss the Unyielding"],
                            [ 5] = L["Viscidus"],
                            [ 6] = L["Princess Huhuran"],
                            [ 7] = L["Twin Emperors"],
                            [ 8] = L["Ouro"],
                            [ 9] = L["C'Thun"],
                          },
                   [ 2] = { [ 1] = L["Razorgore the Untamed"],
                            [ 2] = L["Vaelastrasz the Corrupt"],
                            [ 3] = L["Broodlord Lashlayer"],
                            [ 4] = L["Firemaw"],
                            [ 5] = L["Ebonroc"],
                            [ 6] = L["Flamegor"],
                            [ 7] = L["Chromaggus"],
                            [ 8] = L["Nefarian"],
                          },
                   [ 3] = { [ 1] = L["Lucifron"],
                            [ 2] = L["Magmadar"],
                            [ 3] = L["Gehennas"],
                            [ 4] = L["Garr"],
                            [ 5] = L["Shazzrah"],
                            [ 6] = L["Baron Geddon"],
                            [ 7] = L["Sulfron Harbinger"],
                            [ 8] = L["Golemagg the Incinerator"],
                            [ 9] = L["Majordomo Executus"],
                            [10] = L["Ragnaros"],
                          },
                   [ 4] = { [ 1] = L["Onyxia"],
                          },
                   [ 5] = { [ 1] = L["Kurinnaxx"],
                            [ 2] = L["General Rajaxx"],
                            [ 3] = L["Moam"],
                            [ 4] = L["Buru the Gorger"],
                            [ 5] = L["Ayamiss the Hunter"],
                            [ 6] = L["Ossirian the Unscarred"],
                          },
                   [ 6] = { [ 1] = L["High Warlord Naj'entus"],
                            [ 2] = L["Supremus"],
                            [ 3] = L["Shade of Akama"],
                            [ 4] = L["Teron Gorefiend"],
                            [ 5] = L["Gurtogg Bloodboil"],
                            [ 6] = L["Reliquary of Souls"],
                            [ 7] = L["Mother of Shahraz"],
                            [ 8] = L["The Illidari Council"],
                            [ 9] = L["Illidan Stormrage"],
                          },
                   [ 7] = { [ 1] = L["High King Maulgar"],
                            [ 2] = L["Gruul the Dragonkiller"],
                          },
                   [ 8] = { [ 1] = L["Attumen the Huntsman"],
                            [ 2] = L["Moroes"],
                            [ 3] = L["Maiden of Virtue"],
                            [ 4] = L["Opera Event"],
                            [ 5] = L["The Curator"],
                            [ 6] = L["Chess Event"],
                            [ 7] = L["Terestian Illhoof"],
                            [ 8] = L["Shade of Aran"],
                            [ 9] = L["Netherspite"],
                            [10] = L["Prince Malchezaar"],
                            [11] = L["Nightbane"],
                          },
                   [ 9] = { [ 1] = L["Magtheridon"],
                          },
                   [10] = { [ 1] = L["Hydross the Unstable"],
                            [ 2] = L["The Lurker Below"],
                            [ 3] = L["Leotheras the Blind"],
                            [ 4] = L["Fathom-Lord Karathress"],
                            [ 5] = L["Morogrim Tidewalker"],
                            [ 6] = L["Lady Vashj"],
                          },
                   [11] = { [ 1] = L["Al'ar"],
                            [ 2] = L["Void Reaver"],
                            [ 3] = L["High Astromancer Solarian"],
                            [ 4] = L["Kael'thas Sunstrider"],
                          },
                   [12] = { [ 1] = L["Rage Winterchill"],
                            [ 2] = L["Anetheron"],
                            [ 3] = L["Kaz'rogal"],
                            [ 4] = L["Azgalor"],
                            [ 5] = L["Archimonde"],
                          },
                   [13] = { [ 1] = L["Kalecgos"],
                            [ 2] = L["Brutallus"],
                            [ 3] = L["Felmyst"],
                            [ 4] = L["Eredar Twins"],
                            [ 5] = L["M'uru"],
                            [ 6] = L["Kil'jaeden"],
                          },
                   [14] = { [ 1] = L["Lord Marrowgar"],
                            [ 2] = L["Lady Deathwhisper"],
                            [ 3] = L["Icecrown Gunship Battle"],
                            [ 4] = L["Deathbringer Saurfang"],
                            [ 5] = L["Rotface"],
                            [ 6] = L["Festergut"],
                            [ 7] = L["Professor Putricide"],
                            [ 8] = L["Blood Council"],
                            [ 9] = L["Queen Lana'thel"],
                            [10] = L["Valithria Dreamwalker"],
                            [11] = L["Sindragosa"],
                            [12] = L["The Lich King"],
                          },
                   [15] = { [ 1] = L["Anub'Rekhan"],
                            [ 2] = L["Grand Widow Faerlina"],
                            [ 3] = L["Maexxna"],
                            [ 4] = L["Noth the Plaguebringer"],
                            [ 5] = L["Heigan the Unclean"],
                            [ 6] = L["Loatheb"],
                            [ 7] = L["Instructor Razuvious"],
                            [ 8] = L["Gothik the Harvester"],
                            [ 9] = L["The Four Horsemen"],
                            [10] = L["Patchwerk"],
                            [11] = L["Grobbulus"],
                            [12] = L["Gluth"],
                            [13] = L["Thaddius"],
                            [14] = L["Sapphiron"],
                            [15] = L["Kel'Thuzad"],
                          },
                   [16] = { [ 1] = L["Onyxia"],
                          },
                   [17] = { [ 1] = L["Malygos"],
                          },
                   [18] = { [ 1] = L["Sartharion"],
                          },
                   [19] = { [ 1] = L["Halion"],
                          },
                   [20] = { [ 1] = L["Northrend Beasts"],
                            [ 2] = L["Lord Jaraxxus"],
                            [ 3] = L["Faction Champions"],
                            [ 4] = L["Val'kyr Twins"],
                            [ 5] = L["Anub'arak"],
                          },
                   [21] = { [ 1] = L["Flame Leviathan"],
                            [ 2] = L["Ignis the Furnance Master"],
                            [ 3] = L["Razorscale"],
                            [ 4] = L["XT-002 Deconstructor"],
                            [ 5] = L["Assembly of Iron"],
                            [ 6] = L["Kologarn"],
                            [ 7] = L["Auriaya"],
                            [ 8] = L["Freya"],
                            [ 9] = L["Hodir"],
                            [10] = L["Mimiron"],
                            [11] = L["Thorim"],
                            [12] = L["General Vezax"],
                            [13] = L["Yogg-Saron"],
                            [14] = L["Algalon the Observer"],
                          },
                   [22] = { [ 1] = L["Archavon the Stone Watcher"],
                            [ 2] = L["Emalon the Storm Watcher"],
                            [ 3] = L["Koralon the Flame Watcher"],
                            [ 4] = L["Toravon the Ice Watcher"],
                          },
                   [23] = { [ 1] = L["Argaloth"],
                            [ 2] = L["Occu'thar"],
                            [ 3] = L["Alizabal"],
                          },
                   [24] = { [ 1] = L["Magmaw"],
                            [ 2] = L["Omnotron Defense System"],
                            [ 3] = L["Maloriak"],
                            [ 4] = L["Atramedes"],
                            [ 5] = L["Chimaeron"],
                            [ 6] = L["Nefarian"],
                          },
                   [25] = { [ 1] = L["Morchok"],
                            [ 2] = L["Warlord Zon'ozz"],
                            [ 3] = L["Yor'sahj the Unsleeping"],
                            [ 4] = L["Hagara the Stormbinder"],
                            [ 5] = L["Ultraxion"],
                            [ 6] = L["Warmaster Blackhorn"],
                            [ 7] = L["Spine of Deathwing"],
                            [ 8] = L["Madness of Deathwing"],
                          },
                   [26] = { [ 1] = L["Shannox"],
                            [ 2] = L["Lord Rhyolith"],
                            [ 3] = L["Beth'tilac"],
                            [ 4] = L["Alysrazor"],
                            [ 5] = L["Baleroc"],
                            [ 6] = L["Majordomo Staghelm"],
                            [ 7] = L["Ragnaros"],
                          },
                   [27] = { [ 1] = L["Halfus Wyrmbreaker"],
                            [ 2] = L["Theralion and Valiona"],
                            [ 3] = L["Ascendant Council"],
                            [ 4] = L["Cho'gall"],
                            [ 5] = L["Sinestra"],
                          },
                   [28] = { [ 1] = L["Conclave of Wind"],
                            [ 2] = L["Al'Akir"],
                          },
                   [29] = { [ 1] = L["Impreial Vizier Zor'lok"],
                            [ 2] = L["Blade Lord Ta'yak"],
                            [ 3] = L["Garalon"],
                            [ 4] = L["Wind Lord Mel'jarak"],
                            [ 5] = L["Amber-Shaper Un'sok"],
                            [ 6] = L["Grand Empress Shek'zeer"],
                          },
                   [30] = { [ 1] = L["The Stone Guard"],
                            [ 2] = L["Feng the Accursed"],
                            [ 3] = L["Gara'jal the Spiritbinder"],
                            [ 4] = L["The Spirit Kings"],
                            [ 5] = L["Elegon"],
                            [ 6] = L["Will of the Emperor"],
                          },
                   [31] = { [ 1] = L["Immerseus"],
                            [ 2] = L["The Fallen Protectors"],
                            [ 3] = L["Norushen"],
                            [ 4] = L["Sha of Pride"],
                            [ 5] = L["Galakras"],
                            [ 6] = L["Iron Juggernaut"],
                            [ 7] = L["Kor'kron Dark Shaman"],
                            [ 8] = L["General Nazgrim"],
                            [ 9] = L["Malkorok"],
                            [10] = L["Spoils of Pandaria"],
                            [11] = L["Thok the Bloodthirsty"],
                            [12] = L["Siegecrafter Blackfuse"],
                            [13] = L["Paragons of the Klaxxi"],
                            [14] = L["Garrosh Hellscream"],
                          },
                   [32] = { [ 1] = L["Protectors of the Endless"],
                            [ 2] = L["Tsulong"],
                            [ 3] = L["Lei Shi"],
                            [ 4] = L["Sha of Fear"],
                          },
                   [33] = { [ 1] = L["Jin'rokh the Breaker"],
                            [ 2] = L["Horridon"],
                            [ 3] = L["Council of Elders"],
                            [ 4] = L["Tortos"],
                            [ 5] = L["Megaera"],
                            [ 6] = L["Ji-Kun"],
                            [ 7] = L["Durumu the Forgotten"],
                            [ 8] = L["Primordius"],
                            [ 9] = L["Dark Animus"],
                            [10] = L["Iron Qon"],
                            [11] = L["Twin Consorts"],
                            [12] = L["Lei Shen"],
                            [13] = L["Ra-den"],
                          },
                   [63] = { [ 1] = L["Omen"],
                            [ 2] = L["Galleon"],
                            [ 3] = L["Sha of Anger"],
                            [ 4] = L["Nalak"],
                            [ 5] = L["Oondasta"],
                            [ 6] = L["Chi-Ji"],
                            [ 7] = L["Xuen"],
                            [ 8] = L["Niuzao"],
                            [ 9] = L["Yu'lon"],
                            [10] = L["Ordos"],
                          },
                 } ;

OQ.boss_nicknames = { [ L["The Prophet Skeram"        ] ] = L["The Prophet"],
                      [ L["Silithid Royalty"          ] ] = L["Royalty"],
                      [ L["Battlegaurd Sartura"       ] ] = L["Sartura"],
                      [ L["Fankriss the Unyielding"   ] ] = L["Fankriss"],
                      [ L["Princess Huhuran"          ] ] = L["Huhuran"],
                      [ L["Twin Emperors"             ] ] = L["Twins"],
                      [ L["Razorgore the Untamed"     ] ] = L["Razorgore"],
                      [ L["Vaelastrasz the Corrupt"   ] ] = L["Vaelastrasz"],
                      [ L["Broodlord Lashlayer"       ] ] = L["Lashlayer"],
                      [ L["Baron Geddon"              ] ] = L["Geddon"],
                      [ L["Sulfron Harbinger"         ] ] = L["Sulfron"],
                      [ L["Golemagg the Incinerator"  ] ] = L["Golemagg"],
                      [ L["Majordomo Executus"        ] ] = L["Executus"],
                      [ L["General Rajaxx"            ] ] = L["Rajaxx"],
                      [ L["Buru the Gorger"           ] ] = L["Buru"],
                      [ L["Ayamiss the Hunter"        ] ] = L["Ayamiss"],
                      [ L["Ossirian the Unscarred"    ] ] = L["Ossirian"],
                      [ L["High Warlord Naj'entus"    ] ] = L["Naj'entus"],
                      [ L["Shade of Akama"            ] ] = L["Akama"],
                      [ L["Teron Gorefiend"           ] ] = L["Teron"],
                      [ L["Gurtogg Bloodboil"         ] ] = L["Gurtogg"],
                      [ L["Reliquary of Souls"        ] ] = L["Reliquary"],
                      [ L["Mother of Shahraz"         ] ] = L["Shahraz"],
                      [ L["The Illidari Council"      ] ] = L["Council"],
                      [ L["Illidan Stormrage"         ] ] = L["Illidan"],
                      [ L["High King Maulgar"         ] ] = L["Maulgar"],
                      [ L["Gruul the Dragonkiller"    ] ] = L["Gruul"],
                      [ L["Attumen the Huntsman"      ] ] = L["Huntsman"],
                      [ L["Maiden of Virtue"          ] ] = L["Maiden"],
                      [ L["Terestian Illhoof"         ] ] = L["Illhoof"],
                      [ L["Prince Malchezaar"         ] ] = L["Malchezaar"],
                      [ L["Hydross the Unstable"      ] ] = L["Hydross"],
                      [ L["The Lurker Below"          ] ] = L["Lurker"],
                      [ L["Leotheras the Blind"       ] ] = L["Leotheras"],
                      [ L["Fathom-Lord Karathress"    ] ] = L["Karathress"],
                      [ L["Morogrim Tidewalker"       ] ] = L["Morogrim"],
                      [ L["High Astromancer Solarian" ] ] = L["Solarian"],
                      [ L["Kael'thas Sunstrider"      ] ] = L["Kael'thas"],
                      [ L["Rage Winterchill"          ] ] = L["Winterchill"],
                      [ L["Lord Marrowgar"            ] ] = L["Marrowgar"],
                      [ L["Lady Deathwhisper"         ] ] = L["Deathwhisper"],
                      [ L["Icecrown Gunship"          ] ] = L["Gunship"],
                      [ L["Deathbringer Saurfang"     ] ] = L["Saurfang"],
                      [ L["Professor Putricide"       ] ] = L["Putricide"],
                      [ L["Blood Prince Council"      ] ] = L["Council"],
                      [ L["Queen Lana'thel"           ] ] = L["Lana'thel"],
                      [ L["Blood-Queen Lana'thel"     ] ] = L["Lana'thel"],
                      [ L["Valithria Dreamwalker"     ] ] = L["Valithria"],
                      [ L["The Lich King"             ] ] = L["Lich King"],
                      [ L["Grand Widow Faerlina"      ] ] = L["Faerlina"],
                      [ L["Noth the Plaguebringer"    ] ] = L["Noth"],
                      [ L["Heigan the Unclean"        ] ] = L["Heigan"],
                      [ L["Instructor Razuvious"      ] ] = L["Razuvious"],
                      [ L["Gothik the Harvester"      ] ] = L["Gothik"],
                      [ L["The Four Horsemen"         ] ] = L["Horsemen"],
                      [ L["Northrend Beasts"          ] ] = L["Beasts"],
                      [ L["Faction Champions"         ] ] = L["Champions"],
                      [ L["Flame Leviathan"           ] ] = L["Leviathan"],
                      [ L["Ignis the Furnance Master" ] ] = L["Ignis"],
                      [ L["XT-002 Deconstructor"      ] ] = L["XT-002"],
                      [ L["Algalon the Observer"      ] ] = L["Algalon"],
                      [ L["Archavon the Stone Watcher"] ] = L["Archavon"],
                      [ L["Emalon the Storm Watcher"  ] ] = L["Emalon"],
                      [ L["Koralon the Flame Watcher" ] ] = L["Koralon"],
                      [ L["Toravon the Ice Watcher"   ] ] = L["Toravon"],
                      [ L["Omnotron Defense System"   ] ] = L["Omnotron"],
                      [ L["Yor'sahj the Unsleeping"   ] ] = L["Yor'sahj"],
                      [ L["Hagara the Stormbinder"    ] ] = L["Hagara"],
                      [ L["Warmaster Blackhorn"       ] ] = L["Warmaster"],
                      [ L["Spine of Deathwing"        ] ] = L["Spine"],
                      [ L["Madness of Deathwing"      ] ] = L["Madness"],
                      [ L["Majordomo Staghelm"        ] ] = L["Staghelm"],
                      [ L["Halfus Wyrmbreaker"        ] ] = L["Halfus"],
                      [ L["Theralion and Valiona"     ] ] = L["Theralion"],
                      [ L["Ascendant Council"         ] ] = L["Council"],
                      [ L["Grand Empress Shek'zeer"   ] ] = L["Shek'zeer"],
                      [ L["Amber-Shaper Un'sok"       ] ] = L["Un'sok"],
                      [ L["Wind Lord Mel'jarak"       ] ] = L["Mel'jarak"],
                      [ L["Blade Lord Ta'yak"         ] ] = L["Ta'yak"],
                      [ L["Impreial Vizier Zor'lok"   ] ] = L["Zor'lok"],
                      [ L["Feng the Accursed"         ] ] = L["Feng"],
                      [ L["Gara'jal the Spiritbinder" ] ] = L["Gara'jal"],
                      [ L["Will of the Emperor"       ] ] = L["Emperor"],
                      [ L["The Fallen Protectors"     ] ] = L["Protectors"],
                      [ L["Kor'kron Dark Shaman"      ] ] = L["Kor'kron"],
                      [ L["General Nazgrim"           ] ] = L["Nazgrim"],
                      [ L["Spoils of Pandaria"        ] ] = L["Spoils"],
                      [ L["Thok the Bloodthirsty"     ] ] = L["Thok"],
                      [ L["Siegecrafter Blackfuse"    ] ] = L["Blackfuse"],
                      [ L["Paragons of the Klaxxi"    ] ] = L["Paragons"],
                      [ L["Garrosh Hellscream"        ] ] = L["Garrosh"],
                      [ L["Protectors of the Endless" ] ] = L["Protectors"],
                      [ L["Jin'rokh the Breaker"      ] ] = L["Jin'rokh"],
                      [ L["Council of Elders"         ] ] = L["Council"],
                      [ L["Durumu the Forgotten"      ] ] = L["Durumu"],
                      [ L["Twin Consorts"             ] ] = L["Twins"],
                    } ;
                    
OQ.lieutenants = { [L["Prince Valanar"       ]] = L["Blood Council"],
                   [L["Prince Taldaram"      ]] = L["Blood Council"],
                   [L["Prince Keleseth"      ]] = L["Blood Council"],
                   [L["Blood-Queen Lana'thel"]] = L["Queen Lana'thel"],
                   [L["Orgrim's Hammer"      ]] = L["Icecrown Gunship Battle"],
                   [L["The Skybreaker"       ]] = L["Icecrown Gunship Battle"],
--                   [L[""]] = L[""],
                 } ;
-- 
L[" Battle.net is currently down."] = nil ;
L[" oQueue will not function properly until Battle.net is restored."] = nil ;
L[" Please set your battle-tag before using oQueue."] = nil ;
L[" Your battle-tag can only be set via your WoW account page."] = nil ;
L["NOTICE:  You've exceeded the cap before the cap(%s).  removed: %s"] = nil ;
L["WARNING:  Your battle.net friends list has %s friends."] = nil ;
L["WARNING:  You've exceeded the cap before the cap(%s)"] = nil ;
L["WARNING:  No mesh nodes available for removal.  Please trim your b.net friends list"] = nil ;
L["Found oQ banned b.tag on your friends list.  removing: %s"] = nil ;
  
L["loot.freeforall"     ] = "free for all" ;
L["loot.roundrobin"     ] = "round robin" ;
L["loot.master"         ] = "master looter" ;
L["loot.group"          ] = "group loot" ;
L["loot.needbeforegreed"] = "need before greed" ;

OQ.HINTS = { [ 1] = L["</p><br/><h3 align=\"center\">|cffE9EB15Don't Panic|r</h3><p>"],
             [ 2] = L["if your buddy is always standing in the fire, he might not see it due to being color blind<br/><br/>click the '+' button next to color blind support on the setup tab to cycle through the various color schemes."],
             [ 3] = L["control+left-click on a leader or player on the wait list to get their armory link"],
             [ 4] = L["control+left-click on a friendly player will auto-inspect and show their gear"],
             [ 5] = L["holding SHIFT on the find-premade tab will PAUSE the list until released"],
             [ 6] = L["avoid pug groups with no voice comms for a better experience.<br/><br/>try to reach out and communicate with the people in your group.  you may learn new techniques, strategies, or maybe make a friend."],
             [ 7] = L["award karma to group members using the log or clicking their square on the main premade tab"],
             [ 8] = L["resize the window by dragging the bottom right corner"],
             [ 9] = L["list local group leaders by typing: <br/><br/>/oq show locals"],
             [10] = L["if you see no premades, your connection might be weak or broken.<br/><br/>if you have a weak or broken connection, hit find-mesh and wait for connections from the scorekeeper<br/><br/>also make sure 'auto-join oqgeneral' on setup is checked"],
             [11] = L["hitting find-mesh will request mesh tags from the scorekeeper.  he will send you six(6) random tags active in the last hour.<br/><br/>they may or may not still be online, but will connect when they log in next"],
             [12] = L["your mesh connection is in the lower right<br/><br/>[realm] - [bnet list]<br/><br/>your connection is 'weak' if the sum is less then 20"],
             [13] = L["gain more mesh connections by clicking the find-mesh button"],
             [14] = L["clicking the remove-now button will remove mesh connections.  use with caution"],
             [15] = L["right-click the red 'x' on the find-premade list to ban that group leader"],
             [16] = L["if you're confused, find tiny in public vent"],
             [17] = L["click the spyglass at the top left of the find-premade tab to filter the list<br/><br/>you can use the following logical operators:<br/><br/> &amp; (and)<br/> | (or)<br/> ! (not)<br/><br/>ie:  rbgs | cta &amp; !yolo<br/><br/>meaning:<br/> rbgs or cta and not yolo"],
             [18] = L["you can use wildcards in the spyglass filter<br/><br/>ie:  flex.*1"],
             [19] = L["more advanced filters are possible<br/><br/>ie: flex.*1 | flex.*2"],
             [20] = L["leaders with good karma will have greenish names on the find-premade list.<br/><br/>leaders with bad karma will be shown in red<br/><br/>white is neutral"],
             [21] = L["your karma reflects the opinions of your performance and personality by those you've grouped with.<br/><br/>karma ranges from -25 to +25 and degrades by 1 pt, back towards 0, every 24 hours"],
             [22] = L["karma - what goes around, comes around"],
             [23] = L["right-click filter options on the find-premade tab to toggle exclusion of that type."],
             [24] = L["check the setup tab for various UI tweaks.<br/><br/>such as announcing contracts or showing class portaits on targets"],
             [25] = L["some folks have tried to claim it's bannable to queue with a full 25 for LFR.<br/><br/>this is completely false.<br/><br/>oQueue usage is perfectly fine with Blizzard and within all aspects of the EULA and TOS."],
             [26] = L["gear slots with a red glow contain pvp gear<br/><br/>gear slots with a blue glow contain pve gear"],
             [27] = L["you'll never hit a home run, if you don't step up to the plate"],
             [29] = L["use icebox to install oQueue and other addons.<br/><br/>quick and simple.<br/><br/>its advanced features are very useful!"],
             [30] = L["you make your own luck"],
             [31] = L["in life, you're either the pigeon or the statue"],
           } ;

