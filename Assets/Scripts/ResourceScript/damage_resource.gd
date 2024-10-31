extends Resource
class_name DamageResource

@export var damage: int
@export_enum("PHYSICAL", "FIRE", "WATER", "EARTH", "WIND") 
var type: String
@export var crit_rate_percent: float = 10.0
@export var crit_damage_percent: float = 150.0
