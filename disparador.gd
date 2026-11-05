class_name Disparador
extends Area3D
## Tarea B, nivel 2. Representa una mecánica mientras no existe: avisa con una señal.
## En Hielo Fino: "una casilla se rompe al salir". No conoce ninguna luz.

signal evento(posicion: Vector3)

@export var tecla := KEY_T
@export var que_representa := "una casilla se rompe al salir"

var antes := false


func _enter_tree() -> void:
	add_to_group("disparadores")   # el grupo que escucha SistemaEventos


func _ready() -> void:
	body_entered.connect(func(_cuerpo: Node3D) -> void: evento.emit(global_position))


func _physics_process(_delta: float) -> void:
	var ahora := Input.is_key_pressed(tecla)
	if ahora and not antes:
		evento.emit(global_position)
	antes = ahora
