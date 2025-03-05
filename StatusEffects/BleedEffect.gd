extends StatusEffect
class_name BleedEffect

var bleed_stack : int = 0

func _init(turns: int):
	super._init("Bleeding", turns, true)
	bleed_stack = turns
	
func apply_effect():
	target.health_element.damage(5*bleed_stack)
