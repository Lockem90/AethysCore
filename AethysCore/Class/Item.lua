--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
  local addonName, AC = ...;
  -- AethysCore
  local Cache = AethysCache;
  local Unit = AC.Unit;
  local Player = Unit.Player;
  local Target = Unit.Target;
  local Spell = AC.Spell;
  local Item = AC.Item;
  -- Lua
  
  -- File Locals
  


--- ============================ CONTENT ============================
  -- Get the item ID.
  function Item:ID ()
    return self.ItemID;
  end

  -- Get the item Info.
  function Item:Info (Type, Index)
    local Identifier;
    if Type == "ID" then
      Identifier = self:ID();
    elseif Type == "Name" then
      Identifier = self:Name();
    else
      error("Item Info Type Missing.");
    end
    if Identifier then
      if not Cache.ItemInfo[Identifier] then Cache.ItemInfo[Identifier] = {}; end
      if not Cache.ItemInfo[Identifier].Info then
        Cache.ItemInfo[Identifier].Info = {GetItemInfo(Identifier)};
      end
      if Index then
        return Cache.ItemInfo[Identifier].Info[Index];
      else
        return unpack(Cache.ItemInfo[Identifier].Info);
      end
    else
      error("Identifier Not Found.");
    end
  end

  -- Get the item Info from the item ID.
  function Item:InfoID (Index)
    return self:Info("ID", Index);
  end

  -- Get the item Info from the item Name.
  function Item:InfoName (Index)
    return self:Info("Name", Index);
  end

  -- Get the item Name.
  function Item:Name ()
    return self:Info("ID", 1);
  end

  -- Get the item Rarity.
  -- Item Rarity
    -- 0 = Poor
    -- 1 = Common
    -- 2 = Uncommon
    -- 3 = Rare
    -- 4 = Epic
    -- 5 = Legendary
    -- 6 = Artifact
    -- 7 = Heirloom
    -- 8 = WoW Token
  function Item:Rarity ()
    return self:Info("ID", 3);
  end

  -- Get the item Level.
  function Item:Level ()
    return self:Info("ID", 4);
  end

  -- Get the item level requirement.
  function Item:MinLevel ()
    return self:Info("ID", 5);
  end

  -- Get wether an item is legendary.
  function Item:IsLegendary ()
    return self:Rarity() == 5;
  end

  -- Check if a given item is currently equipped in the given slot.
  -- Inventory slots
    -- INVSLOT_HEAD       = 1;
    -- INVSLOT_NECK       = 2;
    -- INVSLOT_SHOULDAC   = 3;
    -- INVSLOT_BODY       = 4;
    -- INVSLOT_CHEST      = 5;
    -- INVSLOT_WAIST      = 6;
    -- INVSLOT_LEGS       = 7;
    -- INVSLOT_FEET       = 8;
    -- INVSLOT_WRIST      = 9;
    -- INVSLOT_HAND       = 10;
    -- INVSLOT_FINGAC1    = 11;
    -- INVSLOT_FINGAC2    = 12;
    -- INVSLOT_TRINKET1   = 13;
    -- INVSLOT_TRINKET2   = 14;
    -- INVSLOT_BACK       = 15;
    -- INVSLOT_MAINHAND   = 16;
    -- INVSLOT_OFFHAND    = 17;
    -- INVSLOT_RANGED     = 18;
    -- INVSLOT_TABARD     = 19;
  function Item:IsEquipped (Slot)
    -- TODO: Remove Slot argument and "and not Slot" check.
    if self.ItemSlotID[0] == 0 and not Slot then error("Invalid ItemSlotID specified."); end
    if not Cache.ItemInfo[self.ItemID] then Cache.ItemInfo[self.ItemID] = {}; end
    if Cache.ItemInfo[self.ItemID].IsEquipped == nil then
      -- TODO: Plus this compatibility part.
      if Slot then
        Cache.ItemInfo[self.ItemID].IsEquipped = AC.Equipment[Slot] == self.ItemID and true or false;
      else
        local ItemIsEquipped = false;
        -- Returns false for Legion Legendaries while in Instanced PvP. (Assuming 940 ilevel, 910 ones are meant to disappear)
        if not Player:IsInInstancedPvP() or not self:IsLegendary() or self:Level() ~= 940 then
          for i=0, #self.ItemSlotID do
            if AC.Equipment[self.ItemSlotID[i]] == self.ItemID then
              ItemIsEquipped = true;
              break;
            end
          end
        end
        Cache.ItemInfo[self.ItemID].IsEquipped = ItemIsEquipped;
      end
    end
    return Cache.ItemInfo[self.ItemID].IsEquipped;  
  end

  -- Get the item Last Cast Time.
  function Item:LastCastTime ()
    return self.LastCastTime;
  end
