class_name LuzParpadeante
extends OmniLight3D
## Tarea B, nivel 1. Luz con vida: parpadea con ruido suave (no con randf).
## En Hielo Fino: el reflejo de la luna en el agua (base 1.5, amplitud 0.4, ruido lento).

@export var energia_base := 2.0
@export var amplitud := 0.3        # 0.3 = sube o baja hasta un 30 %
@export var velocidad := 4.0       # qué tan rápido recorre el ruido
@export var semilla := 7
@export var imprimir_pruebas := false

var ruido := FastNoiseLite.new()
var t := 0.0


func _ready() -> void:
	ruido.seed = semilla
	ruido.frequency = 1.0   # sin esto casi no cambia (viene en 0.01)
	if imprimir_pruebas:
		print(energia(2.0, 0.3, 1.0), " ", energia(2.0, 0.3, ruido.get_noise_1d(0.25 * 4.0)))


func _process(delta: float) -> void:
	t += delta
	light_energy = energia(energia_base, amplitud, ruido.get_noise_1d(t * velocidad))


## Función pura: energía = base × (1 + amplitud × ruido), nunca negativa.
static func energia(base: float, amp: float, valor_ruido: float) -> float:
	return maxf(0.0, base * (1.0 + amp * valor_ruido))
