extends Node2D

var current_scene: String = "cave_montain"
var change_scene: bool = false


func _on_world_montain_top_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		change_scene = true
		
		if current_scene == "cave_montain":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
