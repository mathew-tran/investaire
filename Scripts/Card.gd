extends Button

class_name Card

var MinRank = 0
var MaxRank = 9

func Flip():
	$AnimationPlayer.play("FlipFront")
