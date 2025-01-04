extends Control

class_name Deck

var Duplicates = 4

signal DeckCreated
	
func CreateDeck():
	var data = []
	var bIsRed = false
	var halfAmount = Duplicates / 2
	for dupe in Duplicates:
		for x in range(0, 11):
			var instanceData = {
				"Rank" : x,
				"bIsRed" : bIsRed
			}
			data.append(instanceData)
		halfAmount -= 1
		if halfAmount == 0:
			bIsRed = true
	data.shuffle()
	
	var cardOffset = Vector2.ZERO
	var timeToCreateDeck = 3.2
	
	var splice = timeToCreateDeck / float(data.size())
	for card in data:
		var instance = load("res://Prefabs/Card.tscn").instantiate()		
		instance.Rank = card["Rank"]
		instance.bIsRed = card["bIsRed"]
		$Cards.add_child(instance)
		instance.global_position = Vector2(-400, 0)
		await instance.Move($Cards.global_position + cardOffset, splice)
		cardOffset += Vector2(-1,-1.0)
	
	DeckCreated.emit()

func DrawCard(newContainer):
	var newCard = $Cards.get_child(len($Cards.get_children()) -1)
	newCard.reparent(newContainer)
	await newCard.Move(newContainer.global_position, .1)
	newCard.Flip()
	return newCard

func IsEmpty():
	return len($Cards.get_children()) == 0
