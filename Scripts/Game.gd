extends Node2D

class_name Game

enum GAME_STATE {
	START,
	POPULATE,
	DRAW,
	CHECK_HAND,
	PLAYER_TURN,
	GAME_END
}

var GameState = GAME_STATE.START

signal CardMoved

func _ready():
	await $Deck.CreateDeck()
	print("ready")
	
	
	while $Deck.IsEmpty() == false:
		await PopulateInvestSlots()
		await PopulatePlaySlot()
		await $InvestSlots.UpdateSlots(GetPlayCard())
		if $InvestSlots.AreAnySlotsActive() == false:
			$BankSlot.TakeCard(GetPlayCard())
		else:
			await CardMoved
			
	print("update")

func GetPlayCard():
	return $PlaySlot.get_child(0)
	
func PopulateInvestSlots():
	while $InvestSlots.AreSlotsVacant():
		await get_tree().create_timer(.2).timeout
		var slot = $InvestSlots.GetNextVacantSlot()
		await $Deck.DrawCard(slot.GetHolder())

func PopulatePlaySlot():
	await get_tree().create_timer(.3).timeout
	await $Deck.DrawCard($PlaySlot)

func OnSlotPressed(slot):
	$InvestSlots.DisableSlots()	
	await slot.TakeCard(GetPlayCard())
	CardMoved.emit()
