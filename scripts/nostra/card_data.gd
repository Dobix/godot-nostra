class_name CardData

enum CardType { BRUDER, SONDERKARTE }

var name: String
var type: CardType
var age: int = 0
var value: int = 0            # Nur bei Bruder sinnvoll
var color: String = ""        # Nur bei Bruder sinnvoll
var image_path: String = ""  # Bildpfad für Darstellung
var id: int

func _init(_name: String, _type: CardType, _age := 0, _value := 0, _color := "", _image_path := "", _id := 0):
	name = _name
	type = _type
	age = _age
	value = _value
	color = _color
	image_path = _image_path
	id = _id
