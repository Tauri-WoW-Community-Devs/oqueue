--[[ 
  @file       oqueue.es.lua
  @brief      localization for oqueue addon (spanish)

  @author     rmcinnis
  @date       june 11, 2012
  @par        copyright (c) 2012 Solid ICE Technologies, Inc.  All rights reserved.
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;

OQ.TRANSLATED_BY["itIT"] = "B1G3M" ;
if ( GetLocale() ~= "itIT" ) then
  return ;
end
local L = OQ._T ; -- for literal string translations

BINDING_HEADER_OQUEUE           = "oQueue";
BINDING_NAME_TOGGLE_OQUEUE      = "Toggle oQueue";
BINDING_NAME_AUTO_INSPECT       = "Auto controllo";
BINDING_NAME_WAITLIST_INVITEALL = "Invita tutti";

OQ.TITLE_LEFT         = "oQueue v" ;
OQ.TITLE_RIGHT        = " - Trova Premade" ;
OQ.BNET_FRIENDS       = "%d  Amici b-net " ;
OQ.PREMADE            = "Premade" ;
OQ.FINDPREMADE        = "Trova Premade" ;
OQ.CREATEPREMADE      = "Crea Premade" ;
OQ.CREATE_BUTTON      = "Crea premade" ;
OQ.UPDATE_BUTTON      = "Aggiorna Premade" ;
OQ.WAITLIST           = "Lista d'attesa" ;
OQ.HONOR_BUTTON       = "OQ premade" ;
OQ.SETUP              = "Impostazioni" ;
OQ.PLEASE_SELECT_BG   = "Perfavore seleziona un campo di battaglia" ;
OQ.BAD_REALID         = "real-id o battle-tag invalido.\n" ;
OQ.QUEUE1_SELECTBG    = "<Seleziona un campo di battaglia>" ;
OQ.NOLEADS_IN_RAID    = "Non ci sono capi incursione nel gruppo" ;
OQ.NOGROUPS_IN_RAID   = "Non si può invitare il gruppo nell'incursione direttamente" ;
OQ.BUT_INVITE         = "invita" ;
OQ.BUT_GROUPLEAD      = "capo gruppo" ;
OQ.BUT_INVITEGROUP    = "gruppo (%d)" ;
OQ.BUT_WAITLIST       = "lista d'attesa" ;
OQ.BUT_INGAME         = "in gioco" ;
OQ.BUT_PENDING        = "in attesa" ;
OQ.BUT_INPROGRESS     = "in battaglia" ;
OQ.BUT_NOTAVAILABLE   = "in attesa" ;
OQ.BUT_FINDMESH       = "trova rete" ;
OQ.BUT_SUBMIT2MESH    = "presenta b-tag" ;
OQ.BUT_PULL_BTAG      = "rimuovi b-tag" ;
OQ.BUT_BAN_BTAG       = "ban b-tag" ;
OQ.BUT_INVITE_ALL     = "invita " ;
OQ.BUT_REMOVE_OFFLINE = "rimuovi offline" ;
OQ.TT_LEADER          = "capo" ;
OQ.TT_REALM           = "reame" ;
OQ.TT_BATTLEGROUP     = "gruppo di battaglia" ;
OQ.TT_MEMBERS         = "membri" ;
OQ.TT_WAITLIST        = "lista d'attesa" ;
OQ.TT_RECORD          = "record (vinte - perse)" ;
OQ.TT_AVG_HONOR       =  "avg onore/gioco" ;
OQ.TT_AVG_HKS         = "avg hks/gioco" ;
OQ.TT_AVG_GAME_LEN    = "avg lunghezza di gioco" ;
OQ.TT_AVG_DOWNTIME    = "avg tempo di attesa" ;
OQ.TT_RESIL           = "resil" ;
OQ.TT_ILEVEL          = "ilevel" ;
OQ.TT_MAXHP           = "max hp" ;
OQ.TT_WINLOSS         = "vinte - perse" ;
OQ.TT_HKS             = "hks totali" ;
OQ.TT_OQVERSION       = "versione" ;
OQ.TT_TEARS           = "tears" ;
OQ.TT_PVPPOWER        = "potenza pvp" ;
OQ.TT_MMR             = "pvp rating" ;
OQ.JOIN_QUEUE         = "entra queue" ;
OQ.LEAVE_QUEUE        = "esci queue" ;
OQ.LEAVE_QUEUE_BIG    = "ESCI QUEUE" ;
OQ.DAS_BOOT           = "DAS BOOT !!" ;
OQ.DISBAND_PREMADE    = "esci dal gruppo premade" ;
OQ.LEAVE_PREMADE      = "esci dal gruppo premade" ;
OQ.RELOAD             = "ricarica" ;
OQ.ILL_BRB            = "torno subito" ;
OQ.LUCKY_CHARMS       = "portafortuna" ;
OQ.IAM_BACK           = "sono tornato" ;
OQ.ROLE_CHK           = "controllo del ruolo" ;
OQ.READY_CHK          = "appello" ;
OQ.APPROACHING_CAP    = "AVVICINARSI AL CAP" ;
OQ.CAPPED             = "CAPPATO" ;
OQ.HDR_PREMADE_NAME   = "premades" ;
OQ.HDR_LEADER         = "capo" ;
OQ.HDR_LEVEL_RANGE    = "livello(i)" ;
OQ.HDR_ILEVEL         = "ilevel" ;
OQ.HDR_RESIL          = "resil" ;
OQ.HDR_POWER          = "potenza pvp" ;
OQ.HDR_TIME           = "tempo" ;
OQ.QUALIFIED          = "qualificato" ;
OQ.PREMADE_NAME       = "nome Premade" ;
OQ.LEADERS_NAME       = "nome del capo" ;
OQ.REALID             = "Real-Id o B-tag" ;
OQ.REALID_MOP         = "Battle-tag" ;
OQ.MIN_ILEVEL         = "Minimo ilevel" ;
OQ.MIN_RESIL          = "Minima resil" ;
OQ.MIN_MMR            = "Minima CdB rating" ;
OQ.BATTLEGROUNDS      = "Descrizione" ;
OQ.ENFORCE_LEVELS     = "rispetta il livello di supporto" ;
OQ.NOTES              = "Note" ;
OQ.PASSWORD           = "Password" ;
OQ.CREATEURPREMADE    = "Crea il tuo premade" ;
OQ.LABEL_LEVEL        = "Livello" ;
OQ.LABEL_LEVELS       = "Livelli" ;
OQ.HDR_BGROUP         = "bgroup" ;
OQ.HDR_TOONNAME       = "nome personaggio" ;
OQ.HDR_REALM          = "reame" ;
OQ.HDR_LEVEL          = "livello" ;
OQ.HDR_ILEVEL         = "ilevel" ;
OQ.HDR_RESIL          = "resil" ;
OQ.HDR_MMR            = "rating" ;
OQ.HDR_PVPPOWER       = "potenza" ;
OQ.HDR_HASTE          = "celerità" ;
OQ.HDR_MASTERY        = "maestria" ;
OQ.HDR_HIT            = "impatto" ;
OQ.HDR_DATE           = "data" ;
OQ.HDR_BTAG           = "battle.tag" ;
OQ.HDR_REASON         = "motivo" ;
OQ.RAFK_ENABLED       = "rafk attivo" ;
OQ.RAFK_DISABLED      = "rafk non attivo" ;
OQ.SETUP_HEADING      = "impostazioni e vari comandi" ;
OQ.SETUP_BTAG         = "indirizzo email Battlenet" ;
OQ.SETUP_GODARK_LBL   = "Di a tutti gli amici di OQ che tu stai andando in oscuro" ;
OQ.SETUP_CAPCHK       = "Forza OQ al controllo dele capacità" ;
OQ.SETUP_REMOQADDED   = "Rimuovi OQ-aggiunti amici B.net" ;
OQ.SETUP_REMOVEBTAG   = "Rimuovi b-tag dal segnapunti" ;
OQ.SETUP_ALTLIST      = "Lista degli alts sul tuo account battle.net :\n(solo per più spec)" ;
OQ.SETUP_AUTOROLE     = "Auto imposta ruolo" ;
OQ.SETUP_CLASSPORTRAIT = "Usa il ritratto di classe" ;
OQ.SETUP_SAYSAPPED    = "Dire tramortito" ;
OQ.SETUP_WHOPOPPED    = "Chi ha spuntato bramosia?" ;
OQ.SETUP_GARBAGE      = "Colleziona rifiuti garbage collect(intervallo 30 secs)" ;
OQ.SETUP_SHOUTKBS     = "Annuncia colpi mortali" ;
OQ.SETUP_SHOUTCAPS    = "Annuncia gli obbiettivi dei CB" ;
OQ.SETUP_SHOUTADS     = "Annuncia premades" ;
OQ.SETUP_AUTOACCEPT_MESH_REQ = "Auto accetta le richieste di presentazione b-tag" ;
OQ.SETUP_ANNOUNCE_RAGEQUIT   = "Annuncia uscita dalla rabbia" ;
OQ.SETUP_OK2SUBMIT_BTAG      = "presenta b-tag ogni 4 giorni" ;
OQ.SETUP_AUTOJOIN_OQGENERAL  = "Entra in automatico nel canale oqgeneral" ;
OQ.SETUP_AUTOHIDE_FRIENDREQS = "Nascondi in automatico le richieste degli amici" ;
OQ.SETUP_ADD          = "aggiungi" ;
OQ.SETUP_MYCREW       = "la mia squadra" ;
OQ.SETUP_CLEAR        = "pulito" ;
OQ.SETUP_COLORBLIND   = "Supporto colori" ;
OQ.SAPPED             = "{rt8}  Tramortito  {rt8}" ;
OQ.BN_FRIENDS         = "OQ abilita amici" ;
OQ.LOCAL_OQ_USERS     = "OQ abilita locali" ;
OQ.TIME_DRIFT         = "tempo corrente" ;
OQ.PPS_SENT           = "pkts inviati/sec" ;
OQ.PPS_RECVD          = "pkts ricevuti/sec" ;
OQ.PPS_PROCESSED      = "pkts elaborati/sec" ;
OQ.MEM_USED           = "memoria usata (kB)" ;
OQ.BANDWIDTH_UP       = "upload (kBps)" ;
OQ.BANDWIDTH_DN       = "download (kBps)" ;
OQ.OQSK_DTIME         = "variazione del tempo" ;
OQ.SETUP_CHECKNOW     = "controlla adesso" ;
OQ.SETUP_GODARK       = "vai oscuro" ;
OQ.SETUP_REMOVENOW    = "rimuovi adesso" ;
OQ.STILL_IN_PREMADE   = "perfavore rimuovi il tuo premade attivo prima di crearne uno nuovo" ;
OQ.DD_PROMOTE         = "promuovi a capogruppo" ;
OQ.DD_KICK            = "rimuovi membro" ;
OQ.DD_BAN             = "BANNA battle.tag della persona" ;
OQ.DD_REFORM          = "riforma gruppo" ;
OQ.DISABLED           = "oQueue disabilitato" ;
OQ.ENABLED            = "oQueue abilitato" ;
OQ.THETIMEIS          = "il tempo è %d (GMT)" ;
OQ.RAGEQUITSOFAR      = " uscito dalla rabbia: %s  dopo %d:%02d  (%d finora)" ;
OQ.RAGEQUITTERS       = "%d uscito dalla rabbia %d:%02d" ;
OQ.RAGELASTGAME       = "%d uscito dalla rabbia nell'ultima partita (cb durato %d:%02d)" ;
OQ.NORAGEQUITS        = "non sei in un campo di batatglia" ;
OQ.RAGEQUITS          = "%d uscito dalla rabbia fin ora" ;
OQ.MSG_PREMADENAME    = "perfavore inserisci un nome al premade" ;
OQ.MSG_MISSINGNAME    = "perfavore dai un nome al tuo premade" ;
OQ.MSG_REJECT         = "La richiesta per la lista d'attesa non accettata.\nreason: %s" ;
OQ.MSG_CANNOTCREATE_TOOLOW   = "Non posso creare un premade.  \nDevi essere di livello 10 o superiore" ;
OQ.MSG_NOTLFG         = "Perfavore non usare oqueue per fare pubblicità della tua ricerca di gruppi. \nSe lo fai alcuni giocatori possono bannarti dal loro premade." ;
OQ.TAB_PREMADE        = "Premade" ;
OQ.TAB_FINDPREMADE    = "Trova Premade" ;
OQ.TAB_CREATEPREMADE  = "Crea Premade" ;
OQ.TAB_THESCORE       = "Il punteggio" ;
OQ.TAB_SETUP          = "Impostazioni" ;
OQ.TAB_BANLIST        = "Lista ban" ;
OQ.TAB_WAITLIST       = "Lista d'attesa" ;
OQ.TAB_WAITLISTN      = "Lista d'attesa (%d)" ;
OQ.CONNECTIONS        = "connessione  %d - %d" ;
OQ.ANNOUNCE_PREMADES  = "%d premades disponibili" ;
OQ.NEW_PREMADE        = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r" ;
OQ.PREMADE_NAMEUPD    = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r" ;
OQ.DLG_OK             = "ok" ;
OQ.DLG_YES            = "si" ;
OQ.DLG_NO             = "no" ;
OQ.DLG_CANCEL         = "cancella" ;
OQ.DLG_ENTER          = "Entra nella batatglia" ;
OQ.DLG_LEAVE          = "Togli coda" ;
OQ.DLG_READY          = "Pronto" ;
OQ.DLG_NOTREADY       = "NON pronto" ;
OQ.DLG_01             = "Perfavore inserisci il nome del tuo personaggio:" ;
OQ.DLG_02             = "Entra nella battaglia" ;
OQ.DLG_03             = "Perfavore inserisci nome del tuo premade:" ;
OQ.DLG_04             = "Perfavore inserisci il tuo real-id:" ;
OQ.DLG_05             = "Password:" ;
OQ.DLG_06             = "Perfavore inserisci il real-id o il nome del nuovo capogruppo:" ;
OQ.DLG_07             = "\nUNA NUOVA VERSIONE E' DISPONIBILE !!\n\noQueue  v%s  build  %d\n" ;
OQ.DLG_08             = "Perfavore esci dal tuo gruppo per segnarti nella lista d'attesa o \nChiedi al tuo capogruppo di mettere in coda tutto il gruppo" ;
OQ.DLG_09             = "Solo il capogruppo può creare un Premade con OQ" ;
OQ.DLG_10             = "La coda è pronta.\n\nQual'è la tua decisione?" ;
OQ.DLG_11             = "La coda è pronta.  Attendi che il capogruppo prenda una decisione.\nPerfavore attendi." ;
OQ.DLG_12             = "Sei sicuro che vuoi uscire dal gruppo d'incursione?" ;
OQ.DLG_13             = "Il capo del premade sta iniziando un controllo di chi è pronto" ;
OQ.DLG_14             = "Il capo incursione ha richiesto una ricarica UI" ;
OQ.DLG_15             = "Bannare: %s \nPerfavore inserisci un motivo:" ;
OQ.DLG_16             = "Impossibile selezionare il tipo di premade.\nTroppi membri (max. %d)" ;
OQ.DLG_17             = "Perfavore inserisci il tuo battle-tag per ban:" ;
OQ.DLG_18a            = "Versione %d.%d.%d è adesso disponibile" ;
OQ.DLG_18b            = "--  Richiesto aggiornamento  --" ;
OQ.DLG_19             = "Devi essere qualificato per il tuo premade" ;
OQ.DLG_20             = "Nessun gruppo consentito per questo tipo di premade" ;
OQ.DLG_21             = "Lascia il tuo premade prima di entrare in lista d'attesa" ;
OQ.DLG_22             = "Sciogli il tuo premade prima di entrare in lista d'attesa" ;
OQ.MENU_KICKGROUP     = "Buttafuori il gruppo" ;
OQ.MENU_SETLEAD       = "Imposta il capogruppo" ;
OQ.HONOR_PTS          = "Punti Onore" ;
OQ.NOBTAG_01          = " informazioni battle-tag non ricevuti in tempo." ;
OQ.NOBTAG_02          = " perfavore riprova." ;
OQ.MINIMAP_HIDDEN     = "(OQ) pulsante minimappa nascosto" ;
OQ.MINIMAP_SHOWN      = "(OQ) pulsante minimappa mostrato" ;
OQ.FINDMESH_OK        = "La tua connessione è ok.  premades aggiornato su cicli di 30 secondi" ;
OQ.TIMEERROR_1        = "OQ: l'orario del tuo sistema non è sincronizzato (%s)." ;
OQ.TIMEERROR_2        = "OQ: si prega di aggiornare l'ora ed il fuso orario del tuo sistema" ;
OQ.SYS_YOUARE_AFK     = "Ora sei lontano dalla tastiera" ;
OQ.SYS_YOUARENOT_AFK  = "Ora non sei più lontano dalla tastiera" ;
OQ.ERROR_REGIONDATA   = "I dati della regione non è stata caricati correttamente." ;
OQ.TT_LEAVEPREMADE    = "click sinistro:  leva coda\nclick destro:  banna il capo del premade" ;
OQ.TT_FINDMESH        = "richiedi il battle-tags dal segnapunti\nper connetterti nella rete" ;
OQ.TT_SUBMIT2MESH     = "inserisci il tuo battle-tag sul segnapunti\nper aiutare a far crescere la rete" ;
OQ.LABEL_TYPE         = "|cFF808080type:|r  %s" ;
OQ.LABEL_ALL          = "tutti i premades" ;
OQ.LABEL_BGS          = "campi di battaglia" ;
OQ.LABEL_RBGS         = "campi di battaglia classificati" ;
OQ.LABEL_DUNGEONS     = "spedizioni" ;
OQ.LABEL_LADDERS      = "scala" ;
OQ.LABEL_RAIDS        = "incursioni" ;
OQ.LABEL_SCENARIOS    = "scenari" ;
OQ.LABEL_CHALLENGES   = "sfide" ;
OQ.LABEL_BG           = "campi di battaglia" ;
OQ.LABEL_RBG          = "campi di battaglia classificati" ;
OQ.LABEL_ARENAS       = "arene" ;
OQ.LABEL_ARENA        = "arena" ;
OQ.LABEL_DUNGEON      = "spedizioni" ;
OQ.LABEL_LADDER       = "scala" ;
OQ.LABEL_RAID         = "incursioni" ;
OQ.LABEL_SCENARIO     = "scenario" ;
OQ.LABEL_CHALLENGE    = "sfida" ;
OQ.LABEL_MISC         = "misto" ;
OQ.PATTERN_CAPS       = "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]" ;
OQ.CONTRIBUTE         = "invia birra!" ;
OQ.MATCHUP            = "corrisponde" ;
OQ.NODIPFORYOU        = "Hai più amici di b.net %d ." ;
OQ.GAINED             = "ottenuto" ;
OQ.LOST               = "perso" ;
OQ.PERHOUR            = "per ora" ;
OQ.NOW                = "adesso" ;
OQ.WITH               = "con" ;
OQ.RAID_TOES          = "terrazza dell'eterna primavera" ;
OQ.RAID_HOF           = "cuore della paura" ;
OQ.RAID_MV            = "mogushan vaults" ;
OQ.RAID_TOT           = "throne of thunder" ;
OQ.RAID_RA_DEN        = "Ra-den" ;
OQ.RBG_HRANK_1        = "Sentinella" ;
OQ.RBG_HRANK_2        = "Grunt" ;
OQ.RBG_HRANK_3        = "Sergente" ;
OQ.RBG_HRANK_4        = "Sergente Istruttore" ;
OQ.RBG_HRANK_5        = "Primo Sergente" ;
OQ.RBG_HRANK_6        = "Guardia di Pietra" ;
OQ.RBG_HRANK_7        = "Guardia di Sangue" ;
OQ.RBG_HRANK_8        = "Legionario" ;
OQ.RBG_HRANK_9        = "Centurione" ;
OQ.RBG_HRANK_10       = "Campione" ;
OQ.RBG_HRANK_11       = "Tenente Generale" ;
OQ.RBG_HRANK_12       = "Generale" ;
OQ.RBG_HRANK_13       = "Signore della Guerra" ;
OQ.RBG_HRANK_14       = "Gran Signore della Guerra" ;
OQ.RBG_ARANK_1        = "Soldato" ;
OQ.RBG_ARANK_2        = "Caporale" ;
OQ.RBG_ARANK_3        = "Sergente" ;
OQ.RBG_ARANK_4        = "Sergente Capo" ;
OQ.RBG_ARANK_5        = "Sergente Maggiore" ;
OQ.RBG_ARANK_6        = "Cavaliere" ;
OQ.RBG_ARANK_7        = "Cavalier Tenente" ;
OQ.RBG_ARANK_8        = "Cavalier Capitano" ;
OQ.RBG_ARANK_9        = "Cavalier Campione" ;
OQ.RBG_ARANK_10       = "Tenente Comandante" ;
OQ.RBG_ARANK_11       = "Comandante" ;
OQ.RBG_ARANK_12       = "Maresciallo" ;
OQ.RBG_ARANK_13       = "Primo Maresciallo" ;
OQ.RBG_ARANK_14       = "Gran Maresciallo" ;
OQ.TITLES             = "titoli" ;
OQ.CONQUEROR          = "conquistatore" ;
OQ.BLOODTHIRSTY       = "sanguinario" ;
OQ.BATTLEMASTER       = "maestro di battaglia" ;
OQ.HERO               = "eroe" ;
OQ.WARBRINGER         = "Maestro di Guerra" ;
OQ.KHAN               = "il Supremo Khan" ;
OQ.RANAWAY            = "disertore. perdita registrata"
OQ.TT_KARMA           = "karma"  ;
OQ.UP                 = "sopra" ;
OQ.DOWN               = "sotto" ;
OQ.BAD_KARMA_BTAG     = "OQ: il battle-tag del membro del gruppo selezionato non è valido" ;
OQ.MAX_KARMA_TODAY    = "OQ: %s hai già ricevuto karma oggi" ;
OQ.YOUVE_GOT_KARMA    = "hai guadagnato %d punti karma." ;
OQ.YOUVE_LOST_KARMA   = "hai perso %d punto karma." ;
OQ.YOUVE_LOST_KARMAS  = "hai perso %d punti karma." ;
OQ.INSTANCE_LASTED    = "durata istanza" ;
OQ.SHOW_ILEVEL        = "mostra ilevel" ;
OQ.SOCKET             = " incavo" ;
OQ.SHA_TOUCHED        = "Toccata dallo Sha" 
OQ.TT_BATTLE_TAG      = "battle-tag" ;
OQ.TT_REGULAR_BG      = "cdb regolare" ;
OQ.TT_PERSONAL        = "come membro" ;
OQ.TT_ASLEAD          = "come capo" ;
OQ.AVG_ILEVEL         = "avg ilevel: %d" ;
OQ.ENCHANTED          = "Incantato:" ;
OQ.ENABLE_FOG         = "nebbia di guerra" ;
OQ.AUTO_INSPECT       = "Auto ispeziona (ctrl left-click)" ;
OQ.TIMELEFT           = "Tempo rimasto:" ;
OQ.HORDE              = "Orda" ;
OQ.ALLIANCE           = "Alleanza" ;
OQ.SETUP_TIMERWIDTH   = "Timer width" ;
OQ.BG_BEGINS          = " cominciare!" -- testo parziale di msg inizio
OQ.BG_BEGUN           = " iniziata!" -- testo parziale di msg inizio
OQ.SETUP_SHOW_CONTROLLED   = "Mostra nodi di controllo" ;
OQ.MM_OPTION1         = "verifica utente principale" ;
OQ.MM_OPTION2         = "verifica marquee" ;
OQ.MM_OPTION3         = "verifica cronometro" ;
OQ.MM_OPTION4         = "verifica minaccia dell'utente principale" ;
OQ.MM_OPTION5         = "riavviare cronometro" ;
OQ.MM_OPTION6         = "mostra l'ora della rete" ;
OQ.MM_OPTION7         = "sistema l'utente principale" ;
OQ.MM_OPTION8         = "dove sono?" ;
OQ.MM_OPTION9         = "vai oscuro" ;
OQ.LABEL_QUESTING     = "fare missioni" ;
OQ.LABEL_QUESTERS     = "missioni di gruppo" ;
OQ.ACTIVE_LASTPERIOD  = "# attivo ultimi 7 giorni" ;
OQ.SCORE_NLEADERS     = "# capi" ;
OQ.SCORE_NGAMES       = "# giochi" ;
OQ.SCORE_NBOSSES      = "# boss" ;
OQ.TT_PVERECORD       = "record (boss - morti)" ;
OQ.TT_5MANS           = "capo: 5 uomini" ;
OQ.TT_RAIDS           = "capo: incursioni" ;
OQ.TT_CHALLENGES      = "capo: corse nelle sfide" ;
OQ.TT_LEADER_DKP      = "capo: punti drago uccisi" ;
OQ.TT_DKP             = "punti drago uccisi" ;
OQ.SCORE_DKP          = "# punti drago uccisi" ;
OQ.ERR_NODURATION     = "Durata dell'istanza sconosciuta.  Impossibile calcolare le variazioni di valuta" ;
OQ.DRUNK              = "..hic!" ;
OQ.MM_OPTION2a        = "verifica tabella premi" ;
OQ.ANNOUNCE_CONTRACTS = "Annuncia contratti" ;
OQ.SETUP_SHOUTCONTRACTS = "Annuncia contratti" ;
OQ.CONTRACT_ARRIVED   = " Contratto #%s appena arrivato!  Bersaglio: %s  Ricompensa: |h%s" ;
OQ.CONTRACT_CLAIMED01 = "%s %s contratto rivendicato #%s e vince %s" ;
OQ.CONTRACT_CLAIMED02 = "%s contratto rivendicato #%s e vince %s" ;
OQ.TARGET_MARK        = "Hai in bersaglio un obiettivo di taglie! ( contratto#%s )" ;
OQ.BOUNTY_TARGET      = "Hai ucciso il bersaglio obiettivo! ( contract#%s )" ;
OQ.DEATHMATCH_SCORE   = "Punteggio!" ;
OQ.FRIEND_REQUEST     = "%s-%s vuole diventare tuo amico" ;
OQ.ALREADY_FRIENDED   = "sei già amico battle-net con %s" ;
OQ.TT_FRIEND_REQUEST  = "richiesta d'amicizia" ;
OQ.DEATHMATCH_BEGINS  = "Lo scontro di sangue PVP è iniziato!  Arrivate alla colonna vertebrale in Pandaria e difendete i vostri fornitori PVP!" ;
OQ.WONTHEMATCH        = "Vinto lo scontro!" ;
OQ.MSG_MISSINGTYPE    = "Perfavore seleziona il tipo di premade" ;

OQ.CONTRIBUTION_DLG = { "",
                        "Vi siete divertiti con oQueue e negli eventi pubblici?",
                        "Allora cadi e dici ciao!",
                        "",
                        "Per le ultime su oQueue:",
                        "beg.oq",
                        "",
                        "o vai nel forum:",
                        "beg.vent",
                        "",
                        "Buon divertimento ed una gran nottata!",
                        "",
                        "- tiny",
                      } ;
OQ.CONTRIBUTION2_DLG = { "",
                        "Vi siete divertiti con oQueue e negli eventi pubblici?",
                        "Invia a loro una birra!",
                        "",
                        "per tiny e oQueue:",
                        "beg.oq",
                        "",
                        "per Rathamus ed eventi pubblici:",
                        "beg.vent",
                        "",
                        "Grazie!",
                        "",
                        "- tiny",
                      } ;
OQ.TIMEVARIANCE_DLG = { "",
                        "Attenzione:",
                        "",
                        "  l'orario del tuo sistema è molto ",
                        "  differente dalla rete.  Tu devi",
                        "  correggerlo prima di poter",
                        "  creare un premade.",
                        "",
                        "  varianza del tempo:  %s",
                        "",
                        "- tiny",
                      } ;
OQ.LFGNOTICE_DLG = { "",
                        "Attenzione:",
                        "",
                        "  Non usare oQueue nomi premade per",
                        "  LFG o altri tipi personali",
                        "  pubblicità.  Molte persone vengono bannate ",
                        "  chiunque lo utilizzi come tale.  Se si prende",
                        "  il ban, non sarai in grado di entrare",
                        "  nei gruppi.",
                        "",
                        "- tiny",
                      } ;


OQ.BG_NAMES     = { [ "Campi di Battaglia Casuali"    ] = { type_id = OQ.RND  },
                    [ "Forra dei Cantaguerra"          ] = { type_id = OQ.WSG  },
                    [ "Picchi Gemelli"             ] = { type_id = OQ.TP   },
                    [ "Battaglia per Gilneas" ] = { type_id = OQ.BFG  },
                    [ "Bacino d'Arathi"           ] = { type_id = OQ.AB   },
                    [ "Occhio del ciclone"       ] = { type_id = OQ.EOTS },
                    [ "Lido degli Antichi" ] = { type_id = OQ.SOTA },
                    [ "Isola della Conquista"       ] = { type_id = OQ.IOC  },
                    [ "Valle d'Alterac"         ] = { type_id = OQ.AV   },
                    [ "Miniere di Cupargento"      ] = { type_id = OQ.SSM  },
                    [ "Tempio di Kotmogu"      ] = { type_id = OQ.TOK  },
                    [ "Scavi di Ventotetro"         ] = { type_id = OQ.DWG  },
                    [ "Punti Drago Uccisi"     ] = { type_id = OQ.DKP  },
                    [ ""                       ] = { type_id = OQ.NONE },
                  } ;
                  
OQ.BG_SHORT_NAME = { [ "Bacino d'Arathi"           ] = "BA",
                     [ "Valle d'Alterac"         ] = "VA",
                     [ "Battaglia per Gilneas" ] = "BPG",
                     [ "Occhio del ciclone"       ] = "OdC",
                     [ "Isola della Conquista"       ] = "IdC",
                     [ "Lido degli Antichi" ] = "LdA",
                     [ "Wildhammer Stronghold"  ] = "TP",
                     [ "Dragonmaw Stronghold"   ] = "TP",
                     [ "Picchi Gemelli"             ] = "PG",
                     [ "Silverwing Hold"        ] = "WSG",
                     [ "Forra dei Cantaguerra"          ] = "FdC",
                     [ "Warsong Lumber Mill"    ] = "WSG",
                     [ "Miniere di Cupargento"      ] = "SSM",
                     [ "Tempio di Kotmogu"      ] = "ToK",
                     [ "Scavi di Ventotetro"         ] = "DWG",
                     
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
                   
OQ.BG_STAT_COLUMN = { [ "Base Attaccata"       ] = "Base Attaccata",
                      [ "Base Difesa"        ] = "Base Difesa",
                      [ "Demolitori Distrutti" ] = "Demolitori Distrutti",
                      [ "Bandiera Catturata"         ] = "Bandiera Catturata",
                      [ "Bandiera Riportata"          ] = "Bandiera Riportata",
                      [ "Cancello Distrutto"       ] = "Cancello Distrutto",
                      [ "Cimmitero Assalito"  ] = "Cimmitero Assalito",
                      [ "Cimmitero Difeso"   ] = "Cimmitero Difeso",
                      [ "Torre allalita"      ] = "Torre allalita",
                      [ "Torre Difesa"       ] = "Torre Difesa",
                    } ;

OQ.COLORBLINDSHADER = { [ 0 ] = "disabilitato",
                        [ 1 ] = "Protanopia",
                        [ 2 ] = "Protanomaly",
                        [ 3 ] = "Deuteranopia",
                        [ 4 ] = "Deuteranomaly",
                        [ 5 ] = "Tritanopia",
                        [ 6 ] = "Tritanomaly",
                        [ 7 ] = "Achromatopsia",
                        [ 8 ] = "Achromatomaly",
                      } ;

OQ.TRANSLATED_BY = {} ;

-- Class talent specs
local DK    = { ["Sangue"]          = "Tank",
                ["Gelo"]          = "Melee",
                ["Empietà"]         = "Melee",
              } ;
local DRUID = { ["Equilibrio"]        = "Knockback",
                ["Aggressore Ferino"]   = "Melee",
                ["Rigenerazione"]    = "Healer",
                ["Guardiano Ferino"]       = "Tank",
              } ;
local HUNTER = { ["Affinità Animale"] = "Knockback",
                 ["Precisione di Tiro"]  = "Ranged",
                 ["Sopravvivenza"]      = "Ranged",
               } ;
local MAGE = {  ["Arcano"]         = "Knockback",
                ["Fuoco"]           = "Ranged",
                ["Gelo"]          = "Ranged",
             } ; 
local MONK = {  ["Mastro Birraio"]     = "Tank",
                ["Misticismo"]     = "Healer",
                ["Impeto"]     = "Melee",
             } ; 
local PALADIN = { ["Sacro"]         = "Healer",
                  ["Protezione"]   = "Tank",
                  ["Castigo"]  = "Melee",
                } ; 
local PRIEST = { ["Disciplina"]    = "Healer",
                 ["Sacro"]          = "Healer",
                 ["Ombra"]        = "Ranged",
               } ; 
local ROGUE = { ["Assassinio"]  = "Melee",
                ["Combattimento"]         = "Melee",
                ["Scaltrezza"]       = "Melee",
              } ; 
local SHAMAN = { ["Elementale"]     = "Knockback",
                 ["Potenziamento"]   = "Melee",
                 ["Rigenerazione"]   = "Healer",
               } ; 
local WARLOCK = { ["Afflizione"]   = "Knockback",
                  ["Demonologia"]   = "Knockback",
                  ["Distruzione"]  = "Knockback",
                } ; 
local WARRIOR = { ["Armi"]         = "Melee",
                  ["Furia"]         = "Melee",
                  ["Protezione"]   = "Tank",
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
L[" Battle.net is currently down."] = "Battle.net è al momento non disponibile" ;
L[" oQueue will not function properly until Battle.net is restored."] = "oQueue non funzionerà affinchè Battle.net rifunzionerà" ;
L[" Please set your battle-tag before using oQueue."] = "Perfavore imposta il tuo battle-tag prima di usare oQueue" ;
L[" Your battle-tag can only be set via your WoW account page."] = "Il tuo battle-tag può essere impostato solo sulla pagina dell'account di WoW" ;
L["NOTICE:  You've exceeded the cap before the cap(%s).  removed: %s"] = "NOTA: Stai superando il cap(%s). Rimuovi: %s"  ;
L["WARNING:  Your battle.net friends list has %s friends."] = "ATTENZIONE: la tua lista amici battle.net ha %s amici" ;
L["WARNING:  You've exceeded the cap before the cap(%s)"] = "ATTENZIONE: Stai superando il cap(%s)." ;
L["WARNING:  No mesh nodes available for removal.  Please trim your b.net friends list"] = "ATTENZIONE: Nessuna rete disponibile per rimuovere. Perfavore controlla la tua lista amici di b.net" ;
L["Found oQ banned b.tag on your friends list.  removing: %s"] = "Trovato oQ b.tag bannato nella tua lista di amici. rimuovi %s" ;
L["<html><body>"..
  "<h2 align=\"left\">Where to get help</h2>".. 
  "<br/>"..
  "<h1 align=\"left\">main site</h1>".. 
  "<p>solidice.com</p>"..
  "<br/>"..
  "<h1 align=\"left\">vent support</h1>".. 
  "<p>wow.publicvent.org : 4135  room 0</p>"..
  "<br/>"..
  "<h1 align=\"left\">facebook group</h1>".. 
  "<p>facebook.com/groups/oqueue</p>"..
  "<br/>"..
  "<h1 align=\"left\">forums</h1>".. 
  "<p>oq.publicvent.org/forums</p>"..
  "<br/>"..
  "<h1 align=\"left\">twitter</h1>".. 
  "<p>twitter.com/tinystomper</p>"..
  "</body></html>"] = nil ;