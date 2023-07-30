extends AudioStreamPlayer

var playback_position: float = 0.0


func pause():
	playback_position = get_playback_position()
	stop()


func resume():
	play(playback_position)


func update_stream(new_audio_stream_path: String):
	if new_audio_stream_path.is_empty():
		set_stream(null)
	elif FileAccess.file_exists(new_audio_stream_path):
		var new_audio_stream: AudioStream = load(new_audio_stream_path)
		if not stream == new_audio_stream:
			set_stream(new_audio_stream)
			play()
