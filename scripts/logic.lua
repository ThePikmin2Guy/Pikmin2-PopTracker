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
    ["RP"] = "redonion", -- Red Onion
    ["YP"] = "yellowonion", -- Yellow Onion
    ["BP"] = "blueonion", -- Blue Onion
    ["PP"] = "purpleonion", -- Purple Onion
    ["WP"] = "whiteonion", -- White Onion

    ["W2"] = "sphericalatlas", -- Sphere Chart
    ["W3"] = "geographicprojection", -- Survey Chart
    ["NS"] = "napsack", -- Napsack
  }

  if item_map[item] ~= nil then
    return Tracker:FindObjectForCode(item_map[item]).Active
  end
end

function HasKey(key)
  local key_map = {
    ["EC"] = "ecentrancekey", -- Emerence Cave
    ["SC"] = "scentrancekey", -- Subterranean Complex
    ["FC"] = "fcentrancekey", -- Frontier Cavern
    ["HoB"] = "hobentrancekey", -- Hole of Beasts
    ["WFG"] = "wfgentrancekey", -- White Flower Garden
    ["BK"] = "bkentrancekey", -- Bulblax Kingdom
    ["SH"] = "shentrancekey", -- Snagret Hole
    ["CoS"] = "cosentrancekey", -- Citadel of Spiders
    ["GK"] = "gkentrancekey", -- Glutton's Kitchen
    ["SR"] = "srentrancekey", -- Shower Room
    ["SMGC"] = "smgcentrancekey", -- Submerged Castle
    ["CoC"] = "cocentrancekey", -- Cavern of Chaos
    ["HoH"] = "hohentrancekey", -- Hole of Heroes
    ["DD"] = "ddentrancekey", -- Dream Den
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
  local debt = 10000
  return CountPokos() >= debt
end

function IsSelectedDestination(entrance, area)
  return Tracker:FindObjectForCode(entrance .. "_dst").CurrentStage == EntranceTable[area]
end
