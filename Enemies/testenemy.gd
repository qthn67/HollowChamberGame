extends Node2D

@onready var health_element = $HealthElement

@onready var hp_bar = $EnemyContainer/HpBar
@onready var combat = $"../.."
		
func _process(delta):
	hp_bar.value = health_element.current_hp
	
func take_turn():
	combat.health_element.damage(20)
	#combat.health_element.bleed(duration)

func _on_texture_button_pressed():
	if combat.can_select_enemy == true:
		health_element.damage(combat.player_bullet_damage)
		combat.can_select_enemy = false
		
		if combat.use_bullets == true:
			combat.loaded_bullets -= 1
			
		if combat.is_knife == true:
			combat.left_melee_hits -= 1
			
		if combat.is_knife == true && health_element.current_hp <= 0:
			combat.bonus_turn_amount += 1
			queue_free()
		elif(health_element.current_hp <= 0):
			queue_free()
