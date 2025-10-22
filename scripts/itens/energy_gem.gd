extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var energy: float

func _on_body_entered(body: Node2D) -> void:
	animation_player.play("pick_up")
	
	#if body.name == "Player" and body.type_of_body == TYPE_TRANSFORM.HUMAN:
	body.update_energy(energy)
