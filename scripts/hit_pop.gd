extends Area2D

@export var dialog_texts : Array[String] = []
@export var offset_position : Vector2 = Vector2(0,-180)

func _on_body_entered(body: Node2D) -> void:
	DialogManager.start_dialog(dialog_texts, global_position + offset_position)
	
