extends Node

@export var main_character: PackedScene

func _ready():
	var main_character_instance = main_character.instantiate()
	add_child(main_character_instance)
	var screen_size = main_character_instance.get_viewport_rect().size
	main_character_instance.global_position = screen_size / 2
