extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(target_scene: String) -> void:
	animation_player.play("fade_in")
	
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file(target_scene)
	
	animation_player.play_backwards("fade_in")
	
	if get_tree().paused:
		get_tree().paused = false


func first_fade() -> void:
	animation_player.play_backwards("fade_in")
	
	await animation_player.animation_finished
