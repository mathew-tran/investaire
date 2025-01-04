extends Panel

func _ready():
	visible = false
	
func Show(points):
	visible = true
	$AnimationPlayer.play("animIn")
	$VBoxContainer/HBoxContainer/VBoxContainer/CurrentScore.text = str(points)
