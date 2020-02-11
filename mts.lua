function get_day_type(dateTable)
    if (dateTable.wday == 6) then
        return '2'
    end
    if (dateTable.wday == 0) then
        return '3'
    end
    return '1'
end

function get_season()
    return '2'
end


function get_current_seconds()
    local dateTable = os.date("*t", os.time()) 
    return dateTable['hour'] * 3600 + dateTable['min'] * 60  - time_diff * 60
end


function Initialize()
    dofile(SKIN:GetVariable('@')..('json.lua'))
    fname = SKIN:GetVariable('@')..('alldata.json')
    file = io.open(fname, "r")

    id = SELF:GetOption('id')
    line = SELF:GetOption('line')
    local station = SELF:GetNumberOption('station')

    local dateTable = os.date("*t", os.time()) 
    
    day_type = get_day_type(dateTable)

    season = get_season()


    if not file then
        print("ReadFile: unable to open file at " .. fname)
        return
    else
        print("File opened")
        -- read the whole json file and parse it
        data = json.decode(file:read("*all"))
        file:close()

        station = get_station_by_id(data[line][day_type][season]['stations'], station)
        time_diff = station['time_diff']
        SKIN:Bang('!SetOption', id .. 'LineTitleMeter', 'Text', data['lines'][tonumber(line)])
    end
    --print(io.read())
end

local function get_value (tab, val)
    for index, value in ipairs(tab) do
        -- We grab the first index of our sub-table instead
        if value > val then
            return index
        end
    end
    return 0
end

function get_station_by_id(stations, id)
    for idx,value in ipairs(stations) do
        if value['id'] == id then
            print('found station with id ', id)
            return value
        end
    end
    print('station not found with id ', id)
    return nil
end

function secondsToTimeString(seconds, time_diff)
    local hours = (seconds + time_diff * 60) / 3600  
    local minutes = (hours % 1) * 60  
    hours = hours - (hours % 1)
    --print(string.format("%d:%d", hours,minutes))
    return string.format("%d:%.2d", hours,minutes)
end

function Update()

    local secs = get_current_seconds()

    local times = data[line][day_type][season]['times']

    local idx = get_value(times, secs)
    print('idx ' , idx)

    local hours = (times[idx] + time_diff * 60) / 3600  
    local minutes = (hours % 1) * 60  
    hours = hours - (hours % 1)
    --print(string.format("%d:%d", hours,minutes))
    t1 =  secondsToTimeString(times[idx],time_diff)
    t2 =  secondsToTimeString(times[(idx + 1) ],time_diff)
    
    SKIN:Bang('!SetOption', id .. 'Line1TimeMeter', 'Text', t1)
    SKIN:Bang('!SetOption', id .. 'Line2TimeMeter', 'Text', t2)
end