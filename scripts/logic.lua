require("scripts/countPokos")

EntranceTable = {
  ["unknown"] = 0,
  ["EC"] = 1,
  ["SC"] = 2,
  ["FC"] = 3,
  ["HoB"] = 4,
  ["WFG"] = 5,
  ["BK"] = 6,
  ["SH"] = 7,
  ["CoS"] = 8,
  ["GK"] = 9,
  ["SR"] = 10,
  ["SMGC"] = 11,
  ["CoC"] = 12,
  ["HoH"] = 13,
  ["DD"] = 14
}

function Has(item)
  local item_map = {
    ["RP"] = "redonion",
    ["YP"] = "yellowonion",
    ["BP"] = "blueonion",
    ["PP"] = "purpleonion",
    ["WP"] = "whiteonion",

    ["W2"] = "sphericalatlas",
    ["W3"] = "geographicprojection",
    ["W4"] = "debt",

    ["NS"] = "five-mannapsack",
    ["RA"] = "repugnant_appendage"
  }

  if item == "W4" then
    return DebtPayedOff()
  elseif item == "WP" then
    return Tracker:FindObjectForCode("whiteonion").Active or Has("W2")
  elseif item_map[item] ~= nil then
    return Tracker:FindObjectForCode(item_map[item]).Active
  end
end

function HasKey(key)
  local key_map = {
    ["EC"] = "ecentrancekey",
    ["SC"] = "scentrancekey",
    ["FC"] = "fcentrancekey",
    ["HoB"] = "hobentrancekey",
    ["WFG"] = "wfgentrancekey",
    ["BK"] = "bkentrancekey",
    ["SH"] = "shentrancekey",
    ["CoS"] = "cosentrancekey",
    ["GK"] = "gkentrancekey",
    ["SR"] = "srentrancekey",
    ["SMGC"] = "smgcentrancekey",
    ["CoC"] = "cocentrancekey",
    ["HoH"] = "hohentrancekey",
    ["DD"] = "ddentrancekey",
  }

  if key_map[key] ~= nil then
    return Tracker:FindObjectForCode(key_map[key]).Active
  end
end

function NotHasKey(key)
  return not HasKey(key)
end

function SB()
  return AccessibilityLevel.SequenceBreak
end

function DebtPayedOff()
  local pokos = 0
  pokos = pokos + Tracker:FindObjectForCode("pokos_tenthousand").CurrentStage * 10000
  pokos = pokos + Tracker:FindObjectForCode("pokos_thousand").CurrentStage * 1000
  pokos = pokos + Tracker:FindObjectForCode("pokos_hundred").CurrentStage * 100
  pokos = pokos + Tracker:FindObjectForCode("pokos_ten").CurrentStage * 10
  pokos = pokos + Tracker:FindObjectForCode("pokos_one").CurrentStage * 1
  local debt = 0
  debt = debt + Tracker:FindObjectForCode("debt_tenthousand").CurrentStage * 10000
  debt = debt + Tracker:FindObjectForCode("debt_thousand").CurrentStage * 1000
  debt = debt + Tracker:FindObjectForCode("debt_hundred").CurrentStage * 100
  debt = debt + Tracker:FindObjectForCode("debt_ten").CurrentStage * 10
  debt = debt + Tracker:FindObjectForCode("debt_one").CurrentStage * 1
  return pokos >= debt
end

function IsSelectedDestination(entrance, area)
  return Tracker:FindObjectForCode(entrance .. "_dst").CurrentStage == EntranceTable[area]
end

function ResetCaves()
  Tracker:FindObjectForCode("EC_dst").CurrentStage = 1
  Tracker:FindObjectForCode("SC_dst").CurrentStage = 2
  Tracker:FindObjectForCode("FC_dst").CurrentStage = 3
  Tracker:FindObjectForCode("HoB_dst").CurrentStage = 4
  Tracker:FindObjectForCode("WFG_dst").CurrentStage = 5
  Tracker:FindObjectForCode("BK_dst").CurrentStage = 6
  Tracker:FindObjectForCode("SH_dst").CurrentStage = 7
  Tracker:FindObjectForCode("CoS_dst").CurrentStage = 8
  Tracker:FindObjectForCode("GK_dst").CurrentStage = 9
  Tracker:FindObjectForCode("SR_dst").CurrentStage = 10
  Tracker:FindObjectForCode("SMGC_dst").CurrentStage = 11
  Tracker:FindObjectForCode("CoC_dst").CurrentStage = 12
  Tracker:FindObjectForCode("HoH_dst").CurrentStage = 13
  Tracker:FindObjectForCode("DD_dst").CurrentStage = 14
end

function CaveAccessLevel(cave)
  local cave_access = {
    EC = {
      {requirements = {}, level = true},
    },
    SC = {
      {requirements = {"BP", "WP"}, level = true},
      {requirements = {}, level = AccessibilityLevel.SequenceBreak},
    },
    FC = {
      {requirements = {"BP"}, level = true},
      {requirements = {}, level = AccessibilityLevel.SequenceBreak},
    }, 
    HoB = {
      {requirements = {"W2"}, level = true},
    },
    WFG = {
      {requirements = {"W2", "PP"}, level = true},
      {requirements = {"W2", "BP"}, level = true},
      {requirements = {"W2", "NS"}, level = AccessibilityLevel.SequenceBreak},
    },
    BK = {
      {requirements = {"W2", "YP", "PP", "WP"}, level = true},
      {requirements = {"W2", "YP", "BP"}, level = true},
      {requirements = {"W2", "NS"}, level = AccessibilityLevel.SequenceBreak},
    },
    SH = {
      {requirements = {"W2", "BP", "WP"}, level = true},
      {requirements = {"W2", "WP"}, level = AccessibilityLevel.SequenceBreak},
    },
    CoS = {
      {requirements = {"W3"}, level = true},
    },
    GK = {
      {requirements = {"W3", "YP"}, level = true},
      {requirements = {"W3", "NS"}, level = AccessibilityLevel.SequenceBreak},
    },
    SR = {
      {requirements = {"W3", "BP", "YP"}, level = true},
      {requirements = {"W3", "RA"}, level = AccessibilityLevel.SequenceBreak}
    },
    SMGC = {
      {requirements = {"W3", "BP"}, level = true},
    },
    CoC = {
      {requirements = {"W4"}, level = true},
    },
    HoH = {
      {requirements = {"W4", "BP", "YP"}, level = true},
    },
    DD = {
      {requirements = {"W4", "WP", "BP"}, level = true},
      {requirements = {"W4", "WP"}, level = AccessibilityLevel.SequenceBreak},
    },
  }

  if not HasKey(cave) then
    return false
  end

  for _, route in ipairs(cave_access[cave]) do
    local can_access_route = true
    for _, key in ipairs(route.requirements) do
      if not Has(key) then
        can_access_route = false
        break
      end
    end
    if can_access_route then
      return route.level
    end
  end
  return false
end

function CanAccess(cave)
  return CaveAccessLevel(cave) == true
end

function CanBreakAccess(cave)
  return CaveAccessLevel(cave) == AccessibilityLevel.SequenceBreak
end

function CheckBuried(location)
  local white_pikmin = Tracker:FindObjectForCode("whiteonion")
  if (white_pikmin ~= nil and white_pikmin.Active) or SLOT_DATA == nil or SLOT_DATA["buried_treasure_locations"] == nil then
    return true
  end

  for _, treasure in pairs(SLOT_DATA["buried_treasure_locations"]) do
    if location == treasure[2] then
      return false
    end
  end
  return true
end

function IsSublevel(cave, level, result)
  if SLOT_DATA["sublevels"] ~= nil then
    return SLOT_DATA["sublevels"][cave][tonumber(level)] == tonumber(result) - 1
  else
    return level == result
  end
end
