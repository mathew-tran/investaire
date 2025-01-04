extends Node

func GetGame() -> Game:
	var result = get_tree().get_nodes_in_group("Game")	
	if result:
		return result[0]
	return null
	
func GetDeadCardGroup():
	var result = get_tree().get_nodes_in_group("DeadCard")	
	if result:
		return result[0]
	return null

func GetSFXManager() -> SFXManager:
	var result = get_tree().get_nodes_in_group("SFXManager")	
	if result:
		return result[0]
	return null
