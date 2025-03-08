extends StatusEffect
class_name FractureEffect

var max_hp_loss : int = 0

func _init(amount: int):
	super._init("Fracture", -1, false)
	max_hp_loss = amount

func apply_effect():
	target.health_element.max_hp -= max_hp_loss
	if target.health_element.current_hp > target.health_element.max_hp:
		target.health_element.current_hp = target.health_element.max_hp
