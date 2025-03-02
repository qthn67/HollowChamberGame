extends Node2D

@onready var hp_bar = $EnemyContainer/HpBar
@onready var combat = $"../.."

@onready var max_hp : int = 100

var hp : int = 100

func _process(delta):
	hp_bar.value = hp
	if hp <= 0:
		$".".visible = false

	
func _on_texture_button_pressed():
	if combat.can_select_enemy == true:
		hp -= combat.player_bullet_damage
		combat.can_select_enemy = false
		combat.loaded_bullets -= 1
