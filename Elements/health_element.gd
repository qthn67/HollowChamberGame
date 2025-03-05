extends Node2D

@export var max_hp : int = 100
var current_hp

func _ready():
	current_hp = max_hp

func _process(delta):
	if current_hp > max_hp:
		current_hp = max_hp

func damage(damage):
	current_hp -= damage

func heal(heal):
	current_hp += heal
