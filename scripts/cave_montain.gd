extends Node2D

@onready var player: CharacterBody2D = $Enviroment/Player
@onready var hp_hud: Node2D = $Enviroment/hp_hud

var current_scene: String = "cave_montain"
var change_scene: bool = false


func _ready() -> void:		
	hp_hud.hp_bar_update(Global.health)
	player.health = Global.health
	
	hp_hud.energy_bar_update(Global.energy)
	player.energy = Global.energy

func _on_world_montain_top_body_entered(body: Node2D) -> void:
	Global.health = player.health
	
	Global.energy = player.energy
	
	if body.is_in_group("Player"):
		change_scene = true
		
		if current_scene == "cave_montain":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
