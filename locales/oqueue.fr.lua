--[[ 
  @file       oqueue.fr.lua
  @brief      localization for oqueue addon (french)

  @author     rmcinnis
  @date       june 11, 2012
  @par        copyright (c) 2012 Solid ICE Technologies, Inc.  All rights reserved.
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;

OQ.TRANSLATED_BY["frFR"] = "Shamallo" ;
OQ.TRANSLATED_BY["frFR"] = "Alathèa (Medivh, EU)" ;
if ( GetLocale() ~= "frFR" ) then
  return ;
end
local L = OQ._T ; -- for literal string translations

BINDING_HEADER_OQUEUE           = "oQueue";
BINDING_NAME_TOGGLE_OQUEUE      = "Touche oQueue";
BINDING_NAME_AUTO_INSPECT       = "Inspection Automatique";
BINDING_NAME_WAITLIST_INVITEALL = "Inviter Tous";

OQ.TITLE_LEFT         = "oQueue v" ;
OQ.TITLE_RIGHT        = " - Chercheur de groupe" ;
OQ.BNET_FRIENDS       = "%d Amis battle-net" ;
OQ.PREMADE            = "Groupe" ;
OQ.FINDPREMADE        = "Chercher groupe" ;
OQ.CREATEPREMADE      = "Créer groupe" ;
OQ.CREATE_BUTTON      = "Créer groupe" ;
OQ.UPDATE_BUTTON      = "Mettre à jour groupe" ;
OQ.WAITLIST           = "File d'attente" ;
OQ.HONOR_BUTTON       = "OQ groupe" ;
OQ.SETUP              = "Configuration" ;
OQ.PLEASE_SELECT_BG   = "SVP choisir un champ de bataille" ;
OQ.BAD_REALID         = "Royaume-ID ou B-TAG invalide.\n" ;
OQ.QUEUE1_SELECTBG    = "<Choisir un champ de bataille>" ;
OQ.NOLEADS_IN_RAID    = "Il n'y a pas de Chef de raid dans le raid" ;
OQ.NOGROUPS_IN_RAID   = "Impossible d'inviter le groupe dans le raid directement" ;
OQ.BUT_INVITE         = "Inviter" ;
OQ.BUT_GROUPLEAD      = "Chef de groupe" ;
OQ.BUT_INVITEGROUP    = "Groupe (%d)" ;
OQ.BUT_WAITLIST       = "Rejoindre" ;
OQ.BUT_INGAME         = "En jeu" ;
OQ.BUT_PENDING        = "En attente" ;
OQ.BUT_INPROGRESS     = "En combat" ;
OQ.BUT_NOTAVAILABLE   = "Attente" ;
OQ.BUT_FINDMESH       = "Recherche réseau" ;
OQ.BUT_CLEARFILTERS   = "Retirer filtre" ;
OQ.BUT_SUBMIT2MESH    = "Suggérer B-TAG" ;
OQ.BUT_PULL_BTAG      = "Retirer B-TAG" ;
OQ.BUT_BAN_BTAG       = "Bannir B-TAG" ;
OQ.BUT_INVITE_ALL     = "Inviter " ;
OQ.BUT_REMOVE_OFFLINE = "Retirer Hors Ligne" ;
OQ.TT_LEADER          = "Chef" ;
OQ.TT_REALM           = "Royaume" ;
OQ.TT_BATTLEGROUP     = "Corps de bataille" ;
OQ.TT_MEMBERS         = "Membres" ;
OQ.TT_WAITLIST        = "File d'attente" ;
OQ.TT_RECORD          = "Record (Victoire - Défaite)" ;
OQ.TT_AVG_HONOR       = "Moyenne honneur/jeu" ;
OQ.TT_AVG_HKS         = "avg hks/game" ;
OQ.TT_AVG_GAME_LEN    = "avg game length" ;
OQ.TT_AVG_DOWNTIME    = "avg down time" ;
OQ.TT_RESIL           = "Résilience" ;
OQ.TT_ILEVEL          = "ilevel" ;
OQ.TT_MAXHP           = "Max HP" ;
OQ.TT_WINLOSS         = "Victoire - Défaite" ;
OQ.TT_HKS             = "total hks" ;
OQ.TT_OQVERSION       = "Version" ;
OQ.TT_TEARS           = "tears" ;
OQ.TT_PVPPOWER        = "Puissance JcJ" ;
OQ.TT_MMR             = "Côte JcJ" ;
OQ.JOIN_QUEUE         = "Joindre file" ;
OQ.LEAVE_QUEUE        = "Quitter file" ;
OQ.LEAVE_QUEUE_BIG    = "SORTIE FILE" ;
OQ.DAS_BOOT           = "DAS BOOT !!" ;
OQ.DISBAND_PREMADE    = "Dissoudre groupe" ;
OQ.LEAVE_PREMADE      = "Quitter Groupe" ;
OQ.RELOAD             = "Recharger" ;
OQ.ILL_BRB            = "S'absenter" ;
OQ.LUCKY_CHARMS       = "Porte-Bonheur" ;
OQ.IAM_BACK           = "Je suis de retour" ;
OQ.ROLE_CHK           = "Vérification des rôles" ;
OQ.READY_CHK          = "Appel" ;
OQ.APPROACHING_CAP    = "APPROCHE DU PLAFOND" ;
OQ.CAPPED             = "ÉTONNÉ" ;
OQ.HDR_PREMADE_NAME   = "Groupes" ;
OQ.HDR_LEADER         = "Chef" ;
OQ.HDR_LEVEL_RANGE    = "Niveau(x)" ;
OQ.HDR_ILEVEL         = "ilevel" ;
OQ.HDR_RESIL          = "Résilience" ;
OQ.HDR_POWER          = "Puissance JcJ" ;
OQ.HDR_TIME           = "Temps" ;
OQ.QUALIFIED          = "Qualifié" ;
OQ.PREMADE_NAME       = "Nom de groupe" ;
OQ.LEADERS_NAME       = "Chef de raid" ;
OQ.REALID             = "Royaume-ID ou B-TAG" ;
OQ.REALID_MOP         = "B-TAG" ;
OQ.MIN_ILEVEL         = "Minimum ilevel" ;
OQ.MIN_RESIL          = "Minimum résilience" ;
OQ.MIN_MMR            = "Minimum côte BG" ;
OQ.BATTLEGROUNDS      = "Description" ;
OQ.ENFORCE_LEVELS     = "Respecter la tranche de niveau" ;
OQ.NOTES              = "Remarques" ;
OQ.PASSWORD           = "Mot de passe" ;
OQ.CREATEURPREMADE    = "Créez votre groupe" ;
OQ.LABEL_LEVEL        = "Niveau" ;
OQ.LABEL_LEVELS       = "Niveaux" ;
OQ.HDR_BGROUP         = "Bgroupe" ;
OQ.HDR_TOONNAME       = "Pseudo" ;
OQ.HDR_REALM          = "Royaume" ;
OQ.HDR_LEVEL          = "Niveaux" ;
OQ.HDR_ILEVEL         = "ilevel" ;
OQ.HDR_RESIL          = "Résilience" ;
OQ.HDR_MMR            = "Côte" ;
OQ.HDR_PVPPOWER       = "Puissance" ;
OQ.HDR_HASTE          = "Hâte" ;
OQ.HDR_MASTERY        = "Maîtrise" ;
OQ.HDR_HIT            = "Critique" ;
OQ.HDR_DATE           = "Date" ;
OQ.HDR_BTAG           = "B-TAG" ;
OQ.HDR_REASON         = "Raison" ;
OQ.RAFK_ENABLED       = "Rafk Activé" ;
OQ.RAFK_DISABLED      = "Rafk Désactivé" ;
OQ.SETUP_HEADING      = "Configuration et commandes diverses" ;
OQ.SETUP_BTAG         = "Adresse email battlenet" ;
OQ.SETUP_GODARK_LBL   = "Dire à tous les amis OQ que vous êtes invisible" ;
OQ.SETUP_CAPCHK       = "Obliger OQ à vérifier la capacité" ;
OQ.SETUP_REMOQADDED   = "Retirer les amis ajoutés par OQ" ;
OQ.SETUP_REMOVEBTAG   = "Retirer B-TAG du marqueur" ;
OQ.SETUP_ALTLIST      = "Liste d'alts sur ce compte battle.net:\n (seulement pour multi-boxing)" ;
OQ.SETUP_AUTOROLE     = "Choix automatique du rôle" ;
OQ.SETUP_CLASSPORTRAIT = "Utiliser des portaits de classe" ;
OQ.SETUP_SAYSAPPED    = "Dire Sappé" ;
OQ.SETUP_WHOPOPPED    = "Who Popped Lust?" ;
OQ.SETUP_GARBAGE      = "garbage collect (30 sec intervals)" ;
OQ.SETUP_SHOUTKBS     = "Annoncer killing blows" ;
OQ.SETUP_SHOUTCAPS    = "Annoncer objectifs BG" ;
OQ.SETUP_SHOUTADS     = "Annoncer groupes" ;
OQ.SETUP_AUTOACCEPT_MESH_REQ = "Accepter automatiquement les requêtes réseaux B-TAG" ;
OQ.SETUP_ANNOUNCE_RAGEQUIT   = "Annoncer les rage quitter" ;
OQ.SETUP_OK2SUBMIT_BTAG      = "Suggérer B-TAG tous les 4 jours" ;
OQ.SETUP_AUTOJOIN_OQGENERAL  = "Joindre automatiquement le canal oqgeneral" ;
OQ.SETUP_AUTOHIDE_FRIENDREQS = "Cacher automatiquement les requêtes amies" ;
OQ.SETUP_SHOW_GEARHILIGHT    = "Montrer gearscore en surbrillance" ;
OQ.SETUP_ADD          = "Ajouter" ;
OQ.SETUP_MYCREW       = "Mon équipage" ;
OQ.SETUP_CLEAR        = "Retirer" ;
OQ.SETUP_COLORBLIND   = "Support Daltonien" ;
OQ.SAPPED             = "{rt8}  Sappé  {rt8}" ;
OQ.BN_FRIENDS         = "OQ enabled friends" ;
OQ.LOCAL_OQ_USERS     = "OQ enabled locals" ;
OQ.TIME_DRIFT         = "time drift" ;
OQ.PPS_SENT           = "pkts sent/sec" ;
OQ.PPS_RECVD          = "pkts recvd/sec" ;
OQ.PPS_PROCESSED      = "pkts processed/sec" ;
OQ.MEM_USED           = "Mémoire utilisée (ko)" ;
OQ.BANDWIDTH_UP       = "Upload (kBps)" ;
OQ.BANDWIDTH_DN       = "Download (kBps)" ;
OQ.OQSK_DTIME         = "time variance" ;
OQ.SETUP_CHECKNOW     = "Vérifier maintenant" ;
OQ.SETUP_GODARK       = "Etre Invisible" ;
OQ.SETUP_REMOVENOW    = "Retirer maintenant" ;
OQ.STILL_IN_PREMADE   = "SVP quittez votre groupe actuel avant d'en créer un nouveau" ;
OQ.DD_PROMOTE         = "Nommer Chef de raid" ;
OQ.DD_KICK            = "Retirer membre" ;
OQ.DD_BAN             = "Bannir cet utilisateur B-TAG" ;
OQ.DD_REFORM          = "Reformer les groupe" ;
OQ.DISABLED           = "oQueue Désactivé" ;
OQ.ENABLED            = "oQueue Activé" ;
OQ.THETIMEIS          = "Le temps est %d (GMT)" ;
OQ.RAGEQUITSOFAR      = "Rage quit: %s  after %d:%02d  (%d so far)" ;
OQ.RAGEQUITTERS       = "%d rage quit over %d:%02d" ;
OQ.RAGELASTGAME       = "%d rage quit last game (bg lasted %d:%02d)" ;
OQ.NORAGEQUITS        = "you are not in a battleground" ;
OQ.RAGEQUITS          = "%d rage quit so far" ;
OQ.MSG_PREMADENAME    = "SVP entrez un nom pour ce groupe" ;
OQ.MSG_MISSINGNAME    = "Nom de groupe manquant" ;
OQ.MSG_REJECT         = "File d'attente refusée.\nraison: %s" ;
OQ.MSG_CANNOTCREATE_TOOLOW   = "Impossible de créer un groupe.  \nVous devez être de niveau 10 ou supérieur" ;
OQ.MSG_NOTLFG         = "Please do not use oQueue as LookingForGroup advertisement. \nSome players may ban you from their premade if you do." ;
OQ.TAB_PREMADE        = "Groupe" ;
OQ.TAB_FINDPREMADE    = "Chercher groupe" ;
OQ.TAB_CREATEPREMADE  = "Créer groupe" ;
OQ.TAB_THESCORE       = "Score" ;
OQ.TAB_SETUP          = "Configuration" ;
OQ.TAB_BANLIST        = "Liste des bannis" ;
OQ.TAB_WAITLIST       = "File d'attente" ;
OQ.TAB_WAITLISTN      = "File d'attente (%d)" ;
OQ.CONNECTIONS        = "connexion  %d - %d" ;
OQ.ANNOUNCE_PREMADES  = "%d groupes disponibles" ;
OQ.NEW_PREMADE        = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r" ;
OQ.PREMADE_NAMEUPD    = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r" ;
OQ.DLG_OK             = "OK" ;
OQ.DLG_YES            = "Oui" ;
OQ.DLG_NO             = "Non" ;
OQ.DLG_CANCEL         = "Annuler" ;
OQ.DLG_ENTER          = "Entrer Bataille" ;
OQ.DLG_LEAVE          = "Quitter Queue" ;
OQ.DLG_READY          = "Prêt" ;
OQ.DLG_NOTREADY       = "Pas Prêt" ;
OQ.DLG_01             = "Entrez svp votre pseudo:" ;
OQ.DLG_02             = "Entrer Bataille" ;
OQ.DLG_03             = "Nom de votre groupe:" ;
OQ.DLG_04             = "Entrez svp votre Royaume-ID:" ;
OQ.DLG_05             = "Mot de passe:" ;
OQ.DLG_06             = "Entrez svp l'ID ou le nom du nouveau chef de groupe :" ;
OQ.DLG_07             = "\nNOUVELLE VERSION DISPONIBLE !!\n\noQueue  v%s  version  %d\n" ;
OQ.DLG_08             = "SVP quittez votre groupe avant de rejoindre la file d'attente ou \nDemandez à votre Chef de groupe de mettre le groupe en file d'attente" ;
OQ.DLG_09             = "Seul le Chef de raid peut créer un groupe OQ" ;
OQ.DLG_10             = "The queue has popped.\n\nWhat is your decision?" ;
OQ.DLG_11             = "Your queue has popped.  Waiting for Raid Leader to make a decision.\nPlease stand by." ;
OQ.DLG_12             = "Êtes-vous sûr de vouloir quitter le groupe ?" ;
OQ.DLG_13             = "Le Chef de raid a lancé un appel" ;
OQ.DLG_14             = "The raider leader has requested a reload" ;
OQ.DLG_15             = "Bannir: %s \nEntrez la raison:" ;
OQ.DLG_16             = "Impossible de choisir le type de groupe.\nTrop de membres (max. %d)" ;
OQ.DLG_17             = "Entrez le B-TAG à bannir:" ;
OQ.DLG_18a            = "La version %d.%d.%d est disponible" ;
OQ.DLG_18b            = "--  Mise à jour requise  --" ;
OQ.DLG_19             = "Vous devez être qualifié pour votre propre groupe" ;
OQ.DLG_20             = "Pas de groupe autorisé pour ce type de groupe" ;
OQ.DLG_21             = "Quittez le groupe avant d'entrer en liste d'attente" ;
OQ.DLG_22             = "Dissoudre le groupe avant d'entrer en file d'attente" ;
OQ.MENU_KICKGROUP     = "Kicker du groupe" ;
OQ.MENU_SETLEAD       = "Nommer Chef de raid" ;
OQ.HONOR_PTS          = "Points d'honneur" ;
OQ.NOBTAG_01          = "Informations B-TAG non reçues à temps." ;
OQ.NOBTAG_02          = "Recommencez svp." ;
OQ.MINIMAP_HIDDEN     = "(OQ) Bouton de minimap caché" ;
OQ.MINIMAP_SHOWN      = "(OQ) Bouton de minimap affiché" ;
OQ.FINDMESH_OK        = "Votre connexion est bonne. Les groupes sont actualisés par cyle de 30 secondes." ;
OQ.TIMEERROR_1        = "OQ: Votre système est visiblement désynchronisé (%s)." ;
OQ.TIMEERROR_2        = "OQ: please update your system time and timezone." ;
OQ.SYS_YOUARE_AFK     = "Vous êtes absent." ;
OQ.SYS_YOUARENOT_AFK  = "Vous n'êtes plus absent." ;
OQ.ERROR_REGIONDATA   = "Les données de la régions n'ont pas été chargées correctement." ;
OQ.TT_LEAVEPREMADE    = "clic-gauche:  Se mettre en file d'attente\nclic-droit:  Bannir le chef de groupe" ;
OQ.TT_FINDMESH        = "Requête B-TAG pour se connecter au réseau" ;
OQ.TT_SUBMIT2MESH     = "Suggérez votre B-TAG pour agrandir le réseau OQ" ;
OQ.LABEL_TYPE         = "|cFF808080type:|r  %s" ;
OQ.LABEL_ALL          = "Tous les groupes" ;
OQ.LABEL_BGS          = "Champs de batailles" ;
OQ.LABEL_RBGS         = "BGs côtés" ;
OQ.LABEL_DUNGEONS     = "Donjons" ;
OQ.LABEL_LADDERS      = "Échelle" ;
OQ.LABEL_RAIDS        = "Raids" ;
OQ.LABEL_SCENARIOS    = "Scenarios" ;
OQ.LABEL_CHALLENGES   = "Défis" ;
OQ.LABEL_BG           = "Champ de bataille" ;
OQ.LABEL_RBG          = "BG côtés" ;
OQ.LABEL_ARENAS       = "Arênes" ;
OQ.LABEL_ARENA        = "Arêne" ;
OQ.LABEL_DUNGEON      = "Donjon" ;
OQ.LABEL_LADDER       = "Échelle" ;
OQ.LABEL_RAID         = "Raid" ;
OQ.LABEL_SCENARIO     = "Scenario" ;
OQ.LABEL_CHALLENGE    = "Défi" ;
OQ.LABEL_MISC         = "Divers" ;
OQ.LABEL_ROLEPLAY     = "Jeux de rôle" ;
OQ.PATTERN_CAPS       = "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]" ;
OQ.CONTRIBUTE         = "Envoyez une donation !" ;
OQ.MATCHUP            = "match disponible" ;
OQ.NODIPFORYOU        = "Vous avez plus de %d amis B-NET. Aucun changement pour vous." ;
OQ.GAINED             = "gagné" ;
OQ.LOST               = "perdu" ;
OQ.PERHOUR            = "par heure" ;
OQ.NOW                = "maintenant" ;
OQ.WITH               = "avec" ;
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
OQ.RANAWAY            = "Déserteur.  loss registered"
OQ.TT_KARMA           = "karma"  ;
OQ.UP                 = "Monter" ;
OQ.DOWN               = "Descendre" ;
OQ.BAD_KARMA_BTAG     = "OQ: Battle-tag du membre selectionné invalide" ;
OQ.MAX_KARMA_TODAY    = "OQ: %s has already received karma from you today" ;
OQ.YOUVE_GOT_KARMA    = "you've gained %d karma point." ;
OQ.YOUVE_LOST_KARMA   = "you've lost %d karma point." ;
OQ.YOUVE_LOST_KARMAS  = "you've lost %d karma points." ;
OQ.INSTANCE_LASTED    = "instance lasted" ;
OQ.SHOW_ILEVEL        = "Montrer ilevel" ;
OQ.SOCKET             = "Socket" ;
OQ.SHA_TOUCHED        = "Sha--Touched" 
OQ.TT_BATTLE_TAG      = "B-TAG" ;
OQ.TT_REGULAR_BG      = "BGs réguliers" ;
OQ.TT_PERSONAL        = "Comme membre" ;
OQ.TT_ASLEAD          = "Comme chef" ;
OQ.AVG_ILEVEL         = "avg ilevel: %d" ;
OQ.ENCHANTED          = "Enchanté:" ;
OQ.ENABLE_FOG         = "fog of war" ;
OQ.AUTO_INSPECT       = "Inspection automatique (ctrl clic-gauche)" ;
OQ.TIMELEFT           = "Temps restant:" ;
OQ.HORDE              = "Horde" ;
OQ.ALLIANCE           = "Alliance" ;
OQ.SETUP_TIMERWIDTH   = "Ecart minuteur" ;
OQ.BG_BEGINS          = "Début !" -- partial text of start msg
OQ.BG_BEGUN           = "Démarré !" -- partial text of start msg
OQ.SETUP_SHOW_CONTROLLED   = "Montrer les points contrôlés" ;
OQ.MM_OPTION1         = "toggle main UI" ;
OQ.MM_OPTION2         = "toggle marquee" ;
OQ.MM_OPTION3         = "toggle timers" ;
OQ.MM_OPTION4         = "toggle threat UI" ;
OQ.MM_OPTION5         = "Effacer les temps" ;
OQ.MM_OPTION6         = "Montrer temps de recherche" ;
OQ.MM_OPTION7         = "Fixer UI" ;
OQ.MM_OPTION8         = "Ou suis-je ?" ;
OQ.MM_OPTION9         = "Être invisible" ;
OQ.LABEL_QUESTING     = "Quête" ;
OQ.LABEL_QUESTERS     = "Quête de groupe" ;
OQ.ACTIVE_LASTPERIOD  = "# Actif les 7 derniers jours" ;
OQ.SCORE_NLEADERS     = "# chefs" ;
OQ.SCORE_NGAMES       = "# jeux" ;
OQ.SCORE_NBOSSES      = "# boss" ;
OQ.TT_PVERECORD       = "Statistiques(Boss - Morts)" ;
OQ.TT_5MANS           = "chef : groupe" ;
OQ.TT_RAIDS           = "chef : raid" ;
OQ.TT_CHALLENGES      = "chef : défi" ;
OQ.TT_LEADER_DKP      = "leader: dragon kill pts" ;
OQ.TT_DKP             = "dragon kill pts" ;
OQ.SCORE_DKP          = "# dragon kill pts" ;
OQ.ERR_NODURATION     = "Unknown instance duration.  Unable to calculate currency changes" ;
OQ.DRUNK              = "..hic!" ;
OQ.MM_OPTION2a        = "toggle bounty board" ;
OQ.ANNOUNCE_CONTRACTS = "Annoncer contracts" ;
OQ.SETUP_SHOUTCONTRACTS = "Annoncer contracts" ;
OQ.CONTRACT_ARRIVED   = " Contract #%s just arrived!  Target: %s  Reward: |h%s" ;
OQ.CONTRACT_CLAIMED01 = "%s %s claimed contract #%s and won %s" ;
OQ.CONTRACT_CLAIMED02 = "%s claimed contract #%s and won %s" ;
OQ.TARGET_MARK        = "You've targeted a bounty target! ( contract#%s )" ;
OQ.BOUNTY_TARGET      = "You've killed a bounty target! ( contract#%s )" ;
OQ.DEATHMATCH_SCORE   = "Score!" ;
OQ.FRIEND_REQUEST     = "%s-%s veut devenir votre ami" ;
OQ.ALREADY_FRIENDED   = "Vous êtes déja ami battle-net avec %s" ;
OQ.TT_FRIEND_REQUEST  = "Requête amie" ;
OQ.DEATHMATCH_BEGINS  = "WPvP Death Match has begun!  Get to the spine in Pandaria and defend your pvp vendors!" ;
OQ.WONTHEMATCH        = "gagne le match !" ;
OQ.MSG_MISSINGTYPE    = "Selectionnez votre type de groupe" ;

OQ.LABEL_VENTRILO     = "Ventrilo" ;
OQ.LABEL_SKYPE        = "Skype" ;
OQ.LABEL_TEAMSPEAK    = "Teamspeak" ;
OQ.LABEL_DOLBYAXON    = "Dolby Axon" ;
OQ.LABEL_RAIDCALL     = "RaidCall" ;
OQ.LABEL_RAZOR        = "Razer" ;
OQ.LABEL_MUMBLE       = "Mumble" ;
OQ.LABEL_UNSPECIFIED  = "Non spécifié" ;
OQ.LABEL_NOVOICE      = "Muet" ;
OQ.LABEL_WOWVOIP      = "Voix en IG WoW" ;

OQ.LABEL_US_ENGLISH   = "Anglais (US)" ;
OQ.LABEL_UK_ENGLISH   = "Anglais (UK)" ;
OQ.LABEL_OC_ENGLISH   = "Anglais (AUS)" ;
OQ.LABEL_RUSSIAN      = "Russe (RU)" ;
OQ.LABEL_GERMAN       = "Allemand (DE)" ;
OQ.LABEL_ES_SPANISH   = "Espagnol (ES)" ;
OQ.LABEL_MX_SPANISH   = "Espagnol (MX)" ;
OQ.LABEL_BR_PORTUGUESE= "Portuguais (BR)" ;
OQ.LABEL_PT_PORTUGUESE= "Portuguais (PT)" ;
OQ.LABEL_FRENCH       = "Français (FR)" ;
OQ.LABEL_ITALIAN      = "Italien (IT)" ;
OQ.LABEL_TURKISH      = "Turc (TR)" ;
OQ.LABEL_GREEK        = "Grec (GR)" ;
OQ.LABEL_DUTCH        = "Hollandais (DU)" ;
OQ.LABEL_SWEDISH      = "Suédois (SE)" ;
OQ.LABEL_ARABIC       = "Arabe (AR)" ;

OQ.CONTRIBUTION_DLG = { "",
                        "Having fun with oQueue and public vent?",
                        "Then drop by and say hi!",
                        "",
                        "for the latest on oQueue:",
                        "beg.oq",
                        "",
                        "or drop by the forums:",
                        "beg.vent",
                        "",
                        "Have fun and have a great night!",
                        "",
                        "- tiny",
                      } ;
OQ.CONTRIBUTION2_DLG = { "",
                        "Having fun with oQueue and public vent?",
                        "Then send us a beer!",
                        "",
                        "for tiny and oQueue:",
                        "beg.oq",
                        "",
                        "for Rathamus and public vent:",
                        "beg.vent",
                        "",
                        "Thanks!",
                        "",
                        "- tiny",
                      } ;
OQ.TIMEVARIANCE_DLG = { "",
                        "Attention:",
                        "",
                        "  Votre heure de système diffère de ",
                        "  manière signifiante du réseau OQ. ",
                        "  Vous devez corriger ceci avant de ",
                        "  pouvoir à nouveau créer un groupe.",
                        "",
                        "  Variance de temps :  %s",
                        "",
                        "- Tiny",
                      } ;
OQ.LFGNOTICE_DLG = { "",
                        "Attention:",
                        "",
                        "  AVERTISSEMENT : N'utilisez pas oQueue   ",
                        "  pour LFG ou d'autres types de fonctions ",
                        "  personnelles. Beaucoup de personnes se  ",
                        "  font bannir en l'utilisant comme tel. Si",
                        "  vous êtes banni, vous ne pourrez plus   ",
                        "  rejoindre leurs groupes.",
                        "",
                        "- Tiny",
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
                   
OQ.BG_STAT_COLUMN = { [ "Bases Assaulted"       ] = "Bases Attaqu�es",
                      [ "Bases Defended"        ] = "Bases Défendues",
                      [ "Demolishers Destroyed" ] = "Démolisseur D�truit",
                      [ "Flag Captures"         ] = "Drapeau Capturé",
                      [ "Flag Returns"          ] = "Drapeau Récupéré",
                      [ "Gates Destroyed"       ] = "Porte Détruite",
                      [ "Graveyards Assaulted"  ] = "Cimetiere Attaqué",
                      [ "Graveyards Defended"   ] = "Cimetiere Défendu",
                      [ "Towers Assaulted"      ] = "Tour Attaquée",
                      [ "Towers Defended"       ] = "Tour Défendue",
                    } ;

OQ.COLORBLINDSHADER = { [ 0 ] = "Désactivé",
                        [ 1 ] = "Protanopia",
                        [ 2 ] = "Protanomaly",
                        [ 3 ] = "Deuteranopia",
                        [ 4 ] = "Deuteranomaly",
                        [ 5 ] = "Tritanopia",
                        [ 6 ] = "Tritanomaly",
                        [ 7 ] = "Achromatopsia",
                        [ 8 ] = "Achromatomaly",
                      } ;

OQ.TRANSLATED_BY["frFR"] = "Alathèa (Medivh, EU)" ;

-- Class talent specs
local DK =      {
		 ["Sang"]		= "Tank",
		 ["Givre"]		= "Melee",
                 ["Impie"]		= "Melee",
              	} ;
local DRUID =	{
		 ["Equilibre"]		= "Knockback",
		 ["Farouche"]		= "Melee",
		 ["Restauration"]	= "Healer",
		 ["Gardien"]		= "Tank",
              	} ;
local HUNTER =  {
		 ["Maîtrise des b�tes"] = "Knockback",
		 ["Pr�cision"]          = "Ranged",
		 ["Survie"]             = "Ranged",
                } ;
local MAGE =	{
		 ["Arcanes"]       = "Knockback",
		 ["Feu"]           = "Ranged",
		 ["Givre"]         = "Ranged",
		} ;
local MONK =	{
		 ["Maître brasseur"] = "Tank",
		 ["Tisse-brume"]     = "Healer",
		 ["Marche-vent"]     = "Melee",
              	} ;
local PALADIN = {
		 ["Sacré"]        = "Healer",
		 ["Protection"]   = "Tank",
		 ["Vindicte"]     = "Melee",
              	} ;
local PRIEST = {
		 ["Discipline"]    = "Healer",
		 ["Sacré"]         = "Healer",
		 ["Ombre"]         = "Ranged",
              	} ;
local ROGUE = {
		 ["Assassinat"]  = "Melee",
		 ["Combat"]      = "Melee",
		 ["Finesse"]     = "Melee",
              	} ;
local SHAMAN = {
		 ["Elémentaire"]    = "Knockback",
		 ["Amélioration"]   = "Melee",
		 ["Restauration"]   = "Healer",
              	} ;
local WARLOCK = {
		 ["Affliction"]   = "Knockback",
		 ["Démonologie"]  = "Knockback",
		 ["Destruction"]  = "Knockback",
              	} ;
local WARRIOR = {
		 ["Armes"]        = "Melee",
		 ["Fureur"]       = "Melee",
		 ["Protection"]   = "Tank",
              	} ;

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
