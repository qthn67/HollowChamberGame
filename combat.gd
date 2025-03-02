extends Control

@onready var temp_bullet_counter = $TempBulletCounter
@onready var temp_loaded_bullet_counter = $TempLoadedBulletCounter

@onready var bonus_turn_bar = $BonusTurnBar
@onready var player_hp_bar = $PlayerHpBar

@onready var options = $Options
@onready var gun_options = $GunOptions

var can_select_enemy : bool = false

var player_damage : int = 20
var max_player_ammo : int = 32
var player_ammo : int = 32
var loaded_bullets : int = 0
var player_hp : int = 100
var bonus_turn_amount : int = 0

func _process(delta):
	bonus_turn_bar.value = bonus_turn_amount
	player_hp_bar.value = player_hp
	
	temp_bullet_counter.text = str(player_ammo)
	temp_loaded_bullet_counter.text = str(loaded_bullets)
	if loaded_bullets == 0:
		if player_ammo >= 6:
			loaded_bullets += 6
			player_ammo -= 6
		else:
			loaded_bullets = player_ammo
			player_ammo = 0
			
func _on_gun_pressed():
	gun_options.visible = true
	options.visible = false

func _on_chant_pressed():
	pass # Replace with function body.


func _on_murder_pressed():
	can_select_enemy = true

func _on_pass_pressed():
	loaded_bullets -= 1

func _on_shoot_self_pressed():
	player_hp -= player_damage
	loaded_bullets -= 1

func _on_back_pressed():
	gun_options.visible = false
	options.visible = true
	
