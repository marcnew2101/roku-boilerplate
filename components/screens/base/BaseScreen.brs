' Each component extending BaseScreen MUST define its own init() and call baseScreenInit() first. Example:
'   sub init()
'       baseScreenInit()
'       m.myList = m.top.findNode("myList")
'       ...
'   end sub
sub baseScreenInit()
    ' visible=false is load-bearing — the observer needs a false→true transition to
    ' fire onScreenVisible on first show (see README). Don't remove.
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
