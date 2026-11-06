class_name LuzJugador
extends OmniLight3D
## Tarea C, nivel 1. La luz que acompaña al jugador.
## Es HIJA del Bloque, así que se mueve con él sin que nadie la mueva por código:
## por eso esta clase no tiene _process.
## En Hielo Fino: el brillo azul (#2E86DE) del bloque, con alcance de 2 m.

@export var rango := 2.0            # m: hasta dónde alumbra (Range del Inspector)
@export var altura := 1.0           # m sobre los pies del bloque (su centro)
@export var imprimir_pruebas := false


func _ready() -> void:
	position = Vector3(0.0, altura, 0.0)   # relativa al Jugador: queda encima de sus pies
	omni_range = rango
	omni_attenuation = 2.0                 # la que se parece a 1/d²
	if imprimir_pruebas:
		# Nivel 1: deben salir 1, 0.25 y 0.0625.
		print("atenuacion: ", atenuacion(1.0), " ", atenuacion(2.0), " ", atenuacion(4.0))
		# Nivel 3: deben salir 1.0 y 0.0794.
		print("blinn_phong: ",
			blinn_phong(Vector3(0, 1, 0), Vector3(0, 1, 1), Vector3(0, 1, -1), 32.0), " ",
			blinn_phong(Vector3(0, 1, 0), Vector3(0, 1, 1), Vector3(0, 1, 0), 32.0))


## Función pura: cuánta luz llega a distancia d. No toca la escena.
## maxf(d, 0.0001) evita dividir por cero cuando la distancia es 0.
static func atenuacion(d: float, exponente: float = 2.0) -> float:
	return 1.0 / pow(maxf(d, 0.0001), exponente)


## Función pura: el brillo de una superficie lisa (Blinn-Phong).
## h es el vector medio entre la luz y el ojo; con brillo grande el punto es pequeño y nítido.
static func blinn_phong(normal: Vector3, hacia_luz: Vector3,
		hacia_ojo: Vector3, brillo: float) -> float:
	var n := Vectores.normalizar(normal)
	var l := Vectores.normalizar(hacia_luz)
	var v := Vectores.normalizar(hacia_ojo)
	var h := Vectores.normalizar(l + v)
	return pow(maxf(0.0, n.dot(h)), brillo)   # negativo = la luz llega por detrás: 0
