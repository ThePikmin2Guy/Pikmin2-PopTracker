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
    ["NS"] = "five-mannapsack",
  }

  if (item == "W2" or item == "W3") and Tracker:FindObjectForCode("setting_prog_globes").CurrentStage == 1 then
    local globe1 = Tracker:FindObjectForCode("sphericalatlas").Active
    local globe2 = Tracker:FindObjectForCode("geographicprojection").Active
    if item == "W2" then
      return globe1 or globe2
    elseif item == "W3" then
      return globe1 and globe2
    end
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
