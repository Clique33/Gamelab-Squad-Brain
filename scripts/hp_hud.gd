extends Node2D


@onready var hp_bar = $CanvasLayer/hp_bar
@onready var energy_bar = $CanvasLayer/energy_bar

#func _ready() -> void:
	#var player = get_node("/root/player")  
	#player.connect("damaged", Callable(self, "_on_player_damaged"))
	#player.connect("attacked", Callable(self, "_on_player_attacked"))
	


func _on_player_attacked(cost):
	energy_bar.value -= cost


func _on_drone_melee_damaged(amount: Variant) -> void:
	hp_bar.value -= amount
