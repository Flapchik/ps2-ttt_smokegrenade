hook.Add( "PS2_ModulesLoaded", "DLC_Smoke", function( )
	local MODULE = Pointshop2.GetModule( "Дополнения" )
	table.insert( MODULE.Blueprints, {
		label = "Smoke",
		base = "base_smoke",
		icon = "pointshop2/fedora.png",
		creator = "DSmokeCreator"
	} )
end )

hook.Add( "PS2_PopulateCredits", "AddSmokeCredit", function( panel )
	panel:AddCreditSection( "Pointshop 2 Smoke", [[
By Leo
	]] )
end )