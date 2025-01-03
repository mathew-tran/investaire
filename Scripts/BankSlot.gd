extends TextureRect

class_name BankSlot

func TakeCard(card : Card):
	card.reparent(self)
	await card.Move(global_position, .2)
