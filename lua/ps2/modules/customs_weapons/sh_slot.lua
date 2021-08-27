Pointshop2.AddEquipmentSlot( "Дымчанский", function( item )
    --Check if the item is a low_gravity item
    return instanceOf( Pointshop2.GetItemClassByName( "base_smoke" ), item )
end )