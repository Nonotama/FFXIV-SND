--[[
********************************************************************************
*                             Wondrous Tails Doer                              *
*                                Version 0.1.0                                 *
********************************************************************************

Created by: pot0to (https://ko-fi.com/pot0to)

Description: Picks up a Wondrous Tails journal from Khloe, then attempts each duty

For dungeons:
- Attempts dungeon Unsynced if duty is at least 20 levels below you
- Attempts dungeon with Duty Support if duty is within 20 levels of you and Duty
Support is available

For EX Trials:
- Attempts any duty unsynced if it is 20 levels below you
- Note: Not all EX trials have BossMod support, but this script will attempt
each one once anyways
- Some EX trials are blacklisted due to mechanics that cannot be done solo
(Byakko tank buster, Tsukuyomi meteors, etc.)

Alliance Raids/PVP/Treasure Maps/Palace of the Dead
- Skips them all

********************************************************************************
*                               Required Plugins                               *
********************************************************************************
1. Autoduty
2. Rotation Solver Reborn
3. BossModReborn (BMR) or Veyn's BossMod (VBM)
]]

-- Region: Data ---------------------------------------------------------------------------------

WonderousTailsDuties = {
    { -- type 0:É trials
        { instanceId=20010, dutyId=297, dutyName="ÉK[_¢Åí", minLevel=50 },
        { instanceId=20009, dutyId=296, dutyName="É^C^¢Åí", minLevel=50 },
        { instanceId=20008, dutyId=295, dutyName="ÉCt[g¢Åí", minLevel=50 },
        { instanceId=20012, dutyId=364, dutyName="É¤OEOXII¢¢Åí", minLevel=50 },
        { instanceId=20018, dutyId=359, dutyName="É@CAT¢Åí", minLevel=50 },
        { instanceId=20023, dutyId=375, dutyName="ÉE¢Åí", minLevel=50 },
        { instanceId=20025, dutyId=378, dutyName="ÉV@¢Åí", minLevel=50 },
        { instanceId=20013, dutyId=348, dutyName="É¶z Ae}EF|jóìí", minLevel=50 },
        { instanceId=20034, dutyId=447, dutyName="ÉrX}N¢Åí", minLevel=60 },
        { instanceId=20032, dutyId=446, dutyName="É[@i¢Åí", minLevel=60 },
        { instanceId=20036, dutyId=448, dutyName="V¶z iCcEIuEEh¢Åí", minLevel=60 },
        { instanceId=20038, dutyId=524, dutyName="É_ZtBg¢Åí", minLevel=60 },
        { instanceId=20040, dutyId=566, dutyName="Éj[YwbOª³í", minLevel=60 },
        { instanceId=20042, dutyId=577, dutyName="É_\tBA¢Åí", minLevel=60 },
        { instanceId=20044, dutyId=638, dutyName="ÉS_Y[¢Åí", minLevel=60 },
        { instanceId=20049, dutyId=720, dutyName="ÉNV~¢Åí", minLevel=70 },
        { instanceId=20056, dutyId=779, dutyName="ÉcN~¢Åí", minLevel=70 },
        { instanceId=20058, dutyId=811, dutyName="Ééª°í", minLevel=70 },
        { instanceId=20054, dutyId=762, dutyName="ÉIEXëÂí", minLevel=70 },
        { instanceId=20061, dutyId=825, dutyName="ÉÉÂ´ª°í", minLevel=70 },
        { instanceId=20063, dutyId=858, dutyName="ÉeB^[jA¢Åí", minLevel=80 },
        { instanceId=20065, dutyId=848, dutyName="ÉCmZX¢Åí", minLevel=80 },
        { instanceId=20067, dutyId=885, dutyName="Én[fX¢Åí", minLevel=80 },
        { instanceId=20069, dutyId=912, dutyName="Ér[EF|jóìí", minLevel=80 },
        { instanceId=20070, dutyId=913, dutyName="ÉV^fE{YÇ¯í", minLevel=80 },
        { instanceId=20072, dutyId=923, dutyName="ÉEH[CAEIuECg¢Åí", minLevel=80 },
        { instanceId=20074, dutyId=935, dutyName="ÉGhEF|jóìí", minLevel=80 },
        { instanceId=20076, dutyId=951, dutyName="É_CEF|jóìí", minLevel=80 },
        { instanceId=20078, dutyId=996, dutyName="ÉnCf¢Åí", minLevel=90 },
        { instanceId=20081, dutyId=993, dutyName="É]fBA[N¢Åí", minLevel=90 },
        { instanceId=20083, dutyId=998, dutyName="IÉÌí¢", minLevel=90 },
        { instanceId=20085, dutyId=1072, dutyName="ÉooVA¢Åí", minLevel=90 },
        { instanceId=20087, dutyId=1096, dutyName="ÉrJe¢Åí", minLevel=90 },
        { instanceId=20090, dutyId=1141, dutyName="ÉSx[U¢Åí", minLevel=90 },
        { instanceId=20092, dutyId=1169, dutyName="É[X¢Åí", minLevel=90 }
    },
    1,
    2,
    { -- type 3: special content
        -- { dutyName="Deep Dungeons" }
    },
    { -- type 4: raids
        { dutyName="åÀ{on[gFç®çÒ1", dutyId=241, minLevel=50 },
        { dutyName="åÀ{on[gFNUÒ1", dutyId=355, minLevel=50 },
        { dutyName="åÀ{on[gF^¬Ò1", dutyId=193, minLevel=50 },
        { dutyName="@HéALT_[FN®Ò1", dutyId=442, minLevel=60 },
        { dutyName="@HéALT_[F¥®Ò1", dutyId=520, minLevel=60 },
        { dutyName="@HéALT_[FV¹Ò1", dutyId=580, minLevel=60 },
        { dutyName="³Ì·ÔIKFf^Ò1", dutyId=693, minLevel=70 },
        { dutyName="³Ì·ÔIKFVO}Ò1", dutyId=748, minLevel=70 },
        { dutyName="³Ì·ÔIKFIKÒ1", dutyId=798, minLevel=70 },
        { dutyName="ó]ÌGfFoÁÒ1", dutyId=849, minLevel=80 },
        { dutyName="ó]ÌGfF¤ÂÒ1", dutyId=903, minLevel=80 },
        { dutyName="ó]ÌGfFÄ¶Ò1", dutyId=942, minLevel=80 }
    },
    { -- type 5: leveling dungeons
        { dutyName="xO_W Lv1-49", dutyId=172 }, --The Aurum Vale
        { dutyName="xO_W Lv51-79", dutyId=434 }, --The Dusk Vigil
        { dutyName="xO_W Lv81-99", dutyId=952 } --The Tower of Zot
    },
    { -- type 6: expansion cap dungeons
        { dutyName="nCxO_W Lv50-60", dutyId=362 }, --Brayflox Longstop (Hard)
        { dutyName="nCxO_W Lv70-80", dutyId=1146 }, --Ala Mhigo
        { dutyName="nCxO_W Lv90", dutyId=973 } --The Dead Ends
    },
    Blacklisted= {
        {
            { instanceId=20052, dutyId=758, dutyName="ÉÕª°í", minLevel=70 }, -- cannot solo double tankbuster vuln
            { instanceId=20047, dutyId=677, dutyName="ÉXTmI¢Åí", minLevel=70 }, -- cannot solo active time maneuver
            { instanceId=20056, dutyId=779, dutyName="ÉcN~¢Åí", minLevel=70 } -- cannot solo meteors
        },
        {},
        {},
        {
            { dutyName="Treasure Dungeons" }
        },
        {
            { dutyName="ACAXChiV¶GI[Aj", dutyId=174 },
            { dutyName="ACAXChiVÌCVKhj", dutyId=508 },
            { dutyName="ACAXChig@Ìx[^[j", dutyId=734 },
            { dutyName="ACAXChi½ÌBYj", dutyId=882 },
            { dutyName="ACAXChiÅÌtBi[j", dutyId=1054 },
            { dutyName="apfjEFÓÒ1-4", dutyId=1002 },
            { dutyName="apfjEFùÒ1-4", dutyId=1081 },
            { dutyName="apfjEFVÒ1-4", dutyId=1147 },
            { dutyName="VÌÀAJfBAFCgwr[1-2", dutyId=1125 },
            { dutyName="VÌÀAJfBAFCgwr[3-4", dutyId=1231 }
        }
    }
}

Khloe = {
    x = -19.346453,
    y = 210.99998,
    z = 0.086749226,
    name = "NEAA|["
}

-- Region: Functions ---------------------------------------------------------------------------------

function SearchWonderousTailsTable(type, data, text)
    if type == 0 then -- trials are indexed by instance#
        for _, duty in ipairs(WonderousTailsDuties[type+1]) do
            if duty.instanceId == data then
                return duty
            end
        end
    elseif type == 5 then
        for _, duty in ipairs(WonderousTailsDuties[type+1]) do
            if duty.dutyName == text then
                duty.minLevel = data
                return duty
            end
        end
    elseif type == 6 then
        for _, duty in ipairs(WonderousTailsDuties[type+1]) do
            if duty.dutyName == text then
                duty.minLevel = data - 9
                return duty
            end
        end
    elseif type == 3 or type == 4 then
        for _, duty in ipairs(WonderousTailsDuties[type+1]) do
            if duty.dutyName == text then
                return duty
            end
        end
    end
end

-- Region: Main ---------------------------------------------------------------------------------

CurrentLevel = GetLevel()

-- Pick up a journal if you need one
if not HasWeeklyBingoJournal() or IsWeeklyBingoExpired() or WeeklyBingoNumPlacedStickers() == 9 then
    if not IsInZone(478) then
        yield("/tp CfBVCA")
        yield("/wait 1")
    end
    while not (IsInZone(478) and IsPlayerAvailable()) do
        yield("/wait 1")
    end
    PathfindAndMoveTo(Khloe.x, Khloe.y, Khloe.z)
    while(GetDistanceToPoint(Khloe.x, Khloe.y, Khloe.z) > 5) do
        yield("/wait 1")
    end
    yield("/target "..Khloe.name)
    yield("/wait 1")
    yield("/interact")
    while not IsAddonVisible("SelectString") do
        yield("/click Talk Click")
        yield("/wait 1")
    end
    if IsAddonVisible("SelectString") then
        if not HasWeeklyBingoJournal() then
            yield("/callback SelectString true 0")
        elseif IsWeeklyBingoExpired() then
            yield("/callback SelectString true 1")
        elseif WeeklyBingoNumPlacedStickers() == 9 then
            yield("/callback SelectString true 0")
        end
        
    end
    while GetCharacterCondition(32) do
        yield("/click Talk Click")
        yield("/wait 1")
    end
    yield("/wait 1")
end

-- skip 13: Shadowbringers raids (not doable solo unsynced)
-- skip 14: Endwalker raids (not doable solo unsynced)
-- skip 15: PVP
for i = 0, 12 do
    if GetWeeklyBingoTaskStatus(i) == 0 then
        local key = GetWeeklyBingoOrderDataKey(i)
        local type = GetWeeklyBingoOrderDataType(key)
        local data = GetWeeklyBingoOrderDataData(key)
        local text = GetWeeklyBingoOrderDataText(key)
        LogInfo("[WonderousTails] Wonderous Tails #"..(i+1).." Key: "..key)
        LogInfo("[WonderousTails] Wonderous Tails #"..(i+1).." Type: "..type)
        LogInfo("[WonderousTails] Wonderous Tails #"..(i+1).." Data: "..data)
        LogInfo("[WonderousTails] Wonderous Tails #"..(i+1).." Text: "..text)

        local duty = SearchWonderousTailsTable(type, data, text)
        if duty == nil then
            yield("/echo duty is nil")
        end
        local dutyMode = "Support"
        if duty ~= nil then
            if CurrentLevel < duty.minLevel then
                yield("/echo [WonderousTails] Cannot queue for "..duty.dutyName.." as level is too low.")
                duty.dutyId = nil
            elseif type == 0 then -- trials
                yield("/autoduty cfg Unsynced true")
                dutyMode = "Trial"
            elseif type == 4 then -- raids
                yield("/autoduty cfg Unsynced true")
                dutyMode = "Raid"
            elseif CurrentLevel - duty.minLevel <= 20 then
                -- yield("/autoduty cfg dutyModeEnum 1") -- TODO: test this when it gets released
                -- yield("/autoduty cfg Unsynced false")
                dutyMode = "Support"
            else
                -- yield("/autoduty cfg dutyModeEnum 8")
                yield("/autoduty cfg Unsynced true")
                dutyMode = "Regular"
            end

            if duty.dutyId ~= nil then
                yield("/echo Queuing duty TerritoryId#"..duty.dutyId.." for Wonderous Tails #"..(i+1))
                yield("/autoduty run "..dutyMode.." "..duty.dutyId.." 1 true")
                yield("/bmrai on")
                yield("/rotation auto")
                yield("/wait 10")
                while GetCharacterCondition(34) or GetCharacterCondition(51) or GetCharacterCondition(56) do -- wait for duty to be finished
                    if GetCharacterCondition(2) and i > 4 then -- dead, not a dungeon
                        yield("/echo Died to "..duty.dutyName..". Skipping.")
                        repeat
                            yield("/wait 1")
                        until not GetCharacterCondition(2)
                        LeaveDuty()
                        break
                    end
                    yield("/wait 1")
                end
                yield("/wait 10")
            else
                if duty.dutyName ~= nil then
                    yield("/echo Wonderous Tails Script does not support Wonderous Tails entry #"..(i+1).." "..duty.dutyName)
                    LogInfo("[WonderousTails] Wonderous Tails Script does not support Wonderous Tails entry #"..(i+1).." "..duty.dutyName)
                else
                    yield("/echo Wonderous Tails Script does not support Wonderous Tails entry #"..(i+1))
                    LogInfo("[WonderousTails] Wonderous Tails Script does not support Wonderous Tails entry #"..(i+1))
                end
            end
        end
    end

    -- if GetWeeklyBingoTaskStatus(i) == 1
    --    and (not StopPlacingStickersAt7 or WeeklyBingoNumPlacedStickers() < 7)
    -- then
    --     if not IsAddonVisible("WeeklyBingo") then
    --         yield("/callback WeeklyBingo true 2 "..i)
    --         yield("/wait 1")
    --     end
    -- end
end

yield("/echo Completed all Wonderous Tails entries it is capable of.<se.3>")