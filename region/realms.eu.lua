--[[ 
  @file       realms.eu.lua
  @brief      realm list for region: eu

  @author     rmcinnis
  @date       november 26, 2012
  @par        copyright (c) 2012 Solid ICE Technologies, Inc.  All rights reserved.
              this file may be distributed so long as it remains unaltered
              if this file is posted to a web site, credit must be given to me along with a link to my web page
              no code in this file may be used in other works without expressed permission  
]]--
local addonName, OQ = ... ;

if (string.sub(GetCVar("realmList"),1,2) == "hu") then
 
OQ.REGION   = "hu";
OQ.SK_BTAG  = "Maczuga";
OQ.SK_NAME  = "Maczuga";
OQ.SK_REALM = "[EN] Evermoon";
OQ.DEFAULT_PREMADE_TEXT = "" ;

OQ.BGROUP_ICON = {["Tauri Cross Realm"] = "Interface\\Icons\\Spell_Shadow_Misery"};

OQ.REALMNAMES_SPECIAL = {
} ;

OQ.BGROUPS = {
  ["Tauri Cross Realm"] = {
    "[EN] Evermoon",
    "[HU] Tauri WoW Server",
    "[HU] Warriors of Darkness",
  },
} ;

OQ.SHORT_BGROUPS = {
	["[EN] Evermoon"] = 1, -- [1]
	["[HU] Tauri WoW Server"] = 2, -- [2]
  ["[HU] Warriors of Darkness"] = 3, -- [3]

  [1] = "[EN] Evermoon",
  [2] = "[HU] Tauri WoW Server",
  [3] = "[HU] Warriors of Darkness",
} ;


OQ.gbl = {};
end
