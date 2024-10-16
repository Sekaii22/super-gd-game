extends Node2D
class_name ChunkObjective

signal OnCleared

enum OBJECTIVE_TYPE {KILL_ENEMIES, PLATFORMER}

@export var objective: OBJECTIVE_TYPE
