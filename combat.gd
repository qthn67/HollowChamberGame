extends Control

@onready var temp_bullet_counter = $TempBulletCounter
@onready var temp_loaded_bullet_counter = $TempLoadedBulletCounter

@onready var test_enemy_layout = $TestEnemyLayout

@onready var health_element = $HealthElement

@onready var gun = $Options/Gun
@onready var chant = $Options/Chant
@onready var items = $Options/Items
@onready var melee = $Options/Melee

@onready var murder = $GunOptions/Murder
@onready var pass_turn = $GunOptions/Pass
@onready var shoot_self = $GunOptions/ShootSelf

@onready var bonus_turn_bar = $BonusTurnBar
@onready var player_hp_bar = $PlayerHpBar
@onready var melee_bar = $Options/Melee/MeleeBar

@onready var options = $Options
@onready var gun_options = $GunOptions

var can_select_enemy : bool = false
var use_bullets : bool = false
var is_knife : bool = false

var player_bullet_damage : int = 20
var max_player_ammo : int = 32
var player_ammo : int = 26
var loaded_bullets : int = 6
var bonus_turn_amount : int = 0
var left_melee_hits : int = 2


func battle_start():
#fill with functions that reset all the temporary values when the battle restarts
	pass

func _process(_delta):
#Assign values to bars
	bonus_turn_bar.value = bonus_turn_amount
	player_hp_bar.max_value = health_element.max_hp
	player_hp_bar.value = health_element.current_hp
	melee_bar.value = left_melee_hits
	
#Temporary
	temp_bullet_counter.text = str(player_ammo)
	temp_loaded_bullet_counter.text = str(loaded_bullets)
	
#Disabling Melee if no melee hits are available
	if left_melee_hits == 0:
		melee.disabled = true
		
#Disabling Gun options if no bullets are available
	if loaded_bullets == 0:
		murder.disabled = true
		pass_turn.disabled = true
		shoot_self.disabled = true
		
#End Turn/Reload
	if loaded_bullets == 0 && left_melee_hits == 0:
		end_of_turn()
			
func end_of_turn():
	gun.disabled = true
	chant.disabled = true
	items.disabled = true
	melee.disabled = true
	gun_options.visible = false
	options.visible = true
	
	if player_ammo >= 6:
		loaded_bullets += 6
		player_ammo -= 6
		left_melee_hits = 2
	elif player_ammo < 6:
		loaded_bullets = player_ammo
		player_ammo = 0
		left_melee_hits = 2
	elif player_ammo == 0:
		left_melee_hits = 2
		
	test_enemy_layout.enemy_turn()
	
	murder.disabled = false
	pass_turn.disabled = false
	shoot_self.disabled = false
	gun.disabled = false
	chant.disabled = false
	items.disabled = false
	melee.disabled = false
	
func _on_gun_pressed():
	can_select_enemy = false
	
	gun_options.visible = true
	options.visible = false
	

func _on_chant_pressed():
	can_select_enemy = false
	

func _on_melee_pressed():
	use_bullets = false
	is_knife = true
	can_select_enemy = true
	

func _on_murder_pressed():
	use_bullets = true
	is_knife = false
	can_select_enemy = true

func _on_pass_pressed():
	can_select_enemy = false
	
	loaded_bullets -= 1
	if bonus_turn_amount < 10:
		bonus_turn_amount += 1

func _on_shoot_self_pressed():
	is_knife = false
	can_select_enemy = false
	
	health_element.damage(player_bullet_damage * 2)
	print(health_element.current_hp)
	loaded_bullets -= 1

func _on_back_pressed():
	can_select_enemy = false
	
	gun_options.visible = false
	options.visible = true
