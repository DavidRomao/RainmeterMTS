import requests as req
import json

url = 'http://intranet.mts.pt/api/search'

def getData(line,season,day):
    params = {}
    params['season'] = season
    params['day_type'] = day
    params['line'] = line
    params['stations'] = 15
    resp = req.post(url,  params)
    data = json.loads(resp.content)['data']
    data = {"stations" : data['stations'], 'times' : data['times']}
    return data



def download():
    data = {}
    for line in range(1,7):
        data[line] = {}
        for day in range(1,4):
            data[line][day] = {}
            for season in range(1,3):
                data[line][day][season] = getData(line,season,day)
    return data


def process(data,apply):
    for line in range(1,7):
        for day in range(1,4):
            for season in range(1,3):
                st = data[line][day][season]['stations']
                for idx,val in enumerate(st):
                    if idx > 0:
                        st[idx]['time_diff'] = st[idx]['time_diff']  + st[idx-1]['time_diff'] 
                

def process2(data):
    for line in range(1,7):
        for day in range(1,4):
            for season in range(1,3):
                ts = data[line][day][season]['times']
                for idx, val in enumerate(ts):
                    ts[idx] = ts[idx]['start_time']




f = open("alldata.json", 'w')

#data = download()
#js = json.dumps(data)
f.write(js)
f.close()




