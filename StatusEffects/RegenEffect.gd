extends StatusEffect
class_name RegenEffect

func _init(turns: int):
	super._init("Regen", turns, false)

func apply_effect():
	target.health_element.heal(5)
