extends HSlider

@export var audio_bus_name: String
var audio_bus_id: int
var db: int # Saves converted db value, goes from 0 to 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	
	
func _on_value_changed(value: float) -> void:
	db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
