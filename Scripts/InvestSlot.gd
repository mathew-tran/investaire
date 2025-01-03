extends TextureRect

class_name InvestSlot

var bActivated = false

@onready var CardHolder = $Cards

var MaxCardAmount = 5

func IsEmpty():
	return CardHolder.get_child_count() == 0

func TakeCard(card : Card):
	var bMoveToTop = false
	card.reparent(CardHolder)
	await get_tree().process_frame
	if len(CardHolder.get_children()) == 1:		
		if card.Rank > CardHolder.get_child(0).Rank:
			bMoveToTop = true
		

	elif len(CardHolder.get_children()) > 1:
		if card.Rank in CardHolder.get_child(0).GetAllowableNumbers(Card.CARD_POSITION.TOP):
			if card.Rank >= CardHolder.get_child(0).Rank:
				bMoveToTop = true
			
			
	if bMoveToTop:
		CardHolder.move_child(card, 0)
	else:
		CardHolder.move_child(card, -1)
			
	await get_tree().process_frame
	
	await RepositionCards()	
	if CardHolder.get_child_count() == MaxCardAmount:
		await get_tree().create_timer(1).timeout
		var deadCards = []
		for deadcard in CardHolder.get_children():
			deadCards.append(deadcard)
		deadCards.reverse()
		
		for children in deadCards:
			children.reparent(Finder.GetDeadCardGroup())
			children.ReverseFlip()
			await get_tree().create_timer(.8).timeout
			await children.Move(Vector2(2200, -100), .1, Tween.TransitionType.TRANS_CUBIC)
			children.queue_free()
	await get_tree().process_frame
	
func RepositionCards():
	if CardHolder.get_child_count() < 2:
		return
	var cardOffset = Vector2.ZERO
	var cards = CardHolder.get_children()
	for card in cards:
		if card.global_position != CardHolder.global_position + cardOffset:
			await card.Move(CardHolder.global_position + cardOffset, .1, Tween.TransitionType.TRANS_QUAD)
		card.z_index = 0
		cardOffset.y += 35
		cardOffset.x -= 3.5
	pass

func CanActivate(card : Card):
	var allowedNumbers = []
	
	if CardHolder.get_child_count() == 0:
		return false
		
	if CardHolder.get_child_count() == 1:
		for number in CardHolder.get_child(0).GetAllowableNumbers(Card.CARD_POSITION.MIDDLE):
			allowedNumbers.append(number)
	else:
		for number in CardHolder.get_child(0).GetAllowableNumbers(Card.CARD_POSITION.TOP):
			allowedNumbers.append(number)
		for number in CardHolder.get_child(-1).GetAllowableNumbers(Card.CARD_POSITION.BOTTOM):
			allowedNumbers.append(number)
			
	print(name + " activate check")
	print(allowedNumbers)
	if card.Rank in allowedNumbers:
		return true
		
	return false
	
func GetHolder():
	return CardHolder
	
func IsActive():
	return bActivated
	
func SetActivated(bActive):
	bActivated = bActive
	$Button.visible = bActive


func _on_button_button_up():
	Finder.GetGame().OnSlotPressed(self)
