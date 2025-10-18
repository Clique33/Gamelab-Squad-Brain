extends Node2D

var current_scene: String = "cave_plaines"
var change_scene: bool = false

@onready var player: CharacterBody2D = $Enviroment/Player
@onready var hp_hud: Node2D = $Enviroment/hp_hud

func _ready() -> void:		
	hp_hud.hp_bar_update(Global.health)
	player.health = Global.health
	
	# hp_hud.energy_bar_update(Global.energy)
	# player.energy = Global.energy

func _on_world_plaines_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		change_scene = true
		
		if current_scene == "cave_plaines":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
