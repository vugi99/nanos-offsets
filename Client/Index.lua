
OFFSETS_UI = WebUI(
    "Offsets UI",
    "file:///ui/index.html",
    true,
    true,
    true
)

OFFSETS_UI:Subscribe("UpdateOffsets", function(...)
    Events.CallRemote("UpdateOffsets_Remote", ...)
end)

OFFSETS_UI:Subscribe("ASM", function(...)
    Events.CallRemote("ASM_Remote", ...)
end)

OFFSETS_UI:Subscribe("ALight", function(...)
    Events.CallRemote("ALight_Remote", ...)
end)

OFFSETS_UI:Subscribe("ADestroy", function()
    Events.CallRemote("ADestroy_Remote")
end)

local m_enabled = false

Input.Register("Toggle Mouse", "K")

Input.Bind("Toggle Mouse", InputEvent.Pressed, function()
    m_enabled = not m_enabled
    Client.SetMouseEnabled(m_enabled)
    Client.SetInputEnabled(not m_enabled)
    if m_enabled then
        OFFSETS_UI:BringToFront()
        OFFSETS_UI:SetFocus()

    end
end)