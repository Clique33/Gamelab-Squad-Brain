extends HSlider

var audio_bus_music_id: int
var audio_bus_sfx_id: int
var db: float # Saves converted db value, goes from 0 to 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_bus_music_id = AudioServer.get_bus_index("Music")
	audio_bus_sfx_id = AudioServer.get_bus_index("SFX")
	
func _on_music_volume_value_changed(new_volume: float) -> void:
	db = linear_to_db(new_volume)
	AudioServer.set_bus_volume_db(audio_bus_music_id, db)


func _on_sfx_volume_value_changed(new_volume: float) -> void:
	db = linear_to_db(new_volume)
	AudioServer.set_bus_volume_db(audio_bus_sfx_id, db)
