extends Polygon2D

class_name colorful_interactable_box

@export var interactable_component: PackedScene

func _ready():
	var interactable_component_instance: Interactable = interactable_component.instantiate()
	add_child(interactable_component_instance)
	interactable_component_instance.interacted.connect(swap_color)

func swap_color():
	self.color = Color.hex(randi())
