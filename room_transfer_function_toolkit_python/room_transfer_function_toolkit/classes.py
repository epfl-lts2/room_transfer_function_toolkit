from enum import Enum
import math

class Point3D:
	def __init__(self, x, y, z):
		self.CoordinateX = x
		self.CoordinateY = y
		self.CoordinateZ = z
	def get_coordinates(self):
		return self.CoordinateX, self.CoordinateY, self.CoordinateZ
	def disp(self):
		print('(%d, %d, %d)', self.CoordinateX, self.CoordinateY, \
			self.CoordinateZ)
	def distance(self):
		return math.sqrt(math.pow(self.CoordinateX, 2) + \
			math.pow(self.CoordinateY, 2) + math.pow(self.CoordinateZ, 2))

class InputSignal(Enum):
	SineSum, FreqSweep, Noise, Music = range(4)