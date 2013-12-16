land_vehicles = {}
function AddVehicle(id)
	land_vehicles[id] = true
end
AddVehicle(1)
AddVehicle(2)
AddVehicle(4)
AddVehicle(7)
AddVehicle(8)
AddVehicle(9)
AddVehicle(10)
AddVehicle(11)
AddVehicle(12)
AddVehicle(13)
AddVehicle(15)
AddVehicle(18)
AddVehicle(21)
AddVehicle(22)
AddVehicle(23)
AddVehicle(26)
AddVehicle(29)
AddVehicle(31)
AddVehicle(32)
AddVehicle(33)
AddVehicle(35)
AddVehicle(36)
AddVehicle(40)
AddVehicle(41)
AddVehicle(42)
AddVehicle(43)
AddVehicle(44)
AddVehicle(46)
AddVehicle(47)
AddVehicle(48)
AddVehicle(49)
AddVehicle(52)
AddVehicle(54)
AddVehicle(55)
AddVehicle(56)
AddVehicle(60)
AddVehicle(61)
AddVehicle(63)
AddVehicle(66)
AddVehicle(68)
AddVehicle(70)
AddVehicle(71)
AddVehicle(72)
AddVehicle(73)
AddVehicle(74)
AddVehicle(76)
AddVehicle(77)
AddVehicle(78)
AddVehicle(79)
AddVehicle(83)
AddVehicle(84)
AddVehicle(86)
AddVehicle(87)
AddVehicle(89)
AddVehicle(90)
AddVehicle(91)
AddVehicle(5)
AddVehicle(6)
AddVehicle(16)
AddVehicle(19)
AddVehicle(25)
AddVehicle(27)
AddVehicle(28)
AddVehicle(38)
AddVehicle(45)
AddVehicle(50)
AddVehicle(69)
AddVehicle(80)
AddVehicle(88)
AddVehicle(53)

local timer = Timer()
local nos_enabled = true

function InputEvent( args )
	if window_open then
		return false
	end

	if not nos_enabled then return true end

	if LocalPlayer:InVehicle() and 
		LocalPlayer:GetState() == PlayerState.InVehicle and 
		IsValid(LocalPlayer:GetVehicle()) and
		timer:GetSeconds() > 0.2 and 
		LocalPlayer:GetWorld() == DefaultWorld and
		land_vehicles[LocalPlayer:GetVehicle():GetModelId()] then
		
		if Game:GetSetting( GameSetting.GamepadInUse ) == 1 then
			if args.input == Action.VehicleFireLeft then
				Network:Send("Boost", true)
				timer:Restart()
			end
		else
			if args.input == Action.PlaneIncTrust then
				Network:Send("Boost", true)
				timer:Restart()
			end
		end

	end
end

function RenderEvent()
	if not nos_enabled then return end
	if LocalPlayer:InVehicle() and LocalPlayer:GetState() ~= PlayerState.InVehicle then return end
	if not IsValid(LocalPlayer:GetVehicle()) then return end
	if land_vehicles[LocalPlayer:GetVehicle():GetModelId()] == nil then return end
	if LocalPlayer:GetWorld() ~= DefaultWorld then return end

	local boost_text = "Boost Lite - /boost to toggle"
	local boost_size = Render:GetTextSize( boost_text )

	local boost_pos = Vector2( 
		(Render.Width - boost_size.x)/2, 
		Render.Height - boost_size.y )

	Render:DrawText( boost_pos, boost_text, Color( 255, 255, 255 ) )
end

function LocalPlayerChat( args )
	if args.text == "/boost" then
		SetWindowOpen( not GetWindowOpen() )
	end
end

function CreateSettings()
    window_open = false

    window = Window.Create()
    window:SetSize( Vector2( 300, 100 ) )
    window:SetPosition( (Render.Size - window:GetSize())/2 )

    window:SetTitle( "Boost Settings" )
    window:SetVisible( window_open )
    window:Subscribe( "WindowClosed", function() SetWindowOpen( false ) end )

    local enabled_checkbox = LabeledCheckBox.Create( window )
    enabled_checkbox:SetSize( Vector2( 300, 20 ) )
    enabled_checkbox:SetDock( GwenPosition.Top )
    enabled_checkbox:GetLabel():SetText( "Enabled" )
    enabled_checkbox:GetCheckBox():SetChecked( nos_enabled )
    enabled_checkbox:GetCheckBox():Subscribe( "CheckChanged", 
        function() nos_enabled = enabled_checkbox:GetCheckBox():GetChecked() end )
end

function GetWindowOpen()
    return window_open
end

function SetWindowOpen( state )
    window_open = state
    window:SetVisible( window_open )
    Mouse:SetVisible( window_open )
end

function ModulesLoad()
	Events:FireRegisteredEvent( "HelpAddItem",
        {
            name = "Boost",
            text = 
                "The boost lets you increase the speed of your car/boat.\n\n" ..
                "To use it, tap Shift on a keyboard, or the LB button " ..
                "on controllers.\n\n" ..
                "To disable the script, type /boost into chat."
        } )
end

function ModuleUnload()
    Events:FireRegisteredEvent( "HelpRemoveItem",
        {
            name = "Boost"
        } )
end

CreateSettings()

Events:Subscribe("LocalPlayerChat", LocalPlayerChat)
Events:Subscribe("Render", RenderEvent)
Events:Subscribe("LocalPlayerInput", InputEvent)
Events:Subscribe("ModulesLoad", ModulesLoad)
Events:Subscribe("ModuleUnload", ModuleUnload)