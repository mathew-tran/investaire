extends Node2D

class_name Game

func _ready():
	await $Deck.CreateDeck()
	print("ready")
	await PopulateInvestSlots()
	await PopulatePlaySlot()
	
	
	
func PopulateInvestSlots():
	while $InvestSlots.AreSlotsVacant():
		await get_tree().create_timer(.2).timeout
		var slot = $InvestSlots.GetNextVacantSlot()
		await $Deck.DrawCard(slot)

func PopulatePlaySlot():
	await get_tree().create_timer(.3).timeout
	await $Deck.DrawCard($PlaySlot)
