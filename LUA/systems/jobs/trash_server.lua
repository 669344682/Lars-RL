----------------------------------------------------
----------------------------------------------------
------ Copyright (c) 2014-2018 FirstOne Media ------
----------------------------------------------------
------ Commercial use or Copyright removal is ------
------ strictly prohibited without permission ------
----------------------------------------------------
----------------------------------------------------

local JobID					= 7
local pricePerRubbish		= 30
local pricePerSmallBin		= 40
local pricePerBigBin		= 60
local maxPlayersRubbish	= 15
local maxPlayersBin		= 15
local RubbishIds				= {2670, 2675, 2814, 2953, 2671, 2674, 2673}
local BigBinIds				= {1331, 1332, 1333}
local SmallBinIds			= {1337, 1339}

local curRubbish				= {}
local curBin					= {}


local Rubbish = {
	{
		pos = {2218.8, -2148.5, 12.5},
	},
	{
		pos = {2264.7, -2096.8999, 12.8},
	},
	{
		pos = {2382.5, -2052.8999, 14.3},
	},
	{
		pos = {2539.2, -2046.9, 24.2},
	},
	{
		pos = {2712.2, -2088.8, 10.5},
	},
	{
		pos = {2762.3999, -2050.2, 11.4},
	},
	{
		pos = {2664.6001, -2002.5, 12.5},
	},
	{
		pos = {2741.7, -1990.5, 12.4},
	},
	{
		pos = {2766, -1934, 12.4},
	},
	{
		pos = {2674.7, -1876.6, 10},
	},
	{
		pos = {2659.2, -1661.6, 9.8},
	},
	{
		pos = {2523.8999, -1750.9, 12.5},
	},
	{
		pos = {2416.5, -1781.1, 12.5},
	},
	{
		pos = {2409.5, -1932, 12.5},
	},
	{
		pos = {2337.6001, -1974.7, 12.4},
	},
	{
		pos = {2315.3, -1948, 12.5},
	},
	{
		pos = {2213.5, -1972.6, 12.5},
	},
	{
		pos = {2263.3999, -1890.7, 12.4},
	},
	{
		pos = {2221.1001, -1833.1, 12.3},
	},
	{
		pos = {2279.1001, -1751.1, 12.5},
	},
	{
		pos = {2309.5, -1729.1, 12.5},
	},
	{
		pos = {2345.3, -1698.3, 12.5},
	},
	{
		pos = {2373.5, -1655.9, 12.5},
	},
	{
		pos = {2467.8999, -1664.7, 12.4},
	},
	{
		pos = {2482.8, -1656.3, 12.4},
	},
	{
		pos = {2190.2, -1665, 13.8},
	},
	{
		pos = {2178, -1756.6, 12.5},
	},
	{
		pos = {2101.5, -1747.2, 12.5},
	},
	{
		pos = {2083.5, -1687, 12.5},
	},
	{
		pos = {2082, -1785.9, 12.5},
	},
	{
		pos = {2092, -1896.5, 12.5},
	},
	{
		pos = {2053.1001, -1937.6, 12.4},
	},
	{
		pos = {1970.9, -1928.5, 12.5},
	},
	{
		pos = {1965, -1967.4, 12.6},
	},
	{
		pos = {1957.3, -2057.3, 12.5},
	},
	{
		pos = {1963.6, -2154.3, 12.5},
	},
	{
		pos = {1929.3, -2168.5, 12.5},
	},
	{
		pos = {1823.7, -2162.3, 12.5},
	},
	{
		pos = {1817.9, -2070.2, 12.5},
	},
	{
		pos = {1959.3, -1856.4, 12.5},
	},
	{
		pos = {1988, -1810.3, 12.5},
	},
	{
		pos = {1948.9, -1756.5, 12.5},
	},
	{
		pos = {2036.8, -1755.2, 12.5},
	},
	{
		pos = {1937.5, -1627.8, 12.5},
	},
	{
		pos = {1879.9, -1614.5, 12.5},
	},
	{
		pos = {1821.2, -1619.8, 12.5},
	},
	{
		pos = {1809.1, -1728.3, 12.5},
	},
	{
		pos = {1819.7, -1817.7, 12.5},
	},
	{
		pos = {1797.4, -1858, 12.5},
	},
	{
		pos = {1830.8, -1929.9, 12.5},
	},
	{
		pos = {1694.2, -1805.3, 12.5},
	},
	{
		pos = {1671.1, -1873.4, 12.5},
	},
	{
		pos = {1566.4, -1869.6, 12.5},
	},
	{
		pos = {1422.7, -1876.6, 12.5},
	},
	{
		pos = {1408.9, -1932, 15.5},
	},
	{
		pos = {1246.7, -1924.9, 30.3},
	},
	{
		pos = {1392.6, -1812.8, 12.5},
	},
	{
		pos = {1380.9, -1730.8, 12.5},
	},
	{
		pos = {1317.8, -1736.2, 12.5},
	},
	{
		pos = {1314.5, -1603.3, 12.5},
	},
	{
		pos = {1364.8, -1580.4, 12.5},
	},
	{
		pos = {1488.4, -1587.9, 12.5},
	},
	{
		pos = {1535.5, -1621.6, 12.5},
	},
	{
		pos = {1423.4, -1728.1, 12.5},
	},
	{
		pos = {1435.5, -1551.3, 12.5},
	},
	{
		pos = {1466.9, -1439.7, 12.5},
	},
	{
		pos = {1421.4, -1437.5, 12.5},
	},
	{
		pos = {1453.4, -1301.1, 12.5},
	},
	{
		pos = {1538.2, -1297.8, 14.9},
	},
	{
		pos = {1611.5, -1310.9, 16.4},
	},
	{
		pos = {1716.7, -1284.7, 12.5},
	},
	{
		pos = {1709.6, -1161.5, 22.8},
	},
	{
		pos = {1648.5, -1160.6, 23},
	},
	{
		pos = {1551.6, -1064.2, 22.7},
	},
	{
		pos = {1371.3, -1025.9, 25.6},
	},
	{
		pos = {1358.2, -1102.6, 23},
	},
	{
		pos = {1363.9, -1241, 12.5},
	},
	{
		pos = {1330.2, -1283.7, 12.5},
	},
	{
		pos = {1341.9, -1396.1, 12.5},
	},
	{
		pos = {1292.5, -1403.7, 12.3},
	},
	{
		pos = {1257.9, -1331.8, 12.1},
	},
	{
		pos = {1168.1, -1407.1, 12.5},
	},
	{
		pos = {1195.1, -1447.2, 12.5},
	},
	{
		pos = {1236.1, -1571.4, 12.5},
	},
	{
		pos = {1141.2, -1572.3, 12.4},
	},
	{
		pos = {1150.9, -1626.1, 12.9},
	},
	{
		pos = {1172.4, -1761.6, 12.5},
	},
	{
		pos = {1232.2, -1710.6, 12.5},
	},
	{
		pos = {1038.1, -1786.5, 12.7},
	},
	{
		pos = {1055.1, -1832.8, 12.6},
	},
	{
		pos = {947.90002, -1791, 13.1},
	},
	{
		pos = {947.90002, -1791, 13.1},
	},
	{
		pos = {915.09998, -1710.4, 12.5},
	},
	{
		pos = {879.09998, -1574, 12.5},
	},
	{
		pos = {808.20001, -1667, 12.5},
	},
	{
		pos = {784.79999, -1590.7, 12.5},
	},
	{
		pos = {783, -1530.4, 12.5},
	},
	{
		pos = {800.90002, -1393.2, 12.6},
	},
	{
		pos = {652.20001, -1405.2, 12.5},
	},
	{
		pos = {630.40002, -1514.7, 13.9},
	},
	{
		pos = {610.40002, -1594.2, 15.1},
	},
	{
		pos = {621.20001, -1679.4, 14.9},
	},
	{
		pos = {613.5, -1729.8, 12.9},
	},
	{
		pos = {457.20001, -1726.6, 9.4},
	},
	{
		pos = {440.5, -1775, 4.4},
	},
	{
		pos = {320.29999, -1741.4, 3.5},
	},
	{
		pos = {342.70001, -1698, 5.7},
	},
	{
		pos = {178.10001, -1594.5, 12.9},
	},
	{
		pos = {189.60001, -1517.8, 11.6},
	},
	{
		pos = {286.20001, -1483.4, 31.5},
	},
	{
		pos = {239.5, -1576.8, 32.1},
	},
	{
		pos = {331.5, -1571.3, 32.2},
	},
	{
		pos = {386.10001, -1507.3, 31.4},
	},
	{
		pos = {406, -1432.8, 31.8},
	},
	{
		pos = {361.5, -1433.5, 33.4},
	},
	{
		pos = {481, -1354, 17.2},
	},
	{
		pos = {536.90002, -1260.1, 15.5},
	},
	{
		pos = {392.60001, -1226.3, 51.2},
	},
	{
		pos = {565.09998, -1189.8, 43.8},
	},
	{
		pos = {614.29999, -1109.6, 46},
	},
	{
		pos = {386.20001, -1171.8, 77.9},
	},
	{
		pos = {297, -1256.6, 71.5},
	},
	{
		pos = {339.20001, -1279.8, 53.1},
	},
	{
		pos = {165, -1401.9, 45.9},
	},
	{
		pos = {96.8, -1522.6, 5},
	},
	{
		pos = {379.60001, -1355.7, 13.6},
	},
	{
		pos = {646.70001, -1209.4, 17.2},
	},
	{
		pos = {641.90002, -1325.4, 12.5},
	},
	{
		pos = {800.90002, -1315.4, 12.5},
	},
	{
		pos = {801.90002, -1142.4, 23.1},
	},
	{
		pos = {799.90002, -1039.4, 23.9},
	},
	{
		pos = {916.40002, -981.90002, 37.2},
	},
	{
		pos = {1040.6, -949.5, 41.7},
	},
	{
		pos = {1155.3, -952.09998, 41.9},
	},
	{
		pos = {1250.6, -929.79999, 41.7},
	},
	{
		pos = {1367.6, -939.29999, 33.3},
	},
	{
		pos = {1260.5, -1038.1, 30.9},
	},
	{
		pos = {1162.1, -1047.8, 30.8},
	},
	{
		pos = {1038.7, -1042.6, 30.8},
	},
	{
		pos = {965.90002, -1111.5, 22.8},
	},
	{
		pos = {942.5, -1242.6, 15.3},
	},
	{
		pos = {1049.6, -1223.1, 16},
	},
	{
		pos = {1100.3, -1278.8, 12.6},
	},
	{
		pos = {1061.9, -1395.9, 12.6},
	},
	{
		pos = {1042, -1556.1, 12.5},
	},
	{
		pos = {1040.5, -1660.8, 12.5},
	},
	{
		pos = {1122.1, -1714.6, 12.5},
	},
	{
		pos = {936, -1487.4, 12.5},
	},
	{
		pos = {916.70001, -1447.4, 12.5},
	},
	{
		pos = {923.20001, -1391.5, 12.5},
	},
	{
		pos = {538.59998, -1506, 13.5},
	},
	{
		pos = {1217, -1151.8, 22.5},
	},
	{
		pos = {1217.1, -1264.7, 12.9},
	},
	{
		pos = {1458.6, -1162.2, 22.8},
	},
	{
		pos = {1868.4, -1155.1, 22.8},
	},
	{
		pos = {1886.6, -1040.5, 22.8},
	},
	{
		pos = {1987, -1047.9, 23.5},
	},
	{
		pos = {1973.6, -1123.9, 24.9},
	},
	{
		pos = {2055, -1137.8, 22.9},
	},
	{
		pos = {2075.1001, -1211.7, 22.9},
	},
	{
		pos = {2147.3, -1221.8, 22.9},
	},
	{
		pos = {2267.1001, -1217.5, 22.9},
	},
	{
		pos = {2275, -1145.4, 25.8},
	},
	{
		pos = {2206, -1123.3, 24.7},
	},
	{
		pos = {2113, -1110.6, 24.2},
	},
	{
		pos = {2015.9, -1263.3, 22.9},
	},
	{
		pos = {2041.9, -1341.6, 22.9},
	},
	{
		pos = {1985.2, -1350.3, 22.9},
	},
	{
		pos = {1981.5, -1465.5, 12.5},
	},
	{
		pos = {2116.3, -1464.7, 22.9},
	},
	{
		pos = {2184, -1384.6, 22.99},
	},
	{
		pos = {2307.8, -1377.2, 23},
	},
	{
		pos = {2328.2, -1299.2, 23.2},
	},
	{
		pos = {2373.2, -1205.3, 26.5},
	},
	{
		pos = {2351.8999, -1152.7, 26.3},
	},
	{
		pos = {2461.3, -1185.6, 35.7},
	},
	{
		pos = {2576.7, -1182.6, 60.8},
	},
	{
		pos = {2736.1001, -1168.5, 68.4},
	},
	{
		pos = {2712.3999, -1071.3, 68.4},
	},
	{
		pos = {2628.8999, -1049.7, 68.5},
	},
	{
		pos = {2550.5, -1051.7, 68.5},
	},
	{
		pos = {2507.1001, -1092.6, 50.9},
	},
	{
		pos = {2313.7, -1149.9, 25.9},
	},
	{
		pos = {2249.3, -1222.1, 22.9},
	},
	{
		pos = {1845, -1440.1, 12.5},
	},
	{
		pos = {1835.8, -1562.8, 12.5},
	},
	{
		pos = {1700.1, -1442.6, 12.5},
	},
	{
		pos = {1571.2, -1442.4, 12.5},
	},
	{
		pos = {2275.3, -1483.9, 21.7},
	},
	{
		pos = {2344.5, -1511.5, 22.9},
	},
	{
		pos = {2440.1001, -1502.1, 22.9},
	},
	{
		pos = {2453.7, -1432.6, 22.9},
	},
	{
		pos = {2416.8999, -1253.4, 22.9},
	},
	{
		pos = {2510.8999, -1311.4, 33.8},
	},
	{
		pos = {2644.2, -1387.2, 29.4},
	},
	{
		pos = {2678.3999, -1417.8, 29.4},
	},
	{
		pos = {2581.7, -1447, 33.8},
	},
	{
		pos = {2483.6001, -1443.5, 25},
	},
	{
		pos = {2545, -1505.7, 23},
	},
}

local BigBins = {
	{
		pos = {1933.2, -2111.3999, 13.6, 0},
	},
	{
		pos = {2009.6, -2142.2, 13.5, 0},
	},
	{
		pos = {1994.2, -2014.7, 13.5, 0},
	},
	{
		pos = {2053, -1898.5, 13.5, 0},
	},
	{
		pos = {2122.8999, -1790.2, 13.5, 0},
	},
	{
		pos = {1970.7, -1779.2, 13.5, 90},
	},
	{
		pos = {1846.7, -1862.6, 13.5, 90},
	},
	{
		pos = {1770.5, -1910.1, 13.5, 90},
	},
	{
		pos = {2276.6001, -1672.6, 15.1, 90},
	},
	{
		pos = {2304.6001, -1629.9, 14.5, 0},
	},
	{
		pos = {2386.3999, -1547.8, 24.1, 0},
	},
	{
		pos = {2392, -1469.3, 23.9, 0},
	},
	{
		pos = {2431.8999, -1220.5, 25.3, 0},
	},
	{
		pos = {2140.2, -1158.4, 23.9, 90},
	},
	{
		pos = {1970.7, -1282.7, 23.9, 0},
	},
	{
		pos = {1870.1, -1627.4, 13.3, 0},
	},
	{
		pos = {1614.3, -1895.3, 13.5, 0},
	},
	{
		pos = {1368.4, -1900.7, 13.4, 0},
	},
	{
		pos = {1344.4, -1758.3, 13.4, 0},
	},
	{
		pos = {1462.5, -1506.8, 13.5, 90},
	},
	{
		pos = {1046.7, -1672.6, 13.5, 90},
	},
	{
		pos = {786.90002, -1638.7, 13.3, 0},
	},
	{
		pos = {456.39999, -1486.6, 31, 288},
	},
	{
		pos = {354.29999, -1308.1, 14.5, 30},
	},
	{
		pos = {704.70001, -1439.7, 13.5, 0},
	},
	{
		pos = {986.59998, -892.79999, 42.4, 0},
	},
	{
		pos = {1216.7, -870.70001, 43.1, 0},
	},
	{
		pos = {1012.5, -1006, 32, 0},
	},
	{
		pos = {1422, -1133, 23.9, 0},
	},
	{
		pos = {2491.7, -1556, 24, 90},
	},
	{
		pos = {2450.8999, -1785.1, 13.5, 90},
	},
	{
		pos = {2386.3999, -2014.2, 13.5, 90},
	},
	{
		pos = {1809.5, -1393.6, 13.3, 90},
	},
	{
		pos = {1428.3, -1389.6, 13.5, 90},
	},
	{
		pos = {1147.5, -1345.4, 13.6, 0},
	},
	{
		pos = {960.5, -1521.2, 13.5, 0},
	},
	{
		pos = {809.40002, -1156.2, 23.7, 0},
	},
	{
		pos = {865.09998, -1383, 13.5, 0},
	},
	{
		pos = {1183.9, -1119.5, 24.2, 0},
	},
	{
		pos = {1034.5, -1259.2, 15.1, 0},
	},
	{
		pos = {1606.4, -1640.6, 13.6, 90},
	},
	{
		pos = {1628.2, -1509.6, 13.5, 0},
	},
	{
		pos = {1712.6, -1132.2, 24, 0},
	},
	{
		pos = {2112.3, -1598.8, 13.5, 0},
	},
	{
		pos = {2224.3, -1371.4, 23.9, 0},
	},
	{
		pos = {2016.7, -1040.6, 24.7, 0},
	},
	{
		pos = {2590.5, -1323.3, 39.7, 266},
	},
	{
		pos = {2176.3999, -1908.5, 13.4, 265.995},
	},
	{
		pos = {2257.7, -2243.8999, 13.5, 319.995},
	},
	{
		pos = {2722.8999, -2021.2, 13.5, 265.993},
	},
	{
		pos = {2676.5, -1540.9, 25.3, 183.99},
	},
	{
		pos = {2802.8, -1258.6, 46.9, 125.988},
	},
	{
		pos = {2786.8, -1647.6, 11, 181.986},
	},
	{
		pos = {708.40002, -1194, 15.2, 229.983},
	},
	{
		pos = {644.90002, -1776.2, 12, 167.982},
	},
}

local SmallBins = {
	{
		pos = {1862, -2061.5, 13.2},
	},
	{
		pos = {1975.9, -2048.3999, 13.2},
	},
	{
		pos = {1947.5, -1875.4, 13.2},
	},
	{
		pos = {2039.9, -1623.8, 16},
	},
	{
		pos = {2045.1, -1704.2, 14.4},
	},
	{
		pos = {2129, -1724.1, 13.2},
	},
	{
		pos = {2375.3, -1759.7, 13.2},
	},
	{
		pos = {2103.7, -1360, 23.6},
	},
	{
		pos = {2027.2, -1330.4, 23.6},
	},
	{
		pos = {1832.6, -1313.8, 13.2},
	},
	{
		pos = {1850.7, -1171.4, 23.5},
	},
	{
		pos = {1908.1, -1125.9, 24.3},
	},
	{
		pos = {2012.2, -1126, 24.8},
	},
	{
		pos = {2081.3999, -1187, 23.5},
	},
	{
		pos = {2144.3999, -1230.3, 23.6},
	},
	{
		pos = {2181.8, -1260.3, 23.6},
	},
	{
		pos = {2312.1001, -1222.7, 23.8},
	},
	{
		pos = {2458.7, -1282.1, 23.6},
	},
	{
		pos = {2515.7, -1357.4, 31.2},
	},
	{
		pos = {2518.5, -1454.3, 28.2},
	},
	{
		pos = {2442.3, -1418.8, 23.6},
	},
	{
		pos = {2333.8, -1506.6, 23.6},
	},
	{
		pos = {2001.4, -1924.4, 13.3},
	},
	{
		pos = {1806.9, -1722.4, 13.2},
	},
	{
		pos = {1227.7, -1561.5, 13.2},
	},
	{
		pos = {1016.4, -1501.9, 13.2},
	},
	{
		pos = {907.90002, -1637.6, 13.2},
	},
	{
		pos = {849.09998, -1796.3, 13.5},
	},
	{
		pos = {437.5, -1732.1, 9.1},
	},
	{
		pos = {428.89999, -1600.5, 25.4},
	},
	{
		pos = {525.5, -1363.6, 15.7},
	},
	{
		pos = {828.79999, -1335.9, 13.2},
	},
	{
		pos = {952.40002, -1213, 16.6},
	},
	{
		pos = {1091.8, -1111.5, 24},
	},
	{
		pos = {1284.2, -1029.6, 31.4},
	},
	{
		pos = {1590.6, -1170.3, 23.7},
	},
	{
		pos = {1664.8, -1315.9, 14.1},
	},
	{
		pos = {1462.8, -1452, 13.2},
	},
	{
		pos = {1419.5, -1610.3, 13.2},
	},
	{
		pos = {1577.9, -1772.3, 13.1},
	},
	{
		pos = {1289.9, -1632.9, 13.2},
	},
	{
		pos = {1182.6, -1705.1, 15.5},
	},
	{
		pos = {1028.4, -1719.1, 13.2},
	},
	{
		pos = {617.70001, -1524.3, 14.8},
	},
	{
		pos = {648.09998, -1660.9, 14.5},
	},
	{
		pos = {763, -1685.3, 3.8},
	},
	{
		pos = {784, -1554.3, 13.2},
	},
	{
		pos = {928.40002, -1474.4, 13.2},
	},
	{
		pos = {1000.3, -1387, 13},
	},
	{
		pos = {1207.1, -1413.3, 13},
	},
	{
		pos = {1365.8, -1310.4, 13.2},
	},
	{
		pos = {1465.9, -1287.9, 13.2},
	},
	{
		pos = {1626.3, -1448.4, 13.2},
	},
	{
		pos = {1724.3, -1433, 14.3},
	},
	{
		pos = {1737.4, -1320.6, 13.2},
	},
	{
		pos = {1823.5, -1451.7, 13.2},
	},
	{
		pos = {1973.2, -1452.4, 13.2},
	},
	{
		pos = {2322.3, -1951.1, 13.2},
	},
	{
		pos = {2231.6001, -1904, 13.2},
	},
	{
		pos = {2348.5, -2040.7, 13.2},
	},
	{
		pos = {2224.3999, -1947.9, 13.2},
	},
	{
		pos = {2251.1001, -1723.4, 13.2},
	},
	{
		pos = {2540.2, -1722.5, 13.2},
	},
	{
		pos = {2425.3999, -1941, 13.2},
	},
	{
		pos = {2299.8999, -1982, 13.2},
	},
	{
		pos = {1379, -1597.4, 13.2},
	},
	{
		pos = {1176.2, -1289.8, 13.2},
	},
	{
		pos = {1224.8, -1242.1, 15.4},
	},
	{
		pos = {1313.6, -1131.9, 23.5},
	},
	{
		pos = {958.20001, -942, 40},
	},
	{
		pos = {768.09998, -1037.8, 23.7},
	},
	{
		pos = {648.5, -1311.5, 13.2},
	},
	{
		pos = {886.59998, -974.40002, 36.7},
	},
	{
		pos = {1519.6, -1032.3, 24.4},
	},
	{
		pos = {1157.6, -1631.2, 13.6},
	},
	{
		pos = {1147.7, -1860.4, 13.2},
	},
	{
		pos = {1028.5, -1770.7, 13.2},
	},
	{
		pos = {1350.6, -1491.6, 13.2},
	},
}



-- Level 1
local function spawnRubbish()
	for i, rub in ipairs(Rubbish) do
		
		local updateBlip = false
		local x, y, z		= unpack(rub.pos)
		if (not rub.obj or not isElement(rub.obj)) then
			Rubbish[i].obj = createObject(RubbishIds[math.random(#RubbishIds)], x, y, z)
			setElementData(Rubbish[i].obj, "rubbish", true)
			setElementData(Rubbish[i].obj, "rubbishID", i)
			updateBlip = true
		end
		
		if (not rub.blip) then
			Rubbish[i].blip	= createBlip(x, y, z, 0, 2, 0, 255, 0, 255, 0, 300)
			updateBlip			= true
		end
		
		if (updateBlip) then
			setElementVisibleTo(Rubbish[i].blip, root, false)
			
			for k, v in pairs(getElementsByType("player")) do
				if (Jobs:IsInJob(v) == JobID and tonumber(getElementData(v, "inJobLevel")) == 1) then
					setElementVisibleTo(Rubbish[i].blip, v, true)
				end
			end
		end
		
	end
end
spawnRubbish()
setTimer(function()
	spawnRubbish()
end, 10*60000, 0)
--addCommandHandler("rub", spawnRubbish)


local function onRubbishHit(elem, dim)
	if (elem and dim) then
		if (getElementType(elem) == "object") then
			if (getElementData(elem, "rubbish")) then
				local pName = getElementData(source, "owner")
				if (pName) then
					local player = getPlayerFromName(pName)
					if (player) then
						
						Jobs:AddEarnings(player, JobID, pricePerRubbish)
						Jobs:AddLevel(player, JobID, 1)
						
						local id = getElementData(elem, "rubbishID")
						setElementVisibleTo(Rubbish[id].blip, root, false)
						setElementVisibleTo(Rubbish[id].blip, player, false)
						Rubbish[id].obj = nil
						
						destroyElement(elem)
						
					end
				end
			end
		end
	end
end



-- Level 2
local function searchBin(elem, dim)
	if (elem and dim) then
		if (getElementType(elem) == "player" and not isPedInVehicle(elem)) then
			
			local bX, bY, bZ = 0, 0, 0
			local pX, pY, pZ = getElementPosition(elem)
			local bintyp		= false
			
			local now = getRealTime().timestamp
			if (getElementData(source, "smallbinID")) then
				local id = getElementData(source, "smallbinID")
				bX, bY, bZ = getElementPosition(SmallBins[id].obj)
				if ((now-SmallBins[id].lastSearch) >= (60000*10)) then
					bintyp = "small"
					SmallBins[id].lastSearch = now
				end
				
			elseif (getElementData(source, "bigbinID")) then
				local id = getElementData(source, "bigbinID")
				bX, bY, bZ = getElementPosition(BigBins[id].obj)
				if ((now-BigBins[id].lastSearch) >= (60000*10)) then
					bintyp = "big"
					BigBins[id].lastSearch = now
				end
				
			end
			
			
			local rot = findRotation(pX, pY, bX, bY)
			setElementRotation(elem, 0, 0, rot)
			setPedAnimation(elem, "ped", "ATM", -1, true, false, false)
			toggleAllControls(elem, false)
			
			
			setTimer(function()
				setPedAnimation(elem)
				toggleAllControls(elem, true)
				
				if (bintyp ~= false) then
					local rnd = math.random(1, 11)
					
					local txt = ""
					if (rnd == 1) then
						local am = math.random(1, 75)
						if (bintyp == "big") then
							am = math.random(50, 150)
						end
						givePlayerMoney(elem, am, "Mülltonne")
						txt = am.." $"
						
					elseif (rnd == 2) then
						giveWeapon(elem, 1, 1, true)
						txt = "einen Schlagring"
						
					elseif (rnd == 3) then
						if (bintyp == "big") then
							giveWeapon(elem, 22, math.random(5, 20), true)
							txt = "eine Pistole"
						else
							giveWeapon(elem, 4, 1, true)
							txt = "ein Messer"
						end
						
					elseif (rnd == 4) then
						giveWeapon(elem, 14, 1, true)
						txt = "einen Strauß Blumen"
						
					elseif (rnd == 5) then
						giveWeapon(elem, math.random(10, 12), 1, true)
						txt = "einen Dildo"
						
					elseif (rnd == 6) then
						addInventory(elem, "firstaid", 1)
						txt = "einen Verbandskasten"
						
					elseif (rnd == 7) then
						addInventory(elem, "cigarettes", math.random(1,15))
						txt = "ein paar Zigaretten"
						
					elseif (rnd == 8) then
						addInventory(elem, "toolbox", 1)
						txt = "ein Repair-Kit"
						
					elseif (rnd == 9) then
						addInventory(elem, "schoko", 1)
						txt = "einen Schokoriegel"
						
					elseif (rnd == 10) then
						addInventory(elem, "sprunk", 1)
						txt = "eine Limo"
						
					elseif (rnd == 11) then
						addInventory(elem, "beer", 1)
						txt = "ein Bier"
					end
					
					infoShow(elem, "info", "Du hast "..txt.." in der Mülltonne gefunden.")
					
				else
					infoShow(elem, "info", "Hier ist nichts drin.")
				end
			end, 5000, 1)
			
		end
	end
end




local function spawnBins()
	for i, bin in ipairs(SmallBins) do
		
		local updateBlip = false
		local x, y, z		= unpack(bin.pos)
		if (not bin.obj or not isElement(bin.obj)) then
			SmallBins[i].obj = createObject(SmallBinIds[math.random(#SmallBinIds)], x, y, z)
			setElementData(SmallBins[i].obj, "smallbin", true)
			setElementData(SmallBins[i].obj, "smallbinID", i)
			updateBlip = true
		end
		
		if (not bin.blip) then
			SmallBins[i].blip	= createBlip(x, y, z, 0, 2, 0, 255, 0, 255, 0, 300)
			updateBlip			= true
		end
		
		if (not bin.col) then
			SmallBins[i].col				= createColSphere(x, y, z, 0.72)
			SmallBins[i].lastSearch	= 0
			setElementData(SmallBins[i].col, "smallbinID", i)
			addEventHandler("onColShapeHit", SmallBins[i].col, searchBin)
		end
		
		if (updateBlip) then
			setElementVisibleTo(SmallBins[i].blip, root, false)
			
			for k, v in pairs(getElementsByType("player")) do
				if (Jobs:IsInJob(v) == JobID and tonumber(getElementData(v, "inJobLevel")) == 2) then
					setElementVisibleTo(SmallBins[i].blip, v, true)
				end
			end
		end
		
	end
	
	
	for i, bin in ipairs(BigBins) do
		
		local updateBlip = false
		local x, y, z, rz	= unpack(bin.pos)
		if (not bin.obj or not isElement(bin.obj)) then
			BigBins[i].obj = createObject(BigBinIds[math.random(#BigBinIds)], x, y, z, 0, 0, rz)
			setElementFrozen(BigBins[i].obj, true)
			setElementData(BigBins[i].obj, "bigbin", true)
			setElementData(BigBins[i].obj, "bigbinID", i)
			updateBlip = true
		end
		
		if (not bin.blip) then
			BigBins[i].blip	= createBlip(x, y, z, 0, 2, 255, 0, 0, 255, 0, 300)
			updateBlip			= true
		end
		
		if (not bin.col) then
			BigBins[i].col				= createColSphere(x, y, z, 1.2)
			BigBins[i].lastSearch	= 0
			setElementData(BigBins[i].col, "bigbinID", i)
			addEventHandler("onColShapeHit", BigBins[i].col, searchBin)
		end
		
		if (updateBlip) then
			setElementVisibleTo(BigBins[i].blip, root, false)
			
			for k, v in pairs(getElementsByType("player")) do
				if (Jobs:IsInJob(v) == JobID and tonumber(getElementData(v, "inJobLevel")) == 2) then
					setElementVisibleTo(BigBins[i].blip, v, true)
				end
			end
		end
		
	end
end
spawnBins()
setTimer(function()
	spawnBins()
end, 9*60000, 0)
--addCommandHandler("bin", spawnBins)


local function onBinHit(elem, dim)
	if (elem and dim) then
		if (getElementType(elem) == "object") then
			local pName = getElementData(source, "owner")
			if (pName) then
				local player = getPlayerFromName(pName)
				if (player) then
					
					if (getElementData(elem, "smallbin")) then
						
						local id = getElementData(elem, "smallbinID")
						if (SmallBins[id].blip and isElementVisibleTo(SmallBins[id].blip, player)) then
							setElementFrozen(player, true)
							setElementFrozen(getPedOccupiedVehicle(player), true)
							setTimer(function()
								Jobs:AddEarnings(player, JobID, pricePerSmallBin)
								Jobs:AddLevel(player, JobID, 1)
								
								destroyElement(SmallBins[id].blip)
								SmallBins[id].blip = nil
								setElementFrozen(player, false)
								setElementFrozen(getPedOccupiedVehicle(player), false)
							end, 1500, 1)
						end
						
					elseif (getElementData(elem, "bigbin")) then
						
						local id = getElementData(elem, "bigbinID")
						if (BigBins[id].blip and isElementVisibleTo(BigBins[id].blip, player)) then
							setElementFrozen(player, true)
							setElementFrozen(getPedOccupiedVehicle(player), true)
							setTimer(function()
								Jobs:AddEarnings(player, JobID, pricePerBigBin)
								Jobs:AddLevel(player, JobID, 1)
								
								destroyElement(BigBins[id].blip)
								BigBins[id].blip = nil
								setElementFrozen(player, false)
								setElementFrozen(getPedOccupiedVehicle(player), false)
							end, 2222, 1)
						end
						
					end
					
				end
			end
		end
	end
end




_G["TrashStart"] = function(player, level)
	local state = false
		
	if (level == 1) then
		
		if (#curRubbish < maxPlayersRubbish) then
			
			local pName = getPlayerName(player)
			
			curRubbish[pName] = {}
			
			local fx, fy, fz, frz = 2116.6, -2100.2, 13.6, 255
			
			curRubbish[pName].trashmaster = createVehicle(574, fx, fy, fz, 0, 0, frz)
			setElementData(curRubbish[pName].trashmaster, "jobOwner", pName)
			
			curRubbish[pName].col = createColSphere(fx, fy, fz, 1)
			setElementData(curRubbish[pName].col, "owner", pName)
			attachElements(curRubbish[pName].col, curRubbish[pName].trashmaster, 0, .8, -.6)
			
			addEventHandler("onColShapeHit", curRubbish[pName].col, onRubbishHit)
			
			fadeElementInterior(player, 0, fx, fy, fz, 0, 0, true)
			setTimer(function()
				warpPedIntoVehicle(player, curRubbish[pName].trashmaster)
				infoShow(player, "info", "Fahre über den Müll, um ihn aufzusammeln. Der Müll ist auf der Kate markiert.")
				infoShow(player, "info", "Pro aufgesammelten Müll erhältst Du "..pricePerRubbish.." $.")
			end, 750, 1)
			
			
			for k, v in ipairs(Rubbish) do
				if (v.obj) then
					setElementVisibleTo(v.blip, player, true)
				end
			end
			
			state = true
			
		end
		
	elseif (level == 2) then
			
			if (#curBin < maxPlayersBin) then
			
			local pName = getPlayerName(player)
			
			curBin[pName] = {}
			
			local fx, fy, fz, frz = 2116.5, -2100.4, 14.1, 255
			
			curBin[pName].trashmaster = createVehicle(408, fx, fy, fz, 0, 0, frz)
			setElementData(curBin[pName].trashmaster, "jobOwner", pName)
			
			curBin[pName].col = createColSphere(fx, fy, fz, 2)
			setElementData(curBin[pName].col, "owner", pName)
			attachElements(curBin[pName].col, curBin[pName].trashmaster, 0, -4, -.6)
			
			addEventHandler("onColShapeHit", curBin[pName].col, onBinHit)
			
			fadeElementInterior(player, 0, fx, fy, fz, 0, 0, true)
			setTimer(function()
				warpPedIntoVehicle(player, curBin[pName].trashmaster)
				infoShow(player, "info", "Fahre rückwärts an die Mülltonnen, um Sie zu leeren. Die Mülltonnen sind auf der Karte markiert.")
				infoShow(player, "info", "Pro kleiner Mülltonne erhälst Du "..pricePerSmallBin.." $ und "..pricePerBigBin.." $ pro großer Mülltonne.")
			end, 750, 1)
			
			
			for k, v in ipairs(BigBins) do
				if (v.obj) then
					setElementVisibleTo(v.blip, player, true)
				end
			end
			for k, v in ipairs(SmallBins) do
				if (v.obj) then
					setElementVisibleTo(v.blip, player, true)
				end
			end
			
			state = true
			
		end
		
	end
	
	return state
end


_G["TrashEnd"] = function(player)
	local pName = getPlayerName(player)
	
	if (curRubbish[pName]) then
		removeEventHandler("onColShapeHit", curRubbish[pName].col, onRubbishHit)
		destroyElement(curRubbish[pName].col)
		destroyElement(curRubbish[pName].trashmaster)
		fadeElementInterior(player, 0, 2094.9, -2084.0, 13.6, 225, 0, true)
		curRubbish[pName] = nil
		
		for k, v in ipairs(Rubbish) do
			setElementVisibleTo(v.blip, player, false)
		end
	end
	
	if (curBin[pName]) then
		removeEventHandler("onColShapeHit", curBin[pName].col, onBinHit)
		destroyElement(curBin[pName].col)
		destroyElement(curBin[pName].trashmaster)
		fadeElementInterior(player, 0, 2094.9, -2084.0, 13.6, 225, 0, true)
		curBin[pName] = nil
		
		for k, v in ipairs(BigBins) do
			setElementVisibleTo(v.blip, player, false)
		end
		for k, v in ipairs(SmallBins) do
			setElementVisibleTo(v.blip, player, false)
		end
	end
end