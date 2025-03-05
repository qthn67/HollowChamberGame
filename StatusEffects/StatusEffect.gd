extends Node
class_name StatusEffect

var e_name : String
# -1 duration means it's infinite (or has to be removed with an item)
var duration : int
var stackable : bool
var target : Node2D

func _init(effect_name, turns, can_stack):
	e_name = effect_name
	duration = turns
	stackable = can_stack 

func apply_effect():
	pass
	
func decrease_duration():
	if duration > 0:
		duration -= 1
	return duration != 0
