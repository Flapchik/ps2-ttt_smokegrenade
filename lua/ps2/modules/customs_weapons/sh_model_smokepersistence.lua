Pointshop2.SmokePersistence = class( "Pointshop2.SmokePersistence" )
local SmokePersistence = Pointshop2.SmokePersistence

SmokePersistence.static.DB = "Pointshop2"

SmokePersistence.static.model = {
	tableName = "ps2_smokepersistence",
	fields = {
		itemPersistenceId = "int",
		color = "luadata",
		rainbow = "bool",
	},
	belongsTo = {
		ItemPersistence = {
			class = "Pointshop2.ItemPersistence",
			foreignKey = "itemPersistenceId",
			onDelete = "CASCADE",
		}
	}
}

SmokePersistence:include( DatabaseModel )
SmokePersistence:include( Pointshop2.EasyExport )

function SmokePersistence.static.createOrUpdateFromSaveTable( saveTable, doUpdate )
	return Pointshop2.ItemPersistence.createOrUpdateFromSaveTable( saveTable, doUpdate )
	:Then( function( itemPersistence )
		if doUpdate then
			return SmokePersistence.findByItemPersistenceId( itemPersistence.id )
		else
			local smokePersistence = SmokePersistence:new( )
			smokePersistence.itemPersistenceId = itemPersistence.id
			return smokePersistence
		end
	end )
	:Then( function( smokePersistence )
		smokePersistence.color = saveTable.color
		smokePersistence.rainbow = saveTable.rainbow
		return smokePersistence:save( )
	end )
end
