extends Control

class_name Deck

var Duplicates = 5

signal DeckCreated
	
func CreateDeck():
	var data = []
	for dupe in Duplicates:
		for x in range(0, 9):
			data.append(x)
	data.shuffle()
	
	var index = 100
	var cardOffset = Vector2.ZERO
	for card in data:
		var instance = load("res://Prefabs/Card.tscn").instantiate()		
		instance.Rank = card
		$Cards.add_child(instance)
		instance.global_position = Vector2(-400, 0)
		await instance.Move($Cards.global_position + cardOffset, .05)
		cardOffset += Vector2(-1,-1.2)
	
	DeckCreated.emit()

func DrawCard(newContainer):
	var newCard = $Cards.get_child(len($Cards.get_children()) -1)
	newCard.reparent(newContainer)
	await newCard.Move(newContainer.global_position, .1)
	newCard.Flip()
	return newCard

func IsEmpty():
	return len($Cards.get_children()) == 0
