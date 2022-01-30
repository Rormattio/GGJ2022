import numpy as np
import json

def obstacle(obstacleType, position, speed):
    return {"type": obstacleType,
            "location": [int(pos) for pos in position],
            "speed": speed
            }

def make_line(nb_taxis, nb_ast, init_pos, speed, width, slope):
    line = []
    taxi_xdist, ast_ymargin, ast_xdist = 80, 130, 140
    current_pos = np.array( init_pos, dtype='int' )
    taxi_offset = np.array([0,width/2], dtype='int')
    for _ in range(nb_taxis):
        line.append( obstacle("taxi", current_pos - taxi_offset, speed) )
        line.append( obstacle("taxi", current_pos + taxi_offset, speed) )
        current_pos += np.array( np.array([1,slope]) * taxi_xdist, dtype='int')
    current_pos = np.array( init_pos, dtype='int' )
    for _ in range(6):
        for i in range(3):
            offset = np.array([0, width/2 + (i+1)*ast_ymargin], dtype='int')
            line.append( obstacle("ast", current_pos - offset, speed) )
            line.append( obstacle("ast", current_pos + offset, speed) )
        current_pos += np.array( np.array([1, slope]) * ast_xdist, dtype='int')

    return line

t = '3'
obs = {
        '3': make_line(10,6,[1400,500],[500,30],200,0.3) \
        + make_line(10,6,[2200,500],[500,30],200,-0.3)
        }

print(json.dumps(obs))
