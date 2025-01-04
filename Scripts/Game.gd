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
	SaveManager.LoadData()
	
	if SaveManager.LoadVar("HIGH_SCORE"):
		$CanvasLayer/GameOver.SetHighScore(SaveManager.LoadVar("HIGH_SCORE"))
	else:
		$CanvasLayer/GameOver.SetHighScore(100)
		SaveManager.SaveVar("HIGH_SCORE", 100)
		SaveManager.SaveData()
	
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
		
	var reason = "BANKRUPT!"
	if $Deck.IsEmpty():
		reason = "ROUND OVER"
		
		
	await $CanvasLayer/EndOfGameReason.TellReason(reason)
	
	if $Deck.IsEmpty():
		GainPoints(100)
		await $ScoredSlot/Points.PointAddComplete
		
	await get_tree().create_timer(1).timeout
	
	$CanvasLayer/GameOver.Show(Points)
	


func _input(event):
	if bIsGameOver:
		return
		
	if $PlaySlot.get_child_count() == 0:
		return
		
	if is_instance_valid(GetPlayCard()) == false:
		return
		
	if Input.is_action_just_pressed("slot_1"):
		$InvestSlots.get_child(0).Click()
	if Input.is_action_just_pressed("slot_2"):
		$InvestSlots.get_child(1).Click()
	if Input.is_action_just_pressed("slot_3"):
		$InvestSlots.get_child(2).Click()
	if Input.is_action_just_pressed("slot_4"):
		$InvestSlots.get_child(3).Click()
	if Input.is_action_just_pressed("slot_5"):
		$InvestSlots.get_child(4).Click()
		
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
