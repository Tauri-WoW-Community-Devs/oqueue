--[[ 
  @file       oqueue.es.lua
  @brief      localization for oqueue addon (spanish)

  @author     rmcinnis, Yllelder
  @date       june 11, 2012, revised march 03, 2014
  @par        copyright (c) 2012 Solid ICE Technologies, Inc.  All rights reserved.
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;

OQ.TRANSLATED_BY["esES"] = "NeoSaro" ;
if ( GetLocale() ~= "esES" ) then
  return ;
end
local L = OQ._T ; -- for literal string translations

OQ.TITLE_LEFT       = "oQueue v" ;
OQ.TITLE_RIGHT      = " - Buscador de Premades" ;
OQ.BNET_FRIENDS     = "%d  amigos b-net" ;
OQ.PREMADE          = "Premade" ;
OQ.FINDPREMADE      = "Buscar Premade" ;
OQ.CREATEPREMADE    = "Crear Premade" ;
OQ.CREATE_BUTTON    = "crear premade" ;
OQ.UPDATE_BUTTON    = "Actualizar premade" ;
OQ.WAITLIST         = "Lista de Espera" ;
OQ.HONOR_BUTTON     = "OQ premade" ;
OQ.SETUP            = "Configuración" ;
OQ.PLEASE_SELECT_BG = "Por favor, selecciona un campo de batalla" ;
OQ.BAD_REALID       = "id real o battletag no válido.\n" ;
OQ.QUEUE1_SELECTBG  = "<selecciona un campo de batalla>" ;
OQ.NOLEADS_IN_RAID  = "No hay líderes de grupo en la raid" ;
OQ.NOGROUPS_IN_RAID = "No es posible invitar un grupo directamente a una banda" ;
OQ.BUT_INVITE       = "invitar" ;
OQ.BUT_GROUPLEAD    = "lider de grupo" ;
OQ.BUT_INVITEGROUP  = "grupo (%d)" ;
OQ.BUT_WAITLIST     = "lista de espera" ;
OQ.BUT_INGAME       = "en partida" ;
OQ.BUT_PENDING      = "en espera" ;
OQ.BUT_INPROGRESS   = "en combate" ;
OQ.BUT_NOTAVAILABLE = "no espera" ;
OQ.BUT_FINDMESH     = "buscar malla" ;
OQ.BUT_SUBMIT2MESH  = "enviar b-tag" ;
OQ.BUT_PULL_BTAG    = "eliminar b-tag" ;
OQ.BUT_BAN_BTAG     = "bloquear b-tag" ;
OQ.TT_LEADER        = "lider" ;
OQ.TT_REALM         = "reino" ;
OQ.TT_BATTLEGROUP   = "grupo de batalla" ;
OQ.TT_MEMBERS       = "miembros" ;
OQ.TT_WAITLIST      = "lista de espera" ;
OQ.TT_RECORD        = "record (ganadas - perdidas)" ;
OQ.TT_AVG_HONOR     =  "media honor/partida" ;
OQ.TT_AVG_HKS       = "media muertes honor/partida" ;
OQ.TT_AVG_GAME_LEN  = "media duración partida" ;
OQ.TT_AVG_DOWNTIME  = "media duración muerte" ;
OQ.TT_RESIL         = "temple" ;
OQ.TT_ILEVEL        = "nivel de objeto" ;
OQ.TT_MAXHP         = "salud máxima" ;
OQ.TT_WINLOSS       = "ganada - perdidas" ;
OQ.TT_HKS           = "total muertes por honor" ;
OQ.TT_OQVERSION     = "versión" ;
OQ.TT_TEARS         = "lloricas" ;
OQ.TT_PVPPOWER      = "poder JcJ" ;
OQ.TT_MMR           = "Índice de CdB puntuado" ;
OQ.JOIN_QUEUE       = "unirse a la cola" ;
OQ.LEAVE_QUEUE      = "abandonar cola" ;
OQ.LEAVE_QUEUE_BIG  = "ABANDONAR COLA" ;
OQ.DAS_BOOT         = "¡¡ DAS BOOT !!" ; 
OQ.DISBAND_PREMADE  = "deshacer grupo premade" ;
OQ.LEAVE_PREMADE    = "dejar el grupo de premade" ;
OQ.RELOAD           = "recargar" ;
OQ.ILL_BRB          = "vuelvo enseguida" ;
OQ.LUCKY_CHARMS     = "marcadores de objetivo" ;
OQ.IAM_BACK         = "He vuelto" ;
OQ.ROLE_CHK         = "comprobar rol" ;
OQ.READY_CHK        = "listos" ;
OQ.APPROACHING_CAP  = "LLEGANDO AL LIMITE" ;
OQ.CAPPED           = "LIMITE ALCANZADO" ;
OQ.HDR_PREMADE_NAME = "premades" ;
OQ.HDR_LEADER       = "lider" ;
OQ.HDR_LEVEL_RANGE  = "nivel(es)" ;
OQ.HDR_ILEVEL       = "nivel de objeto" ;
OQ.HDR_RESIL        = "temple" ;
OQ.HDR_POWER        = "poder JcJ" ;
OQ.HDR_TIME         = "hora" ;
OQ.QUALIFIED        = "capacitado" ;
OQ.PREMADE_NAME     = "Nombre de la Premade" ;
OQ.LEADERS_NAME     = "Nombre del Lider" ;
OQ.REALID           = "ID Real o B-tag" ;
OQ.REALID_MOP       = "Battle-tag" ;
OQ.MIN_ILEVEL       = "Nivel de objeto mínimo" ;
OQ.MIN_RESIL        = "Temple mínimo" ;
OQ.MIN_MMR          = "Indice de CdB mínimo" ;
OQ.BATTLEGROUNDS    = "Descripción" ;
OQ.ENFORCE_LEVELS   = "hacer cumplir el rango de niveles" ;
OQ.NOTES            = "Notas" ;
OQ.PASSWORD         = "Contraseña" ;
OQ.CREATEURPREMADE  = "Crear tu propia premade" ;
OQ.LABEL_LEVEL      = "Nivel" ;
OQ.LABEL_LEVELS     = "Niveles" ;
OQ.HDR_BGROUP       = "grupo de batalla" ;
OQ.HDR_TOONNAME     = "nombre del personaje" ;
OQ.HDR_REALM        = "reino" ;
OQ.HDR_LEVEL        = "nivel" ;
OQ.HDR_ILEVEL       = "niv. de objeto" ;
OQ.HDR_RESIL        = "temple" ;
OQ.HDR_MMR          = "indice" ;
OQ.HDR_PVPPOWER     = "poder" ;
OQ.HDR_HASTE        = "celeridad" ;
OQ.HDR_MASTERY      = "maestria" ;
OQ.HDR_HIT          = "golpe" ;
OQ.HDR_DATE         = "fecha" ;
OQ.HDR_BTAG         = "battle.tag" ;
OQ.HDR_REASON       = "razón" ;
OQ.RAFK_ENABLED     = "raus activado" ;
OQ.RAFK_DISABLED    = "raus desactivado" ;
OQ.SETUP_HEADING    = "Configuración y comandos varios" ;
OQ.SETUP_BTAG       = "Dirección de correo electronico de Battlenet" ;
OQ.SETUP_GODARK_LBL = "Indica a todos tus amigos de OQ que vas a ser invisible" ;
OQ.SETUP_CAPCHK     = "Forzar comprobación de capacidad de OQ" ;
OQ.SETUP_REMOQADDED = "Eliminar los amigos de B.net agregados por OQ" ;
OQ.SETUP_REMOVEBTAG = "Eliminar battletag del tanteador" ;
OQ.SETUP_ALTLIST    = "lista de personajes alternativos\nen esta cuenta battle.net:\n(solo para multi-boxers)" ;
OQ.SETUP_AUTOROLE   = "Auto seleccionar rol" ;
OQ.SETUP_CLASSPORTRAIT = "Usar retratos de clase" ;
OQ.SETUP_SAYSAPPED  = "Anunciar aporreados (sapped)" ;
OQ.SETUP_WHOPOPPED  = "¿Quien ha tirado Ansia?" ;
OQ.SETUP_GARBAGE    = "recolector de basura\n(intervalos de 30 seg)" ;
OQ.SETUP_SHOUTKBS   = "Anunciar golpes de gracia" ;
OQ.SETUP_SHOUTCAPS  = "Anunciar objetivos de CdB" ;
OQ.SETUP_SHOUTADS   = "Anunciar premades" ;
OQ.SETUP_AUTOACCEPT_MESH_REQ = "Autoaceptar peticiones\nbattletag de la malla" ;
OQ.SETUP_ANNOUNCE_RAGEQUIT = "Anunciar 'rage quitters'" ;
OQ.SETUP_OK2SUBMIT_BTAG    = "Enviar b-tag cada 4 dias" ;
OQ.SETUP_ADD        = "añadir" ;
OQ.SETUP_MYCREW     = "mi equipo" ;
OQ.SETUP_CLEAR      = "borrar" ;
OQ.SETUP_COLORBLIND = "Soporte para daltonismo" ;
OQ.SAPPED           = "{rt8}  Sapped  {rt8}" ;
OQ.BN_FRIENDS       = "Amigos OQ activos" ;
OQ.LOCAL_OQ_USERS   = "Locales OQ activos" ;
OQ.PPS_SENT         = "pqts enviados/seg" ;
OQ.PPS_RECVD        = "pqts recibidos/seg" ;
OQ.PPS_PROCESSED    = "pqts procesados/seg" ;
OQ.MEM_USED         = "memoria utilizada (kB)" ;
OQ.BANDWIDTH_UP     = "subida (kBps)" ;
OQ.BANDWIDTH_DN     = "bajada (kBps)" ;
OQ.OQSK_DTIME       = "variación de tiempo" ;
OQ.SETUP_CHECKNOW   = "comprobar ahora" ;
OQ.SETUP_GODARK     = "modo invisible" ;
OQ.SETUP_REMOVENOW  = "eliminar ahora" ;
OQ.STILL_IN_PREMADE = "por favor, abandona tu actual premade antes de crear una nueva" ;
OQ.DD_PROMOTE       = "promocionar a lider de grupo" ;
OQ.DD_KICK          = "eliminar miembro" ;
OQ.DD_BAN           = "BLOQUEAR battletag" ;
OQ.DISABLED         = "oQueue desactivado" ;
OQ.ENABLED          = "oQueue activado" ;
OQ.THETIMEIS        = "la hora es %d (GMT)" ;
OQ.RAGEQUITSOFAR    = " 'rage quit': %s despues de %d:%02d  (%d hasta ahora)" ;
OQ.RAGEQUITTERS     = "%d 'rage quit' a lo largo de %d:%02d" ; 
OQ.RAGELASTGAME     = "%d 'rage quit' en la ultima partida (cdb duró %d:%02d)" ;  
OQ.NORAGEQUITS      = "no estas en un campo de batalla" ;
OQ.RAGEQUITS        = "%d 'rage quit' hasta ahora" ;
OQ.MSG_PREMADENAME  = "por favor introduce el nombre de la premade" ;
OQ.MSG_MISSINGNAME  = "por favor da un nombre a tu premade" ;
OQ.MSG_REJECT       = "petición de entrada en lista de espera no aceptada.\nrazón: %s" ;
OQ.MSG_CANNOTCREATE_TOOLOW = "No es posible crear la premade.  \nDebes ser nivel 10 o superior" ;
OQ.MSG_NOTLFG       = "Por favor, no uses oQueue para realizar anuncios de Busqueda de Grupo.\nAlgunos jugadores pueden bloquearte de sus premades si lo haces." ;
OQ.TAB_PREMADE      = "Premade" ;
OQ.TAB_FINDPREMADE  = "Buscar Premade" ;
OQ.TAB_CREATEPREMADE = "Crear Premade" ;
OQ.TAB_THESCORE     = "Puntuación" ;
OQ.TAB_SETUP        = "Configuración" ;
OQ.TAB_BANLIST      = "Bloqueados" ;
OQ.TAB_WAITLIST     = "Lista de Espera" ;
OQ.TAB_WAITLISTN    = "Lista de Espera (%d)" ;
OQ.CONNECTIONS      = "conexion  %d - %d" ;
OQ.ANNOUNCE_PREMADES= "%d premades disponibles" ;
OQ.NEW_PREMADE      = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r" ;
OQ.PREMADE_NAMEUPD  = "(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r" ;
OQ.DLG_OK           = "Aceptar" ;
OQ.DLG_YES          = "Si" ;
OQ.DLG_NO           = "No" ;
OQ.DLG_CANCEL       = "Cancelar" ;
OQ.DLG_ENTER        = "Entrar a la Batalla" ;
OQ.DLG_LEAVE        = "Abandonar cola" ;
OQ.DLG_READY        = "Listo" ;
OQ.DLG_NOTREADY     = "NO estoy listo" ;
OQ.DLG_01           = "Por favor, introduce el nombre del personaje:" ;
OQ.DLG_02           = "Entrar a la Batalla" ;
OQ.DLG_03           = "Por favor da un nombre a tu premade:" ;
OQ.DLG_04           = "Por favor introduce tu ID Real:" ;
OQ.DLG_05           = "Contraseña:" ;
OQ.DLG_06           = "Por favor, introduce el id real o el nombre del nuevo lider de grupo:" ;
OQ.DLG_07           = "\n!Disponible NUEVA VERSIÓN !!\n\noQueue  v%s  build  %d\n" ;
OQ.DLG_08           = "Por favor, deja tu grupo para unirte a la\nlista de espera o pide a tu lider de grupo\nque ponga en cola el grupo completo" ;
OQ.DLG_09           = "Solo el lider del grupo puede crear una Premade OQ" ;
OQ.DLG_10           = "La cola ha saltado.\n¿Cual es tu decisión? ";
OQ.DLG_11           = "La cola ha saltado. Esperando a que el Lider de Banda tome una decisión\nPor favor, espera un momento." ;
OQ.DLG_12           = "¿Seguro que quieres abandonar el grupo de banda?" ;
OQ.DLG_13           = "El lider de la premade mira quién esta listo" ;
OQ.DLG_14           = "El lider de la banda ha solicitado recargar" ;
OQ.DLG_15           = "Bloqueando a: %s \nPor favor, introduce tu motivo:" ;
OQ.DLG_16           = "Imposible seleccionar este tipo de premade.\nDemasiados miembros (max. %d)" ;
OQ.DLG_17           = "Por favor introduce el battletag a bloquear:" ;
OQ.DLG_18a          = "La version %d.%d.%d esta disponible" ;
OQ.DLG_18b          = "--  Actualización Requerida  --" ;
OQ.DLG_19           = "Debes estar capacitado para tu propia premade" ;
OQ.DLG_20           = "No se permiten grupos en este tipo de premade" ;
OQ.DLG_21           = "Abandona tu premade antes de entrar en la lista de espera" ;
OQ.DLG_22           = "Disuelve tu premade antes de entrar en la lista de espera" ;
OQ.MENU_KICKGROUP   = "expulsar grupo" ;
OQ.MENU_SETLEAD     = "establecer lider de grupo" ;
OQ.HONOR_PTS        = "Puntos de Honor" ;
OQ.NOBTAG_01        = " no se ha recibido la información de battletag a tiempo." ;
OQ.NOBTAG_02        = " por favor, intentalo de nuevo." ;
OQ.MINIMAP_HIDDEN   = "(OQ) botín del minimapa oculto" ;
OQ.MINIMAP_SHOWN    = "(OQ) botín del minimapa mostrado" ;
OQ.FINDMESH_OK      = "tu conexión es correcta. Las premades se actualizaran en ciclos de 30 segundos" ;
OQ.TIMEERROR_1      = "OQ: tu hora del sistema esta significativamente fuera de sincronización (%s)." ;
OQ.TIMEERROR_2      = "OQ: por favor actualiza la hora y zona horaria de tu sistema." ;
OQ.SYS_YOUARE_AFK    = "Ahora estás Ausente" ;
OQ.SYS_YOUARENOT_AFK = "Ya no estás Ausente" ;
OQ.ERROR_REGIONDATA = "Datos de región no cargados correctamente" ;
OQ.TT_LEAVEPREMADE  = "clic-izquierdo:  salir de lista de espera\nclic-derecho:  bloquear al lider de la premade" ;
OQ.TT_FINDMESH      = "solicitar battletags del tanteador\npara conectarte a la malla" ;
OQ.TT_SUBMIT2MESH   = "envia tu battletag al tanteador\npara ayudar a que crezca la malla" ;
OQ.LABEL_TYPE       = "|cFF808080tipo:|r  %s" ;
OQ.LABEL_ALL        = "todas las premades" ;
OQ.LABEL_BGS        = "campos de batalla" ;
OQ.LABEL_RBGS       = "CdB puntuados" ;
OQ.LABEL_DUNGEONS   = "mazmorras" ;
OQ.LABEL_LADDERS    = "escalas" ;
OQ.LABEL_RAIDS      = "bandas" ;
OQ.LABEL_SCENARIOS  = "gestas" ;
OQ.LABEL_CHALLENGES = "desafios" ;
OQ.LABEL_BG         = "campo de batalla" ;
OQ.LABEL_RBG        = "CdB puntuado" ;
OQ.LABEL_ARENAS     = "arenas" ;
OQ.LABEL_ARENA      = "arena" ;
--OQ.LABEL_ARENAS     = "arenas (no entrerreinos)" ;
--OQ.LABEL_ARENA      = "arena\n(no entrerreinos)" ;
OQ.LABEL_DUNGEON    = "mazmorra" ;
OQ.LABEL_LADDER     = "escala" ;
OQ.LABEL_RAID       = "banda" ;
OQ.LABEL_SCENARIO   = "gesta" ;
OQ.LABEL_CHALLENGE  = "desafios" ;
OQ.PATTERN_CAPS     = "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]" ;
OQ.CONTRIBUTE       = "¡enviar birra!" ;
OQ.MATCHUP          = "agrupar" ;
OQ.NODIPFORYOU      = "Tienes mas de %d amigos battlenet. para usted no hay inmersión (dip)." ; 
OQ.GAINED           = "ganado" ;
OQ.LOST             = "perdido" ;
OQ.PERHOUR          = "por hora" ;
OQ.NOW              = "ahora" ;
OQ.WITH             = "con" ;
OQ.RAID_TOES        = "Veranda de la Primavera Eterna";
OQ.RAID_HOF         = "Corazón de Miedo" ;
OQ.RAID_MV          = "Cámaras Mogu'shan" ;
OQ.RAID_TOT         = "Solio del Trueno" ;
OQ.RAID_RA_DEN      = "Ra Den" ;
OQ.RBG_HRANK_1      = "Explorador" ;
OQ.RBG_HRANK_2      = "Bruto" ;
OQ.RBG_HRANK_3      = "Capataz" ;
OQ.RBG_HRANK_4      = "Capataz Primero" ;
OQ.RBG_HRANK_5      = "Gran Capataz" ;
OQ.RBG_HRANK_6      = "Guardia de Piedra" ;
OQ.RBG_HRANK_7      = "Guardia de Sangre" ;
OQ.RBG_HRANK_8      = "Legionario" ;
OQ.RBG_HRANK_9      = "Centurión" ;
OQ.RBG_HRANK_10     = "Campeón" ;
OQ.RBG_HRANK_11     = "General" ;
OQ.RBG_HRANK_12     = "Gran General" ;
OQ.RBG_HRANK_13     = "Señor de la Guerra" ;
OQ.RBG_HRANK_14     = "Gran Señor de la Guerra" ;
OQ.RBG_ARANK_1      = "Soldado" ;
OQ.RBG_ARANK_2      = "Cabo" ;
OQ.RBG_ARANK_3      = "Sargento" ;
OQ.RBG_ARANK_4      = "Sargento primero" ;
OQ.RBG_ARANK_5      = "Alférez" ;
OQ.RBG_ARANK_6      = "Caballero" ;
OQ.RBG_ARANK_7      = "Teniente caballero" ;
OQ.RBG_ARANK_8      = "Capitán caballero" ;
OQ.RBG_ARANK_9      = "Campeón caballero" ;
OQ.RBG_ARANK_10     = "Teniente coronel" ;
OQ.RBG_ARANK_11     = "Comandante" ;
OQ.RBG_ARANK_12     = "Mariscal" ;
OQ.RBG_ARANK_13     = "Mariscal de campo" ;
OQ.RBG_ARANK_14     = "Gran Mariscal" ;
OQ.TITLES           = "titulos" ;
OQ.CONQUEROR        = "conquistador" ;
OQ.BLOODTHIRSTY     = "sanguinario" ;
OQ.BATTLEMASTER     = "maestro de batalla" ;
OQ.HERO             = "heroe" ;
OQ.WARBRINGER       = "batallador" ;
OQ.KHAN             = "khan" ;
OQ.RANAWAY          = "desertor.  perdida registrada" ;
OQ.TT_KARMA         = "karma"  ;
OQ.UP               = "mas" ;
OQ.DOWN             = "menos" ;
OQ.BAD_KARMA_BTAG   = "OQ: el battle-tag del miembro de grupo seleccionado no es valido" ;
OQ.MAX_KARMA_TODAY  = "OQ: %s ya ha recibido karma de ti hoy" ;
OQ.YOUVE_GOT_KARMA  = "has ganado %d punto de karma." ;
OQ.YOUVE_LOST_KARMA = "has perdido %d punto de karma." ;
OQ.YOUVE_LOST_KARMAS= "has perdido %d puntos de karma." ;
OQ.INSTANCE_LASTED  = "la instancia ha durado" ;
OQ.SHOW_ILEVEL      = "mostrar nivel de objeto" ;
OQ.SOCKET           = " Ranura" ;
OQ.SHA_TOUCHED      = "Influenciada por el Sha" 
OQ.TT_BATTLE_TAG    = "battle-tag" ;
OQ.TT_REGULAR_BG    = "campos de batalla normales" ;
OQ.TT_PERSONAL      = "como miembro" ;
OQ.TT_ASLEAD        = "como lider" ;
OQ.AVG_ILEVEL       = "nivel de objeto medio: %d" ;
OQ.ENCHANTED        = "Encantado:" ;
OQ.ENABLE_FOG       = "niebla de guerra" ;
OQ.AUTO_INSPECT     = "Auto inspeccionar\n(control clic izquierdo)" ;
OQ.TIMELEFT         = "Tiempo restante:" ;
OQ.HORDE            = "Horda" ;
OQ.ALLIANCE         = "Alianza" ;
OQ.SETUP_TIMERWIDTH = "Ancho de los temporizadores" ;
OQ.BG_BEGINS        = " empieza!" -- partial text of start msg
OQ.BG_BEGUN         = " empeza!" -- partial text of start msg
OQ.SETUP_SHOW_CONTROLLED = "Mostrar nodos controlados" ;
OQ.MM_OPTION1       = "conmutar IU principal" ;
OQ.MM_OPTION2       = "conmutar marquesina" ;
OQ.MM_OPTION3       = "conmutar temporizadores" ;
OQ.MM_OPTION4       = "conmutar IU de amenazas" ;
OQ.MM_OPTION5       = "limpiar temporizadores" ;
OQ.MM_OPTION6       = "mostrar tiempo de malla" ;
OQ.MM_OPTION7       = "reparar IU" ;
OQ.MM_OPTION8       = "¿donde estoy?" ;
OQ.MM_OPTION9       = "modo invisible" ;
OQ.LABEL_QUESTING   = "misión" ;
OQ.LABEL_QUESTERS   = "grupos de misión" ;
OQ.ACTIVE_LASTPERIOD= "# activos en los ultimos 7 dias" ;
OQ.SCORE_NLEADERS   = "# lideres" ;
OQ.SCORE_NGAMES     = "# partidas" ;
OQ.SCORE_NBOSSES    = "# jefes" ;
OQ.TT_PVERECORD     = "record (jefes - wipes)" ;
OQ.TT_5MANS         = "lider: mazmorras de 5 jug." ;
OQ.TT_RAIDS         = "lider: bandas" ;
OQ.TT_CHALLENGES    = "lider: desafios" ;
OQ.TT_LEADER_DKP    = "lider: dragon kill pts" ;
OQ.TT_DKP           = "dragon kill pts" ;
OQ.SCORE_DKP        = "# dragon kill pts" ;
OQ.ERR_NODURATION   = "Duración desconocida de la instancia. Imposible calcular los cambios en las monedas" ;
OQ.DRUNK            = "..hic!" ;
OQ.MM_OPTION2a      = "conmutar recompensas" ; -- Literalmente "conmutar tabl?n de recompensas"
OQ.ANNOUNCE_CONTRACTS = "Anunciar contratos" ;
OQ.SETUP_SHOUTCONTRACTS = "Anunciar contratos" ;
OQ.CONTRACT_ARRIVED   = "¡Acaba de llegar el contrato #%s! Objetivo:%s  Recompensa:|h%s" ;
OQ.CONTRACT_CLAIMED01 = "%s %s reclama el contrato #%s y gana %s" ;
OQ.CONTRACT_CLAIMED02 = "%s reclama el contrato #%s y gana %s" ;
OQ.TARGET_MARK        = "¡Has establecido como objetivo un objetivo con recompensa! ( contrato#%s )" ;
OQ.BOUNTY_TARGET      = "¡Has matado un objetivo con recompensa! ( contrato#%s )" ;
OQ.DEATHMATCH_SCORE   = "¡Punto!" ;
OQ.FRIEND_REQUEST     = "%s-%s quiere ser tu amigo" ;
OQ.ALREADY_FRIENDED   = "ya eres amigo de battle-net con %s" ;
OQ.TT_FRIEND_REQUEST  = "añadir amigo" ;
OQ.DEATHMATCH_BEGINS  = "¡El Encuentro a Muerte de JcJ del mundo ha comenzado!  ¡Ve al espinazo en Pandaria y defiende a tus vendedores JcJ!" ;
OQ.WONTHEMATCH        = "ha ganado el encuentro!" ;

OQ.CONTRIBUTION_DLG = { "¿Te estas divirtiendo con",
            "oQueue y el ventrilo publico?",
                        "¡Entonces envianos una cerveza!",
                        "",
                        "para tiny y oQueue:",
                        "beg.oq",
                        "",
                        "para Rathamus y el ventrilo publico:",
                        "beg.vent",
                        "",
                        "¡Gracias!",
                        "",
                        "- tiny",
                      } ;
OQ.TIMEVARIANCE_DLG = { "",
                        "Aviso:",
                        "",
                        "  Tu hora del sistema es significativamente",
                        "  diferente de la de la malla. Debes",
                        "  corregirlo antes de que puedas",
                        "  crear una premade.",
                        "",
                        "  variación de tiempo:  %s",
                        "",
                        "- tiny",
                      } ;
OQ.LFGNOTICE_DLG = { "",
                        "Aviso:",
                        "",
                        "  No uses los nombres de las premades de",
                        "  oQueue para buscar grupos u otros tipos",
                        "  de anuncios personales. Hay bastante ",
                        "  gente que bloquear a cualquiera",
                        "  usandolo de esta forma. Si eres",
                        "  bloqueado, no podrás unirte a sus grupos.",
                        "",
                        "- tiny",
                      } ;


OQ.BG_NAMES     = { [ "Campo de Batalla Aleatorio"  ] = { type_id = OQ.RND  },
                    [ "Garganta Grito de Guerra"    ] = { type_id = OQ.WSG  },
                    [ "Cumbres Gemelas"             ] = { type_id = OQ.TP   },
                    [ "La Batalla por Gilneas"      ] = { type_id = OQ.BFG  },
                    [ "Cuenca de Arathi"            ] = { type_id = OQ.AB   },
                    [ "Ojo de la Tormenta"          ] = { type_id = OQ.EOTS },
                    [ "Playa de los Ancestros"      ] = { type_id = OQ.SOTA },
                    [ "Isla de la Conquista"        ] = { type_id = OQ.IOC  },
                    [ "Valle de Alterac"            ] = { type_id = OQ.AV   },
                    [ "Minas Lonjaplata"            ] = { type_id = OQ.SSM  },
                    [ "Templo de Kotgomu"           ] = { type_id = OQ.TOK  },
                    [ "Cañón del Céfiro"            ] = { type_id = OQ.DWG  },
                    [ "Dragon Kill Points"          ] = { type_id = OQ.DKP  },
                    [ ""                            ] = { type_id = OQ.NONE },
                  } ;
                  
OQ.BG_SHORT_NAME = { [ "Cuenca de Arathi"         ] = "CA",
                     [ "Valle de Alterac"         ] = "VA",
                     [ "La Batalla por Gilneas"   ] = "BpG",
                     [ "Ojo de la Tormenta"       ] = "OT",
                     [ "Isla de la Conquista"     ] = "IC",
                     [ "Playa de los Ancestros"   ] = "PA",
                     [ "Bastión Martillo Salvaje" ] = "CG",
                     [ "Bastión Faucedraco"       ] = "CG",
                     [ "Cumbres Gemelas"          ] = "CG",
                     [ "Bastión Ala de Plata"     ] = "GGG",
                     [ "Garganta Grito de Guerra" ] = "GGG",
                     [ "Serreria Grito de Guerra" ] = "GGG",
                     [ "Minas Lonjaplata"         ] = "ML",
                     [ "Templo de Kotgomu"        ] = "TdK",
                     [ "Cañón del Céfiro"         ] = "CdC",
                     
                     [ OQ.AB                    ] = "CA",
                     [ OQ.AV                    ] = "VA",
                     [ OQ.BFG                   ] = "BpG",
                     [ OQ.EOTS                  ] = "OT",
                     [ OQ.IOC                   ] = "IC",
                     [ OQ.SOTA                  ] = "PA",
                     [ OQ.TP                    ] = "CG",
                     [ OQ.WSG                   ] = "GGG",
                     [ OQ.SSM                   ] = "ML",
                     [ OQ.TOK                   ] = "TdK",
                     [ OQ.DWG                   ] = "CdC",
                     
                     [ "CA"                     ] = OQ.AB,
                     [ "VA"                     ] = OQ.AV,
                     [ "BpG"                    ] = OQ.BFG,
                     [ "OT"                     ] = OQ.EOTS,
                     [ "IC"                     ] = OQ.IOC,
                     [ "PA"                     ] = OQ.SOTA,
                     [ "CG"                     ] = OQ.TP,
                     [ "GGG"                    ] = OQ.WSG,
                     [ "ML"                     ] = OQ.SSM,
                     [ "TdK"                    ] = OQ.TOK,
                     [ "CdC"                    ] = OQ.DWG,
                   } ;
                   
OQ.BG_STAT_COLUMN = { [ "Bases Asaltadas"        ] = "Base Asaltada",
                      [ "Bases Defendidas"       ] = "Base Defendida",
                      [ "Demoledores Destruidos" ] = "Demoledor Destruido",
                      [ "Banderas capturadas"    ] = "Bandera capturada",
                      [ "Banderas recuperadas"   ] = "Bandera recuperada",
                      [ "Puertas Destruidas"     ] = "Puerta Destruida",
                      [ "Cementerios Asaltados"  ] = "Cementerio Asaltado",
                      [ "Cementerios Defendidos" ] = "Cementerio Defendido",
                      [ "Torres Asaltadas"       ] = "Torre Asaltada",
                      [ "Torres Defendidas"      ] = "Torre Defendida",
              } ;

OQ.COLORBLINDSHADER = { [ 0 ] = "Desactivado",
                        [ 1 ] = "Protanopia",
                        [ 2 ] = "Protanomal?a",
                        [ 3 ] = "Deuteranopia",
                        [ 4 ] = "Deuteranomal?a",
                        [ 5 ] = "Tritanopia",
                        [ 6 ] = "Tritanomal?a",
                        [ 7 ] = "Acromatopsia",
                        [ 8 ] = "Acromatosis",
                      } ;

-- Class talent specs
local DK    = { ["Sangre"]             = "Tank",
                ["Escarcha"]           = "Melee",
                ["Profano"]            = "Melee",
              } ; 
local DRUID = { ["Equilibrio"]         = "Knockback",
                ["Feral"]              = "Melee",
                ["Restauración"]       = "Healer",
                ["Guardián"]           = "Tank",
              } ;
local HUNTER = { ["Bestias"]           = "Knockback",
                 ["Puntería"]          = "Ranged",
                 ["Supervivencia"]     = "Ranged",
               } ;
local MAGE = {  ["Arcano"]             = "Knockback",
                ["Fuego"]              = "Ranged",
                ["Escarcha"]           = "Ranged",
             } ; 
local MONK = {  ["Maestro cervecero"]  = "Tank",
                ["Tejedor de niebla"]  = "Healer",
                ["Viajero del viento"] = "Melee",
             } ; 
local PALADIN = { ["Sagrado"]          = "Healer",
                  ["Protección"]       = "Tank",
                  ["Reprensión"]       = "Melee",
                } ; 
local PRIEST = { ["Disciplina"]        = "Healer",
                 ["Sagrado"]           = "Healer",
                 ["Sombra"]            = "Ranged",
               } ; 
local ROGUE = { ["Asesinato"]          = "Melee",
                ["Combate"]            = "Melee",
                ["Sutileza"]           = "Melee",
              } ; 
local SHAMAN = { ["Elemental"]         = "Knockback",
                 ["Mejora"]            = "Melee",
                 ["Restauración"]      = "Healer",
               } ; 
local WARLOCK = { ["Aflicción"]        = "Knockback",
                  ["Demonología"]      = "Knockback",
                  ["Destrucción"]      = "Knockback",
                } ; 
local WARRIOR = { ["Armas"]            = "Melee",
                  ["Furia"]            = "Melee",
                  ["Protección"]       = "Tank",
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
OQ.DEFEAT_EMOTES["El Sha del odio ha abandonado mi cuerpo... y el monasterio. Os lo agradezco, forasteros. El Shadopan está en deuda con vosotros. Ahora queda mucho trabajo por hacer..."] = 56884 ; -- Taran Zhu
OQ.DEFEAT_EMOTES["I am bested. Give me a moment and we will venture together to face the Sha."] = 60007 ; -- Master Snowdrift (Can't translate until we know why the emote doesn't work in esES)
OQ.DEFEAT_EMOTES["Aun juntos... hemos fracasado..."] = 56747 ; -- Gu Cloudstrike
OQ.DEFEAT_EMOTES["¡Imposible! ¡Nuestra fuerza no tiene rival en todo el imperio!"] = 61445 ; -- Haiyan the Unstoppable, Trial of the King
OQ.DEFEAT_EMOTES["Se me ha caído la venda de los ojos... Perdonadme por dudar de vosotros..."] = 56732 ; -- Liu Flameheart

--
L["Doom Lord Kazzak"        ] = "Señor de fatalidad Kazzak" ;
L["Hogger"                  ] = "Hogger" ;
L["Lord Overheat"           ] = "Lord Quemado" ;
L["Randolph Moloch"         ] = "Randolph Moloch" ;
L["Adarogg"                 ] = "Adarogg" ;
L["Slagmaw"                 ] = "Faucescoria" ;
L["Lava Guard Gordoth"      ] = "Guardia de lava Gordoth" ;
L["Newton Burnside"         ] = "Newton Ladoquemado" ;
L["Auctioneer Chilton"      ] = "Subastador Chilton" ;
L["Alchemist Mallory"       ] = "Alquimista Mallory" ;
L["Toddrick"                ] = "Toddrick" ;
L["Remen Marcot"            ] = "Remen Marcot" ;
L["Goldtooth"               ] = "Dientes de Oro" ;
L["Auctioneer Fazdran"      ] = "Subastador Fazdran" ;
L["Kixa"                    ] = "Kixa" ;
L["Gor the Enforcer"        ] = "Gor el Déspota" ;
L["Tarshaw Jaggedscar"      ] = "Tarshaw Marcauna" ;
L["Rokar Bladeshadow"       ] = "Rokar Filosombra" ;
L["Kor'kron Spotter"        ] = "Avistador Kor'kron" ;
L["Falstad Wildhammer"      ] = "Falstad Martillo Salvaje" ;
L["Baine Bloodhoof"         ] = "Baine Pezuña de Sangre" ;
L["Fel Reaver"              ] = "Atracador vil" ;
L["Brewmaster Roland"       ] = "Maestro cervecero Roland" ;
L["Reeler Uko"              ] = "Devanador Uko" ;
L["Sulik'shor"              ] = "Sulik'shor" ;
L["Qu'nas"                  ] = "Qu'nas" ;
L["Nal'lak the Ripper"      ] = "Nal'lak el Destripador" ;
L["Muerta"                  ] = "Muerta" ;
L["Disha Fearwarden"        ] = "Disha Eludemiedo" ;
L["Bonestripper Buzzard"    ] = "Águila ratonera limpiahuesos" ;
L["Fulgorge"                ] = "Atiborrador" ;
L["Sahn Tidehunter"         ] = "Sahn Cazador de Olas" ;
L["Moldo One-Eye"           ] = "Moldo el Tuerto" ;
L["Omnis Grinlok"           ] = "Omnis Grinlok" ;
L["Armsmaster Holinka"      ] = "Maestro de armas Holinka" ;
L["Roo Desvin"              ] = "Roo Desvin" ;
L["Hiren Loresong"          ] = "Hiren Romanza" ;
L["Vasarin Redmorn"         ] = "Vasarin Rojoalbor" ;
L["Grumbol Grimhammer"      ] = "Grumbol Martillo Siniestro" ;
L["Usha Eyegouge"           ] = "Usha Ojo de Gubia" ;
L["Bartlett the Brave"      ] = "Bartlett el Valiente" ;
L["Anette Williams"         ] = "Anette Williams" ;
L["Auctioneer Vizput"       ] = "Subastador Vizput" ;
L["Lady Sylvanas Windrunner"] = "Lady Sylvanas Brisaveloz" ;
L["Devrak"                  ] = "Devrak" ;
L["Felicia Maline"          ] = "Felicia Maline" ;
L["Radulf Leder"            ] = "Radulf Leder" ;
L["The Black Bride"         ] = "La Novia Negra" ;
L["Shan'ze Battlemaster"    ] = "Maestro de batalla Shan'ze" ;
L["Holgar Stormaxe"         ] = "Holgar Hachatormenta" ;
L["Ruskan Goreblade"        ] = "Ruskan Hojasanguina" ;
L["Maginor Dumas"           ] = "Maginor Dumas" ;
L["High Sorcerer Andromath" ] = "Sumo hechicero Andromath" ;
L["Captain Dirgehammer"     ] = "Capitán Martillo de Endecha" ;
L["Keryn Sylvius"           ] = "Keryn Sylvius" ;
L["Bizmo's Brawlpub Bouncer"] = "Gorila del Club de Lucha de Bizmo" ;
L["Myolor Sunderfury"       ] = "Myolor Furiahendida" ;
L["Golnir Bouldertoe"       ] = "Golnir Dedorroca" ;
L["Auctioneer Lympkin"      ] = "Subastadora Lympkin" ;
L["Jarven Thunderbrew"      ] = "Jarven Cebatruenos" ;
L["Mistblade Scale-Lord"    ] = "Señor de escamas Hojaniebla" ;
L["Major Nanners"           ] = "Mayor Nanners" ;
L["Doris Chiltonius"        ] = "Doris Chiltonius" ;
L["Lucan Malory"            ] = "Lucan Malory" ;
L["Acon Deathwielder"       ] = "Acon Penamuerte" ;
L["Ethan Natice"            ] = "Ethan Natice" ;
L["Kri'chon"                ] = "Kri'chon" ;
L["Warlord Bloodhilt"       ] = "Señor de la guerra Sangrastil" ;
L["High Marshal Twinbraid"  ] = "Alto mariscal Trenzado" ;
