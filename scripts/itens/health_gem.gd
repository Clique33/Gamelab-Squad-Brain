extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var health: float

func _on_body_entered(body: Node2D) -> void:
	animation_player.play("pick_up")
	
	if body.name == "Player":
		body.update_health(health)
