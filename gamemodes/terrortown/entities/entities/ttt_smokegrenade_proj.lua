
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_smokegrenade_thrown.mdl")


AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )

function ENT:SetupDataTables()
self.BaseClass.SetupDataTables( self )

	self:NetworkVar( "Bool", 2, "Rainbow" )
	self:NetworkVar( "Int",3 , "Red" )
	self:NetworkVar( "Int",4 , "Green" )
	self:NetworkVar( "Int",5 , "Blue" )
	
end

function ENT:Initialize()
   if not self:GetRadius() then self:SetRadius(50) end
   
   if SERVER then
		local item = self:GetOwner():PS2_GetItemInSlot( "Дымчанский" )
		if item then
			self:SetRainbow(item.rainbow)
			self:SetRed(item.color.r)
			self:SetGreen(item.color.g)
			self:SetBlue(item.color.b)
		else
			self:SetRainbow(false)
			self:SetRed(0)
			self:SetGreen(0)
			self:SetBlue(0)
		end
	end

   return self.BaseClass.Initialize(self)
end



if CLIENT then

   local smokeparticles = {
      Model("particle/particle_smokegrenade"),
      Model("particle/particle_noisesphere")
   };

   function ENT:CreateSmoke(center)
      local rainbow=self:GetRainbow()
	  
	  local red = self:GetRed()
	  local green = self:GetGreen()
	  local blue = self:GetBlue()
	
      local em = ParticleEmitter(center)

      local r = self:GetRadius()

      for i=1, 50 do
         local prpos = VectorRand() * r
         prpos.z = prpos.z + 32
         local p = em:Add(table.Random(smokeparticles), center + prpos)
         if p then
			
			if (rainbow!=false or red!=0 or green!=0 or blue!=0) then
			
				if self:GetRainbow() then
					p:SetColor(math.random(1, 255), math.random(1, 255), math.random(1, 255))
				else
					p:SetColor(red, green, blue)
				end
				
			else
				color = math.random(75, 200)
				p:SetColor(color, color, color)
			end
            p:SetStartAlpha(255)
            p:SetEndAlpha(200)
            p:SetVelocity(VectorRand() * math.Rand(900, 1300))
            p:SetLifeTime(0)
            
            p:SetDieTime(math.Rand(50, 70))

            p:SetStartSize(math.random(140, 150))
            p:SetEndSize(math.random(1, 40))
            p:SetRoll(math.random(-180, 180))
            p:SetRollDelta(math.Rand(-0.1, 0.1))
            p:SetAirResistance(600)

            p:SetCollide(true)
            p:SetBounce(0.4)

            p:SetLighting(false)
         end
      end

      em:Finish()
   end
end

function ENT:Explode(tr)
   if SERVER then
      self:SetNoDraw(true)
      self:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self:GetPos()

      self:Remove()
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)

      if tr.Fraction != 1.0 then
         spos = tr.HitPos + tr.HitNormal * 0.6
      end

      -- Smoke particles can't get cleaned up when a round restarts, so prevent
      -- them from existing post-round.
      if GetRoundState() == ROUND_POST then return end

      self:CreateSmoke(spos)
   end
end
