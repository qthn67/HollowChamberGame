extends Node2D

@onready var temp_bullet_counter = $TempBulletCounter
@onready var temp_loaded_bullet_counter = $TempLoadedBulletCounter

@onready var test_enemy_layout = $TestEnemyLayout

@onready var health_element: Node2D = $HealthElement
@onready var narration: Label = $Narration
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var narration_delay = $NarrationDelay

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

var status_effects = []

var can_select_enemy : bool = false
var use_bullets : bool = false
var is_knife : bool = false

var concussed : bool = false
var silenced : bool = false

var player_bullet_damage : int = 20
var max_player_ammo : int = 32
var player_ammo : int = 26
var loaded_bullets : int = 6
var bonus_turn_amount : int = 0
var left_melee_hits : int = 2

func _ready() -> void:
	battle_start()
	
func battle_start():
#fill with functions that reset all the temporary values when the battle restarts
	bonus_turn_amount = 0
	left_melee_hits  = 2
	narrate("Your turn!")

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
			
#Applying a status effect
func apply_status(effect: StatusEffect):
	effect.target = self
	
	for i in range(status_effects.size()):
		if status_effects[i].e_name == effect.e_name:
			if status_effects[i].stackable:
				status_effects.append(effect)
			else:
				status_effects[i].duration = max(status_effects[i].duration, effect.duration)
			return
	status_effects.append(effect)
	
func apply_status_effect(e_name: String, duration: int):
	var effect = null
	
	match e_name:
		"Poison":
			effect = PoisonEffect.new(duration)
		"Bleed":
			effect = BleedEffect.new(duration)
		"Fracture":
			effect = FractureEffect.new(duration)
		"Regen":
			effect = RegenEffect.new(duration)
		"Concuss":
			effect = ConcussEffect.new(duration)
		"Venom":
			effect = VenomEffect.new(duration)
		"Silent":
			effect = SilentEffect.new(duration)
		
	if effect:
		apply_status(effect)
			
func process_turn():
	var active_effects = []
	
	for effect in status_effects:
		if effect is ConcussEffect:
			concussed = true
		else:
			concussed = false
		
		if effect is SilentEffect:
			silenced = true
		else:
			silenced = false
	
	for effect in status_effects:
		effect.apply_effect()
		if effect.decrease_duration() or effect.duration == -1:
			active_effects.append(effect)
	
	status_effects = active_effects

# Simple narration system kinda like in rpg maker
func narrate(text):
	narration.text = text
	animation_player.play("narration_text")
	narration_delay.start()
	await narration_delay.timeout

func end_of_turn():
	gun.disabled = true
	chant.disabled = true
	items.disabled = true
	melee.disabled = true
	gun_options.visible = false
	options.visible = true
	
	if loaded_bullets == 0:
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
		
	await test_enemy_layout.enemy_turn()
	process_turn()
	if concussed == false:
		start_new_turn()
	else:
		await narrate("You've been concussed!")
		end_of_turn()
	
	
func start_new_turn():
	print(health_element.current_hp)
	print(health_element.max_hp)
	if health_element.current_hp == 0:
		narrate("player lost")
	else:
		murder.disabled = false
		pass_turn.disabled = false
		shoot_self.disabled = false
		gun.disabled = false
		chant.disabled = false
		items.disabled = false
		melee.disabled = false
		narrate("Your turn!")

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
	loaded_bullets -= 1

func _on_back_pressed():
	can_select_enemy = false
	
	gun_options.visible = false
	options.visible = true
