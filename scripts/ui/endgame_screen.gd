extends Control

@onready var victory_title: Label = $VictoryTitle
@onready var death_title: Label = $DeathTitle

func _ready() -> void:
	victory_title.visible = false
	

func endgame_victory() -> void:
	death_title.visible = false
	
	victory_title.visible = true

func _on_main_menu_pressed() -> void:
	TransitionScene.change_scene("res://scenes/ui/main_menu.tscn")
	
	
func _on_exit_pressed() -> void:
	get_tree().quit()
