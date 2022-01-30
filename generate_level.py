import json


with open("run_src/spawn_lvl_2_base.json") as json_file: 
	data = json.load(json_file)
	
times = 9

new_data = {}
for i in range(times):
	offset = i*len(data)
	for j, value in enumerate(data.values()):
		new_data[str(j+offset)] = value 
		 

print(new_data)

with open("run_src/spawn_lvl_2_generated.json", "w") as outfile: 
	json.dump(new_data, outfile)
