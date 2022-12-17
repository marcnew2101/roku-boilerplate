import requests
import os
import zipfile
import sys
import subprocess
from pathlib import Path
from dotenv import load_dotenv
from requests.auth import HTTPDigestAuth

baseUrl = 'http://'
# define root directory (/roku-boilerplate)
rootDir = Path(__file__).parents[1]
# define the path to the build script
buildScriptPath = Path('build.py')
# define zip file location and name
zipFilePath = rootDir / 'out' / 'roku-deploy.zip'
# remove existing zip file
zipFilePath.unlink(True)
# define env file location
envFilePath = rootDir / '.env'
# load env files
load_dotenv(envFilePath)
# define Roku host
host = os.getenv('ROKU_HOST')
# define Roku username
username = 'rokudev'
# define Roku password
pw = os.getenv('ROKU_PASSWORD')
# global retries (always set to zero)
retries = 0
# set to true to immediately deploy the app to Roku or false for file zip only
deployToRoku = True
# this preempts the make script and uses build.py to designate a build type (release, debug) and generate the manifest file
# setting this to False will require manually editing the config.json file for buildType
runBuildFile = True

# define root folders to zip (includes sub folders)
folders = [
    "components",
    "images",
    "locale",
    "source"
]
# define root files to zip
files = [
    "manifest"
]

def sendRequest(
    baseUrl = baseUrl, 
    query = '', 
    port = 80, 
    payload = {}, 
    files = {}, 
    timeout = 5, 
    maxRetries = 3, 
    retryConnection = False, 
    host = host, 
    username = username, 
    pw = pw
    ):
    global retries
    if retryConnection:
        if retries <= maxRetries:
            retries += 1
            print('retrying...')
        else:
            sys.exit("unable to reach Roku device, please verify connection")
    url = baseUrl + host + ':' + str(port) + '/' + query if port != 80 else baseUrl + host + '/' + query
    try:
        req = requests.post(url = url, data=payload, files=files, auth=HTTPDigestAuth(username, pw), timeout=timeout, verify=False)
        if req.status_code == 200:
            fileExists = req.text.find('Identical to previous version')
            if fileExists > -1:
                print("file already exists")
                deleteRokuApp()
                installRokuApp()
            else:
                print('loading roku app...')
    except ConnectionAbortedError:
        print("connection aborted")
        sendRequest(baseUrl=baseUrl, query=query, port=port, payload=payload, files=files, retryConnection=True, host=host, username=username, pw=pw)
    except Exception as e:
        print("something went wrong: " + str(e))
        sendRequest(baseUrl=baseUrl, query=query, port=port, payload=payload, files=files, retryConnection=True, host=host, username=username, pw=pw)
        
def deleteRokuApp():
    print('deleting roku app...')
    payload = {'mySubmit': 'Delete'}
    files = {'archive': ''}
    sendRequest(query = 'plugin_install', payload = payload, files = files)

def installRokuApp(zipFilePath = zipFilePath):
    print('reinstalling roku app...')
    payload = {'mySubmit': 'Install'}
    files = {'archive': open(zipFilePath, 'rb')}
    sendRequest(query = 'plugin_install', payload = payload, files = files)

def replaceRokuApp(zipFilePath = zipFilePath):
    print('installing roku app...')
    payload = {'mySubmit': 'Replace'}
    files = {'archive': open(zipFilePath, 'rb')}
    sendRequest(query = 'plugin_install', payload = payload, files = files)
    
# define an array of file paths
def getFilesAndZip(folders, files):
    filePaths = []
    for folder in folders:
            dirPath = rootDir / folder
            for directory in dirPath.rglob('*'):
                if directory.is_file():
                    filePaths.append(directory)
    for file in files:
        filePath = rootDir / file
        filePaths.append(filePath)
    if len(filePaths) > 0:
        # zip the files
        zipFiles(filePaths)
    else:
        sys.exit("could not get list of files")

def zipFiles(filePaths):
    global deployToRoku
    try:
        with zipfile.ZipFile(zipFilePath, 'w') as archive:
            for file in filePaths:
                archive.write(file, file.relative_to(rootDir))
        print('files compressed')
    except Exception as e:
        print('unable to create zip file: ' + str(e))
    finally:
        archive.close()

# should the build file run first
if runBuildFile:
    try:
        buildType = int(input('which build type? 1=release, 2 or ENTER=debug: '))
        buildType = 'release' if buildType == 1 else 'debug'
    except:
        buildType = 'debug'
        pass
    finally:
        print('running build as ' + buildType)
        subprocess.call(['python', buildScriptPath, buildType])
# get files and compress them
getFilesAndZip(folders, files)
# should the zip file be deployed to Roku device
if deployToRoku: replaceRokuApp()