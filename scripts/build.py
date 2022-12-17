import sys
import json
from pathlib import Path

# define root directory (/roku-boilerplate)
rootDir = Path(__file__).parents[1]
# define file paths for config and manifest
configFile = rootDir / 'components' / 'data' / 'config.json'
manifestFile = rootDir / 'manifest'
# get build from script args
build = sys.argv[1:][0]
# define default log levels
debugLogLevel = 0
logging = -1

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
                if build == 'debug':
                    try:
                        logging = int(input('Specify debug logging level? (0, 1, 2, 3, 4) \nor press ENTER to use previously set log level in config: '))
                    except:
                        pass
                    if 'debugLogLevel' not in data:
                        sys.exit('config.json is missing key "debugLogLevel"')
                    else:
                        debugLogLevel = logging if logging >= 0 else data['debugLogLevel']
                        data['debugLogLevel'] = debugLogLevel
                        print("logging level set to " + str(debugLogLevel))
            if 'manifest' not in data:
                sys.exit('config.json is missing key "manifest"')
            else:
                try:
                    with open(manifestFile, 'w') as manifest:
                        manifestItems = data['manifest']
                        if len(manifestItems) > 0:
                            for item in manifestItems:
                                manifest.write(item['comment'] + '\n')
                                for key, value in item.items():
                                    if key != 'note' and key != 'comment':
                                        manifest.write(key + '=' + str(value) + '\n')
                                manifest.write('\n')
                        manifest.write('## Debug Settings ##' + '\n')
                        isDebug = 'true' if build == 'debug' else 'false'
                        manifest.write('debug=' + isDebug + '\n')
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