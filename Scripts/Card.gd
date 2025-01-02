extends Button

class_name Card

var Rank = 0

signal MoveComplete

func _ready():
	Create()
	
func Create():
	var image = "res://Art/Cards/" + str(Rank) + ".png"
	$Front.texture = load(image)
	
func Flip():
	$AnimationPlayer.play("FlipFront")
	
func Move(newPosition, speed = .1):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", newPosition, speed)
	await tween.finished
	MoveComplete.emit()
