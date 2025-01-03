extends TextureRect

class_name BankSlot

@onready var CardHolder = $Cards
func TakeCard(card : Card):
	card.reparent(CardHolder)
	await get_tree().process_frame
	await RepositionCards()
	await CheckDupes()
	await RepositionCards()
	
func CheckDupes():
	var values = {}
	for card in CardHolder.get_children():
		if values.has(str(card.Rank)) == false:
			values[str(card.Rank)] = card
		else:
			await card.Kill(Card.KILL_REASON.BANK)
			await values[str(card.Rank)].Kill(Card.KILL_REASON.BANK)	
			await get_tree().create_timer(1.5).timeout
			return
	
func CheckBankrupt():
	pass

func RepositionCards():
	if CardHolder.get_child_count() == 0:
		return
	if CardHolder.get_child_count() == 1:
		await CardHolder.get_child(0).Move(CardHolder.global_position + Vector2(30.5, 0), .01, Tween.TransitionType.TRANS_QUAD)
		return
	var cardOffset = Vector2.ZERO
	var startPosition = CardHolder.global_position + Vector2(30.5, 0)
	print(startPosition)
	var cards = CardHolder.get_children()
	for card in cards:		
		card.z_index = 0
		cardOffset.x -= 25.5
		if card.global_position != CardHolder.global_position + cardOffset:
			await card.Move(startPosition + cardOffset, .01, Tween.TransitionType.TRANS_QUAD)
		#cardOffset.y -= 5.5
	pass
