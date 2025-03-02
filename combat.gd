extends Control

@onready var temp_bullet_counter = $TempBulletCounter
@onready var temp_loaded_bullet_counter = $TempLoadedBulletCounter

@onready var bonus_turn_bar = $BonusTurnBar
@onready var player_hp_bar = $PlayerHpBar

@onready var options = $Options
@onready var gun_options = $GunOptions

var can_select_enemy : bool = false
var use_bullets : bool = false

var player_bullet_damage : int = 20
var max_player_ammo : int = 32
var player_ammo : int = 32
var loaded_bullets : int = 0
var player_hp : int = 100
var bonus_turn_amount : int = 0

func _process(_delta):
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
	can_select_enemy = false
	
	gun_options.visible = true
	options.visible = false
	

func _on_chant_pressed():
	can_select_enemy = false
	

func _on_melee_pressed():
	use_bullets = false
	can_select_enemy = true
	

func _on_murder_pressed():
	use_bullets = true
	can_select_enemy = true

func _on_pass_pressed():
	can_select_enemy = false
	
	loaded_bullets -= 1
	if bonus_turn_amount < 10:
		bonus_turn_amount += 1

func _on_shoot_self_pressed():
	can_select_enemy = false
	
	player_hp -= player_bullet_damage
	loaded_bullets -= 1

func _on_back_pressed():
	can_select_enemy = false
	
	gun_options.visible = false
	options.visible = true
	
