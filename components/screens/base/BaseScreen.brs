sub init()
    ' cache the root Scene; subclasses and util scripts use m.scene instead of m.top.getScene()
    m.scene = m.top.getScene()
    ' hide until shown; subclasses override the hooks below, not init()
    m.top.visible = false
    m.top.observeField("visible", "baseScreenOnVisibleChange")
    onScreenInit()
end sub
sub baseScreenOnVisibleChange(obj)
    if obj.getData() then onScreenVisible() else onScreenHidden()
end sub
' default no-op hooks; subclasses override by redeclaring
sub onScreenInit()
end sub
sub onScreenVisible()
end sub
sub onScreenHidden()
end sub
