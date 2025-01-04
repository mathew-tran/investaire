extends Button


var Charge = 0
var MaxCharge = 100

var bIsPressed = false

func _on_button_up():
	bIsPressed = false
	Charge = 0


func _on_button_down():
	bIsPressed = true
	
	
func _process(delta):
	$ProgressBar.visible = bIsPressed
	if bIsPressed:
		Charge += delta * 120
		$ProgressBar.value = Charge
		if Charge >= MaxCharge:
			get_tree().reload_current_scene()
			
		
