import sys
import json

build = sys.argv[1:][0]
debugLogLevel = 0
configFile = './components/data/config.json'
manifestFile = './manifest'

buildTypes = [
    'release',
    'debug'
]

if build in buildTypes:
    try:
        with open(configFile, 'r') as config:
            data = json.load(config)
            if 'buildType' not in data:
                sys.exit('config.json is missing key "buildType"')
            else:
                data['buildType'] = build
            if 'debugLogLevel' not in data:
                sys.exit('config.json is missing key "debugLogLevel"')
            else:
                debugLogLevel = data['debugLogLevel']
            if 'manifest' not in data:
                sys.exit('config.json is missing key "manifest"')
            else:
                try:
                    with open(manifestFile, 'w') as manifest:
                        manifestItems = data['manifest']
                        if len(manifestItems) > 0:
                            for key, value in manifestItems.items():
                                manifest.write(key + '=' + str(value) + '\n')
                        if build == 'debug':
                            manifest.write('debug=true\n')
                        else:
                            manifest.write('debug=false\n')
                        manifest.write('debug_log_level=' + str(debugLogLevel) + '\n')
                except FileNotFoundError:
                        print(f'{manifestFile} not found')
                finally:
                    manifest.close()
        with open(configFile, 'w') as file:
            json.dump(data, file, indent=4)
    except FileNotFoundError:
        print(f'{configFile} not found')
    finally:
        config.close()
else:
    print(f'{build} is not valid, please use one of the following build types:')
    for i in buildTypes:
        print(i)