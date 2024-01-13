LUAGUI_NAME = 'GoA ROM 3 Drive Mod'
LUAGUI_AUTH = 'Codename_Geek'
LUAGUI_DESC = 'A lua mod to use in conjunction with the GoA. Forces 3 Drive start unless R1 is held during Dream Weapon Selection.'

function _OnInit()
	print('3 Drive GoA Mod')
	GoAOffset = 0x7C
	if (GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301) and ENGINE_TYPE == "ENGINE" then --PCSX2
		if ENGINE_VERSION < 3.0 then
			print('LuaEngine is Outdated. Things might not work properly.')
		end
		Now = 0x032BAE0 --Current Location
		Slot1    = 0x1C6C750 --Unit Slot 1
	elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
		if ENGINE_VERSION < 5.0 then
			ConsolePrint('LuaBackend is Outdated. Things might not work properly.',2)
		end
		Now = 0x0714DB8 - 0x56454E
			Slot1    = 0x2A20C58 - 0x56450E
	end
end

function Events(M,B,E) --Check for Map, Btl, and Evt
    return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
end

originalDrive = -1
lastNewInput = -1
lastInput = -1
toggleDriveCount = false
function _OnFrame()
	Place  = ReadShort(Now+0x00)
	Map    = ReadShort(Now+0x04)
	Btl    = ReadShort(Now+0x06)
	Evt    = ReadShort(Now+0x08)

	--record last input for toggle
	local input = ReadInt(0x29F89B0 - 0x56450E)
	if input ~= lastInput then
		lastInput = input
		if input ~= 0 then
			lastNewInput = input
			--ConsolePrint(lastNewInput)
			if lastNewInput & 2048 == 2048 then
				toggleDriveCount = not toggleDriveCount
			end
		end
	end

	if Place == 0x2002 and Events(0x01,Null,0x01) then --Station of Serenity Weapons
		--Get the drive count the Original GoA starts with. Done so it's compatible with 0 drive start GoA
		if originalDrive == -1 then
			originalDrive = ReadByte(Slot1+0x1B2)
			ConsolePrint(originalDrive)
		end
		--Starting Drive
	    WriteByte(Slot1+0x1B0,100) --Starting Drive %
	    WriteByte(Slot1+0x1B1,3)   --Starting Drive Current
	    WriteByte(Slot1+0x1B2,3)   --Starting Drive Max
		--if toggleDriveCount then
		--	WriteByte(Slot1+0x1B1,originalDrive)   --Starting Drive Current
	    --	WriteByte(Slot1+0x1B2,originalDrive)   --Starting Drive Max
		--end
    end
end