extends Node
class_name MyMath

static func manhattan_dist(a:Array[int], b:Array[int]) -> int:
	var out:int = 0
	for i in range(0, min(a.size(),b.size())):
		out += abs(a[i]-b[i])
	return out
