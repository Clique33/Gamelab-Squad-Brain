extends Node2D

var maxhp = 100
var hp = 100
var maxen = 100
var en = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dano"):
		hp -= 10
		if hp < 0:
			hp = 0
		
	else:
		hp += 1*delta
		if hp > 100:
			hp = 100
	if Input.is_action_just_pressed("atacar"):
		en -= 10
		if en < 0:
			en = 0
	else:
		en += 1*delta
		if en > 100:
			en = 100
