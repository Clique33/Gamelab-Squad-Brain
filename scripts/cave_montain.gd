extends Node2D

@onready var player: CharacterBody2D = $Enviroment/Player
@onready var hp_hud: Node2D = $Enviroment/hp_hud

var current_scene: String = "cave_montain"
var change_scene: bool = false


func _ready() -> void:
	hp_hud._on_health_update(Global.health)
	player.health = Global.health
	
	hp_hud._on_energy_update(Global.energy)
	player.energy = Global.energy


func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("Enemy").size() == 0:
		Global.block_cave_montains = true


func _on_world_montain_top_body_entered(body: Node2D) -> void:
	Global.health = player.health
	
	Global.energy = player.energy
	
	if body.is_in_group("Player"):
		change_scene = true
		
		if current_scene == "cave_montain":
			TransitionScene.change_scene("res://scenes/world.tscn")
