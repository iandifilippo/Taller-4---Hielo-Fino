class_name CicloDia
extends Node

const NARANJA := Color(0.0431, 0.1020, 0.1804) # COLOR BAJO #0B1A2E REVISAR???

@export var hora := 9.0 # LUNA A 45° - REVISAR ESTA PARTE
@export var duracion_dia := 48.0 # SEG POR DIA
@export var pausado := true # LUZ FIJA BIEN

func avanzar(dt: float) -> void:
	if not pausado:
		hora = fposmod(hora + 24.0 * dt / duracion_dia, 24.0) # VUELVE A 0 TRAS 24 BIEN

static func elevacion(h: float) -> float:
	return (h - 6.0) * 15.0 # 6H = 0°, 12H = 90° BIEN 

static func factor_sol(h: float) -> float:
	return maxf(0.0, sin(deg_to_rad(elevacion(h)))) # SENO, NUNCA NEGATIVO

static func color_sol(h: float) -> Color:
	return NARANJA.lerp(Color.WHITE, factor_sol(h)) # BAJO -> BLANCO
