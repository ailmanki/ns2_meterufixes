

if Client then

    function ExoVariantMixin:OnUpdateRender()
        PROFILE("ExoVariantMixin:OnUpdateRender")

        if self.dirtySkinState then

            local weaponClass = self:GetWeaponLoadoutClass()
            if not weaponClass then
                --Log("ERROR: Exo with invalid weapon class, skin update failure")
                self.dirtySkinState = false
                return false
            end

            --Handle world model
            local worldModel = self:GetRenderModel()
            if worldModel and worldModel:GetReadyForOverrideMaterials() then

                if self.exoVariant ~= kDefaultExoVariant then

                    local worldMats = GetPrecachedCosmeticMaterial( weaponClass, self.exoVariant )
                    assert(worldMats and type(worldMats) == "table")

                    for i = 1, #worldMats do
                        local worldMaterial = worldMats[i].mat
                        local worldMatIndex = worldMats[i].idx
                        assert(worldMaterial)
                        assert(worldMatIndex)
                        worldModel:SetOverrideMaterial( worldMatIndex, worldMaterial )
                    end

                else
                    worldModel:ClearOverrideMaterials()
                end
                
                self:SetHighlightNeedsUpdate()
            else
                return false --delay a frame
            end

            --only try to update view models for players, not Exosuits
            if self:isa("Exo") and self:GetIsLocalPlayer() then

                local viewModelEnt = self:GetViewModelEntity()
                
                if viewModelEnt then

                    local viewModel = viewModelEnt:GetRenderModel()
                    if viewModel and viewModel:GetReadyForOverrideMaterials() then

                        if self.exoVariant ~= kDefaultExoVariant then

                            local viewMats = GetPrecachedCosmeticMaterial( weaponClass, self.exoVariant, true )
                            assert(viewMats and type(viewMats) == "table")

                            if weaponClass == "Minigun" then
                                assert(#viewMats == 1)
                                viewModel:SetOverrideMaterial( 0, viewMats[1] )
                            elseif weaponClass == "Railgun" then
                                assert(#viewMats == 2)
                                viewModel:SetOverrideMaterial( 0, viewMats[1] )
                                viewModel:SetOverrideMaterial( 1, viewMats[2] )
                            end

                        else
                            viewModel:ClearOverrideMaterials()
                        end
                    else
                        return false
                    end

                    viewModelEnt:SetHighlightNeedsUpdate()
                end
    
            end

            self.dirtySkinState = false
            self.clientExoVariant = self.exoVariant
        end

    end

end