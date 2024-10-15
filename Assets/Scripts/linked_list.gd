extends Node
class_name LinkedList

## next is a LinkedList or null
var next
var value

func _init(next_node, val) -> void:
	next = next_node
	value = val
	
func push_to_end(val):
	var curr_node = self
	while curr_node.next != null:
		curr_node = curr_node.next
		
	var new_node = LinkedList.new(null, val)
	curr_node.next = new_node
		
func _to_string() -> String:
	return str(value) + " -> " + str(next)
