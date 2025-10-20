extends Area2D

const RIGHT: Vector2 = Vector2.RIGHT
@export var speed: int = 200
var movement: Vector2


func _physics_process(delta: float) -> void:
	movement = RIGHT.rotated(rotation) * speed * delta
	
	global_position += movement
	


func destroy() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.update_health(-5)
		
		destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
