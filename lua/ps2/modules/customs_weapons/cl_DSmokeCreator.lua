local PANEL = {}

function PANEL:Init( )
	self:addSectionTitle( "Smoke Color" )

	self.colorsPanel = vgui.Create( "DPanel" )
	self.colorsPanel:SetTall( 64 )
	self.colorsPanel:SetWide( self:GetWide( ) )
	function self.colorsPanel:Paint( ) end

	local rightPnl = vgui.Create( "DPanel", self.colorsPanel )
	rightPnl:Dock( FILL )
	function rightPnl:Paint( )
	end

	self.colorPicker = vgui.Create( "DColorMixer", self.colorsPanel )
	self.colorPicker:DockMargin( 5, 0, 5, 5 )
	self.colorPicker:SetPalette( false )
    self.colorPicker:SetWangs( true )
    self.colorPicker:SetAlphaBar( false )
    --self.colorPicker:Dock( FILL )
	function self.colorPicker.OnColorPicked( _self, color )
        self.color = color
    end

	local cont = self:addFormItem( "color", self.colorsPanel )
	cont:SetTall( 256 )
	
	
	self.checkBox = vgui.Create( "DCheckBox", self.colorsPanel )
	self.checkBox:SetValue( false )
	
	local cont = self:addFormItem( "Rainbow", self.checkBox  )
	cont:SetTall( 14 )
	
end

function PANEL:SaveItem( saveTable )
	self.BaseClass.SaveItem( self, saveTable )
	saveTable.weaponClass = "weapon_ttt_smokegrenade"
	saveTable.loadoutType = "Дымчанский"
    saveTable.color = self.colorPicker:GetColor( )
	saveTable.rainbow = self.checkBox:GetChecked()
end

function PANEL:EditItem( persistence, itemClass )
	self.BaseClass.EditItem( self, persistence.ItemPersistence, itemClass )
    self.colorPicker:SetColor( persistence.color )
	self.checkBox:SetChecked( persistence.rainbow )
	
end

function PANEL:Validate( saveTable )
	local succ, err = self.BaseClass.Validate( self, saveTable )
	if not succ then
		return succ, err
	end

	return true
end


vgui.Register( "DSmokeCreator", PANEL, "DItemCreator" )
