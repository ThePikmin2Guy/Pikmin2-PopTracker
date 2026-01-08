ENABLE_DEBUG_LOG = true

print("\n-- Loading Pikmin 2 Tracker --")
print("Variant: ", Tracker.ActiveVariantUID)
if ENABLE_DEBUG_LOG then
	print("Debug Logging Enabled")
end

-- Maps
Tracker:AddMaps("maps/maps.json")

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/locations.json")
Tracker:AddItems("items/numbers.json")
Tracker:AddItems("items/cave_entries.json")
Tracker:AddItems("items/options.json")

-- Locations
Tracker:AddLocations("locations/vor.json")
Tracker:AddLocations("locations/ec.json")
Tracker:AddLocations("locations/aw.json")
Tracker:AddLocations("locations/pp.json")
Tracker:AddLocations("locations/ww.json")

-- Layouts
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/overview.json")
Tracker:AddLayouts("layouts/pikmin.json")
Tracker:AddLayouts("layouts/explorer_kit.json")
Tracker:AddLayouts("layouts/keys.json")
Tracker:AddLayouts("layouts/td_weapons.json")
Tracker:AddLayouts("layouts/pokos.json")
Tracker:AddLayouts("layouts/entrances.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/treasures.json")

-- Scripts
ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/countPokos.lua")

-- AutoTracking via Archipelago
if PopVersion and PopVersion >= "0.26.0" then
  ScriptHost:LoadScript("scripts/autotracking.lua")
end
