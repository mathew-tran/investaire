extends TextureRect

class_name BankSlot

@onready var CardHolder = $Cards
func TakeCard(card : Card):
	card.reparent(CardHolder)
	await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
	await SortCards()
	await RepositionCards()
	await CheckDupes()
	await get_tree().process_frame
	await RepositionCards()
	if len(CardHolder.get_children()) >= 3:
		Finder.GetGame().KillGame()
	
func CompareCards(cardA : Card, cardB : Card):
	if cardA.Rank >= cardB.Rank:
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
			await get_tree().create_timer(.1).timeout
			await values[str(card.Rank)].Kill(Card.KILL_REASON.BANK)	
			await card.Kill(Card.KILL_REASON.BANK)
			await CardHolder.NOTIFICATION_CHILD_ORDER_CHANGED
			return
	
func CheckBankrupt():
	pass

func RepositionCards():
	await get_tree().create_timer(.1).timeout
	var cardOffset = Vector2.ZERO
	var speed = .08 / CardHolder.get_child_count()
	var cards = CardHolder.get_children()
	for card in cards:		
		await card.Move(CardHolder.global_position + cardOffset, speed, Tween.TransitionType.TRANS_QUAD, Card.MOVE_TYPE.BANK)
		cardOffset.y += 60

	pass
