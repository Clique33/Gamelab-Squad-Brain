extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var energy: float

func _on_body_entered(body: Node2D) -> void:
	animation_player.play("pick_up")
	
	if body != null:
		body.update_energy(energy)
