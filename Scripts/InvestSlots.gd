extends HBoxContainer

class_name InvestSlots

signal FinishInvestSlotUpdate

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

func UpdateSlots(playCard : Card):
	for slot in get_children():
		if slot.CanActivate(playCard):
			slot.SetActivated(true)
		else:
			slot.SetActivated(false)
	FinishInvestSlotUpdate.emit()

func DisableSlots():
	for slot in get_children():
		slot.SetActivated(false)
		
func AreAnySlotsActive():
	for slot in get_children():
		if slot.IsActive():
			return true
	return false
