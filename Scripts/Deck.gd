extends Node2D

var Duplicates = 4

func _ready():
	CreateDeck()
	
func CreateDeck():
	var cardOffset = Vector2.ZERO
	for dupe in Duplicates:
			for x in range(0, 9):
				var instance = load("res://Prefabs/Card.tscn").instantiate()
				
				$Cards.add_child(instance)
				instance.global_position = $Cards.global_position + cardOffset
				cardOffset += Vector2(-1,-1)
		
	$Cards.get_child(len($Cards.get_children())-1).Flip()
