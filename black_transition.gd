extends Node2D

@export var player: CharacterBody2D
@export var camera: Camera2D
var enter_trans = true
var exit_trans = false
var combat_leave= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(enter_trans == true and modulate.a > 0):
		modulate = Color(1, 1, 1, modulate.a - delta)
		print("fading to clear")
	else:
		if(combat_leave == false):
			enter_trans = false
		elif(combat_leave == true):
			exit_trans = true
		
	if(exit_trans == true and modulate.a <= 1):
		print("fading to black")
		modulate = Color(1, 1, 1, modulate.a + delta)
	else:
		exit_trans = false
