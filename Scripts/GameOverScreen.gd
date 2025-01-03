extends Panel

func _ready():
	visible = false
	
func Show():
	visible = true
	$AnimationPlayer.play("animIn")
