local Schwimmbad = createWater(1867, -1444, 10, 1968, -1443, 10, 1867, -1372, 10, 1968, -1370, 10)
setWaterLevel(Schwimmbad, 12.48)

setOcclusionsEnabled(false)
removeWorldModel(4215,100,1779.599609375,-1782.2001953125,18.39999961853)
removeWorldModel(4003,50,1490.49,-1747.12,34.26)
removeWorldModel(620,100,1482.27734375,-1779.2225341797,13.569999694824)
removeWorldModel(713,100,1482.27734375,-1779.2225341797,13.569999694824)
removeWorldModel(673,100,1482.27734375,-1779.2225341797,13.569999694824)
removeWorldModel(4217,100,1482.27734375,-1779.2225341797,13.569999694824)
removeWorldModel(713,100,1494.4670410156,-1704.9368896484,13.385938644409)
removeWorldModel(5766,100,1146.7337646484,-1190.2601318359,33.1171875)





-- Fix für "The Welcome Pump" Interior
local o = createObject(974, 681.6, -448.0, -26.7, 90, 0, 0)
setElementInterior(o, 1)
setElementDimension(o, -1)
local o = createObject(974, 682.7, -447.4, -23.8, 0, 0, 90)
setElementInterior(o, 1)
setElementDimension(o, -1)
local o = createObject(974, 680.4, -447.4, -23.8, 0, 0, 90)
setElementInterior(o, 1)
setElementDimension(o, -1)