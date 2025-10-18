extends Node2D

var current_scene: String = "world"

@onready var player: CharacterBody2D = $Environment/Player
@onready var hp_hud: Node2D = $Environment/hp_hud

func _ready() -> void:
	if Global.last_world_positioin != Vector2.ZERO:
		player.position = Global.last_world_positioin + Vector2(0, 2)
		
		hp_hud.hp_bar_update(Global.health)
		player.health = Global.health
		
		# hp_hud.energy_bar_update(Global.energy)
		# player.energy = Global.energy


func _on_cave_montain_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		change_scene("montain")


func _on_cave_plaines_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):	
		change_scene("plaines")


func change_scene(change_to: String) -> void:
	Global.last_world_positioin = player.position
	
	Global.health = player.health
	
	# Global.energy = player.energy
	
	match change_to:
		"montain":
			get_tree().change_scene_to_file("res://scenes/cave_montain.tscn")
		"plaines":
			get_tree().change_scene_to_file("res://scenes/cave_plaines.tscn")
