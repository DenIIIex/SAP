extends Node


const PortalParticle = preload("res://Scenes/PortalParticle.tscn")
const maxX = int(round(OS.window_size.x))
const maxY = int(round(OS.window_size.y))
var height = maxY
var width = maxX

var matrix = []
var matrixW = []
var matrixH = []
var cellSize = 32
var player
onready var levelAllCell = 0
var difficalty = GlobalVars.get_difficalty()
var rng = RandomNumberGenerator.new()

var startPos
const mapOfset = 2
var tileW = width / cellSize - 2 * mapOfset
var tileH = height / cellSize - 2 * mapOfset

enum Tiles{
	LU = 12
	U = 13
	UR = 14
	LUR = 15
	L = 16
	LURD = 17
	R = 18
	LR = 19
	LD = 20
	D = 21
	RD = 22
	LRD = 23
	LUD = 24
	UD = 25
	URD = 26
	PU = 28
	PR = 29
	PD = 30
	PL = 31
	E = -1
}
func getLevelStartPos():
	return startPos

func getLevel():
	return matrix

	
func getWidth():
	return width

func getHeight():
	return height

func getMapOfset():
	return mapOfset * cellSize

func _ready():
	pass

func getAllCell():
	return levelAllCell - 1

func getStartPos():
	return Vector2(map.map_to_world(startPos).x + mapOfset * cellSize + cellSize /2 ,map.map_to_world(startPos).y + mapOfset* cellSize + cellSize/2)

func getLevelData():
	var data = ""
	data += "tileW: %d \n" % tileW
	data += "tileH: %d \n" % tileH
	data += startPos as String
	for x in range(tileW):
		for y in range(tileH):
			data += "|%d|" % matrix[x][y]
		data += "\n"
	return data

func genMap(level,start_pos):


func fillMap():
	for x in range(0,tileW):
		for y in range(0,tileH):
			if(matrix[x][y] == 2):
				levelAllCell += 1
				map.set_cellv(Vector2(x+mapOfset,y+mapOfset), matrix[x][y])
			elif(matrix[x][y] >= 28 and matrix[x][y] <= 31):
				var portal = PortalParticle.instance()
				var portalPos = Vector2(x,y)
				portal.set_position(Vector2(map.map_to_world(portalPos).x + mapOfset * cellSize,map.map_to_world(portalPos).y + mapOfset * cellSize + cellSize /2))
				if(matrix[x][y] == 28):
					portal.rotation_degrees = 180
					portal.set_position(Vector2(map.map_to_world(portalPos).x + mapOfset * cellSize + cellSize /2,map.map_to_world(portalPos).y + cellSize + mapOfset * cellSize))
				if(matrix[x][y] == 29):
					portal.rotation_degrees = -90
					portal.set_position(Vector2(map.map_to_world(portalPos).x + mapOfset * cellSize ,map.map_to_world(portalPos).y + mapOfset * cellSize + cellSize /2))
				if(matrix[x][y] == 30):
					portal.rotation_degrees = 0
					portal.set_position(Vector2(map.map_to_world(portalPos).x + mapOfset * cellSize + cellSize /2,map.map_to_world(portalPos).y + mapOfset * cellSize))
				if(matrix[x][y] == 31):
					portal.rotation_degrees = 90
					portal.set_position(Vector2(map.map_to_world(portalPos).x + mapOfset * cellSize + cellSize,map.map_to_world(portalPos).y + mapOfset * cellSize + cellSize /2))
				self.add_child(portal)
			else:
				if(x > 0 and y > 0 and x < tileW - 1 and y < tileH - 1):
					var tileId = getTileId(x,y)
					map.set_cellv(Vector2(x+mapOfset,y+mapOfset), tileId)
				else:
					if(matrix[x][y] >= 28 and matrix[x][y] <= 31):
						continue
					if(x == 0) and (y == 0) or (x == tileW - 1) and (y == 0) or (x == 0) and (y == tileH - 1):
						map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.E)
						continue
					if(x == 0):
						if(matrix[x + 1][y] == 2):
							map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.R)
						else:
							map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.E)
					elif(x == tileW - 1):
						if(matrix[x - 1][y] == 2):
							map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.L)
						else:
							map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.E)
					elif(y == 0):
						if(matrix[x][y + 1] == 2):
							map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.D)
						else:
							map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.E)
					elif(y == tileH - 1):
						if(matrix[x][y - 1] == 2):
							map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.U)
						else:
							map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.E)
					else:
						map.set_cellv(Vector2(x + mapOfset,y + mapOfset), Tiles.E)

func getTileId(x : int, y : int):
	if(matrix[x][y - 1] == 2 and matrix[x][y + 1] == 2 and matrix[x - 1][y] == 2 and matrix[x + 1][y] == 2):
		return Tiles.LURD
	elif(matrix[x][y - 1] == 2 and matrix[x][y + 1] == 2 and matrix[x - 1][y] == 2 and matrix[x + 1][y] != 2):
		return Tiles.LUD
	elif(matrix[x][y - 1] == 2 and matrix[x][y + 1] == 2 and matrix[x - 1][y] != 2 and matrix[x + 1][y] == 2):
		return Tiles.URD
	elif(matrix[x][y - 1] == 2 and matrix[x][y + 1] != 2 and matrix[x - 1][y] == 2 and matrix[x + 1][y] == 2):
		return Tiles.LUR
	elif(matrix[x][y - 1] != 2 and matrix[x][y + 1] == 2 and matrix[x - 1][y] == 2 and matrix[x + 1][y] == 2):
		return Tiles.LRD
	elif(matrix[x][y - 1] != 2 and matrix[x][y + 1] != 2 and matrix[x - 1][y] == 2 and matrix[x + 1][y] == 2):
		return Tiles.LR
	elif(matrix[x][y - 1] != 2 and matrix[x][y + 1] == 2 and matrix[x - 1][y] != 2 and matrix[x + 1][y] == 2):
		return Tiles.RD
	elif(matrix[x][y - 1] != 2 and matrix[x][y + 1] == 2 and matrix[x - 1][y] == 2 and matrix[x + 1][y] != 2):
		return Tiles.LD
	elif(matrix[x][y - 1] == 2 and matrix[x][y + 1] != 2 and matrix[x - 1][y] != 2 and matrix[x + 1][y] == 2):
		return Tiles.UR
	elif(matrix[x][y - 1] == 2 and matrix[x][y + 1] != 2 and matrix[x - 1][y] == 2 and matrix[x + 1][y] != 2):
		return Tiles.LU
	elif(matrix[x][y - 1] == 2 and matrix[x][y + 1] == 2 and matrix[x - 1][y] != 2 and matrix[x + 1][y] != 2):
		return Tiles.UD
	elif(matrix[x][y - 1] != 2 and matrix[x][y + 1] != 2 and matrix[x - 1][y] != 2 and matrix[x + 1][y] == 2):
		return Tiles.R
	elif(matrix[x][y - 1] != 2 and matrix[x][y + 1] != 2 and matrix[x - 1][y] == 2 and matrix[x + 1][y] != 2):
		return Tiles.L
	elif(matrix[x][y - 1] != 2 and matrix[x][y + 1] == 2 and matrix[x - 1][y] != 2 and matrix[x + 1][y] != 2):
		return Tiles.D
	elif(matrix[x][y - 1] == 2 and matrix[x][y + 1] != 2 and matrix[x - 1][y] != 2 and matrix[x + 1][y] != 2):
		return Tiles.U
	return Tiles.E

#func addText(x: int, y: int):
#	var TextInd = Text.instance()
#	TextInd.text = GlobInd as String
#	GlobInd += 1
#	TextInd.set_position(map.map_to_world(Vector2(x,y)))
#	self.add_child(TextInd)
#func addCount():
#	var CountInd = CountText.instance()
#	CountInd.text = levelAllCell as String
#	CountInd.set_position(map.map_to_world(Vector2(0,0)))
#	self.add_child(CountInd)
func generateMap(pos : Vector2, dir : int, count: int):
	if(count < 1):
		return
	if(dir == 0):
		var yy = 0
		var b =  getOfset(pos, dir, 1, tileH-3)
		if(b == null or b < 0):
			print("ERROR")
			return
		for i in range(1,b + 1):
			yy = pos.y + i
			if(pos.y + i >= tileH):
				yy = (pos.y + i) - tileH
			if (matrix[pos.x][yy] == 11):
				yy -= 1
				b = i
				break
			matrix[pos.x][yy] = 2
		if(yy < pos.y):
			matrix[pos.x][0] = Tiles.PU
			matrix[pos.x][tileH-1] = Tiles.PD
		matrix[pos.x][yy+1] = 11
		matrixW[pos.x] = 1
		generateMap(Vector2(pos.x,yy),rng.randi_range(2,3),count-b)
		
	elif(dir == 1):
		var yy = 0
		var b = getOfset(pos, dir, 1, tileH - 3) 
		if(b == null or b < 0):
			print("ERROR")
			return
		for i in range(1,b + 1):
			yy = pos.y - i
			if(pos.y - i < 0):
				yy = tileH - (i - pos.y)
			if (matrix[pos.x][yy] == 11):
				yy += 1
				b = i
				break
			matrix[pos.x][yy] = 2
		if(yy > pos.y):
			matrix[pos.x][0] = Tiles.PU
			matrix[pos.x][tileH-1] = Tiles.PD
		matrix[pos.x][yy-1] = 11
		matrixW[pos.x] = 1
		generateMap(Vector2(pos.x,yy),rng.randi_range(2,3),count-b)
		
	elif(dir == 2):
		var xx = 0
		var b = getOfset(pos, dir, 1, tileW - 3)
		if(b == null or b < 0):
			print("ERROR")
			return
		for i in range(1,b + 1):
			xx = pos.x + i
			if(pos.x + i >= tileW):
				xx = (pos.x + i) - tileW
			if (matrix[xx][pos.y] == 11):
				xx -= 1
				b = i
				break
			matrix[xx][pos.y] = 2
		if(xx < pos.x):
			matrix[0][pos.y] = Tiles.PL
			matrix[tileW-1][pos.y] = Tiles.PR
		matrix[xx+1][pos.y] = 11
		
		generateMap(Vector2(xx,pos.y),rng.randi_range(0,1),count-b)
		
	elif(dir == 3):
		var xx = 0
		var b = getOfset(pos, dir, 1, tileW - 3)
		if(b == null or b < 0):
			print("ERROR")
			return
		for i in range(1,b + 1):
			xx = pos.x - i
			if(pos.x - i < 0):
				xx = tileW - (i - pos.x)
			if (matrix[xx][pos.y] == 11):
				xx += 1
				b = i
				break
			matrix[xx][pos.y] = 2
		if(xx > pos.x):
			matrix[0][pos.y] = Tiles.PL
			matrix[tileW - 1][pos.y] = Tiles.PR
		matrix[xx-1][pos.y] = 11
		generateMap(Vector2(xx,pos.y),rng.randi_range(0, 1),count - b)
		
func getOfset(pos: Vector2, dir : int, start : int, end :int):
	var ofsetArray = []
	var ofset = 0
	if(dir == 0):
		for yy in range(1, tileH - 2):
			if(matrix[pos.x][yy + 1] != 2 and (matrix[pos.x][yy + 1] < 28 or matrix[pos.x][yy + 1] > 31) and yy != pos.y):
				ofsetArray.append(yy)
		if(ofsetArray.size() <= 1):
			return -1
		else:
			var ind = rng.randi_range(0,ofsetArray.size()-1)
			ofset = ofsetArray[ind] - pos.y
			if(ofset < 0):
				return tileH + ofset
			return ofset
	elif (dir == 1):
		for yy in range(1, tileH - 2):
			if(matrix[pos.x][yy - 1] != 2 and (matrix[pos.x][yy - 1] < 28 or matrix[pos.x][yy - 1] > 31) and yy != pos.y):
				ofsetArray.append(yy)
		if(ofsetArray.size() <= 1):
			return -1
		else:
			var ind = rng.randi_range(0,ofsetArray.size()-1)
			ofset = pos.y - ofsetArray[ind]
			if(ofset < 0):
				return tileH + ofset
			return ofset
	elif(dir == 2):
		for xx in range(1, tileW - 2):
			if(matrix[xx + 1][pos.y] != 2 and (matrix[xx + 1][pos.y] < 28 or matrix[xx + 1][pos.y] > 31) and xx != pos.x):
				ofsetArray.append(xx)
		if(ofsetArray.size() <= 1):
			return -1
		else:
			var ind = rng.randi_range(0,ofsetArray.size()-1)
			ofset = ofsetArray[ind] - pos.x
			if(ofset < 0):
				return tileW + ofset
			return ofset
	elif (dir == 3):
		for xx in range(1, tileW - 2):
			if(matrix[xx - 1][pos.y] != 2 and (matrix[xx - 1][pos.y] < 28 or matrix[xx - 1][pos.y] > 31) and xx != pos.x):
				ofsetArray.append(xx)
		if(ofsetArray.size() <= 1):
			return -1
		else:
			var ind = rng.randi_range(0,ofsetArray.size()-1)
			ofset = pos.x - ofsetArray[ind]
			if(ofset < 0):
				return tileW + ofset
			return ofset
