extends Sprite2D
@export var player: CharacterBody2D
@export var choice_label: Label

var triggered = false
var displaying = false
var moving_up = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# print("triggered: ", triggered)
	# print("displaying: ", displaying)
	# print("moving_up: ", moving_up)
	choice_label.position = Vector2(-610, -340)
	var move = create_tween()  # Create a new tween if needed
	
	if(player.stupid_bool2 == true):
		triggered = true
	
	if(triggered):
		player.stupid_bool1 == false
		player.stupid_bool2 == false
		triggered = false
		move.tween_property(self, "position", Vector2(964, 545), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		displaying = true
	
	if(displaying):
		if(Input.is_action_just_pressed("LeftClick")):
			displaying = false
			moving_up = true
			player.pause_movement = false
			move.tween_property(self, "position", Vector2(964, -328), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			var triggered = false
			var moving_up = false
