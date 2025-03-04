extends Node2D

@export_enum("L1", "L2", "L3") var selected_layout = 0

var enemies = []

func _ready():
	apply_layout(selected_layout)

func apply_layout(selected_layout):
	match selected_layout:
		0: setup_test_layout()
		1: setup_layout_1()
		2: setup_layout_2()

func spawn_enemy(enemy_scene_path: String, enemy_position: Vector2):
	var enemy_scene = load(enemy_scene_path) as PackedScene
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = enemy_position
		add_child(enemy)

func enemy_turn():
	enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.take_turn()
	
func setup_test_layout():
	spawn_enemy("res://Enemies/testenemy.tscn", Vector2(280, 80))
	spawn_enemy("res://Enemies/testenemy.tscn", Vector2(220, 80))
	spawn_enemy("res://Enemies/testenemy.tscn", Vector2(160, 80))

func setup_layout_1():
	spawn_enemy("res://Enemies/testenemy.tscn", Vector2(220, 80))
	spawn_enemy("res://Enemies/testenemy.tscn", Vector2(160, 80))

func setup_layout_2():
	spawn_enemy("res://Enemies/testenemy.tscn", Vector2(220, 80))
