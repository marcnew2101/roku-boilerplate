' Shared screen-lifecycle setup. Each component that extends BaseScreen MUST define
' its own sub init() and call baseScreenInit() as the first line.
' Example:
'   sub init()
'       baseScreenInit()
'       m.myList = m.top.findNode("myList")
'       ...
'   end sub
sub baseScreenInit()
    ' cache the root Scene so subclasses and util scripts can use m.scene
    m.scene = m.top.getScene()
    ' hide until shown; the visible observer below dispatches the on*Screen hooks
    m.top.visible = false
    m.top.observeField("visible", "baseScreenOnVisibleChange")
end sub

sub baseScreenOnVisibleChange(obj)
    if obj.getData() then onScreenVisible() else onScreenHidden()
end sub

' default no-op hooks; subclasses override by redeclaring
sub onScreenVisible()
end sub

sub onScreenHidden()
end sub
