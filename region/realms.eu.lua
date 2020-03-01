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
print(GetCVar("realmList"));
OQ.REGION   = "hu" ;
OQ.SK_BTAG  = "OQSK#2404" ;
OQ.SK_NAME  = "Scorekeeper" ;
OQ.SK_REALM = "[EN] Evermoon" ;
OQ.DEFAULT_PREMADE_TEXT = "teamspeak:  ts.overheatedpenguins.com" ;

OQ.BGROUP_ICON = {["Misery"] = "Interface\\Icons\\Spell_Shadow_Misery"};

OQ.REALMNAMES_SPECIAL = { 
  ["[EN] Evermoon (5.4.8)"] = "[EN] Evermoon (5.4.8)",
  ["[HU] Tauri WoW Server"] = "[HU] Tauri WoW Server",
  ["[HU] Warriors of Darkness"] = "[HU] Warriors of Darkness"
} ;

OQ.BGROUPS = {};


OQ.SHORT_BGROUPS = {
  ["[EN] Evermoon (5.4.8)"] = "[EN] Evermoon (5.4.8)",
  ["[HU] Tauri WoW Server"] = "[HU] Tauri WoW Server",
  ["[HU] Warriors of Darkness"] = "[HU] Warriors of Darkness"
};

OQ.gbl = {} ;
end
