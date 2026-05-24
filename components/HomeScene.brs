sub init()
    ' cache the root Scene; util scripts use m.scene instead of m.top.getScene()
    m.scene = m.top.getScene()
    ' setTheme(true) applies default; pass {"type":"light","color":"red"} matching /components/data/themes.json to override
    setTheme(true)
    ' setRequirements(true) enforces /components/data/requirements.json; bump minVersion there to test the OS-update error path
    requirements = setRequirements(false)
    if requirements then startApp()
end sub

sub startApp()
    initScreenStack()
    ' see README for addScreen() arguments
    addScreen("LandingScreen")
end sub

