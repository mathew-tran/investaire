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

var Points = 0

signal PointsGained(amount)

var bIsGameOver = false

func _ready():
	await $Deck.CreateDeck()
	print("ready")
	
	
	while $Deck.IsEmpty() == false and bIsGameOver == false:
		await PopulateInvestSlots()
		await PopulatePlaySlot()
		if is_instance_valid(GetPlayCard()) == false:
			break
		await $InvestSlots.UpdateSlots(GetPlayCard())
		if $InvestSlots.AreAnySlotsActive() == false:
			await $BankSlot.TakeCard(GetPlayCard())
		else:
			await CardMoved
			
		await get_tree().create_timer(.5).timeout
		
	await get_tree().create_timer(1.0).timeout
		
	
	$CanvasLayer/GameOver.Show()

func KillGame():
	bIsGameOver = true
	$InvestSlots.DisableSlots()	
	
func GetPlayCard():
	return $PlaySlot.get_child(0)
	
func GainPoints(amount):
	Points += amount
	await get_tree().create_timer(.1).timeout
	PointsGained.emit(amount)
	
	
func PopulateInvestSlots():
	while $InvestSlots.AreSlotsVacant():
		await get_tree().create_timer(.2).timeout
		var slot = $InvestSlots.GetNextVacantSlot()
		if $Deck.IsEmpty() == false:
			await $Deck.DrawCard(slot.GetHolder())
		else:
			break

func PopulatePlaySlot():
	await get_tree().create_timer(.3).timeout
	if $Deck.IsEmpty() == false:
		await $Deck.DrawCard($PlaySlot)

func OnSlotPressed(slot):
	$InvestSlots.DisableSlots()	
	await slot.TakeCard(GetPlayCard())
	CardMoved.emit()
