extends Node2D

@export var black_transition: Node2D
@export var player: CharacterBody2D
@export var music: AudioStreamPlayer2D

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

var silenced : bool = false
var concussed : bool = false
var cursed : bool = false
var asleep : bool = false
var asleep_hp : int

var player_bullet_damage : int = 20
var max_player_ammo : int = 32
var player_ammo : int = 26
var loaded_bullets : int = 6
var bonus_turn_amount : int = 0
var left_melee_hits : int = 2

var first_time = true

func _ready() -> void:
	battle_start()
	test_enemy_layout.apply_layout(test_enemy_layout.selected_layout)

func starting() -> void:
	print("READY")
	if(!first_time):
		battle_start()
		test_enemy_layout.apply_layout(test_enemy_layout.selected_layout)
	else:
		first_time = false
	
func battle_start():
#fill with functions that reset all the temporary values when the battle restarts
	bonus_turn_amount = 0
	left_melee_hits  = 2
	narrate("Your turn!")

func _process(_delta):
	# if(loaded_bullets <= 0):
		# player_ammo -= 6
		# loaded_bullets = 6
	
	
	if health_element.current_hp <= 0:
		narrate("player lost")
		black_transition.combat_leave = true
		if (black_transition.combat_leave):
			black_transition.combat_leave = true
			black_transition.enter_trans = false
			black_transition.exit_trans = true
			#await get_tree().create_timer(1).timeout
		#await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://overworld.tscn")
	
	if(!player.pause_movement and health_element.current_hp > 0):
		await get_tree().create_timer(1).timeout
		visible = false
		
	if(player.fighting):
		# print("signal_end: ", test_enemy_layout.signal_end)
		# print("combat_leave: ", black_transition.combat_leave)
		if ((Input.is_action_just_pressed("debug1") or test_enemy_layout.signal_end) and !black_transition.combat_leave):
			# print("enter trans: ", black_transition.enter_trans)
			# print("exit trans: ", black_transition.exit_trans)
			test_enemy_layout.done_once = false
			print("booey")
			test_enemy_layout.done_once = false
			black_transition.combat_leave = true
		if (black_transition.combat_leave):
			black_transition.combat_leave = true
			black_transition.enter_trans = false
			black_transition.exit_trans = true
			if(health_element.current_hp > 0):
				await get_tree().create_timer(2).timeout
			
			music.stream_paused = false
			
			player.fighting = false
			black_transition.combat_leave = false
			black_transition.enter_trans = true
			black_transition.exit_trans = false
	
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
		"Curse":
			effect = CursedEffect.new(duration)
		"Asleep":
			effect = AsleepEffect.new(duration)
		
	if effect:
		apply_status(effect)
			
func process_turn():

	
	var active_effects = []
	concussed = false
	silenced = false
	cursed = false
	asleep = false
	for effect in status_effects:
		if effect is ConcussEffect:
			concussed = true
		
		if effect is SilentEffect:
			silenced = true
			
		if effect is CursedEffect:
			cursed = true
		
		if effect is AsleepEffect:
			asleep = true
		
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
	if asleep_hp > health_element.current_hp:
		asleep = false
		
	if concussed == false && asleep == false:
		start_new_turn()
	elif concussed == true:
		await narrate("You've been concussed!")
		end_of_turn()
	elif asleep == true:
		await narrate("You're too eepy to fight!")
		end_of_turn()
	
	
func start_new_turn():
	print(health_element.current_hp)
	print(health_element.max_hp)
	if health_element.current_hp <= 0:
		narrate("player lost")
	else:
		murder.disabled = false
		pass_turn.disabled = false
		shoot_self.disabled = false
		gun.disabled = false
		chant.disabled = false
		items.disabled = false
		melee.disabled = false
		
		if silenced == true:
			chant.disabled = true
		if cursed == true:
			items.disabled = true
			
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
