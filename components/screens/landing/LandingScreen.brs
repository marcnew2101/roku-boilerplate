sub init()
    ' node identifiers
    m.labelList = m.top.findNode("landingLabelList")

    ' node observers
    m.top.observeField("visible", "screenVisible")
end sub

sub screenVisible(obj)
    visible = obj.getData()
    if (visible)
        ? "LandingScreen is now visible"
    end if
end sub