extends Node2D

@export var player: CharacterBody2D
@export var camera: Camera2D
var enter_trans = true
var exit_trans = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(enter_trans == true and modulate.a > 0):
		modulate = Color(1, 1, 1, modulate.a - delta)
	else:
		enter_trans = false
		
	if(exit_trans == true and modulate.a <= 1):
		modulate = Color(1, 1, 1, modulate.a + delta)
	else:
		exit_trans = false
