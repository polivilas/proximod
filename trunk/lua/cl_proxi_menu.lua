////////////////////////////////////////////////
// -- Proxi                                   //
// by Hurricaaane (Ha3)                       //
//                                            //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Menu                                       //
////////////////////////////////////////////////

include( 'CtrlColor.lua' )

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// DERMA PANEL .
do ---- Notepad++ convenience (do end) to hide this

function proxi.Util_FrameGetExpandTable( myPanel )
	local expandTable = {}
	
	for k,subtable in pairs( myPanel.Categories ) do
		table.insert(expandTable, subtable[1]:GetExpanded())
		
	end
	
	return expandTable
end

function proxi.Util_AppendPanel( myPanel, thisPanel )
	local toAppendIn = myPanel.Categories[#myPanel.Categories][1].List
	
	thisPanel:SetParent( toAppendIn )
	toAppendIn:AddItem( thisPanel )
	
end

function proxi.Util_AppendCheckBox( myPanel, title, cvar )

	local checkbox = vgui.Create( "DCheckBoxLabel" )
	checkbox:SetText( title )
	checkbox:SetConVar( cvar )
	
	proxi.Util_AppendPanel( myPanel, checkbox )
	
end

function proxi.Util_AppendLabel( myPanel, sText, optiSize, optbWrap )

	local label = vgui.Create( "DLabel" )
	label:SetText( sText )
	
	if optiSize then
		label:SetWrap( true )
		label:SetContentAlignment( 2 )
		label:SetSize( myPanel.W_WIDTH, optiSize )
		
	end
	
	if optbWrap then
		label:SetWrap( true )
		
	end
	
	proxi.Util_AppendPanel( myPanel, label )
	
end

function proxi.Util_AppendSlider( myPanel, sText, sCvar, fMin, fMax, iDecimals)
	local slider = vgui.Create("DNumSlider")
	slider:SetText( sText )
	slider:SetMin( fMin )
	slider:SetMax( fMax )
	slider:SetDecimals( iDecimals )
	slider:SetConVar( sCvar )
	
	proxi.Util_AppendPanel( myPanel, slider )
end

function proxi.Util_AppendPreset( myPanel, sFolder, tCvars, opttOptions )
	local ctrl = vgui.Create( "ControlPresets", self )
	
	ctrl:SetPreset( sFolder )
	
	if ( opttOptions ) then
		for k, v in pairs( opttOptions ) do
			if ( k != "id" ) then
				ctrl:AddOption( k, v )
			end
		end
	end
	
	if ( tCvars ) then
		for k, v in pairs( tCvars ) do
			ctrl:AddConVar( v )
		end
	end
	
	proxi.Util_AppendPanel( myPanel, ctrl )
	
end

function proxi.Util_MakeFrame( width, height, optsTitleAppend )
	local myPanel = vgui.Create( "DFrame" )
	local border = 4
	
	myPanel.W_HEIGHT = height - 20
	myPanel.W_WIDTH = width - 2 * border
	
	myPanel:SetPos( ScrW() * 0.5 - width * 0.5 , ScrH() * 0.5 - height * 0.5 )
	myPanel:SetSize( width, height )
	myPanel:SetTitle( PROXI_NAME .. (proxi_internal.IsUsingCloud and proxi_internal.IsUsingCloud() and " over Cloud" or "" ) .. (optsTitleAppend or "" ) )
	myPanel:SetVisible( false )
	myPanel:SetDraggable( true )
	myPanel:ShowCloseButton( true )
	myPanel:SetDeleteOnClose( false )
	
	myPanel.Contents = vgui.Create( "DPanelList", myPanel )
	myPanel.Contents:SetPos( border , 22 + border )
	myPanel.Contents:SetSize( myPanel.W_WIDTH, height - 2 * border - 22 )
	myPanel.Contents:SetSpacing( 5 )
	myPanel.Contents:EnableHorizontal( false )
	myPanel.Contents:EnableVerticalScrollbar( false )
	
	myPanel.Categories = {}
	
	return myPanel
end

function proxi.Util_MakeCategory( myPanel, sTitle, bExpandDefault )
	local category = vgui.Create("DCollapsibleCategory", myPanel.Contents)
	category.List  = vgui.Create("DPanelList", category )
	table.insert( myPanel.Categories, {category, bExpandDefault} )
	category:SetSize( myPanel.W_WIDTH, 50 )
	category:SetLabel( sTitle )
	
	category.List:EnableHorizontal( false )
	category.List:EnableVerticalScrollbar( false )
	
	return category
end

function proxi.Util_ApplyCategories( myPanel )
	for k,subtable in pairs( myPanel.Categories ) do
		subtable[1]:SetExpanded( opt_tExpand and (opt_tExpand[k] and 1 or 0) or subtable[2] )
		subtable[1].List:SetSize( myPanel.W_WIDTH, myPanel.W_HEIGHT - #myPanel.Categories * 10 - 10 )
		subtable[1]:SetSize( myPanel.W_WIDTH, myPanel.W_HEIGHT - #myPanel.Categories * 10 )
		
		subtable[1].List:PerformLayout()
		subtable[1].List:SizeToContents()
		
		subtable[1]:SetContents( subtable[1].List )
		
		myPanel.Contents:AddItem( subtable[1] )
	end
	
end

function proxi.MenuCall_ReloadFromCloud()
	if proxi_cloud then
		proxi_cloud:Ask()
	end
	
end

function proxi.MenuCall_ReloadFromLocale()
	if proxi_cloud then
		proxi_cloud:LoadLocale()
	end
	
end

end

function proxi.BuildMenu( opt_tExpand )
	if proxi.DermaPanel then proxi.DermaPanel:Remove() end
	
	local bCanGetVersion = proxi_internal ~= nil
	local MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK
	local ONLINE_VERSION_READ = -1
	if bCanGetVersion then
		MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK = proxi_internal.GetVersionData()
		
		if ONLINE_VERSION == -1 then
			ONLINE_VERSION_READ = "<offline>"
		else
			ONLINE_VERSION_READ = tostring( ONLINE_VERSION )
		end
		
	end
	
	proxi.DermaPanel = proxi.Util_MakeFrame( 352, ScrH() * 0.80 )
	local refPanel = proxi.DermaPanel
	
	proxi.Util_MakeCategory( refPanel, "General", 1 )
	proxi.Util_AppendCheckBox( refPanel, "Enable" , "proxi_core_enable" )
	
	--Helper label
	do
		local GeneralTextLabelMessage = "The command \"proxi_menu\" calls this menu.\n"
		GeneralTextLabelMessage = GeneralTextLabelMessage .. "Example : To assign " .. PROXI_NAME .. " menu to F10, type in the console :"
		
		proxi.Util_AppendLabel( refPanel, GeneralTextLabelMessage, 50, true )
		
		local GeneralCommandLabel = vgui.Create("DTextEntry")
		GeneralCommandLabel:SetText( "bind \"F10\" \"proxi_menu\"" )
		GeneralCommandLabel:SetEditable( false )

		proxi.Util_AppendPanel( refPanel, GeneralCommandLabel )
		
	end
	
	
	--Update label
	do
		if bCanGetVersion and (MY_VERSION and ONLINE_VERSION and (MY_VERSION < ONLINE_VERSION)) then
			GeneralTextLabelMessage = "Your version is "..MY_VERSION.." and the updated one is "..ONLINE_VERSION.." ! You should update !"
			proxi.Util_AppendLabel( refPanel, GeneralTextLabelMessage, 50, true )
			
			local CReload = vgui.Create("DButton")
			CReload:SetText( "Open full Changelog" )
			CReload.DoClick = proxi.ShowChangelog
			proxi.Util_AppendPanel( refPanel, CReload )
			
			proxi.Util_AppendLabel( refPanel, "" )
			
			if ONLINE_VERSION and ONLINE_VERSION ~= -1 then
				local myVer = MY_VERSION or 0
				
				local contents = proxi_internal.GetReplicate() or ( tostring( MY_VERSION or 0 ) .. "\n<Nothing to show>" )
				local split = string.Explode( "\n", contents )
				if (#split % 2) == 0 then
					local dList = vgui.Create("DListView")
					dList:SetMultiSelect( false )
					dList:SetTall( 150 )
					dList:AddColumn( "Ver." ):SetMaxWidth( 45 ) -- Add column
					dList:AddColumn( "Log" )
					
					local gotMyVer = false
					local i = 1
					while (i <= #split) and not gotMyVer do
						local iVer = tonumber( split[i] or 0 ) or 0
						if not gotMyVer and iVer ~= 0 and iVer <= myVer and (split[i+2] ~= "&") then
							dList:AddLine( "*" .. myVer .. "*", "< Locale version >" )
							gotMyVer = true
							
						else
							local myLine = dList:AddLine( (split[i] ~= "&") and split[i] or "", split[i+1] or "" )
							myLine:SizeToContents()
							
						end
						
						i = i + 2
						
					end
					
					proxi.Util_AppendPanel( refPanel, dList )
					
				end
				
			end
			
		end
		
	end
	
	if proxi_internal.IsUsingCloud then
		if proxi_internal.IsUsingCloud() then
			proxi.Util_MakeCategory( refPanel, "Using Cloud" .. (bCanGetVersion and (" [ v" .. tostring(MY_VERSION) .. " >> v" .. tostring(ONLINE_VERSION_READ) .. " ]") or " Version" ), 0 )
		
		else
			proxi.Util_MakeCategory( refPanel, "Using Locale" .. (bCanGetVersion and (" [ v" .. tostring(MY_VERSION) .. " >> v" .. tostring(ONLINE_VERSION_READ) .. " ]") or " Version" ), 0 )
			
		end
		
	else
		proxi.Util_MakeCategory( refPanel, "Cloud" .. (bCanGetVersion and (" [ v" .. tostring(MY_VERSION) .. " >> v" .. tostring(ONLINE_VERSION_READ) .. " ]") or " Version" ), 0 )
		
	end
	
	-- Reload from Cloud Button
	do
		local CReload = vgui.Create("DButton")
		CReload:SetText( "Reload from Cloud" )
		CReload.DoClick = proxi.MenuCall_ReloadFromCloud
		proxi.Util_AppendPanel( refPanel, CReload )
	end
	
	-- Reload from Locale Button
	if proxi_internal then
		local CReload = vgui.Create("DButton")
		CReload:SetText( "Reload from Locale" )
		CReload.DoClick = proxi.MenuCall_ReloadFromLocale
		proxi.Util_AppendPanel( refPanel, CReload )
	end
	
	-- Changelog Button
	if proxi_internal and proxi_internal.GetReplicate then
		proxi.Util_AppendLabel( refPanel, "" )
		
		local CChangelog = vgui.Create("DButton")
		CChangelog:SetText( "Open Changelog" )
		CChangelog.DoClick = proxi.ShowChangelog
		proxi.Util_AppendPanel( refPanel, CChangelog )
	end
	
	proxi.Util_ApplyCategories( refPanel )
	
end


function proxi.ShowMenuNoOverride( )
	proxi.ShowMenu( true )
end

function proxi.ShowMenu( optbKeyboardShouldNotOverride )
	if not proxi.DermaPanel then
		proxi.BuildMenu()
	end
	--proxi.DermaPanel:Center()
	proxi.DermaPanel:MakePopup()
	proxi.DermaPanel:SetKeyboardInputEnabled( not optbKeyboardShouldNotOverride )
	proxi.DermaPanel:SetVisible( true )
end

function proxi.HideMenu()
	if not proxi.DermaPanel then
		return
	end
	proxi.DermaPanel:SetVisible( false )
end

function proxi.DestroyMenu()
	if proxi.DermaPanel then
		proxi.DermaPanel:Remove()
		proxi.DermaPanel = nil
	end
end

-----------

function proxi.BuildChangelog( opt_tExpand )
	if proxi.ChangelogPanel then proxi.ChangelogPanel:Remove() end
	
	local bCanGetVersion = proxi_internal ~= nil
	local MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK
	local ONLINE_VERSION_READ = -1
	if bCanGetVersion then
		MY_VERSION, ONLINE_VERSION, DOWNLOAD_LINK = proxi_internal.GetVersionData()
		
		if ONLINE_VERSION == -1 then
			ONLINE_VERSION_READ = "<offline>"
		else
			ONLINE_VERSION_READ = tostring( ONLINE_VERSION )
		end
		
	end
	
	proxi.ChangelogPanel = proxi.Util_MakeFrame( ScrW() * 0.95, ScrH() * 0.75, " - Changelog" )
	local refPanel = proxi.ChangelogPanel
	
	proxi.Util_MakeCategory( refPanel, "Changelog", 1 )
	
	if ONLINE_VERSION and ONLINE_VERSION ~= -1 and proxi_internal.GetReplicate then
		local myVer = MY_VERSION or 0
		
		local contents = proxi_internal.GetReplicate() or ( tostring( MY_VERSION or 0 ) .. "\n<Nothing to show>" )
		local split = string.Explode( "\n", contents )
		if (#split % 2) == 0 then
			local dList = vgui.Create("DListView")
			dList:SetMultiSelect( false )
			dList:SetTall( refPanel.W_HEIGHT - 40 )
			dList:AddColumn( "Ver." ):SetMaxWidth( 45 ) -- Add column
			dList:AddColumn( "Type" ):SetMaxWidth( 60 ) -- Add column
			dList:AddColumn( "Log" )
			
			local gotMyVer = false
			for i=1, #split, 2 do
				local iVer = tonumber( split[i] or 0 ) or 0
				if not gotMyVer and iVer ~= 0 and iVer <= myVer and (split[i+2] ~= "&") then
					dList:AddLine( "*" .. myVer .. "*", "Locale", "< Currently installed version >" )
					gotMyVer = true
					
				end
				local nature = tonumber( split[i] )
				nature = (nature == nil) and "" or math.floor(nature*1000) % 10 > 0 and "Fix" or math.floor(nature*100) % 10 > 0 and "Feature" or "Release"
				local myLine = dList:AddLine( (split[i] ~= "&") and split[i] or "", tostring(nature), split[i+1] or "" )
				myLine:SizeToContents()
				
			end
			
			proxi.Util_AppendPanel( refPanel, dList )
			--dList:SizeToContents()
			
		else
			proxi.Util_AppendLabel( refPanel, "<Changelog data is corrupted>", 70, true )
			
		end
		
	elseif not proxi_internal.GetReplicate then
		proxi.Util_AppendLabel( refPanel, "Couldn't load changelog because your Locale version is too old.", 70, true )
		
	else
		proxi.Util_AppendLabel( refPanel, "Couldn't load changelog because ".. PROXI_NAME .." failed to pickup information from the Cloud.", 70, true )
	
	end
	
	proxi.Util_ApplyCategories( refPanel )

end

function proxi.ShowChangelog( optbKeyboardShouldNotOverride )
	if not proxi.ChangelogPanel then
		proxi.BuildChangelog()
	end
	proxi.ChangelogPanel:MakePopup()
	proxi.ChangelogPanel:SetKeyboardInputEnabled( not optbKeyboardShouldNotOverride )
	proxi.ChangelogPanel:SetVisible( true )
end

function proxi.HideChangelog()
	if not proxi.ChangelogPanel then
		return
	end
	proxi.ChangelogPanel:SetVisible( false )
end

function proxi.DestroyChangelog()
	if proxi.ChangelogPanel then
		proxi.ChangelogPanel:Remove()
		proxi.ChangelogPanel = nil
	end
end

--[[
function proxi.MakePresetPanel( data )
	local ctrl = vgui.Create( "ControlPresets", self )
	
	ctrl:SetPreset( data.folder )
	
	if ( data.options ) then
		for k, v in pairs( data.options ) do
			if ( k != "id" ) then
				ctrl:AddOption( k, v )
			end
		end
	end
	
	if ( data.cvars ) then
		for k, v in pairs( data.cvars ) do
			ctrl:AddConVar( v )
		end
	end
	
	return ctrl
end
]]--

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
//// SANDBOX PANEL .

function proxi.Panel(Panel)	
	Panel:AddControl("Checkbox", {
			Label = "Enable", 
			Description = "Enable", 
			Command = "proxi_core_enable" 
		}
	)
	Panel:AddControl("Button", {
			Label = "Open Menu (proxi_menu)", 
			Description = "Open Menu (proxi_menu)", 
			Command = "proxi_menu"
		}
	)
	
	Panel:Help("To trigger the menu in any gamemode, type proxi_menu in the console, or bind this command to any key.")
end

function proxi.AddPanel()
	spawnmenu.AddToolMenuOption("Options", "Player", PROXI_NAME, PROXI_NAME, "", "", proxi.Panel, {SwitchConVar = 'proxi_core_enable'})
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
// MOUNT FCTS.

function proxi.MountMenu()
	concommand.Add( "proxi_menu", proxi.ShowMenuNoOverride )
	concommand.Add( "proxi_call_menu", proxi.ShowMenuNoOverride )
	concommand.Add( "+proxi_menu", proxi.ShowMenu )
	concommand.Add( "-proxi_menu", proxi.HideMenu )
end

function proxi.UnmountMenu()
	proxi.DestroyMenu()

	concommand.Remove( "proxi_call_menu" )
	concommand.Remove( "proxi_menu" )
	concommand.Remove( "+proxi_menu" )
	concommand.Remove( "-proxi_menu" )
end

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////