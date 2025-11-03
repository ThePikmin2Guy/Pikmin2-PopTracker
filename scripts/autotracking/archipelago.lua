require("scripts/autotracking/item_mapping")
require("scripts/autotracking/location_mapping")

CUR_INDEX = -1

function dump_table(o, depth)
  if depth == nil then
    depth = 0
  end
  if type(o) == 'table' then
    local tabs = ('\t'):rep(depth)
    local tabs2 = ('\t'):rep(depth + 1)
    local s = '{\n'
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
    end
    return s .. tabs .. '}'
  else
    return tostring(o)
  end
end

function OnClear(slot_data)
  CUR_INDEX = -1
  -- reset locations
  for _, location in pairs(LOCATION_MAPPING) do
    if location[1] then
      local obj = Tracker:FindObjectForCode(location[1])
      if obj then
        if location[1]:sub(1, 1) == "@" then
          obj.AvailableChestCount = obj.ChestCount
        else
          obj.Active = false
        end
      elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onClear: could not find location obj for code %s", location[1]))
      end
    end
  end
  -- reset items
  local onion_shuffled = Tracker:FindObjectForCode("setting_onion_rando").CurrentStage
  for _, item in pairs(ITEM_MAPPING) do
    if item[1] and item[2] then
      -- don't reset onions if not in pool
      if onion_shuffled == 2 or (item[1] ~= "redonion" and item[1] ~= "yellowonion" and item[1] ~= "blueonion") then
        local obj = Tracker:FindObjectForCode(item[1])
        if obj then
          if item[2] == "toggle" then
            obj.Active = false
          elseif item[2] == "progressive" then
            obj.CurrentStage = 0
            obj.Active = false
          elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onClear: unknown item type %s for code %s", item[2], item[1]))
          end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
          print(string.format("onClear: could not find item obj for code %s", item[1]))
        end
      end
    end
  end

  if onion_shuffled == 0 then
    Tracker:FindObjectForCode("redonion").Active = true
  else
    local start_onion_id = Tracker:FindObjectForCode("setting_start_onion").CurrentStage
    if start_onion_id == 0 then
      Tracker:FindObjectForCode("redonion").Active = true
    elseif start_onion_id == 1 then
      Tracker:FindObjectForCode("yellowonion").Active = true
    elseif start_onion_id == 2 then
      Tracker:FindObjectForCode("blueonion").Active = true
    end
  end

  local caves_locked = Tracker:FindObjectForCode("setting_caves_locked").CurrentStage == 1
  if not caves_locked then
    Tracker:FindObjectForCode("ecentrancekey").Active = true
    Tracker:FindObjectForCode("scentrancekey").Active = true
    Tracker:FindObjectForCode("fcentrancekey").Active = true
    Tracker:FindObjectForCode("hobentrancekey").Active = true
    Tracker:FindObjectForCode("wfgentrancekey").Active = true
    Tracker:FindObjectForCode("bkentrancekey").Active = true
    Tracker:FindObjectForCode("shentrancekey").Active = true
    Tracker:FindObjectForCode("cosentrancekey").Active = true
    Tracker:FindObjectForCode("gkentrancekey").Active = true
    Tracker:FindObjectForCode("srentrancekey").Active = true
    Tracker:FindObjectForCode("smgcentrancekey").Active = true
    Tracker:FindObjectForCode("cocentrancekey").Active = true
    Tracker:FindObjectForCode("hohentrancekey").Active = true
    Tracker:FindObjectForCode("ddentrancekey").Active = true
  end

  local caves_shuffled = Tracker:FindObjectForCode("setting_caves_rando").CurrentStage == 1
  if not caves_shuffled then
    ResetCaves()
  end
end

function OnItem(index, item_id, item_name, player_number)
  if index <= CUR_INDEX then
    return
  end
  CUR_INDEX = index;
  local item = ITEM_MAPPING[item_id]
  local obj = Tracker:FindObjectForCode(item[1])
  if obj then
    if obj.Type == "toggle" then
      obj.Active = true
    end
  else
    print(string.format("onItem: could not find object for code %s", item[1]))
  end

  UpdatePokos()
end

function OnLocation(location_id, location_name)
  local location = LOCATION_MAPPING[location_id]
  if not location or not location[1] then
    print(string.format("onLocation: could not find location mapping for id %s", location_id))
    return
  end

  local obj = Tracker:FindObjectForCode(location[1])
  if obj then
    if location[1]:sub(1, 1) == "@" then
      obj.AvailableChestCount = obj.AvailableChestCount - 1
    else
      obj.Active = true
    end
  else
    print(string.format("onLocation: could not find object for code %s", location[1]))
  end
end

function UpdatePokos()
  local current_pokos = CountPokos()
  local digits = { 0, 0, 0, 0, 0 }
  local pokos_codes = {
    "pokos_tenthousand",
    "pokos_thousand",
    "pokos_hundred",
    "pokos_ten",
    "pokos_one"
  }

  digits[1] = math.floor(current_pokos / 10000) % 10
  digits[2] = math.floor(current_pokos / 1000) % 10
  digits[3] = math.floor(current_pokos / 100) % 10
  digits[4] = math.floor(current_pokos / 10) % 10
  digits[5] = current_pokos % 10

  for k, v in pairs(pokos_codes) do
    Tracker:FindObjectForCode(v).CurrentStage = digits[k]
  end
end

Archipelago:AddClearHandler("clear handler", OnClear)
Archipelago:AddItemHandler("item handler", OnItem)
Archipelago:AddLocationHandler("location handler", OnLocation)
