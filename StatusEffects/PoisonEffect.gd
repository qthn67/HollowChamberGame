extends StatusEffect
class_name PoisonEffect

func _init(turns: int):
	super._init("Poison", turns, true)

func apply_effect():
	target.health_element.damage(5)
