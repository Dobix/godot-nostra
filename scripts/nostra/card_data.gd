class_name CardData

enum CardType { BRUDER, SONDERKARTE }

var name: String
var type: CardType
var value: int = 0
var absolute_value: int = 0
var image_path: String = ""
var id: int

func _init(_name: String, _type: CardType, _value := 0, _absolute_value := 0, _image_path := "", _id := 0):
	name = _name
	type = _type
	value = _value
	absolute_value = _absolute_value
	image_path = _image_path
	id = _id
