import json


with open("run_src/spawn_lvl_2.json") as json_file: 
	data1 = json.load(json_file)
	
with open("run_src/spawn_lvl_2.json") as json_file: 
	data2 = json.load(json_file)
	
for key in data1:
	if key in data2:
		for elem in data2[key]:
			data1[key].append(elem)

print(data1)

with open("run_src/spawn_merged.json", "w") as outfile: 
	json.dump(data1, outfile)
