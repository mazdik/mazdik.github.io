import urllib.request
import json
import ssl

ssl._create_default_https_context = ssl._create_unverified_context

def get(url):
    request = urllib.request.urlopen(url)
    elevations = request.read()
    data = json.loads(elevations)
    return data

def post(body, url):
    req = urllib.request.Request(url)
    req.add_header('Content-Type', 'application/json; charset=utf-8')
    jsondata = json.dumps(body)
    jsondataasbytes = jsondata.encode('utf-8')  # needs to be bytes
    req.add_header('Content-Length', len(jsondataasbytes))
    response = urllib.request.urlopen(req, jsondataasbytes)
    return response
