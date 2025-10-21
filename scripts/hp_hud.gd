extends Node2D

@onready var hp_bar = $CanvasLayer/hp_bar
@onready var energy_bar = $CanvasLayer/energy_bar
@onready var VictoryCountersd: Label = $CanvasLayer/VictoryCounter


func energy_bar_update(value: int):
	energy_bar.value = value


func hp_bar_update(value: int) -> void:
	hp_bar.value = value

func _process(delta: float) -> void:
	VictoryCounter.text = "%d / 3" % Global.victories
