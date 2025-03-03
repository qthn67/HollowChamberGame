extends Node2D

@onready var hp_bar = $EnemyContainer/HpBar
@onready var combat = $"../.."

@onready var max_hp : int = 100
@onready var hp : int = 100


func _process(delta):
	hp_bar.value = hp
		
		
func _on_texture_button_pressed():
	if combat.can_select_enemy == true:
		hp -= combat.player_bullet_damage
		combat.can_select_enemy = false
		
		if combat.use_bullets == true:
			combat.loaded_bullets -= 1
			
		if combat.is_knife == true:
			combat.left_melee_hits -= 1
			
		if combat.is_knife == true && hp <= 0:
			combat.bonus_turn_amount += 1
			queue_free()
		elif(hp <= 0):
			queue_free()
