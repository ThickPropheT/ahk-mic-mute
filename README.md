# ahk-mic-mute
An AutoHotkey script used to map hotkeys to microphone muting/unmuting operations.

Relies on the [Vista Audio Control Functions Library](https://github.com/ahkscript/VistaAudio) to get and set microphone mute state (see [./Lib/VA/README.md](https://github.com/ThickPropheT/ahk-mic-mute/tree/59cc8767a8a1bd7e69b89cc94731714d1b3cb076/Lib/VA)).

## Defaults & Assumptions
- Assumes `device_desc` to be `"capture"` and `subunit_desc` to be `unset` (see [VistaAudio VA_SetMute docs](https://ahkscript.github.io/VistaAudio/#VA_SetMute))
	- If the script crashes or does not correctly mute your mic, you will have to tinker with these values. Good luck.
		- `device_desc`: There are several formats you can use here. See [the docs](https://ahkscript.github.io/VistaAudio/#VA_GetDevice) to get an idea of what those might be.
    		- `subunit_desc`: Once again, there are several supported formats. See [the docs](https://ahkscript.github.io/VistaAudio/#VA_FindSubunit) for more info. In my experience, this isn't as important as `device_desc`, so I would leave this one `unset` unless you've exhausted all other options.
  		- [This](https://www.autohotkey.com/docs/v1/lib/SoundSet.htm#Soundcard) scans your input & output devices and _may_ be helpful in identifying what values to use for `device_desc` & `subunit_desc`. It didn't work for me, but YMMV.
- `NumLock` bound by default
	- On key-press: toggle mute
	- On key-held (default hold duration is `250 ms`): push-to-talk
- ToolTip enabled by default with display duration of `750 ms`

## Based On
[mute-mic.ahk](https://gist.github.com/airstrike/5cb66c97a288efdb578a) by Andy Terra <[github.com/airstrike](github.com/airstrike)>

## Further Reading
- [Vista Audio Control Functions Library Docs](https://ahkscript.github.io/VistaAudio/)
- [Remapping Keys Reference](https://www.autohotkey.com/docs/v2/misc/Remap.htm)
- [`SoundSet/SoundGet` Reference](https://www.autohotkey.com/docs/commands/SoundSet.htm)
- [`SoundSet/SoundGet` Example](https://www.reddit.com/r/AutoHotkey/comments/uiyfz8/toggle_mute_script_help/)
