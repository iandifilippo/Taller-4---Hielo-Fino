class_name SistemaSol
extends Node

signal cambio_noche(es_noche: bool) # AVISO DE NOCHE

@export var sol: DirectionalLight3D # LA LUNA
@export var entorno: WorldEnvironment # NIEBLA AZUL
@export var energia_sol := 1.0
@export var azimut := -30.0 # HACIA DONDE CAEN SOMBRAS
@export var ambiente_dia := 1.0
@export var ambiente_noche := 0.2

@onready var ciclo: CicloDia = $CicloDia

var era_noche := false # ESTADO DEL FRAME ANTERIOR

func _ready() -> void:
	aplicar_hora()
	era_noche = CicloDia.factor_sol(ciclo.hora) <= 0.0
	cambio_noche.connect(func(n): print("noche: ", n, " a las ", snappedf(ciclo.hora, 0.1))) # PRUEBA

func _process(delta: float) -> void:
	ciclo.avanzar(delta)
	aplicar_hora()
	var es_noche := CicloDia.factor_sol(ciclo.hora) <= 0.0
	if es_noche != era_noche: # SOLO SI CAMBIA
		era_noche = es_noche
		cambio_noche.emit(es_noche)

func aplicar_hora() -> void:
	var h := ciclo.hora
	var f := CicloDia.factor_sol(h)
	sol.rotation_degrees = Vector3(-CicloDia.elevacion(h), azimut, 0.0) # X NEGATIVA = APUNTA ABAJO
	sol.light_energy = energia_sol * f
	sol.light_color = CicloDia.color_sol(h)
	entorno.environment.ambient_light_energy = lerpf(ambiente_noche, ambiente_dia, f) # NOCHE -> DIA

static func lambert(normal: Vector3, hacia_luz: Vector3) -> float:
	var n := Vectores.normalizar(normal)
	var l := Vectores.normalizar(hacia_luz)
	return maxf(0.0, n.dot(l)) # NEGATIVO = LUZ POR DETRAS

func prediccion_piso() -> float:
	var hacia_luz := sol.global_transform.basis.z # LUZ VA A -Z
	var rojo := sol.light_color.srgb_to_linear().r # GODOT ILUMINA EN LINEAL
	return sol.light_energy * rojo * lambert(Vector3.UP, hacia_luz)

func prediccion_piso_sin_convertir() -> float:
	var hacia_luz := sol.global_transform.basis.z
	return sol.light_energy * sol.light_color.r * lambert(Vector3.UP, hacia_luz) # FORMULA DE LA GUIA
