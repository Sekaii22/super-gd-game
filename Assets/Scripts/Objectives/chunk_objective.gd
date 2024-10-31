extends Node2D
class_name ChunkObjective

signal OnCleared

enum OBJECTIVE_TYPE {KILL_ENEMIES, PLATFORMER}

@export var objective: OBJECTIVE_TYPE
## When the objective is started, set the variable to true
var started: bool = false
## When the objective is completed, set the variable to true
var finished: bool = false
