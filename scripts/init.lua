ENABLE_DEBUG_LOG = true

local variant = Tracker.ActiveVariantUID

IS_HORIZONTAL = variant:find("horizontal")

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
Tracker:AddLocations("locations/aw.json")
Tracker:AddLocations("locations/pp.json")
Tracker:AddLocations("locations/ww.json")
Tracker:AddLocations("locations/world.json")
Tracker:AddLocations("locations/caves/ec.json")
Tracker:AddLocations("locations/caves/sc.json")
Tracker:AddLocations("locations/caves/fc.json")
Tracker:AddLocations("locations/caves/hob.json")
Tracker:AddLocations("locations/caves/wfg.json")
Tracker:AddLocations("locations/caves/bk.json")
Tracker:AddLocations("locations/caves/sh.json")
Tracker:AddLocations("locations/caves/cos.json")
Tracker:AddLocations("locations/caves/gk.json")
Tracker:AddLocations("locations/caves/sr.json")
Tracker:AddLocations("locations/caves/smgc.json")
Tracker:AddLocations("locations/caves/coc.json")
Tracker:AddLocations("locations/caves/hoh.json")
Tracker:AddLocations("locations/caves/dd.json")

-- Layouts
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/overview.json")
Tracker:AddLayouts("layouts/pikmin.json")
Tracker:AddLayouts("layouts/explorer_kit.json")
Tracker:AddLayouts("layouts/td_weapons.json")
Tracker:AddLayouts("layouts/pokos.json")
Tracker:AddLayouts("layouts/entrances.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/treasures.json")

if IS_HORIZONTAL then
  Tracker:AddLayouts("layouts/horizontal/tracker_horizontal.json")
  Tracker:AddLayouts("layouts/horizontal/pikmin_horizontal.json")
  Tracker:AddLayouts("layouts/horizontal/pokos_horizontal.json")
  Tracker:AddLayouts("layouts/horizontal/td_weapons_horizontal.json")
end

-- Scripts
ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/countPokos.lua")

-- AutoTracking via Archipelago
if PopVersion and PopVersion >= "0.26.0" then
  ScriptHost:LoadScript("scripts/autotracking.lua")
end
