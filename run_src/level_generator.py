import numpy as np
import json

def obstacle(obstacleType, position, speed):
    return {"type": obstacleType,
            "location": list(position),
            "speed": speed
            }

t = '3'
obs = {t: []}
init_pos = np.array( [1400,500] )
current_pos = init_pos[:]
speed = [500,30]
width = 200
taxi_xdist = 80
slope = 20

taxi_offset = np.array([0,width/2])
for i in range(10):
    obs[t].append( obstacle("taxi",current_pos - taxi_offset,speed) )
    obs[t].append( obstacle("taxi",current_pos + taxi_offset,speed) )
    current_pos += np.array([taxi_xdist,slope])

print(json.dumps(obs,indent=2))

ast_ymargin = 130
ast_xdist = 150
