extends Enemy

@onready var hitbox: Area2D = get_node("Hitbox")

#func _process(delta: float) -> void:
#	hitbox.knockback_direction = velocity.normalized()

func _ready() -> void:
	if hitbox:
		# Conecta o sinal 'body_entered' do hitbox para a função _on_body_entered
		hitbox.connect("body_entered", Callable(self, "_on_body_entered"))

	# Garante que a lógica de inicialização de Enemy também seja executada
	super._ready()

func _process(delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Aplica o dano ao jogador.
		body.take_damage(5, velocity.normalized(), 0)

		# Mudar o estado para "dead" antes de destruir o drone.
		# A máquina de estados vai cuidar de chamar a animação "dead".
		state_machine.set_state(state_machine.states.kamicaze)

		# Aguarda a animação de morte terminar antes de remover o drone.
		await get_node("AnimationPlayer").animation_finished
		
		# Destrói a instância do drone (inimigo)
		#self.queue_free()
