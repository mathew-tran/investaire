extends HBoxContainer

class_name InvestSlots

func AreSlotsVacant():
	for slot in get_children():
		if slot.IsEmpty():
			return true
	return false

func GetNextVacantSlot():
	for slot in get_children():
		if slot.IsEmpty():
			return slot
	return null
