extends AudioStreamPlayer

class_name SFXManager

func PlaySound(path):
	stream = load(path)
	pitch_scale = randf_range(.9, 1.1)
	play()

func PlayChips():
	pitch_scale = randf_range(.9, 1.1)
	$Points.play()
