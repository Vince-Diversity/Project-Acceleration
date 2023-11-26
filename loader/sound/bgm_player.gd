class_name BGMPlayer extends AudioStreamPlayer

var playback_position: float = 0.0
var sound_toggle: bool = true:
	set(mode):
		sound_toggle = mode
		if mode: resume()
		else: pause()


func pause():
	playback_position = get_playback_position()
	stop()


func resume():
	play(playback_position)


func update_stream(new_audio_stream_path: String):
	if new_audio_stream_path.is_empty():
		set_stream(null)
	elif ResourceLoader.exists(new_audio_stream_path):
		var new_audio_stream: AudioStream = load(new_audio_stream_path)
		if not stream == new_audio_stream:
			set_stream(new_audio_stream)
			if sound_toggle:
				play()


func reset_stream():
	if is_instance_valid(stream):
		playback_position = 0.0
