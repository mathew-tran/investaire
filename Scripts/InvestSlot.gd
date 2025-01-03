extends TextureRect

class_name InvestSlot

var bActivated = false

@onready var CardHolder = $Cards

var MaxCardAmount = 5

func IsEmpty():
	return CardHolder.get_child_count() == 0

func SortCards():
	var cards = []
	for card in CardHolder.get_children():
		cards.append(card)
		
	cards.sort_custom(CompareCards)
	
	print("sorting:" + name)
	for card in cards:
		print(str(card.Rank))
		CardHolder.move_child(card, 0)
		await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
		await get_tree().process_frame
		await get_tree().process_frame
	
	print("======")
		
	
func CompareCards(cardA : Card, cardB : Card):
	if cardA.Rank <= cardB.Rank:
		return true
	return false
	
func TakeCard(card : Card):
	var bMoveToTop = false
	card.reparent(CardHolder)
	await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
	await SortCards()	
	await RepositionCards()	
	if CardHolder.get_child_count() == MaxCardAmount:
		await get_tree().create_timer(.4).timeout
		var deadCards = []
		for deadcard in CardHolder.get_children():
			deadCards.append(deadcard)
		deadCards.reverse()
		
		for children in deadCards:
			await children.Kill()
			await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
	
func RepositionCards():
	if CardHolder.get_child_count() < 2:
		return
	var cardOffset = Vector2.ZERO
	await get_tree().create_timer(.1).timeout
	var cards = CardHolder.get_children()
	for card in cards:
		if card.global_position != CardHolder.global_position + cardOffset:
			await card.Move(CardHolder.global_position + cardOffset, .01, Tween.TransitionType.TRANS_QUAD)
		cardOffset.y += 55
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
