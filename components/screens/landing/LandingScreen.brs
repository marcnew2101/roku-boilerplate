sub init()
    m.top.observeField("visible", "screenVisible")
end sub

sub screenVisible(obj)
    visible = obj.getData()
    if visible then ? "LandingScreen is now visible"
end sub