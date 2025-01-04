extends Panel

func _ready():
	visible = false
	
func Show(points):
	visible = true
	$AnimationPlayer.play("animIn")
	
	$VBoxContainer/HBoxContainer/VBoxContainer/CurrentScore.text = str(points)
	$VBoxContainer/HBoxContainer2/PlayAgainButton.grab_focus()
	$VBoxContainer/HBoxContainer2/PlayAgainButton.disabled = true
	
	await $AnimationPlayer.animation_finished
	if SaveManager.LoadVar("HIGH_SCORE"):
		if SaveManager.LoadVar("HIGH_SCORE") < points:
			
			SaveManager.SaveVar("HIGH_SCORE", points)
			SaveManager.SaveData()
			get_tree().create_timer(.1)
			SetHighScore(points)
			get_tree().create_timer(.2)
			$VBoxContainer/HBoxContainer/VBoxContainer2/HighScore.modulate = Color.GREEN
	$VBoxContainer/HBoxContainer2/PlayAgainButton.disabled = false
	

func SetHighScore(amount):
	$VBoxContainer/HBoxContainer/VBoxContainer2/HighScore.text = str(amount)
