extends Panel

@onready var itemVisual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label

func update(slot: InvSlot):
	if !slot.items:
		itemVisual.visible = false
		amount_text.visible = false
	else:
		itemVisual.visible = true
		itemVisual.texture = slot.items.texture
		if slot.amount > 1:
			amount_text.visible = true
		amount_text.text = str(slot.amount)
