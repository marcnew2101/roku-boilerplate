import sys
import json

build = sys.argv[1:][0]
fileName = "./components/data/config.json"

buildTypes = [
    "release",
    "debug"
]

if build in buildTypes:
    try:
        with open(fileName, 'r') as file:
            data = json.load(file)
            if 'buildType' not in data:
                sys.exit("config.json is missing key 'buildType'")
            else:
                data['buildType'] = build
        with open(fileName, 'w') as file:
            json.dump(data, file, indent=4)
    except FileNotFoundError:
        print(f"{fileName} not found")
else:
    print(f"{build} is not valid, please use one of the following build types:")
    for i in buildTypes:
        print(i)