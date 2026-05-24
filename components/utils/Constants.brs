' Single source of truth for magic strings used across the channel.
' Grouped by purpose; reference with e.g. Const().key.back
function Const() as object
    return {
        key: {
            back: "back"
            up: "up"
            down: "down"
            left: "left"
            right: "right"
            ok: "OK"
            replay: "replay"
            play: "play"
            playOnly: "playonly"
            rewind: "rewind"
            fastForward: "fastforward"
            options: "options"
            pause: "pause"
            channelUp: "channelup"
            channelDown: "channeldown"
        }
        path: {
            messages: "pkg:/components/data/messages.json"
            requirements: "pkg:/components/data/requirements.json"
            themes: "pkg:/components/data/themes.json"
        }
        registry: {
            theme: "theme"
        }
        beacon: {
            dialogInitiate: "AppDialogInitiate"
            dialogComplete: "AppDialogComplete"
            launchComplete: "AppLaunchComplete"
        }
        dialog: {
            messageTextStyle: "bold"
            messageFontSize: 32
            helpFontSize: 29
        }
    }
end function
