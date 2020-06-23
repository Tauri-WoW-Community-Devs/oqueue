local _, OQ = ...

OQ.TRANSLATED_BY['ruRU'] = 'Efzet (Сибил, Azuregos EU)'
if (GetLocale() ~= 'ruRU') then
    return
end
local L = OQ._T

BINDING_HEADER_OQUEUE = 'oQueue'
BINDING_NAME_TOGGLE_OQUEUE = 'Вкл/Выкл oQueue'

OQ.TITLE_LEFT = 'oQueue v'
OQ.TITLE_RIGHT = ' - Поисковик премейдов'
OQ.PREMADE = 'Мой премейд'
OQ.FINDPREMADE = 'Поиск'
OQ.CREATEPREMADE = 'Создать'
OQ.CREATE_BUTTON = 'Создать премейд'
OQ.UPDATE_BUTTON = 'Обновить премейд'
OQ.WAITLIST = 'Очередь'
OQ.HONOR_BUTTON = 'oQ премейд'
OQ.PLEASE_SELECT_BG = 'Пожалуйста, выберите поле боя'
OQ.BAD_REALID = 'Неверный real-id или battle-tag.\n'
OQ.QUEUE1_SELECTBG = '<выберите поле боя>'
OQ.NOLEADS_IN_RAID = 'В рейде нет лидеров групп'
OQ.NOGROUPS_IN_RAID = 'Невозможно присоединить группу к рейду'
OQ.BUT_INVITE = 'Пригласить'
OQ.BUT_GROUPLEAD = 'Дать лидера'
OQ.BUT_INVITEGROUP = 'Группа (%d)'
OQ.BUT_WAITLIST = 'В очередь'
OQ.BUT_INGAME = 'В игре'
OQ.BUT_PENDING = 'Ожидание'
OQ.BUT_INPROGRESS = 'В бою.'
OQ.BUT_NOTAVAILABLE = 'Недоступно'
OQ.BUT_FINDMESH = 'Найти связи'
OQ.BUT_SUBMIT2MESH = 'Отправ. b-tag'
OQ.BUT_BAN_BTAG = 'Ввести b-tag'
OQ.BUT_INVITE_ALL = 'Взять всех'
OQ.BUT_REMOVE_OFFLINE = 'Убрать оффлайн'
OQ.BUT_CLEARFILTERS = 'Снять фильтр'
OQ.TT_LEADER = 'Лидер'
OQ.TT_REALM = 'Игровой мир'
OQ.TT_MEMBERS = 'Игроки'
OQ.TT_WAITLIST = 'Очередь'
OQ.TT_RECORD = 'Победы - Поражения'
OQ.TT_AVG_HONOR = 'Очков чести за игру'
OQ.TT_AVG_HKS = 'Почетных побед за игру'
OQ.TT_AVG_GAME_LEN = 'Продолжительность игры'
OQ.TT_AVG_DOWNTIME = 'Время без активности'
OQ.TT_RESIL = 'Устойчивость'
OQ.TT_ILEVEL = 'Ур. предметов'
OQ.TT_MAXHP = 'Макс. здоровья'
OQ.TT_WINLOSS = 'Победа - Поражение'
OQ.TT_HKS = 'Всего почетных побед'
OQ.TT_OQVERSION = 'Версия'
OQ.TT_TEARS = 'Покинул рейд'
OQ.TT_PVPPOWER = 'PvP сила'
OQ.TT_MMR = 'PvP рейтинг'
OQ.JOIN_QUEUE = 'Встать в очередь'
OQ.LEAVE_QUEUE = 'Покинуть очередь'
OQ.LEAVE_QUEUE_BIG = 'ПОКИНУТЬ ОЧЕРЕДЬ'
OQ.DAS_BOOT = 'ЭТО БОТ!'
OQ.DISBAND_PREMADE = 'Распустить премейд'
OQ.LEAVE_PREMADE = 'Покинуть премейд'
OQ.RELOAD = 'Перезагрузить'
OQ.ILL_BRB = 'Скоро вернусь'
OQ.LUCKY_CHARMS = 'Расставить метки'
OQ.IAM_BACK = 'Я вернулся'
OQ.ROLE_CHK = 'Проверка ролей'
OQ.READY_CHK = 'Готовность'
OQ.APPROACHING_CAP = 'СКОРО ЗАХВАТЫВАТЬ'
OQ.CAPPED = 'ЗАХВАЧЕН'
OQ.HDR_PREMADE_NAME = 'Список премейдов'
OQ.HDR_LEADER = 'Лидер'
OQ.HDR_LEVEL_RANGE = 'Ур.'
OQ.HDR_TIME = 'Время'
OQ.HDR_TOONNAME = 'Имя'
OQ.HDR_REALM = 'Мир'
OQ.HDR_LEVEL = 'Ур.'
OQ.HDR_ILEVEL = 'ИЛ'
OQ.HDR_RESIL = 'Рес.'
OQ.HDR_MMR = 'Рейт.'
OQ.HDR_PVPPOWER = 'PvP сила'
OQ.HDR_POWER = 'Сила'
OQ.HDR_HASTE = 'Скор.'
OQ.HDR_MASTERY = 'Искус.'
OQ.HDR_HIT = 'Метк.'
OQ.HDR_DATE = 'Дата'
OQ.HDR_BTAG = 'Battle Tag'
OQ.HDR_REASON = 'Причина'
OQ.QUALIFIED = 'Подходит'
OQ.PREMADE_NAME = 'Название премейда'
OQ.REALID = 'Real-Id или B-tag'
OQ.REALID_MOP = 'Battle-tag'
OQ.MIN_ILEVEL = 'Мин. ур. предметов'
OQ.MIN_RESIL = 'Мин. устойчивость'
OQ.MIN_MMR = 'Мин. рейтинг поля боя'
OQ.BATTLEGROUNDS = 'Описание'
OQ.ENFORCE_LEVELS = 'Подобрать группу по уровню'
OQ.NOTES = 'Заметка'
OQ.PASSWORD = 'Пароль'
OQ.CREATEURPREMADE = 'Создание своего премейда'
OQ.LABEL_LEVEL = 'Уровень'
OQ.LABEL_LEVELS = 'Уровни'
OQ.RAFK_ENABLED = 'AFK включен'
OQ.RAFK_DISABLED = 'AFK выключен'
OQ.SETUP_HEADING = 'Настройки и различные команды'
OQ.SETUP_BTAG = 'Почтовый адрес battle.net'
OQ.SETUP_CAPCHK = 'Проверка совместимости oQ'
OQ.SETUP_ALTLIST = 'Список альтов на b-net аккаунте:\n(Мультибоксинг)'
OQ.SETUP_AUTOROLE = 'Автовыставление роли'
OQ.SETUP_CLASSPORTRAIT = 'Использовать иконки классов'
OQ.SETUP_GARBAGE = 'Собирать мусор (интервал 30 сек)'
OQ.SETUP_SHOUTADS = 'Объявить премейды'
OQ.SETUP_AUTOHIDE_FRIENDREQS = 'Скрывать запросы предложения дружбы'
OQ.SETUP_ADD = 'Добавить'
OQ.SETUP_MYCREW = 'Моя команда'
OQ.SETUP_CLEAR = 'Очистить'
OQ.LOCAL_OQ_USERS = 'Локальные oQ пользователи'
OQ.TIME_DRIFT = 'Время дрейфа'
OQ.PPS_SENT = 'Отправлено пакетов в сек'
OQ.PPS_RECVD = 'Получено пакетов в сек'
OQ.PPS_PROCESSED = 'Обработано пакетов в сек'
OQ.MEM_USED = 'Использование памяти (kB)'
OQ.BANDWIDTH_UP = 'Выгрузка (kBps)'
OQ.BANDWIDTH_DN = 'Загрузка (kBps)'
OQ.OQSK_DTIME = 'Время дисперсии'
OQ.SETUP_CHECKNOW = 'Проверить сейчас'
OQ.SETUP_REMOVENOW = 'Удалить сейчас'
OQ.STILL_IN_PREMADE = 'Пожалуйста, покиньте ваш премейд, чтобы создать новый.'
OQ.DD_PROMOTE = 'Назначить лидером'
OQ.DD_KICK = 'Исключить игрока'
OQ.DD_BAN = 'Заблокировать b-tag'
OQ.DISABLED = 'oQueue отключен'
OQ.ENABLED = 'oQueue включен'
OQ.THETIMEIS = 'Время: %d (GMT)'
OQ.MSG_PREMADENAME = 'Пожалуйста, введите название премейда'
OQ.MSG_MISSINGNAME = 'Пожалуйста, назовите свой премейд'
OQ.MSG_REJECT = 'Запрос не принят.\nПричина: %s'
OQ.MSG_CANNOTCREATE_TOOLOW = 'Невозможно создать премейд.  \nВы должны быть 10 уровня или выше.'
OQ.MSG_NOTLFG =
    'Пожалуйста, не используйте oQueue как рекламную площадку для поиска группы. \nНекоторые игроки могут вас заблокировать.'
OQ.TAB_PREMADE = 'Премейд'
OQ.TAB_FINDPREMADE = 'Поиск'
OQ.TAB_CREATEPREMADE = 'Создать'
OQ.TAB_SETUP = 'Настройки'
OQ.TAB_BANLIST = 'Черный список'
OQ.TAB_WAITLIST = 'Ожидание'
OQ.TAB_WAITLISTN = 'Ожидание (%d)'
OQ.CONNECTIONS = 'Соединение  %d - %d'
OQ.ANNOUNCE_PREMADES = 'Доступно %d премейдов'
OQ.NEW_PREMADE = '(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r'
OQ.PREMADE_NAMEUPD = '(|cFF808080%d|r) |cFFC0C0C0%s|r : %s  |cFFC0C0C0%s|r'
OQ.DLG_OK = 'OK'
OQ.DLG_YES = 'Да'
OQ.DLG_NO = 'Нет'
OQ.DLG_CANCEL = 'Отмена'
OQ.DLG_ENTER = 'Войти в бой'
OQ.DLG_LEAVE = 'Покинуть очередь'
OQ.DLG_READY = 'Готов'
OQ.DLG_NOTREADY = 'НЕ ГОТОВ'
OQ.DLG_01 = 'Пожалуйста, введите имя альта:'
OQ.DLG_02 = 'Войти в бой'
OQ.DLG_03 = 'Пожалуйста, назовите ваш премейд:'
OQ.DLG_04 = 'Пожалуйста, введите ваш real-id:'
OQ.DLG_05 = 'Пароль:'
OQ.DLG_06 = 'Пожалуйста, введите real-id или имя нового лидера группы:'
OQ.DLG_07 =
    '\nДоступна НОВАЯ ВЕРСИЯ!\n\noQueue  v%s  build  %d\nСкачать с официального сайта: http://solidice.com/oqueue/'
OQ.DLG_08 =
    'Пожалуйста, покиньте вашу группу чтобы встать в очередь или \nпопросите вашего лидера встать в очередь группой'
OQ.DLG_09 = 'Только лидер группы имеет право создавать премейд в oQ'
OQ.DLG_10 = 'Пришло приглашение.\n\nВаше решение?'
OQ.DLG_11 = 'Пришло приглашение. Ждем лидера рейда для принятия решения.\nПожалуйста, подождите.'
OQ.DLG_12 = 'Вы уверены, что хотите покинуть рейдовую группу?'
OQ.DLG_13 = 'Лидер премейда запустил проверку готовности'
OQ.DLG_14 = 'Лидер рейда перезагружается'
OQ.DLG_15 = 'Блокировка: %s \nПожалуйста, введите причину:'
OQ.DLG_16 = 'Невозможно выбрать тип премейда.\nСлишком много игроков (макс. %d)'
OQ.DLG_17 = 'Пожалуйста, введите b-tag для блокировки:'
OQ.DLG_18a = 'Версия %d.%d.%d уже доступна!'
OQ.DLG_18b = '--  Требуется обновление  --'
OQ.DLG_19 = 'Вы должны соответствовать требованиям вашего премейда'
OQ.DLG_20 = 'Нет подходящих групп для этого типа премейда'
OQ.DLG_21 = 'Покиньте ваш премейд прежде чем встать в очередь'
OQ.DLG_22 = 'Распустите ваш премейд прежде чем встать в очередь'
OQ.MENU_KICKGROUP = 'Распустить группу'
OQ.MENU_SETLEAD = 'Дать лидера'
OQ.HONOR_PTS = 'Очки чести'
OQ.NOBTAG_01 = 'Информация о b-tag не получена вовремя'
OQ.NOBTAG_02 = 'Пожалуйста, попробуйте еще раз.'
OQ.MINIMAP_HIDDEN = '(OQ) Скрыть иконку миникарты'
OQ.MINIMAP_SHOWN = '(OQ) Показать иконку миникарты'
OQ.FINDMESH_OK = 'Соединение в порядке. Премейды обновляются каждые 30 сек.'
OQ.TIMEERROR_1 = 'OQ: Ваше системное время сильно отличается (%s).'
OQ.TIMEERROR_2 = 'OQ: Пожалуйста, синхронизируйте ваше системное время с вашим часовым поясом.'
OQ.SYS_YOUARE_AFK = 'Вы отсутствуете (AFK).'
OQ.SYS_YOUARENOT_AFK = 'Вы вернулись.'
OQ.ERROR_REGIONDATA = 'Региональные данные загружены неправильно.'
OQ.TT_LEAVEPREMADE = 'ЛКМ: Скрыть премейд\nПКМ: Заблокировать лидера премейда'
OQ.LABEL_TYPE = '|cFF808080type:|r  %s'
OQ.LABEL_ALL = 'Все премейды'
OQ.LABEL_BGS = 'Поля боя'
OQ.LABEL_RBGS = 'Рейт. поля боя'
OQ.LABEL_DUNGEONS = 'Подземелья'
OQ.LABEL_LADDERS = 'Ладдеры'
OQ.LABEL_RAIDS = 'Рейды'
OQ.LABEL_SCENARIOS = 'Сценарии'
OQ.LABEL_CHALLENGES = 'Испытания'
OQ.LABEL_BG = 'Поле боя'
OQ.LABEL_RBG = 'Рейт. поле боя'
OQ.LABEL_ARENAS = 'Арены'
OQ.LABEL_ARENA = 'Арена'
OQ.LABEL_DUNGEON = 'Подземелье'
OQ.LABEL_LADDER = 'Ладдер'
OQ.LABEL_RAID = 'Рейд'
OQ.LABEL_SCENARIO = 'Сценарий'
OQ.LABEL_CHALLENGE = 'Испытание'
OQ.LABEL_QUESTING = 'Задание'
OQ.LABEL_QUESTERS = 'Групповые задания'
OQ.LABEL_MISC = 'Разное'
OQ.LABEL_ROLEPLAY = 'Ролевыя игры'
OQ.PATTERN_CAPS = '[ABCDEFGHIJKLMNOPQRSTUVWXYZ]'
OQ.MATCHUP = 'Совпадают'
OQ.GAINED = 'Получено'
OQ.LOST = 'Потеряно'
OQ.PERHOUR = 'в час'
OQ.NOW = 'Сейчас'
OQ.WITH = 'с'
OQ.RAID_TOES = 'ТВВ'
OQ.RAID_HOF = 'СС'
OQ.RAID_MV = 'ПМ'
OQ.RAID_TOT = 'ПГ'
OQ.RAID_RA_DEN = 'Ра-Ден'
OQ.RAID_SOO = 'ОО'
OQ.RBG_HRANK_1 = 'Scout'
OQ.RBG_HRANK_2 = 'Grunt'
OQ.RBG_HRANK_3 = 'Sergeant'
OQ.RBG_HRANK_4 = 'Senior Sergeant'
OQ.RBG_HRANK_5 = 'First Sergeant'
OQ.RBG_HRANK_6 = 'Stone Guard'
OQ.RBG_HRANK_7 = 'Blood Guard'
OQ.RBG_HRANK_8 = 'Legionnaire'
OQ.RBG_HRANK_9 = 'Centurion'
OQ.RBG_HRANK_10 = 'Champion'
OQ.RBG_HRANK_11 = 'Lieutenant General'
OQ.RBG_HRANK_12 = 'General'
OQ.RBG_HRANK_13 = 'Warlord'
OQ.RBG_HRANK_14 = 'High Warlord'
OQ.RBG_ARANK_1 = 'Private'
OQ.RBG_ARANK_2 = 'Corporal'
OQ.RBG_ARANK_3 = 'Sergeant'
OQ.RBG_ARANK_4 = 'Master Sergeant'
OQ.RBG_ARANK_5 = 'Sergeant Major'
OQ.RBG_ARANK_6 = 'Knight'
OQ.RBG_ARANK_7 = 'Knight-Lieutenant'
OQ.RBG_ARANK_8 = 'Knight-Captain'
OQ.RBG_ARANK_9 = 'Knight-Champion'
OQ.RBG_ARANK_10 = 'Lieutenant Commander'
OQ.RBG_ARANK_11 = 'Commander'
OQ.RBG_ARANK_12 = 'Marshal'
OQ.RBG_ARANK_13 = 'Field Marshal'
OQ.RBG_ARANK_14 = 'Grand Marshal'
OQ.TITLES = 'Звания'
OQ.CONQUEROR = 'Завоеватель'
OQ.BLOODTHIRSTY = 'Кровожадный'
OQ.BATTLEMASTER = 'Полководец'
OQ.HERO = 'Герой'
OQ.WARBRINGER = 'Вестник войны'
OQ.KHAN = 'Хан'
OQ.RANAWAY = 'Дезертир. Убежал с поля боя.'
OQ.UP = '[+]'
OQ.DOWN = '[-]'
OQ.INSTANCE_LASTED = 'Инстанс длился'
OQ.SHOW_ILEVEL = 'Показать ИЛ'
OQ.SOCKET = 'Разъем'
OQ.SHA_TOUCHED = 'Прикосновение Ша'
OQ.TT_BATTLE_TAG = 'Battle Tag'
OQ.TT_REGULAR_BG = 'Поля боя'
OQ.TT_PERSONAL = 'как игрок'
OQ.TT_ASLEAD = 'как лидер'
OQ.AVG_ILEVEL = 'Средний ИЛ: %d'
OQ.ENCHANTED = 'Зачаровано:'
OQ.AUTO_INSPECT = 'Авто-осмотр персонажа (Ctrl+ЛКМ)'
OQ.HORDE = 'Орда'
OQ.ALLIANCE = 'Альянс'
OQ.MM_OPTION1 = 'Вкл/Выкл главное окно'
OQ.MM_OPTION7 = 'Фиксация интерфейс'
OQ.TT_PVERECORD = 'Победы - Поражения'
OQ.TT_5MANS = 'лидер: подземелья'
OQ.TT_RAIDS = 'лидер: рейды'
OQ.TT_CHALLENGES = 'лидер: испытания'
OQ.ERR_NODURATION = 'Неизвестна продолжительность инстанса. Валютные изменения не рассчитаны.'
OQ.DRUNK = '..ик!'
OQ.ALREADY_FRIENDED = 'Вы уже являетесь b-net другом с %s'
OQ.TT_FRIEND_REQUEST = 'Запрос дружбы'
OQ.MSG_MISSINGTYPE = 'Пожалуйста, выберите тип премейда'

OQ.LABEL_VENTRILO = 'Ventrilo'
OQ.LABEL_TEAMSPEAK = 'Teamspeak'
OQ.LABEL_DISCORD = 'Discord'
OQ.LABEL_UNSPECIFIED = 'Не выбрано'
OQ.LABEL_NOVOICE = 'Без голоса'

OQ.LABEL_US_ENGLISH = 'Английский (US)'
OQ.LABEL_UK_ENGLISH = 'Английский (UK)'
OQ.LABEL_OC_ENGLISH = 'Английский (Oceanic)'
OQ.LABEL_EURO = 'Евро (General)'
OQ.LABEL_RUSSIAN = 'Русский'
OQ.LABEL_GERMAN = 'Немецкий'
OQ.LABEL_ES_SPANISH = 'Испанский (ES)'
OQ.LABEL_MX_SPANISH = 'Испанский (MX)'
OQ.LABEL_BR_PORTUGUESE = 'Португальский (BR)'
OQ.LABEL_PT_PORTUGUESE = 'Португальский (PT)'
OQ.LABEL_FRENCH = 'Французский'
OQ.LABEL_ITALIAN = 'Итальянский'
OQ.LABEL_TURKISH = 'Турецкий'
OQ.LABEL_GREEK = 'Греческий'
OQ.LABEL_DUTCH = 'Голландский'
OQ.LABEL_SWEDISH = 'Шведский'
OQ.LABEL_ARABIC = 'Арабский'
OQ.LABEL_KOREAN = 'Корейский'

OQ.TIMEVARIANCE_DLG = {
    '',
    'Внимание:',
    '',
    '  Ваше системное время значительно ',
    '  отличается от сетевого. Вы должны',
    '  скорректировать его, прежде чем приступите',
    '  к созданию премейда.',
    '',
    '  разница времени:  %s',
    '',
    '- tiny'
}
OQ.LFGNOTICE_DLG = {
    '',
    'Внимание:',
    '',
    '  Не используйте имена премейдов oQueue',
    '  для поиска группы или другой вашей',
    '  рекламы. Большинство игроков может',
    '  заблокировать вас и вы не сможете',
    '  присоединиться к их премейдам.',
    '',
    '- tiny'
}

OQ.BG_NAMES = {
    ['Случайное поле боя'] = {type_id = OQ.RND},
    ['Ущелье Песни Войны'] = {type_id = OQ.WSG},
    ['Два Пика'] = {type_id = OQ.TP},
    ['Битва за Гилнеас'] = {type_id = OQ.BFG},
    ['Низина Арати'] = {type_id = OQ.AB},
    ['Око Бури'] = {type_id = OQ.EOTS},
    ['Берег Древних'] = {type_id = OQ.SOTA},
    ['Остров Завоеваний'] = {type_id = OQ.IOC},
    ['Альтеракская Долина'] = {type_id = OQ.AV},
    ['Сверкающие Копи'] = {type_id = OQ.SSM},
    ['Храм Котмогу'] = {type_id = OQ.TOK},
    ['Каньон Суровых Ветров'] = {type_id = OQ.DWG},
    [''] = {type_id = OQ.NONE}
}

OQ.BG_SHORT_NAME = {
    ['Низина Арати'] = 'Арати',
    ['Альтеракская Долина'] = 'Альтерак',
    ['Битва за Гилнеас'] = 'Гилнеас',
    ['Око Бури'] = 'Око',
    ['Остров Завоеваний'] = 'ОЗ',
    ['Берег Древних'] = 'Берег',
    ['Два Пика'] = 'Пики',
    ['Ущелье Песни Войны'] = 'Ущелье',
    ['Сверкающие Копи'] = 'Копи',
    ['Храм Котмогу'] = 'Котмогу',
    ['Каньон Суровых Ветров'] = 'Каньон',
    [OQ.AB] = 'Арати',
    [OQ.AV] = 'Альтерак',
    [OQ.BFG] = 'Гилнеас',
    [OQ.EOTS] = 'Око',
    [OQ.IOC] = 'ОЗ',
    [OQ.SOTA] = 'Берег',
    [OQ.TP] = 'Пики',
    [OQ.WSG] = 'Ущелье',
    [OQ.SSM] = 'Копи',
    [OQ.TOK] = 'Котмогу',
    [OQ.DWG] = 'Каньон',
    ['Арати'] = OQ.AB,
    ['Альтерак'] = OQ.AV,
    ['Гилнеас'] = OQ.BFG,
    ['Око'] = OQ.EOTS,
    ['ОЗ'] = OQ.IOC,
    ['Берег'] = OQ.SOTA,
    ['Пики'] = OQ.TP,
    ['Ущелье'] = OQ.WSG,
    ['Копи'] = OQ.SSM,
    ['Котмогу'] = OQ.TOK,
    ['Каньон'] = OQ.DWG
}

OQ.BG_STAT_COLUMN = {
    ['База атакована'] = 'База атакована',
    ['База защищена'] = 'База защищена',
    ['Разрушитель уничтожен'] = 'Разрушитель уничтожен',
    ['Флаг захвачен'] = 'Флаг захвачен',
    ['Флаг возвращен'] = 'Флаг возвращен',
    ['Врат разрушены'] = 'Врата разрушены',
    ['Кладбище атаковано'] = 'Кладбище атаковано',
    ['Кладбище защищено'] = 'Кладбище защищено',
    ['Башня атакованы'] = 'Башня атакована',
    ['Башня защищена'] = 'Башня защищена'
}

-- Class talent specs
local DK = {
    ['Кровь'] = 'Tank',
    ['Лед'] = 'Melee',
    ['Нечестивость'] = 'Melee'
}
local DRUID = {
    ['Баланс'] = 'Knockback',
    ['Сила зверя'] = 'Melee',
    ['Исцеление'] = 'Healer',
    ['Страж'] = 'Tank'
}
local HUNTER = {
    ['Повелитель зверей'] = 'Knockback',
    ['Стрельба'] = 'Ranged',
    ['Выживание'] = 'Ranged'
}
local MAGE = {
    ['Тайная магия'] = 'Knockback',
    ['Огонь'] = 'Ranged',
    ['Лед'] = 'Ranged'
}
local MONK = {
    ['Хмелевар'] = 'Tank',
    ['Ткач туманов'] = 'Healer',
    ['Танцующий с ветром'] = 'Melee'
}
local PALADIN = {
    ['Свет'] = 'Healer',
    ['Защита'] = 'Tank',
    ['Воздаяние'] = 'Melee'
}
local PRIEST = {
    ['Послушание'] = 'Healer',
    ['Свет'] = 'Healer',
    ['Тьма'] = 'Ranged'
}
local ROGUE = {
    ['Ликвидация'] = 'Melee',
    ['Бой'] = 'Melee',
    ['Скрытность'] = 'Melee'
}
local SHAMAN = {
    ['Стихии'] = 'Knockback',
    ['Совершенствование'] = 'Melee',
    ['Исцеление'] = 'Healer'
}
local WARLOCK = {
    ['Колдовство'] = 'Knockback',
    ['Демонология'] = 'Knockback',
    ['Разрушение'] = 'Knockback'
}
local WARRIOR = {
    ['Оружие'] = 'Melee',
    ['Неистовство'] = 'Melee',
    ['Защита'] = 'Tank'
}

OQ.BG_ROLES = {}
OQ.BG_ROLES['DEATHKNIGHT'] = DK
OQ.BG_ROLES['DRUID'] = DRUID
OQ.BG_ROLES['HUNTER'] = HUNTER
OQ.BG_ROLES['MAGE'] = MAGE
OQ.BG_ROLES['MONK'] = MONK
OQ.BG_ROLES['PALADIN'] = PALADIN
OQ.BG_ROLES['PRIEST'] = PRIEST
OQ.BG_ROLES['ROGUE'] = ROGUE
OQ.BG_ROLES['SHAMAN'] = SHAMAN
OQ.BG_ROLES['WARLOCK'] = WARLOCK
OQ.BG_ROLES['WARRIOR'] = WARRIOR

-- some bosses do not 'die'... their defeat must be detected by watching their yell emotes
-- this table maps a defeat emote to the boss-id (it'd be better if it was mapped to the name, but names aren't necessarily localized)
--
OQ.DEFEAT_EMOTES = {}
OQ.DEFEAT_EMOTES[
        'The Sha of Hatred has fled my body... and the monastery, as well. I must thank you, strangers. The Shado-Pan are in your debt. Now, there is much work to be done...'
    ] = 56884 -- Taran Zhu
OQ.DEFEAT_EMOTES['I am bested. Give me a moment and we will venture together to face the Sha.'] = 60007 -- Master Snowdrift
OQ.DEFEAT_EMOTES['Even together... we failed...'] = 56747 -- Gu Cloudstrike
OQ.DEFEAT_EMOTES['Impossible! Our might is the greatest in all the empire!'] = 61445 -- Haiyan the Unstoppable, Trial of the King
OQ.DEFEAT_EMOTES['The haze has been lifted from my eyes... forgive me for doubting you...'] = 56732 -- Liu Flameheart

OQ.raid_ids = {
    [L["Храм Ан'Киража"]] = 1,
    [L['Логово Крыла Тьмы']] = 2,
    [L['Огненные Недра']] = 3,
    [L['Логово Ониксии']] = 4,
    [L["Руины Ан'Киража"]] = 5,
    [L['Черный Храм']] = 6,
    [L['Логово Груула']] = 7,
    [L['Каражан']] = 8,
    [L['Логово Магтеридона']] = 9,
    [L['Змеиное Святилище']] = 10,
    [L['Крепость Бурь']] = 11,
    [L['Битва за гору Хиджал']] = 12,
    [L['Плато Солнечного Колодца']] = 13,
    [L['Цитадель Ледяной Короны']] = 14,
    [L['Наксрамас']] = 15,
    [L['Логово Ониксии']] = 16,
    [L['Око Вечности']] = 17,
    [L['Обсидиановое Святилище']] = 18,
    [L['Рубиновое Святилище']] = 19,
    [L['Испытание Крестоносца']] = 20,
    [L['Ульдуар']] = 21,
    [L['Склеп Аркавона']] = 22,
    [L['Крепость Барадин']] = 23,
    [L['Твердыня Крыла Тьма']] = 24,
    [L['Душа Дракона']] = 25,
    [L['Огненные Просторы']] = 26,
    [L['Сумеречный Бастион']] = 27,
    [L['Трон Четырех Ветров']] = 28,
    [L['Сердце Страха']] = 29,
    [L['Подземелья Могушан']] = 30,
    [L['Осада Оргриммара']] = 31,
    [L['Терраса Вечной Весны']] = 32,
    [L['Престол Гроз']] = 33,
    [L['Мировой босс']] = 63
}

OQ.raid_abbrevation = {
    [1] = L['АК'], -- Ahn'Qiraj temple
    [2] = L['ЛКТ'], -- blackwing lair
    [3] = L['ОН'], -- molten core
    [4] = L['Они'], -- onyxia's lair
    [5] = L['АК20'], -- ruins of ahn'qiraj
    [6] = L['БТ'], -- black temple
    [7] = L['Гру'], -- gruul's lair
    [8] = L['Кара'], -- karazhan
    [9] = L['Маг'], -- magtheridon's lair
    [10] = L['ЗС'], -- serpentshrine cavern
    [11] = L['КБ'], -- tempest keep
    [12] = L['ГХ'], -- the battle for mount hyjal
    [13] = L['ПСК'], -- the sunwell
    [14] = L['ЦЛК'], -- icecrown citadel
    [15] = L['Накс'], -- naxxramas
    [16] = L['Они'], -- onyxia's lair
    [17] = L['ОВ'], -- the eye of eternity
    [18] = L['ОС'], -- the obsidian sanctum
    [19] = L['РС'], -- the ruby sanctum
    [20] = L['ИК'], -- trail of the crusader
    [21] = L['Ульд'], -- ulduar
    [22] = L['СА'], -- vault of archavon
    [23] = L['КБар'], -- baradin hold
    [24] = L['ТКТ'], -- blackwing descent
    [25] = L['ДД'], -- dragon soul
    [26] = L['ОП'], -- firelands
    [27] = L['СБ'], -- the bastion of twilight
    [28] = L['ТЧВ'], -- throne of the four winds
    [29] = L['СС'], -- heart of fear
    [30] = L['ПМ'], -- mogu'shan vaults
    [31] = L['ОО'], -- siege of orgrimmar
    [32] = L['ТВВ'], -- terrace of endless spring
    [33] = L['ПГ'], -- throne of thunder
    [63] = L['Босс'] -- world boss
}

OQ.raid_bosses = {
    [1] = {
        [1] = L['The Prophet Skeram'],
        [2] = L['Silithid Royalty'],
        [3] = L['Battlegaurd Sartura'],
        [4] = L['Fankriss the Unyielding'],
        [5] = L['Viscidus'],
        [6] = L['Princess Huhuran'],
        [7] = L['Twin Emperors'],
        [8] = L['Ouro'],
        [9] = L["C'Thun"]
    },
    [2] = {
        [1] = L['Razorgore the Untamed'],
        [2] = L['Vaelastrasz the Corrupt'],
        [3] = L['Broodlord Lashlayer'],
        [4] = L['Firemaw'],
        [5] = L['Ebonroc'],
        [6] = L['Flamegor'],
        [7] = L['Chromaggus'],
        [8] = L['Nefarian']
    },
    [3] = {
        [1] = L['Lucifron'],
        [2] = L['Magmadar'],
        [3] = L['Gehennas'],
        [4] = L['Garr'],
        [5] = L['Shazzrah'],
        [6] = L['Baron Geddon'],
        [7] = L['Sulfron Harbinger'],
        [8] = L['Golemagg the Incinerator'],
        [9] = L['Majordomo Executus'],
        [10] = L['Ragnaros']
    },
    [4] = {
        [1] = L['Onyxia']
    },
    [5] = {
        [1] = L['Kurinnaxx'],
        [2] = L['General Rajaxx'],
        [3] = L['Moam'],
        [4] = L['Buru the Gorger'],
        [5] = L['Ayamiss the Hunter'],
        [6] = L['Ossirian the Unscarred']
    },
    [6] = {
        [1] = L["High Warlord Naj'entus"],
        [2] = L['Supremus'],
        [3] = L['Shade of Akama'],
        [4] = L['Teron Gorefiend'],
        [5] = L['Gurtogg Bloodboil'],
        [6] = L['Reliquary of Souls'],
        [7] = L['Mother of Shahraz'],
        [8] = L['The Illidari Council'],
        [9] = L['Illidan Stormrage']
    },
    [7] = {
        [1] = L['High King Maulgar'],
        [2] = L['Gruul the Dragonkiller']
    },
    [8] = {
        [1] = L['Attumen the Huntsman'],
        [2] = L['Moroes'],
        [3] = L['Maiden of Virtue'],
        [4] = L['Opera Event'],
        [5] = L['The Curator'],
        [6] = L['Chess Event'],
        [7] = L['Terestian Illhoof'],
        [8] = L['Shade of Aran'],
        [9] = L['Netherspite'],
        [10] = L['Prince Malchezaar'],
        [11] = L['Nightbane']
    },
    [9] = {
        [1] = L['Magtheridon']
    },
    [10] = {
        [1] = L['Hydross the Unstable'],
        [2] = L['The Lurker Below'],
        [3] = L['Leotheras the Blind'],
        [4] = L['Fathom-Lord Karathress'],
        [5] = L['Morogrim Tidewalker'],
        [6] = L['Lady Vashj']
    },
    [11] = {
        [1] = L["Al'ar"],
        [2] = L['Void Reaver'],
        [3] = L['High Astromancer Solarian'],
        [4] = L["Kael'thas Sunstrider"]
    },
    [12] = {
        [1] = L['Rage Winterchill'],
        [2] = L['Anetheron'],
        [3] = L["Kaz'rogal"],
        [4] = L['Azgalor'],
        [5] = L['Archimonde']
    },
    [13] = {
        [1] = L['Kalecgos'],
        [2] = L['Brutallus'],
        [3] = L['Felmyst'],
        [4] = L['Eredar Twins'],
        [5] = L["M'uru"],
        [6] = L["Kil'jaeden"]
    },
    [14] = {
        [1] = L['Lord Marrowgar'],
        [2] = L['Lady Deathwhisper'],
        [3] = L['Icecrown Gunship Battle'],
        [4] = L['Deathbringer Saurfang'],
        [5] = L['Rotface'],
        [6] = L['Festergut'],
        [7] = L['Professor Putricide'],
        [8] = L['Blood Council'],
        [9] = L["Queen Lana'thel"],
        [10] = L['Valithria Dreamwalker'],
        [11] = L['Sindragosa'],
        [12] = L['The Lich King']
    },
    [15] = {
        [1] = L["Anub'Rekhan"],
        [2] = L['Grand Widow Faerlina'],
        [3] = L['Maexxna'],
        [4] = L['Noth the Plaguebringer'],
        [5] = L['Heigan the Unclean'],
        [6] = L['Loatheb'],
        [7] = L['Instructor Razuvious'],
        [8] = L['Gothik the Harvester'],
        [9] = L['The Four Horsemen'],
        [10] = L['Patchwerk'],
        [11] = L['Grobbulus'],
        [12] = L['Gluth'],
        [13] = L['Thaddius'],
        [14] = L['Sapphiron'],
        [15] = L["Kel'Thuzad"]
    },
    [16] = {
        [1] = L['Onyxia']
    },
    [17] = {
        [1] = L['Malygos']
    },
    [18] = {
        [1] = L['Sartharion']
    },
    [19] = {
        [1] = L['Halion']
    },
    [20] = {
        [1] = L['Northrend Beasts'],
        [2] = L['Lord Jaraxxus'],
        [3] = L['Faction Champions'],
        [4] = L["Val'kyr Twins"],
        [5] = L["Anub'arak"]
    },
    [21] = {
        [1] = L['Flame Leviathan'],
        [2] = L['Ignis the Furnance Master'],
        [3] = L['Razorscale'],
        [4] = L['XT-002 Deconstructor'],
        [5] = L['Assembly of Iron'],
        [6] = L['Kologarn'],
        [7] = L['Auriaya'],
        [8] = L['Freya'],
        [9] = L['Hodir'],
        [10] = L['Mimiron'],
        [11] = L['Thorim'],
        [12] = L['General Vezax'],
        [13] = L['Yogg-Saron'],
        [14] = L['Algalon the Observer']
    },
    [22] = {
        [1] = L['Archavon the Stone Watcher'],
        [2] = L['Emalon the Storm Watcher'],
        [3] = L['Koralon the Flame Watcher'],
        [4] = L['Toravon the Ice Watcher']
    },
    [23] = {
        [1] = L['Argaloth'],
        [2] = L["Occu'thar"],
        [3] = L['Alizabal']
    },
    [24] = {
        [1] = L['Magmaw'],
        [2] = L['Omnotron Defense System'],
        [3] = L['Maloriak'],
        [4] = L['Atramedes'],
        [5] = L['Chimaeron'],
        [6] = L['Nefarian']
    },
    [25] = {
        [1] = L['Morchok'],
        [2] = L["Warlord Zon'ozz"],
        [3] = L["Yor'sahj the Unsleeping"],
        [4] = L['Hagara the Stormbinder'],
        [5] = L['Ultraxion'],
        [6] = L['Warmaster Blackhorn'],
        [7] = L['Spine of Deathwing'],
        [8] = L['Madness of Deathwing']
    },
    [26] = {
        [1] = L['Shannox'],
        [2] = L['Lord Rhyolith'],
        [3] = L["Beth'tilac"],
        [4] = L['Alysrazor'],
        [5] = L['Baleroc'],
        [6] = L['Majordomo Staghelm'],
        [7] = L['Ragnaros']
    },
    [27] = {
        [1] = L['Halfus Wyrmbreaker'],
        [2] = L['Theralion and Valiona'],
        [3] = L['Ascendant Council'],
        [4] = L["Cho'gall"],
        [5] = L['Sinestra']
    },
    [28] = {
        [1] = L['Conclave of Wind'],
        [2] = L["Al'Akir"]
    },
    [29] = {
        [1] = L["Impreial Vizier Zor'lok"],
        [2] = L["Blade Lord Ta'yak"],
        [3] = L['Garalon'],
        [4] = L["Wind Lord Mel'jarak"],
        [5] = L["Amber-Shaper Un'sok"],
        [6] = L["Grand Empress Shek'zeer"]
    },
    [30] = {
        [1] = L['The Stone Guard'],
        [2] = L['Feng the Accursed'],
        [3] = L["Gara'jal the Spiritbinder"],
        [4] = L['The Spirit Kings'],
        [5] = L['Elegon'],
        [6] = L['Will of the Emperor']
    },
    [31] = {
        [1] = L['Immerseus'],
        [2] = L['The Fallen Protectors'],
        [3] = L['Norushen'],
        [4] = L['Sha of Pride'],
        [5] = L['Galakras'],
        [6] = L['Iron Juggernaut'],
        [7] = L["Kor'kron Dark Shaman"],
        [8] = L['General Nazgrim'],
        [9] = L['Malkorok'],
        [10] = L['Spoils of Pandaria'],
        [11] = L['Thok the Bloodthirsty'],
        [12] = L['Siegecrafter Blackfuse'],
        [13] = L['Paragons of the Klaxxi'],
        [14] = L['Garrosh Hellscream']
    },
    [32] = {
        [1] = L['Protectors of the Endless'],
        [2] = L['Tsulong'],
        [3] = L['Lei Shi'],
        [4] = L['Sha of Fear']
    },
    [33] = {
        [1] = L["Jin'rokh the Breaker"],
        [2] = L['Horridon'],
        [3] = L['Council of Elders'],
        [4] = L['Tortos'],
        [5] = L['Megaera'],
        [6] = L['Ji-Kun'],
        [7] = L['Durumu the Forgotten'],
        [8] = L['Primordius'],
        [9] = L['Dark Animus'],
        [10] = L['Iron Qon'],
        [11] = L['Twin Consorts'],
        [12] = L['Lei Shen'],
        [13] = L['Ra-den']
    },
    [63] = {
        [1] = L['Omen'],
        [2] = L['Galleon'],
        [3] = L['Sha of Anger'],
        [4] = L['Nalak'],
        [5] = L['Oondasta'],
        [6] = L['Chi-Ji'],
        [7] = L['Xuen'],
        [8] = L['Niuzao'],
        [9] = L["Yu'lon"],
        [10] = L['Ordos']
    }
}

OQ.boss_nicknames = {
    [L['The Prophet Skeram']] = L['The Prophet'],
    [L['Silithid Royalty']] = L['Royalty'],
    [L['Battlegaurd Sartura']] = L['Sartura'],
    [L['Fankriss the Unyielding']] = L['Fankriss'],
    [L['Princess Huhuran']] = L['Huhuran'],
    [L['Twin Emperors']] = L['Twins'],
    [L['Razorgore the Untamed']] = L['Razorgore'],
    [L['Vaelastrasz the Corrupt']] = L['Vaelastrasz'],
    [L['Broodlord Lashlayer']] = L['Lashlayer'],
    [L['Baron Geddon']] = L['Geddon'],
    [L['Sulfron Harbinger']] = L['Sulfron'],
    [L['Golemagg the Incinerator']] = L['Golemagg'],
    [L['Majordomo Executus']] = L['Executus'],
    [L['General Rajaxx']] = L['Rajaxx'],
    [L['Buru the Gorger']] = L['Buru'],
    [L['Ayamiss the Hunter']] = L['Ayamiss'],
    [L['Ossirian the Unscarred']] = L['Ossirian'],
    [L["High Warlord Naj'entus"]] = L["Naj'entus"],
    [L['Shade of Akama']] = L['Akama'],
    [L['Teron Gorefiend']] = L['Teron'],
    [L['Gurtogg Bloodboil']] = L['Gurtogg'],
    [L['Reliquary of Souls']] = L['Reliquary'],
    [L['Mother of Shahraz']] = L['Shahraz'],
    [L['The Illidari Council']] = L['Council'],
    [L['Illidan Stormrage']] = L['Illidan'],
    [L['High King Maulgar']] = L['Maulgar'],
    [L['Gruul the Dragonkiller']] = L['Gruul'],
    [L['Attumen the Huntsman']] = L['Huntsman'],
    [L['Maiden of Virtue']] = L['Maiden'],
    [L['Terestian Illhoof']] = L['Illhoof'],
    [L['Prince Malchezaar']] = L['Malchezaar'],
    [L['Hydross the Unstable']] = L['Hydross'],
    [L['The Lurker Below']] = L['Lurker'],
    [L['Leotheras the Blind']] = L['Leotheras'],
    [L['Fathom-Lord Karathress']] = L['Karathress'],
    [L['Morogrim Tidewalker']] = L['Morogrim'],
    [L['High Astromancer Solarian']] = L['Solarian'],
    [L["Kael'thas Sunstrider"]] = L["Kael'thas"],
    [L['Rage Winterchill']] = L['Winterchill'],
    [L['Lord Marrowgar']] = L['Marrowgar'],
    [L['Lady Deathwhisper']] = L['Deathwhisper'],
    [L['Icecrown Gunship']] = L['Gunship'],
    [L['Deathbringer Saurfang']] = L['Saurfang'],
    [L['Professor Putricide']] = L['Putricide'],
    [L['Blood Prince Council']] = L['Council'],
    [L["Queen Lana'thel"]] = L["Lana'thel"],
    [L["Blood-Queen Lana'thel"]] = L["Lana'thel"],
    [L['Valithria Dreamwalker']] = L['Valithria'],
    [L['The Lich King']] = L['Lich King'],
    [L['Grand Widow Faerlina']] = L['Faerlina'],
    [L['Noth the Plaguebringer']] = L['Noth'],
    [L['Heigan the Unclean']] = L['Heigan'],
    [L['Instructor Razuvious']] = L['Razuvious'],
    [L['Gothik the Harvester']] = L['Gothik'],
    [L['The Four Horsemen']] = L['Horsemen'],
    [L['Northrend Beasts']] = L['Beasts'],
    [L['Faction Champions']] = L['Champions'],
    [L['Flame Leviathan']] = L['Leviathan'],
    [L['Ignis the Furnance Master']] = L['Ignis'],
    [L['XT-002 Deconstructor']] = L['XT-002'],
    [L['Algalon the Observer']] = L['Algalon'],
    [L['Archavon the Stone Watcher']] = L['Archavon'],
    [L['Emalon the Storm Watcher']] = L['Emalon'],
    [L['Koralon the Flame Watcher']] = L['Koralon'],
    [L['Toravon the Ice Watcher']] = L['Toravon'],
    [L['Omnotron Defense System']] = L['Omnotron'],
    [L["Yor'sahj the Unsleeping"]] = L["Yor'sahj"],
    [L['Hagara the Stormbinder']] = L['Hagara'],
    [L['Warmaster Blackhorn']] = L['Warmaster'],
    [L['Spine of Deathwing']] = L['Spine'],
    [L['Madness of Deathwing']] = L['Madness'],
    [L['Majordomo Staghelm']] = L['Staghelm'],
    [L['Halfus Wyrmbreaker']] = L['Halfus'],
    [L['Theralion and Valiona']] = L['Theralion'],
    [L['Ascendant Council']] = L['Council'],
    [L["Grand Empress Shek'zeer"]] = L["Shek'zeer"],
    [L["Amber-Shaper Un'sok"]] = L["Un'sok"],
    [L["Wind Lord Mel'jarak"]] = L["Mel'jarak"],
    [L["Blade Lord Ta'yak"]] = L["Ta'yak"],
    [L["Impreial Vizier Zor'lok"]] = L["Zor'lok"],
    [L['Feng the Accursed']] = L['Feng'],
    [L["Gara'jal the Spiritbinder"]] = L["Gara'jal"],
    [L['Will of the Emperor']] = L['Emperor'],
    [L['The Fallen Protectors']] = L['Protectors'],
    [L["Kor'kron Dark Shaman"]] = L["Kor'kron"],
    [L['General Nazgrim']] = L['Nazgrim'],
    [L['Spoils of Pandaria']] = L['Spoils'],
    [L['Thok the Bloodthirsty']] = L['Thok'],
    [L['Siegecrafter Blackfuse']] = L['Blackfuse'],
    [L['Paragons of the Klaxxi']] = L['Paragons'],
    [L['Garrosh Hellscream']] = L['Garrosh'],
    [L['Protectors of the Endless']] = L['Protectors'],
    [L["Jin'rokh the Breaker"]] = L["Jin'rokh"],
    [L['Council of Elders']] = L['Council'],
    [L['Durumu the Forgotten']] = L['Durumu'],
    [L['Twin Consorts']] = L['Twins']
}

OQ.lieutenants = {
    [L['Prince Valanar']] = L['Blood Council'],
    [L['Prince Taldaram']] = L['Blood Council'],
    [L['Prince Keleseth']] = L['Blood Council'],
    [L["Blood-Queen Lana'thel"]] = L["Queen Lana'thel"],
    [L["Orgrim's Hammer"]] = L['Icecrown Gunship Battle'],
    [L['The Skybreaker']] = L['Icecrown Gunship Battle']
    --                   [L[""]] = L[""],
}

--
L[' Please set your battle-tag before using oQueue.'] =
    'Пожалуйста, создайте Battle Tag прежде чем использовать oQueue.'
L[' Your battle-tag can only be set via your WoW account page.'] =
    'Ваш Battle Tag может быть создан только на странице аккаунта.'
L["NOTICE:  You've exceeded the cap before the cap(%s).  removed: %s"] =
    'НАПОМИНАНИЕ: Вы превысили максимально возможное кол-во(%s). Удаление: %s'
L['WARNING:  Your battle.net friends list has %s friends.'] =
    'ВНИМАНИЕ: Ваш список друзей Battle.net содержит %s друзей.'
L["WARNING:  You've exceeded the cap before the cap(%s)"] = 'ВНИМАНИЕ: Вы превысили максимально возможное кол-во(%s).'
L['WARNING:  No mesh nodes available for removal.  Please trim your b.net friends list'] =
    'Нет доступных узлов связи для удаления. Проверьте список друзей Battle.net.'
L['Found oQ banned b.tag on your friends list.  removing: %s'] =
    'В вашем списке друзей найден заблокированный Battle Tag. Удаление: %s'

L['Premade type'] = 'Тип премейда'
L['Sub type'] = 'Подтип'
L['VoIP'] = 'Связь'
L['Language'] = 'Язык'
L['Role'] = 'Роль'
L['Classes'] = 'Классы'
L['All'] = 'все'
L['None'] = 'никто'
L['offline'] = 'не в сети'
L["find-mesh response recv'd"] = 'Получен ответ поиска связей'
L['Notes:'] = 'Заметка:'
L['< general >'] = '< общий >'
L['< world boss >'] = '< мировой босс >'
L['no karma sent'] = 'Репутация не отправлена'
L['%d dot of karma sent'] = '%d репутации отправлено'
L['%d dots of karma sent'] = '%d репутации отправлено'
L['Loot method has changed.'] = 'Метод добычи изменился'
L['Do you accept the new loot method?'] = 'Вы подтверждаете новый метод добычи?'
L['accept'] = 'Да'
L['do not accept'] = 'Нет'
L['reject and leave'] = 'Отклонить и выйти'
L['I accept loot method'] = 'Я подтвердил метод добычи'
L['Loot method unacceptable'] = 'Я не принял метод добычи'
L["I'm leaving due to loot method"] = 'Я ухожу из-за такого метода добычи'
L['** PAUSED **'] = '** ПАУЗА **'
