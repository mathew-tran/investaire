extends Label

func _enter_tree():
	text = ""
	
func TellReason(message):
	visible = true
	text = message
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.3, .2)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, .1)
	await tween.finished
