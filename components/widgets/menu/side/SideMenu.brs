sub init()
    ? "initiating side menu"
    m.menulist = m.top.findNode("menuList")
end sub
sub onContentChanged(obj)
    menuItems = obj.getData()
    focusedTargetSet = createObject("roSGNode", "TargetSet")
    m.menulist.focusedTargetSet = [ focusedTargetSet ]
    targetRects = []
    y = 0
    for each item in menuItems.getChildren(-1, 0)
        tempLabel = createObject("roSGNode", "Label")
        tempLabel.text = item.title
        height = tempLabel.boundingRect().height
        width = tempLabel.boundingRect().width
        targetRects.push({"x": 0, "y": y, "height": height, "width": width})
        y += height
    end for
    focusedTargetSet.targetRects = targetRects
end sub