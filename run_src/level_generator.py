import numpy as np

class Obstacle:
    def __init__(self,timing,obstacleType,position,speed):
        self.timing = timing
        self.type = obstacleType
        self.pos = position
        self.speed = speed

    def _timing_json(self):
        return '"type": "%s"'%(self.type)
    def _position_json(self):
        return '"location": [%d,%d]'%(self.pos[0],self.pos[1])
    def _speed_json(self):
        return '"speed": [%d,%d]'%(self.speed[0],self.speed[1])
    def as_json_object(self):
        inside = ',\n\t\t'.join([
                self._timing_json(),self._position_json(),self._speed_json()
                ])
        return '\n\t\t'.join(['{',inside,'}'])

obs = []
t = 3
init_pos = np.array( [1400,500] )
current_pos = init_pos[:]
speed = [500,30]
width = 200
taxi_xdist = 80
slope = 30

taxi_offset = np.array([0,width/2])
for i in range(5):
    obs.append( Obstacle(t,"taxi",current_pos - taxi_offset,speed) )
    obs.append( Obstacle(t,"taxi",current_pos + taxi_offset,speed) )
    current_pos += np.array([taxi_xdist,slope])

print( ',\n\t\t'.join([o.as_json_object() for o in obs]) )

ast_ymargin = 130
ast_xdist = 150
