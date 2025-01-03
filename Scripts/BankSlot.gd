extends TextureRect

class_name BankSlot

@onready var CardHolder = $Cards
func TakeCard(card : Card):
	card.reparent(CardHolder)
	await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
	await SortCards()
	await RepositionCards()
	await CheckDupes()
	await RepositionCards()
	await get_tree().process_frame
	if len(CardHolder.get_children()) >= 3:
		Finder.GetGame().KillGame()
	
func CompareCards(cardA : Card, cardB : Card):
	if cardA.Rank <= cardB.Rank:
		return true
	return false
	
func SortCards():
	var cards = []
	for card in CardHolder.get_children():
		cards.append(card)
		
	cards.sort_custom(CompareCards)
	
	for card in cards:
		card.reparent(Finder.GetDeadCardGroup())
		await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
	
	for card in cards:
		card.reparent(CardHolder)
		await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
		
		
func CheckDupes():
	var values = {}
	for card in CardHolder.get_children():
		if values.has(str(card.Rank)) == false:
			values[str(card.Rank)] = card
		else:
			await card.Kill(Card.KILL_REASON.BANK)
			await values[str(card.Rank)].Kill(Card.KILL_REASON.BANK)	
			await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
			return
	
func CheckBankrupt():
	pass

func RepositionCards():
	if CardHolder.get_child_count() == 0:
		return
	if CardHolder.get_child_count() == 1:
		await CardHolder.get_child(0).Move(CardHolder.global_position + Vector2(30.5, 0), .1, Tween.TransitionType.TRANS_QUAD)
		return
	var cardOffset = Vector2.ZERO
	var startPosition = CardHolder.global_position + Vector2(30.5, 0)
	print(startPosition)
	var speed = .08 / CardHolder.get_child_count()
	var cards = CardHolder.get_children()
	for card in cards:		
		card.z_index = 0
		cardOffset.x -= 25.5
		if card.global_position != CardHolder.global_position + cardOffset:
			await card.Move(startPosition + cardOffset, speed, Tween.TransitionType.TRANS_QUAD)
		#cardOffset.y -= 5.5
	pass
