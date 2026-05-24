' Shared screen-lifecycle setup. Each component that extends BaseScreen MUST define
' its own sub init() and call baseScreenInit() as the first line.
' Example:
'   sub init()
'       baseScreenInit()
'       m.myList = m.top.findNode("myList")
'       ...
'   end sub
sub baseScreenInit()
    ' Setting visible=false is load-bearing: Roku's Group defaults to visible=true,
    ' so without this the observer below would never fire on first show (no false→true
    ' transition). It also prevents a one-frame flash of default content. Don't remove.
    m.top.visible = false
    m.top.observeField("visible", "baseScreenOnVisibleChange")
end sub

sub baseScreenOnVisibleChange(obj)
    visible = obj.getData()
    if visible
        onScreenVisible()
    else
        onScreenHidden()
    end if
end sub

' default no-op hooks; subclasses override by redeclaring
sub onScreenVisible()
end sub

sub onScreenHidden()
end sub
