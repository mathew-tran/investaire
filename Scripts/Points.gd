extends Label

var Total = 0
func _ready():
	Finder.GetGame().PointsGained.connect(OnPointsGained)
	OnPointsGained(0)
	
func OnPointsGained(amount):	
	for x in range(0, amount):
		await IncrementTotal()

func IncrementTotal():
	await get_tree().create_timer(.01).timeout
	Total += 1
	text = str(Total)
	