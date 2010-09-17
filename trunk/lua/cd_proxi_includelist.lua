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
table.insert( ADDON_PROP, "proxi_b_default/props.lua" )
table.insert( ADDON_PROP, "proxi_b_default/rockets.lua" )
table.insert( ADDON_PROP, "proxi_b_default/bolts.lua" )
table.insert( ADDON_PROP, "proxi_b_default/los.lua" )
table.insert( ADDON_PROP, "proxi_b_default/nades.lua" )

---- Menu
table.insert( ADDON_PROP, "cl_proxi_ctrlcolor.lua" )
table.insert( ADDON_PROP, "cl_proxi_menuutils.lua" )
table.insert( ADDON_PROP, "cl_proxi_changelog.lua" )
table.insert( ADDON_PROP, "cl_proxi_menu.lua" )
