ITEM.PrintName	= "Smoke"
ITEM.baseClass	= "base_pointshop_item"
ITEM.Description = "The base_weapon"


function ITEM:getIcon( )
	self.icon = vgui.Create( "DPointshopCustomInvIcon" )
	self.icon:SetItem( self )
	self.icon:SetSize( 64, 64 )
	return self.icon
end

function ITEM:OnEquip( )
end

function ITEM:OnHolster( )
end

function ITEM.static:GetPointshopIconControl( )
	return "DCsgoItemIcon"
end

function ITEM.static.getPersistence( )
	return Pointshop2.SmokePersistence
end

function ITEM.static.generateFromPersistence( itemTable, persistenceItem )
	ITEM.super.generateFromPersistence( itemTable, persistenceItem.ItemPersistence )
	itemTable.color = persistenceItem.color
	itemTable.rainbow = persistenceItem.rainbow
	itemTable.weaponClass = "weapon_ttt_smokegrenade"
	itemTable.loadoutType = "Дымчанский"
end

function ITEM.static.GetPointshopIconDimensions( )
	return Pointshop2.GenerateIconSize( 4, 4 )
end
