extends Node2D

@export var max_hp : int = 100
var current_hp

func _ready():
	current_hp = max_hp

func _process(_delta):
	if current_hp > max_hp:
		current_hp = max_hp

func damage(hp):
	current_hp -= hp

func heal(hp):
	current_hp += hp
