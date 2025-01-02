extends TextureRect

class_name InvestSlot

func IsEmpty():
	return get_child_count() == 0

func TakeCard(card):
	card.reparent(self)
