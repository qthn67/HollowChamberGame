extends StatusEffect
class_name VenomEffect

func _init(turns: int):
	super._init("Venom", turns, false)

func apply_effect():
	target.health_element.damage(5)
