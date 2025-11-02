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
      -- if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
      --     print(string.format("onClear: clearing location %s", v[1]))
      -- end
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
  for _, item in pairs(ITEM_MAPPING) do
    if item[1] and item[2] then
      -- if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
      --     print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
      -- end
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

-- called when an item gets collected
function OnItem(index, item_id, item_name, player_number)
  --   if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
  --     print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
  --   end
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

-- called when a location gets cleared
function OnLocation(location_id, location_name)
  -- if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
  --   print(string.format("called onLocation: %s, %s", location_id, location_name))
  -- end
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

if AUTOTRACKER_ENABLE_ITEM_TRACKING then
  Archipelago:AddItemHandler("item handler", OnItem)
end

if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
  Archipelago:AddLocationHandler("location handler", OnLocation)
end
