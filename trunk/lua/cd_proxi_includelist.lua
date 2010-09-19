//if not ADDON_PROP then return end

ADDON_PROP = {}
---- Preload
table.insert( ADDON_PROP, "cl_proxi_base.lua" )
table.insert( ADDON_PROP, "cl_proxi_cvar_custom.lua" )
table.insert( ADDON_PROP, "cl_proxi_util.lua" )
--table.insert( ADDON_PROP, "cl_proxi_ph_simmap.lua" )
table.insert( ADDON_PROP, "cl_proxi_dup_virtualscene.lua" )

---- Beacons
table.insert( ADDON_PROP, "cl_proxi_beacons.lua" )
table.insert( ADDON_PROP, "proxi_b_default/players.lua" )
table.insert( ADDON_PROP, "proxi_b_default/physprops.lua" )
table.insert( ADDON_PROP, "proxi_b_default/rockets.lua" )
table.insert( ADDON_PROP, "proxi_b_default/bolts.lua" )
table.insert( ADDON_PROP, "proxi_b_default/playerlos.lua" )
table.insert( ADDON_PROP, "proxi_b_default/nades.lua" )
table.insert( ADDON_PROP, "proxi_b_default/compass.lua" )
table.insert( ADDON_PROP, "proxi_b_default/contraptioncompass.lua" )
table.insert( ADDON_PROP, "proxi_b_default/npc.lua" )
table.insert( ADDON_PROP, "proxi_b_default/npclos.lua" )
table.insert( ADDON_PROP, "proxi_b_default/wallfinder.lua" )
table.insert( ADDON_PROP, "proxi_b_default/chat.lua" )
table.insert( ADDON_PROP, "proxi_b_default/wallfinderpierce.lua" )

---- Menu
table.insert( ADDON_PROP, "cl_proxi_ctrlcolor.lua" )
table.insert( ADDON_PROP, "cl_proxi_menuutils.lua" )
table.insert( ADDON_PROP, "cl_proxi_changelog.lua" )
table.insert( ADDON_PROP, "cl_proxi_menu.lua" )
