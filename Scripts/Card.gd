extends Button

class_name Card

var Rank = 0

signal MoveComplete

enum CARD_POSITION {
	TOP,
	MIDDLE,
	BOTTOM
}

enum KILL_REASON {
	DEFAULT,
	BANK
}
func _ready():
	Create()
	
func Create():
	var image = "res://Art/Cards/" + str(Rank) + ".png"
	$Front.texture = load(image)
	
func Flip():
	$AnimationPlayer.play("FlipFront")
	
func ReverseFlip():
	$AnimationPlayer.play("FlipBack", -1, 4.8)
	
func Kill(killReason = KILL_REASON.DEFAULT):
	reparent(Finder.GetDeadCardGroup())
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.5, .1)
	tween.set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, .05)
	await tween.finished
	
	ReverseFlip()
	await get_tree().create_timer(.5).timeout
	await Move(Vector2(2200, -100), .1, Tween.TransitionType.TRANS_CUBIC)
	var pointAmount = Rank
	if Rank == 0:
		pointAmount += 10
		
	if killReason == KILL_REASON.BANK:
		pointAmount *= 3
	Finder.GetGame().GainPoints(pointAmount)
	queue_free()
	
	
	
func Move(newPosition, speed = .1, transType = Tween.TransitionType.TRANS_LINEAR):
	var oldParent = get_parent()
	reparent(Finder.GetDeadCardGroup())
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", newPosition, speed)
	tween.set_trans(transType)
	await tween.finished
	MoveComplete.emit()
	reparent(oldParent)
	await get_tree().process_frame

func GetAllowableNumbers(cardPosition: CARD_POSITION):
	var allowedNumbers = []
	allowedNumbers.append(Rank)
	if Rank < 9 and (cardPosition == CARD_POSITION.TOP or cardPosition == CARD_POSITION.MIDDLE):
		allowedNumbers.append(Rank + 1)
	if Rank >= 1 and (cardPosition == CARD_POSITION.BOTTOM or cardPosition == CARD_POSITION.MIDDLE):
		allowedNumbers.append(Rank - 1)
	return allowedNumbers
