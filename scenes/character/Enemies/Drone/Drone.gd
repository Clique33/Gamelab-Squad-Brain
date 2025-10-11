extends Enemy

@onready var hitbox: Area2D = get_node("Hitbox")

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
		state_machine.set_state(state_machine.states.kamicaze)

func _on_enter_area_body_entered(body: Node2D) -> void:
	# É mais seguro verificar pelo grupo "player" do que pelo nome
	if body.is_in_group("player"):
		# Em vez de apenas definir um alvo, nós DAMOS UMA ORDEM para a FSM.
		state_machine.set_state(state_machine.states.chase)
