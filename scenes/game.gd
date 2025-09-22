extends Node

@export var main_character: PackedScene

func _ready():
	var main_character_instance = main_character.instantiate()
	add_child(main_character_instance)
