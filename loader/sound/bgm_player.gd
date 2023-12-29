class_name BGMPlayer extends AudioStreamPlayer
## Manages background music.
##
## Extends the [AudioStreamPlayer] to allow pausing and resuming.
## The [member sound_toggle] property also makes it possible for the [Settings] node
## to enable or disable background music.
## To play an audio stream from the beginning the next time [member sound_toggle] is on,
## call [method reset_stream] first.

## Position on a music track from where the playback is paused or resumed,
## see [method AudioStreamPlayer.play]
var playback_position: float = 0.0

## Resumes or pauses the playback
## when this property is set to on or off respectively.
var sound_toggle: bool = true:
	set(mode):
		sound_toggle = mode
		if mode: resume()
		else: pause()


## Stops the playback.
func pause():
	playback_position = get_playback_position()
	stop()


## Resumes from the playback position that was previously paused at
## or, if [method reset_stream] had been called first, plays it from the beginning.
func resume():
	play(playback_position)


## Assigns a new [AudioStream] loaded from the given new_audio_stream_path
## to this [AudioStreamPlayer].
## Also plays it from the beginning if [member sound_toggle] is on.
func update_stream(new_audio_stream_path: String):
	if ResourceLoader.exists(new_audio_stream_path):
		var new_audio_stream: AudioStream = load(new_audio_stream_path)
		if not stream == new_audio_stream:
			set_stream(new_audio_stream)
			if sound_toggle:
				play()
	else:
		set_stream(null)


## Restarts the playback for when the next time [method resume] is called.
func reset_stream():
	if is_instance_valid(stream):
		playback_position = 0.0
