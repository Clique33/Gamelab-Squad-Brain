extends Control

@onready var pause_menu: Control = $"."
@onready var pause_buttons: VBoxContainer = $PauseButtons
@onready var options: Panel = $Options

func _ready() -> void:
	pause_menu.visible = false
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func pause() -> void:
	if pause_buttons.visible == false:
		_on_back_options_pressed()
	
	get_tree().paused = true
	
	pause_menu.visible = true


func resume() -> void:
	get_tree().paused = false
	
	pause_menu.visible = false

	
func _on_resume_pressed() -> void:
	resume()
	

func _on_options_pressed() -> void:
	pause_buttons.visible = false
	options.visible = true
	
	
func _on_back_options_pressed() -> void:
	options.visible = false
	pause_buttons.visible = true
	

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	TransitionScene.change_scene("res://scenes/ui/main_menu.tscn")
	
	
func _on_exit_pressed() -> void:
	get_tree().quit()
