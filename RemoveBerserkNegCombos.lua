Save = 0x09A7070 - 0x56450E

function _OnFrame()
    --Force unequip All Berserk and Both negative combos if 2 are equipped
    local NegativeComboCount = 0
    for Slot = 0,68 do
        local Current = Save + 0x2544 + 2*Slot
        local Ability = ReadShort(Current) & 0x0FFF
        local Initial = ReadShort(Current) & 0xF000
        if Ability == 0x018A then --Negative Combo
            if Initial > 0 then --Initially equipped
                NegativeComboCount = NegativeComboCount + 1
            end
            if NegativeComboCount > 1 then --Unequip all Negative Combo except one
                WriteShort(Current,Ability)
            end
        elseif Ability == 0x018B then --Berserk Charge
            WriteShort(Current,Ability)
        end
    end
end