extends Node

var SavePath = "user://game.save"

var Data = {}

func SaveData():
	var file = FileAccess.open(SavePath, FileAccess.WRITE)
	file.store_var(Data)
	file.close()
	
func SaveVar(category, value):
	Data[category] = value
	
func LoadVar(category):
	if Data.has(category):
		return Data[category]
	return null
	
func LoadData():
	if FileAccess.file_exists(SavePath):
		var file = FileAccess.open(SavePath, FileAccess.READ)
		Data = file.get_var()
		file.close()
