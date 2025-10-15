extends Node2D

@onready var hp_bar = $CanvasLayer/hp_bar
@onready var energy_bar = $CanvasLayer/energy_bar


func energy_bar_update(value: int):
	energy_bar.value = value


func hp_bar_update(value) -> void:
	hp_bar.value = value
