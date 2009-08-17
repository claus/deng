package deng.util
{
	import flash.utils.ByteArray;
	
	public class XMLChar
	{
		/** Character flags. */
		private static var CHARS:ByteArray = new ByteArray();
		
		/** Valid character mask. */
		public static const MASK_VALID:uint = 0x01;
		
		/** Space character mask. */
		public static const MASK_SPACE:uint = 0x02;
		
		/** Name start character mask. */
		public static const MASK_NAME_START:uint = 0x04;
		
		/** Name character mask. */
		public static const MASK_NAME:uint = 0x08;
		
		/** Pubid character mask. */
		public static const MASK_PUBID:uint = 0x10;
		
		/** 
		 * Content character mask. Special characters are those that can
		 * be considered the start of markup, such as '&lt;' and '&amp;'. 
		 * The various newline characters are considered special as well.
		 * All other valid XML characters can be considered content.
		 * <p>This is an optimization for the inner loop of character scanning.</p>
		 */
		public static const MASK_CONTENT:uint = 0x20;
		
		/** NCName start character mask. */
		public static const MASK_NCNAME_START:uint = 0x40;
		
		/** NCName character mask. */
		public static const MASK_NCNAME:uint = 0x80;
		
		private static var initialized:Boolean = init();
		
		private static function fill(ba:ByteArray, indexFrom:uint, indexTo:uint, value:int):void {
			for(var i:uint = indexFrom; i < indexTo; i++) {
				ba[i] = value;
			}
		}
		
		private static function init():Boolean {
			CHARS.length = 0x10000;
			CHARS[9] = 0x23;
			CHARS[10] = 0x13;
			CHARS[13] = 0x13;
			CHARS[32] = 0x33;
			CHARS[33] = 0x31;
			CHARS[34] = 0x21;
			fill(CHARS, 35, 38, 0x31); // Fill 3 of value 49
			CHARS[38] = 0x01;
			fill(CHARS, 39, 45, 0x31); // Fill 6 of value 49
			fill(CHARS, 45, 47, 0xB9); // Fill 2 of value -71
			CHARS[47] = 0x31;
			fill(CHARS, 48, 58, 0xB9); // Fill 10 of value -71
			CHARS[58] = 0x3D;
			CHARS[59] = 0x31;
			CHARS[60] = 0x01;
			CHARS[61] = 0x31;
			CHARS[62] = 0x21;
			fill(CHARS, 63, 65, 0x31); // Fill 2 of value 49
			fill(CHARS, 65, 91, 0xFD); // Fill 26 of value -3
			fill(CHARS, 91, 93, 0x21); // Fill 2 of value 33
			CHARS[93] = 0x01;
			CHARS[94] = 0x21;
			CHARS[95] = 0xFD;
			CHARS[96] = 0x21;
			fill(CHARS, 97, 123, 0xFD); // Fill 26 of value -3
			fill(CHARS, 123, 183, 0x21); // Fill 60 of value 33
			CHARS[183] = 0xA9;
			fill(CHARS, 184, 192, 0x21); // Fill 8 of value 33
			fill(CHARS, 192, 215, 0xED); // Fill 23 of value -19
			CHARS[215] = 0x21;
			fill(CHARS, 216, 247, 0xED); // Fill 31 of value -19
			CHARS[247] = 0x21;
			fill(CHARS, 248, 306, 0xED); // Fill 58 of value -19
			fill(CHARS, 306, 308, 0x21); // Fill 2 of value 33
			fill(CHARS, 308, 319, 0xED); // Fill 11 of value -19
			fill(CHARS, 319, 321, 0x21); // Fill 2 of value 33
			fill(CHARS, 321, 329, 0xED); // Fill 8 of value -19
			CHARS[329] = 0x21;
			fill(CHARS, 330, 383, 0xED); // Fill 53 of value -19
			CHARS[383] = 0x21;
			fill(CHARS, 384, 452, 0xED); // Fill 68 of value -19
			fill(CHARS, 452, 461, 0x21); // Fill 9 of value 33
			fill(CHARS, 461, 497, 0xED); // Fill 36 of value -19
			fill(CHARS, 497, 500, 0x21); // Fill 3 of value 33
			fill(CHARS, 500, 502, 0xED); // Fill 2 of value -19
			fill(CHARS, 502, 506, 0x21); // Fill 4 of value 33
			fill(CHARS, 506, 536, 0xED); // Fill 30 of value -19
			fill(CHARS, 536, 592, 0x21); // Fill 56 of value 33
			fill(CHARS, 592, 681, 0xED); // Fill 89 of value -19
			fill(CHARS, 681, 699, 0x21); // Fill 18 of value 33
			fill(CHARS, 699, 706, 0xED); // Fill 7 of value -19
			fill(CHARS, 706, 720, 0x21); // Fill 14 of value 33
			fill(CHARS, 720, 722, 0xA9); // Fill 2 of value -87
			fill(CHARS, 722, 768, 0x21); // Fill 46 of value 33
			fill(CHARS, 768, 838, 0xA9); // Fill 70 of value -87
			fill(CHARS, 838, 864, 0x21); // Fill 26 of value 33
			fill(CHARS, 864, 866, 0xA9); // Fill 2 of value -87
			fill(CHARS, 866, 902, 0x21); // Fill 36 of value 33
			CHARS[902] = 0xED;
			CHARS[903] = 0xA9;
			fill(CHARS, 904, 907, 0xED); // Fill 3 of value -19
			CHARS[907] = 0x21;
			CHARS[908] = 0xED;
			CHARS[909] = 0x21;
			fill(CHARS, 910, 930, 0xED); // Fill 20 of value -19
			CHARS[930] = 0x21;
			fill(CHARS, 931, 975, 0xED); // Fill 44 of value -19
			CHARS[975] = 0x21;
			fill(CHARS, 976, 983, 0xED); // Fill 7 of value -19
			fill(CHARS, 983, 986, 0x21); // Fill 3 of value 33
			CHARS[986] = 0xED;
			CHARS[987] = 0x21;
			CHARS[988] = 0xED;
			CHARS[989] = 0x21;
			CHARS[990] = 0xED;
			CHARS[991] = 0x21;
			CHARS[992] = 0xED;
			CHARS[993] = 0x21;
			fill(CHARS, 994, 1012, 0xED); // Fill 18 of value -19
			fill(CHARS, 1012, 1025, 0x21); // Fill 13 of value 33
			fill(CHARS, 1025, 1037, 0xED); // Fill 12 of value -19
			CHARS[1037] = 0x21;
			fill(CHARS, 1038, 1104, 0xED); // Fill 66 of value -19
			CHARS[1104] = 0x21;
			fill(CHARS, 1105, 1117, 0xED); // Fill 12 of value -19
			CHARS[1117] = 0x21;
			fill(CHARS, 1118, 1154, 0xED); // Fill 36 of value -19
			CHARS[1154] = 0x21;
			fill(CHARS, 1155, 1159, 0xA9); // Fill 4 of value -87
			fill(CHARS, 1159, 1168, 0x21); // Fill 9 of value 33
			fill(CHARS, 1168, 1221, 0xED); // Fill 53 of value -19
			fill(CHARS, 1221, 1223, 0x21); // Fill 2 of value 33
			fill(CHARS, 1223, 1225, 0xED); // Fill 2 of value -19
			fill(CHARS, 1225, 1227, 0x21); // Fill 2 of value 33
			fill(CHARS, 1227, 1229, 0xED); // Fill 2 of value -19
			fill(CHARS, 1229, 1232, 0x21); // Fill 3 of value 33
			fill(CHARS, 1232, 1260, 0xED); // Fill 28 of value -19
			fill(CHARS, 1260, 1262, 0x21); // Fill 2 of value 33
			fill(CHARS, 1262, 1270, 0xED); // Fill 8 of value -19
			fill(CHARS, 1270, 1272, 0x21); // Fill 2 of value 33
			fill(CHARS, 1272, 1274, 0xED); // Fill 2 of value -19
			fill(CHARS, 1274, 1329, 0x21); // Fill 55 of value 33
			fill(CHARS, 1329, 1367, 0xED); // Fill 38 of value -19
			fill(CHARS, 1367, 1369, 0x21); // Fill 2 of value 33
			CHARS[1369] = 0xED;
			fill(CHARS, 1370, 1377, 0x21); // Fill 7 of value 33
			fill(CHARS, 1377, 1415, 0xED); // Fill 38 of value -19
			fill(CHARS, 1415, 1425, 0x21); // Fill 10 of value 33
			fill(CHARS, 1425, 1442, 0xA9); // Fill 17 of value -87
			CHARS[1442] = 0x21;
			fill(CHARS, 1443, 1466, 0xA9); // Fill 23 of value -87
			CHARS[1466] = 0x21;
			fill(CHARS, 1467, 1470, 0xA9); // Fill 3 of value -87
			CHARS[1470] = 0x21;
			CHARS[1471] = 0xA9;
			CHARS[1472] = 0x21;
			fill(CHARS, 1473, 1475, 0xA9); // Fill 2 of value -87
			CHARS[1475] = 0x21;
			CHARS[1476] = 0xA9;
			fill(CHARS, 1477, 1488, 0x21); // Fill 11 of value 33
			fill(CHARS, 1488, 1515, 0xED); // Fill 27 of value -19
			fill(CHARS, 1515, 1520, 0x21); // Fill 5 of value 33
			fill(CHARS, 1520, 1523, 0xED); // Fill 3 of value -19
			fill(CHARS, 1523, 1569, 0x21); // Fill 46 of value 33
			fill(CHARS, 1569, 1595, 0xED); // Fill 26 of value -19
			fill(CHARS, 1595, 1600, 0x21); // Fill 5 of value 33
			CHARS[1600] = 0xA9;
			fill(CHARS, 1601, 1611, 0xED); // Fill 10 of value -19
			fill(CHARS, 1611, 1619, 0xA9); // Fill 8 of value -87
			fill(CHARS, 1619, 1632, 0x21); // Fill 13 of value 33
			fill(CHARS, 1632, 1642, 0xA9); // Fill 10 of value -87
			fill(CHARS, 1642, 1648, 0x21); // Fill 6 of value 33
			CHARS[1648] = 0xA9;
			fill(CHARS, 1649, 1720, 0xED); // Fill 71 of value -19
			fill(CHARS, 1720, 1722, 0x21); // Fill 2 of value 33
			fill(CHARS, 1722, 1727, 0xED); // Fill 5 of value -19
			CHARS[1727] = 0x21;
			fill(CHARS, 1728, 1743, 0xED); // Fill 15 of value -19
			CHARS[1743] = 0x21;
			fill(CHARS, 1744, 1748, 0xED); // Fill 4 of value -19
			CHARS[1748] = 0x21;
			CHARS[1749] = 0xED;
			fill(CHARS, 1750, 1765, 0xA9); // Fill 15 of value -87
			fill(CHARS, 1765, 1767, 0xED); // Fill 2 of value -19
			fill(CHARS, 1767, 1769, 0xA9); // Fill 2 of value -87
			CHARS[1769] = 0x21;
			fill(CHARS, 1770, 1774, 0xA9); // Fill 4 of value -87
			fill(CHARS, 1774, 1776, 0x21); // Fill 2 of value 33
			fill(CHARS, 1776, 1786, 0xA9); // Fill 10 of value -87
			fill(CHARS, 1786, 2305, 0x21); // Fill 519 of value 33
			fill(CHARS, 2305, 2308, 0xA9); // Fill 3 of value -87
			CHARS[2308] = 0x21;
			fill(CHARS, 2309, 2362, 0xED); // Fill 53 of value -19
			fill(CHARS, 2362, 2364, 0x21); // Fill 2 of value 33
			CHARS[2364] = 0xA9;
			CHARS[2365] = 0xED;
			fill(CHARS, 2366, 2382, 0xA9); // Fill 16 of value -87
			fill(CHARS, 2382, 2385, 0x21); // Fill 3 of value 33
			fill(CHARS, 2385, 2389, 0xA9); // Fill 4 of value -87
			fill(CHARS, 2389, 2392, 0x21); // Fill 3 of value 33
			fill(CHARS, 2392, 2402, 0xED); // Fill 10 of value -19
			fill(CHARS, 2402, 2404, 0xA9); // Fill 2 of value -87
			fill(CHARS, 2404, 2406, 0x21); // Fill 2 of value 33
			fill(CHARS, 2406, 2416, 0xA9); // Fill 10 of value -87
			fill(CHARS, 2416, 2433, 0x21); // Fill 17 of value 33
			fill(CHARS, 2433, 2436, 0xA9); // Fill 3 of value -87
			CHARS[2436] = 0x21;
			fill(CHARS, 2437, 2445, 0xED); // Fill 8 of value -19
			fill(CHARS, 2445, 2447, 0x21); // Fill 2 of value 33
			fill(CHARS, 2447, 2449, 0xED); // Fill 2 of value -19
			fill(CHARS, 2449, 2451, 0x21); // Fill 2 of value 33
			fill(CHARS, 2451, 2473, 0xED); // Fill 22 of value -19
			CHARS[2473] = 0x21;
			fill(CHARS, 2474, 2481, 0xED); // Fill 7 of value -19
			CHARS[2481] = 0x21;
			CHARS[2482] = 0xED;
			fill(CHARS, 2483, 2486, 0x21); // Fill 3 of value 33
			fill(CHARS, 2486, 2490, 0xED); // Fill 4 of value -19
			fill(CHARS, 2490, 2492, 0x21); // Fill 2 of value 33
			CHARS[2492] = 0xA9;
			CHARS[2493] = 0x21;
			fill(CHARS, 2494, 2501, 0xA9); // Fill 7 of value -87
			fill(CHARS, 2501, 2503, 0x21); // Fill 2 of value 33
			fill(CHARS, 2503, 2505, 0xA9); // Fill 2 of value -87
			fill(CHARS, 2505, 2507, 0x21); // Fill 2 of value 33
			fill(CHARS, 2507, 2510, 0xA9); // Fill 3 of value -87
			fill(CHARS, 2510, 2519, 0x21); // Fill 9 of value 33
			CHARS[2519] = 0xA9;
			fill(CHARS, 2520, 2524, 0x21); // Fill 4 of value 33
			fill(CHARS, 2524, 2526, 0xED); // Fill 2 of value -19
			CHARS[2526] = 0x21;
			fill(CHARS, 2527, 2530, 0xED); // Fill 3 of value -19
			fill(CHARS, 2530, 2532, 0xA9); // Fill 2 of value -87
			fill(CHARS, 2532, 2534, 0x21); // Fill 2 of value 33
			fill(CHARS, 2534, 2544, 0xA9); // Fill 10 of value -87
			fill(CHARS, 2544, 2546, 0xED); // Fill 2 of value -19
			fill(CHARS, 2546, 2562, 0x21); // Fill 16 of value 33
			CHARS[2562] = 0xA9;
			fill(CHARS, 2563, 2565, 0x21); // Fill 2 of value 33
			fill(CHARS, 2565, 2571, 0xED); // Fill 6 of value -19
			fill(CHARS, 2571, 2575, 0x21); // Fill 4 of value 33
			fill(CHARS, 2575, 2577, 0xED); // Fill 2 of value -19
			fill(CHARS, 2577, 2579, 0x21); // Fill 2 of value 33
			fill(CHARS, 2579, 2601, 0xED); // Fill 22 of value -19
			CHARS[2601] = 0x21;
			fill(CHARS, 2602, 2609, 0xED); // Fill 7 of value -19
			CHARS[2609] = 0x21;
			fill(CHARS, 2610, 2612, 0xED); // Fill 2 of value -19
			CHARS[2612] = 0x21;
			fill(CHARS, 2613, 2615, 0xED); // Fill 2 of value -19
			CHARS[2615] = 0x21;
			fill(CHARS, 2616, 2618, 0xED); // Fill 2 of value -19
			fill(CHARS, 2618, 2620, 0x21); // Fill 2 of value 33
			CHARS[2620] = 0xA9;
			CHARS[2621] = 0x21;
			fill(CHARS, 2622, 2627, 0xA9); // Fill 5 of value -87
			fill(CHARS, 2627, 2631, 0x21); // Fill 4 of value 33
			fill(CHARS, 2631, 2633, 0xA9); // Fill 2 of value -87
			fill(CHARS, 2633, 2635, 0x21); // Fill 2 of value 33
			fill(CHARS, 2635, 2638, 0xA9); // Fill 3 of value -87
			fill(CHARS, 2638, 2649, 0x21); // Fill 11 of value 33
			fill(CHARS, 2649, 2653, 0xED); // Fill 4 of value -19
			CHARS[2653] = 0x21;
			CHARS[2654] = 0xED;
			fill(CHARS, 2655, 2662, 0x21); // Fill 7 of value 33
			fill(CHARS, 2662, 2674, 0xA9); // Fill 12 of value -87
			fill(CHARS, 2674, 2677, 0xED); // Fill 3 of value -19
			fill(CHARS, 2677, 2689, 0x21); // Fill 12 of value 33
			fill(CHARS, 2689, 2692, 0xA9); // Fill 3 of value -87
			CHARS[2692] = 0x21;
			fill(CHARS, 2693, 2700, 0xED); // Fill 7 of value -19
			CHARS[2700] = 0x21;
			CHARS[2701] = 0xED;
			CHARS[2702] = 0x21;
			fill(CHARS, 2703, 2706, 0xED); // Fill 3 of value -19
			CHARS[2706] = 0x21;
			fill(CHARS, 2707, 2729, 0xED); // Fill 22 of value -19
			CHARS[2729] = 0x21;
			fill(CHARS, 2730, 2737, 0xED); // Fill 7 of value -19
			CHARS[2737] = 0x21;
			fill(CHARS, 2738, 2740, 0xED); // Fill 2 of value -19
			CHARS[2740] = 0x21;
			fill(CHARS, 2741, 2746, 0xED); // Fill 5 of value -19
			fill(CHARS, 2746, 2748, 0x21); // Fill 2 of value 33
			CHARS[2748] = 0xA9;
			CHARS[2749] = 0xED;
			fill(CHARS, 2750, 2758, 0xA9); // Fill 8 of value -87
			CHARS[2758] = 0x21;
			fill(CHARS, 2759, 2762, 0xA9); // Fill 3 of value -87
			CHARS[2762] = 0x21;
			fill(CHARS, 2763, 2766, 0xA9); // Fill 3 of value -87
			fill(CHARS, 2766, 2784, 0x21); // Fill 18 of value 33
			CHARS[2784] = 0xED;
			fill(CHARS, 2785, 2790, 0x21); // Fill 5 of value 33
			fill(CHARS, 2790, 2800, 0xA9); // Fill 10 of value -87
			fill(CHARS, 2800, 2817, 0x21); // Fill 17 of value 33
			fill(CHARS, 2817, 2820, 0xA9); // Fill 3 of value -87
			CHARS[2820] = 0x21;
			fill(CHARS, 2821, 2829, 0xED); // Fill 8 of value -19
			fill(CHARS, 2829, 2831, 0x21); // Fill 2 of value 33
			fill(CHARS, 2831, 2833, 0xED); // Fill 2 of value -19
			fill(CHARS, 2833, 2835, 0x21); // Fill 2 of value 33
			fill(CHARS, 2835, 2857, 0xED); // Fill 22 of value -19
			CHARS[2857] = 0x21;
			fill(CHARS, 2858, 2865, 0xED); // Fill 7 of value -19
			CHARS[2865] = 0x21;
			fill(CHARS, 2866, 2868, 0xED); // Fill 2 of value -19
			fill(CHARS, 2868, 2870, 0x21); // Fill 2 of value 33
			fill(CHARS, 2870, 2874, 0xED); // Fill 4 of value -19
			fill(CHARS, 2874, 2876, 0x21); // Fill 2 of value 33
			CHARS[2876] = 0xA9;
			CHARS[2877] = 0xED;
			fill(CHARS, 2878, 2884, 0xA9); // Fill 6 of value -87
			fill(CHARS, 2884, 2887, 0x21); // Fill 3 of value 33
			fill(CHARS, 2887, 2889, 0xA9); // Fill 2 of value -87
			fill(CHARS, 2889, 2891, 0x21); // Fill 2 of value 33
			fill(CHARS, 2891, 2894, 0xA9); // Fill 3 of value -87
			fill(CHARS, 2894, 2902, 0x21); // Fill 8 of value 33
			fill(CHARS, 2902, 2904, 0xA9); // Fill 2 of value -87
			fill(CHARS, 2904, 2908, 0x21); // Fill 4 of value 33
			fill(CHARS, 2908, 2910, 0xED); // Fill 2 of value -19
			CHARS[2910] = 0x21;
			fill(CHARS, 2911, 2914, 0xED); // Fill 3 of value -19
			fill(CHARS, 2914, 2918, 0x21); // Fill 4 of value 33
			fill(CHARS, 2918, 2928, 0xA9); // Fill 10 of value -87
			fill(CHARS, 2928, 2946, 0x21); // Fill 18 of value 33
			fill(CHARS, 2946, 2948, 0xA9); // Fill 2 of value -87
			CHARS[2948] = 0x21;
			fill(CHARS, 2949, 2955, 0xED); // Fill 6 of value -19
			fill(CHARS, 2955, 2958, 0x21); // Fill 3 of value 33
			fill(CHARS, 2958, 2961, 0xED); // Fill 3 of value -19
			CHARS[2961] = 0x21;
			fill(CHARS, 2962, 2966, 0xED); // Fill 4 of value -19
			fill(CHARS, 2966, 2969, 0x21); // Fill 3 of value 33
			fill(CHARS, 2969, 2971, 0xED); // Fill 2 of value -19
			CHARS[2971] = 0x21;
			CHARS[2972] = 0xED;
			CHARS[2973] = 0x21;
			fill(CHARS, 2974, 2976, 0xED); // Fill 2 of value -19
			fill(CHARS, 2976, 2979, 0x21); // Fill 3 of value 33
			fill(CHARS, 2979, 2981, 0xED); // Fill 2 of value -19
			fill(CHARS, 2981, 2984, 0x21); // Fill 3 of value 33
			fill(CHARS, 2984, 2987, 0xED); // Fill 3 of value -19
			fill(CHARS, 2987, 2990, 0x21); // Fill 3 of value 33
			fill(CHARS, 2990, 2998, 0xED); // Fill 8 of value -19
			CHARS[2998] = 0x21;
			fill(CHARS, 2999, 3002, 0xED); // Fill 3 of value -19
			fill(CHARS, 3002, 3006, 0x21); // Fill 4 of value 33
			fill(CHARS, 3006, 3011, 0xA9); // Fill 5 of value -87
			fill(CHARS, 3011, 3014, 0x21); // Fill 3 of value 33
			fill(CHARS, 3014, 3017, 0xA9); // Fill 3 of value -87
			CHARS[3017] = 0x21;
			fill(CHARS, 3018, 3022, 0xA9); // Fill 4 of value -87
			fill(CHARS, 3022, 3031, 0x21); // Fill 9 of value 33
			CHARS[3031] = 0xA9;
			fill(CHARS, 3032, 3047, 0x21); // Fill 15 of value 33
			fill(CHARS, 3047, 3056, 0xA9); // Fill 9 of value -87
			fill(CHARS, 3056, 3073, 0x21); // Fill 17 of value 33
			fill(CHARS, 3073, 3076, 0xA9); // Fill 3 of value -87
			CHARS[3076] = 0x21;
			fill(CHARS, 3077, 3085, 0xED); // Fill 8 of value -19
			CHARS[3085] = 0x21;
			fill(CHARS, 3086, 3089, 0xED); // Fill 3 of value -19
			CHARS[3089] = 0x21;
			fill(CHARS, 3090, 3113, 0xED); // Fill 23 of value -19
			CHARS[3113] = 0x21;
			fill(CHARS, 3114, 3124, 0xED); // Fill 10 of value -19
			CHARS[3124] = 0x21;
			fill(CHARS, 3125, 3130, 0xED); // Fill 5 of value -19
			fill(CHARS, 3130, 3134, 0x21); // Fill 4 of value 33
			fill(CHARS, 3134, 3141, 0xA9); // Fill 7 of value -87
			CHARS[3141] = 0x21;
			fill(CHARS, 3142, 3145, 0xA9); // Fill 3 of value -87
			CHARS[3145] = 0x21;
			fill(CHARS, 3146, 3150, 0xA9); // Fill 4 of value -87
			fill(CHARS, 3150, 3157, 0x21); // Fill 7 of value 33
			fill(CHARS, 3157, 3159, 0xA9); // Fill 2 of value -87
			fill(CHARS, 3159, 3168, 0x21); // Fill 9 of value 33
			fill(CHARS, 3168, 3170, 0xED); // Fill 2 of value -19
			fill(CHARS, 3170, 3174, 0x21); // Fill 4 of value 33
			fill(CHARS, 3174, 3184, 0xA9); // Fill 10 of value -87
			fill(CHARS, 3184, 3202, 0x21); // Fill 18 of value 33
			fill(CHARS, 3202, 3204, 0xA9); // Fill 2 of value -87
			CHARS[3204] = 0x21;
			fill(CHARS, 3205, 3213, 0xED); // Fill 8 of value -19
			CHARS[3213] = 0x21;
			fill(CHARS, 3214, 3217, 0xED); // Fill 3 of value -19
			CHARS[3217] = 0x21;
			fill(CHARS, 3218, 3241, 0xED); // Fill 23 of value -19
			CHARS[3241] = 0x21;
			fill(CHARS, 3242, 3252, 0xED); // Fill 10 of value -19
			CHARS[3252] = 0x21;
			fill(CHARS, 3253, 3258, 0xED); // Fill 5 of value -19
			fill(CHARS, 3258, 3262, 0x21); // Fill 4 of value 33
			fill(CHARS, 3262, 3269, 0xA9); // Fill 7 of value -87
			CHARS[3269] = 0x21;
			fill(CHARS, 3270, 3273, 0xA9); // Fill 3 of value -87
			CHARS[3273] = 0x21;
			fill(CHARS, 3274, 3278, 0xA9); // Fill 4 of value -87
			fill(CHARS, 3278, 3285, 0x21); // Fill 7 of value 33
			fill(CHARS, 3285, 3287, 0xA9); // Fill 2 of value -87
			fill(CHARS, 3287, 3294, 0x21); // Fill 7 of value 33
			CHARS[3294] = 0xED;
			CHARS[3295] = 0x21;
			fill(CHARS, 3296, 3298, 0xED); // Fill 2 of value -19
			fill(CHARS, 3298, 3302, 0x21); // Fill 4 of value 33
			fill(CHARS, 3302, 3312, 0xA9); // Fill 10 of value -87
			fill(CHARS, 3312, 3330, 0x21); // Fill 18 of value 33
			fill(CHARS, 3330, 3332, 0xA9); // Fill 2 of value -87
			CHARS[3332] = 0x21;
			fill(CHARS, 3333, 3341, 0xED); // Fill 8 of value -19
			CHARS[3341] = 0x21;
			fill(CHARS, 3342, 3345, 0xED); // Fill 3 of value -19
			CHARS[3345] = 0x21;
			fill(CHARS, 3346, 3369, 0xED); // Fill 23 of value -19
			CHARS[3369] = 0x21;
			fill(CHARS, 3370, 3386, 0xED); // Fill 16 of value -19
			fill(CHARS, 3386, 3390, 0x21); // Fill 4 of value 33
			fill(CHARS, 3390, 3396, 0xA9); // Fill 6 of value -87
			fill(CHARS, 3396, 3398, 0x21); // Fill 2 of value 33
			fill(CHARS, 3398, 3401, 0xA9); // Fill 3 of value -87
			CHARS[3401] = 0x21;
			fill(CHARS, 3402, 3406, 0xA9); // Fill 4 of value -87
			fill(CHARS, 3406, 3415, 0x21); // Fill 9 of value 33
			CHARS[3415] = 0xA9;
			fill(CHARS, 3416, 3424, 0x21); // Fill 8 of value 33
			fill(CHARS, 3424, 3426, 0xED); // Fill 2 of value -19
			fill(CHARS, 3426, 3430, 0x21); // Fill 4 of value 33
			fill(CHARS, 3430, 3440, 0xA9); // Fill 10 of value -87
			fill(CHARS, 3440, 3585, 0x21); // Fill 145 of value 33
			fill(CHARS, 3585, 3631, 0xED); // Fill 46 of value -19
			CHARS[3631] = 0x21;
			CHARS[3632] = 0xED;
			CHARS[3633] = 0xA9;
			fill(CHARS, 3634, 3636, 0xED); // Fill 2 of value -19
			fill(CHARS, 3636, 3643, 0xA9); // Fill 7 of value -87
			fill(CHARS, 3643, 3648, 0x21); // Fill 5 of value 33
			fill(CHARS, 3648, 3654, 0xED); // Fill 6 of value -19
			fill(CHARS, 3654, 3663, 0xA9); // Fill 9 of value -87
			CHARS[3663] = 0x21;
			fill(CHARS, 3664, 3674, 0xA9); // Fill 10 of value -87
			fill(CHARS, 3674, 3713, 0x21); // Fill 39 of value 33
			fill(CHARS, 3713, 3715, 0xED); // Fill 2 of value -19
			CHARS[3715] = 0x21;
			CHARS[3716] = 0xED;
			fill(CHARS, 3717, 3719, 0x21); // Fill 2 of value 33
			fill(CHARS, 3719, 3721, 0xED); // Fill 2 of value -19
			CHARS[3721] = 0x21;
			CHARS[3722] = 0xED;
			fill(CHARS, 3723, 3725, 0x21); // Fill 2 of value 33
			CHARS[3725] = 0xED;
			fill(CHARS, 3726, 3732, 0x21); // Fill 6 of value 33
			fill(CHARS, 3732, 3736, 0xED); // Fill 4 of value -19
			CHARS[3736] = 0x21;
			fill(CHARS, 3737, 3744, 0xED); // Fill 7 of value -19
			CHARS[3744] = 0x21;
			fill(CHARS, 3745, 3748, 0xED); // Fill 3 of value -19
			CHARS[3748] = 0x21;
			CHARS[3749] = 0xED;
			CHARS[3750] = 0x21;
			CHARS[3751] = 0xED;
			fill(CHARS, 3752, 3754, 0x21); // Fill 2 of value 33
			fill(CHARS, 3754, 3756, 0xED); // Fill 2 of value -19
			CHARS[3756] = 0x21;
			fill(CHARS, 3757, 3759, 0xED); // Fill 2 of value -19
			CHARS[3759] = 0x21;
			CHARS[3760] = 0xED;
			CHARS[3761] = 0xA9;
			fill(CHARS, 3762, 3764, 0xED); // Fill 2 of value -19
			fill(CHARS, 3764, 3770, 0xA9); // Fill 6 of value -87
			CHARS[3770] = 0x21;
			fill(CHARS, 3771, 3773, 0xA9); // Fill 2 of value -87
			CHARS[3773] = 0xED;
			fill(CHARS, 3774, 3776, 0x21); // Fill 2 of value 33
			fill(CHARS, 3776, 3781, 0xED); // Fill 5 of value -19
			CHARS[3781] = 0x21;
			CHARS[3782] = 0xA9;
			CHARS[3783] = 0x21;
			fill(CHARS, 3784, 3790, 0xA9); // Fill 6 of value -87
			fill(CHARS, 3790, 3792, 0x21); // Fill 2 of value 33
			fill(CHARS, 3792, 3802, 0xA9); // Fill 10 of value -87
			fill(CHARS, 3802, 3864, 0x21); // Fill 62 of value 33
			fill(CHARS, 3864, 3866, 0xA9); // Fill 2 of value -87
			fill(CHARS, 3866, 3872, 0x21); // Fill 6 of value 33
			fill(CHARS, 3872, 3882, 0xA9); // Fill 10 of value -87
			fill(CHARS, 3882, 3893, 0x21); // Fill 11 of value 33
			CHARS[3893] = 0xA9;
			CHARS[3894] = 0x21;
			CHARS[3895] = 0xA9;
			CHARS[3896] = 0x21;
			CHARS[3897] = 0xA9;
			fill(CHARS, 3898, 3902, 0x21); // Fill 4 of value 33
			fill(CHARS, 3902, 3904, 0xA9); // Fill 2 of value -87
			fill(CHARS, 3904, 3912, 0xED); // Fill 8 of value -19
			CHARS[3912] = 0x21;
			fill(CHARS, 3913, 3946, 0xED); // Fill 33 of value -19
			fill(CHARS, 3946, 3953, 0x21); // Fill 7 of value 33
			fill(CHARS, 3953, 3973, 0xA9); // Fill 20 of value -87
			CHARS[3973] = 0x21;
			fill(CHARS, 3974, 3980, 0xA9); // Fill 6 of value -87
			fill(CHARS, 3980, 3984, 0x21); // Fill 4 of value 33
			fill(CHARS, 3984, 3990, 0xA9); // Fill 6 of value -87
			CHARS[3990] = 0x21;
			CHARS[3991] = 0xA9;
			CHARS[3992] = 0x21;
			fill(CHARS, 3993, 4014, 0xA9); // Fill 21 of value -87
			fill(CHARS, 4014, 4017, 0x21); // Fill 3 of value 33
			fill(CHARS, 4017, 4024, 0xA9); // Fill 7 of value -87
			CHARS[4024] = 0x21;
			CHARS[4025] = 0xA9;
			fill(CHARS, 4026, 4256, 0x21); // Fill 230 of value 33
			fill(CHARS, 4256, 4294, 0xED); // Fill 38 of value -19
			fill(CHARS, 4294, 4304, 0x21); // Fill 10 of value 33
			fill(CHARS, 4304, 4343, 0xED); // Fill 39 of value -19
			fill(CHARS, 4343, 4352, 0x21); // Fill 9 of value 33
			CHARS[4352] = 0xED;
			CHARS[4353] = 0x21;
			fill(CHARS, 4354, 4356, 0xED); // Fill 2 of value -19
			CHARS[4356] = 0x21;
			fill(CHARS, 4357, 4360, 0xED); // Fill 3 of value -19
			CHARS[4360] = 0x21;
			CHARS[4361] = 0xED;
			CHARS[4362] = 0x21;
			fill(CHARS, 4363, 4365, 0xED); // Fill 2 of value -19
			CHARS[4365] = 0x21;
			fill(CHARS, 4366, 4371, 0xED); // Fill 5 of value -19
			fill(CHARS, 4371, 4412, 0x21); // Fill 41 of value 33
			CHARS[4412] = 0xED;
			CHARS[4413] = 0x21;
			CHARS[4414] = 0xED;
			CHARS[4415] = 0x21;
			CHARS[4416] = 0xED;
			fill(CHARS, 4417, 4428, 0x21); // Fill 11 of value 33
			CHARS[4428] = 0xED;
			CHARS[4429] = 0x21;
			CHARS[4430] = 0xED;
			CHARS[4431] = 0x21;
			CHARS[4432] = 0xED;
			fill(CHARS, 4433, 4436, 0x21); // Fill 3 of value 33
			fill(CHARS, 4436, 4438, 0xED); // Fill 2 of value -19
			fill(CHARS, 4438, 4441, 0x21); // Fill 3 of value 33
			CHARS[4441] = 0xED;
			fill(CHARS, 4442, 4447, 0x21); // Fill 5 of value 33
			fill(CHARS, 4447, 4450, 0xED); // Fill 3 of value -19
			CHARS[4450] = 0x21;
			CHARS[4451] = 0xED;
			CHARS[4452] = 0x21;
			CHARS[4453] = 0xED;
			CHARS[4454] = 0x21;
			CHARS[4455] = 0xED;
			CHARS[4456] = 0x21;
			CHARS[4457] = 0xED;
			fill(CHARS, 4458, 4461, 0x21); // Fill 3 of value 33
			fill(CHARS, 4461, 4463, 0xED); // Fill 2 of value -19
			fill(CHARS, 4463, 4466, 0x21); // Fill 3 of value 33
			fill(CHARS, 4466, 4468, 0xED); // Fill 2 of value -19
			CHARS[4468] = 0x21;
			CHARS[4469] = 0xED;
			fill(CHARS, 4470, 4510, 0x21); // Fill 40 of value 33
			CHARS[4510] = 0xED;
			fill(CHARS, 4511, 4520, 0x21); // Fill 9 of value 33
			CHARS[4520] = 0xED;
			fill(CHARS, 4521, 4523, 0x21); // Fill 2 of value 33
			CHARS[4523] = 0xED;
			fill(CHARS, 4524, 4526, 0x21); // Fill 2 of value 33
			fill(CHARS, 4526, 4528, 0xED); // Fill 2 of value -19
			fill(CHARS, 4528, 4535, 0x21); // Fill 7 of value 33
			fill(CHARS, 4535, 4537, 0xED); // Fill 2 of value -19
			CHARS[4537] = 0x21;
			CHARS[4538] = 0xED;
			CHARS[4539] = 0x21;
			fill(CHARS, 4540, 4547, 0xED); // Fill 7 of value -19
			fill(CHARS, 4547, 4587, 0x21); // Fill 40 of value 33
			CHARS[4587] = 0xED;
			fill(CHARS, 4588, 4592, 0x21); // Fill 4 of value 33
			CHARS[4592] = 0xED;
			fill(CHARS, 4593, 4601, 0x21); // Fill 8 of value 33
			CHARS[4601] = 0xED;
			fill(CHARS, 4602, 7680, 0x21); // Fill 3078 of value 33
			fill(CHARS, 7680, 7836, 0xED); // Fill 156 of value -19
			fill(CHARS, 7836, 7840, 0x21); // Fill 4 of value 33
			fill(CHARS, 7840, 7930, 0xED); // Fill 90 of value -19
			fill(CHARS, 7930, 7936, 0x21); // Fill 6 of value 33
			fill(CHARS, 7936, 7958, 0xED); // Fill 22 of value -19
			fill(CHARS, 7958, 7960, 0x21); // Fill 2 of value 33
			fill(CHARS, 7960, 7966, 0xED); // Fill 6 of value -19
			fill(CHARS, 7966, 7968, 0x21); // Fill 2 of value 33
			fill(CHARS, 7968, 8006, 0xED); // Fill 38 of value -19
			fill(CHARS, 8006, 8008, 0x21); // Fill 2 of value 33
			fill(CHARS, 8008, 8014, 0xED); // Fill 6 of value -19
			fill(CHARS, 8014, 8016, 0x21); // Fill 2 of value 33
			fill(CHARS, 8016, 8024, 0xED); // Fill 8 of value -19
			CHARS[8024] = 0x21;
			CHARS[8025] = 0xED;
			CHARS[8026] = 0x21;
			CHARS[8027] = 0xED;
			CHARS[8028] = 0x21;
			CHARS[8029] = 0xED;
			CHARS[8030] = 0x21;
			fill(CHARS, 8031, 8062, 0xED); // Fill 31 of value -19
			fill(CHARS, 8062, 8064, 0x21); // Fill 2 of value 33
			fill(CHARS, 8064, 8117, 0xED); // Fill 53 of value -19
			CHARS[8117] = 0x21;
			fill(CHARS, 8118, 8125, 0xED); // Fill 7 of value -19
			CHARS[8125] = 0x21;
			CHARS[8126] = 0xED;
			fill(CHARS, 8127, 8130, 0x21); // Fill 3 of value 33
			fill(CHARS, 8130, 8133, 0xED); // Fill 3 of value -19
			CHARS[8133] = 0x21;
			fill(CHARS, 8134, 8141, 0xED); // Fill 7 of value -19
			fill(CHARS, 8141, 8144, 0x21); // Fill 3 of value 33
			fill(CHARS, 8144, 8148, 0xED); // Fill 4 of value -19
			fill(CHARS, 8148, 8150, 0x21); // Fill 2 of value 33
			fill(CHARS, 8150, 8156, 0xED); // Fill 6 of value -19
			fill(CHARS, 8156, 8160, 0x21); // Fill 4 of value 33
			fill(CHARS, 8160, 8173, 0xED); // Fill 13 of value -19
			fill(CHARS, 8173, 8178, 0x21); // Fill 5 of value 33
			fill(CHARS, 8178, 8181, 0xED); // Fill 3 of value -19
			CHARS[8181] = 0x21;
			fill(CHARS, 8182, 8189, 0xED); // Fill 7 of value -19
			fill(CHARS, 8189, 8400, 0x21); // Fill 211 of value 33
			fill(CHARS, 8400, 8413, 0xA9); // Fill 13 of value -87
			fill(CHARS, 8413, 8417, 0x21); // Fill 4 of value 33
			CHARS[8417] = 0xA9;
			fill(CHARS, 8418, 8486, 0x21); // Fill 68 of value 33
			CHARS[8486] = 0xED;
			fill(CHARS, 8487, 8490, 0x21); // Fill 3 of value 33
			fill(CHARS, 8490, 8492, 0xED); // Fill 2 of value -19
			fill(CHARS, 8492, 8494, 0x21); // Fill 2 of value 33
			CHARS[8494] = 0xED;
			fill(CHARS, 8495, 8576, 0x21); // Fill 81 of value 33
			fill(CHARS, 8576, 8579, 0xED); // Fill 3 of value -19
			fill(CHARS, 8579, 12293, 0x21); // Fill 3714 of value 33
			CHARS[12293] = 0xA9;
			CHARS[12294] = 0x21;
			CHARS[12295] = 0xED;
			fill(CHARS, 12296, 12321, 0x21); // Fill 25 of value 33
			fill(CHARS, 12321, 12330, 0xED); // Fill 9 of value -19
			fill(CHARS, 12330, 12336, 0xA9); // Fill 6 of value -87
			CHARS[12336] = 0x21;
			fill(CHARS, 12337, 12342, 0xA9); // Fill 5 of value -87
			fill(CHARS, 12342, 12353, 0x21); // Fill 11 of value 33
			fill(CHARS, 12353, 12437, 0xED); // Fill 84 of value -19
			fill(CHARS, 12437, 12441, 0x21); // Fill 4 of value 33
			fill(CHARS, 12441, 12443, 0xA9); // Fill 2 of value -87
			fill(CHARS, 12443, 12445, 0x21); // Fill 2 of value 33
			fill(CHARS, 12445, 12447, 0xA9); // Fill 2 of value -87
			fill(CHARS, 12447, 12449, 0x21); // Fill 2 of value 33
			fill(CHARS, 12449, 12539, 0xED); // Fill 90 of value -19
			CHARS[12539] = 0x21;
			fill(CHARS, 12540, 12543, 0xA9); // Fill 3 of value -87
			fill(CHARS, 12543, 12549, 0x21); // Fill 6 of value 33
			fill(CHARS, 12549, 12589, 0xED); // Fill 40 of value -19
			fill(CHARS, 12589, 19968, 0x21); // Fill 7379 of value 33
			fill(CHARS, 19968, 40870, 0xED); // Fill 20902 of value -19
			fill(CHARS, 40870, 44032, 0x21); // Fill 3162 of value 33
			fill(CHARS, 44032, 55204, 0xED); // Fill 11172 of value -19
			fill(CHARS, 55204, 55296, 0x21); // Fill 92 of value 33
			fill(CHARS, 57344, 65534, 0x21); // Fill 8190 of value 33
			return true;
		}

		public static function isSupplemental(c:int):Boolean {
			return (c >= 0x10000 && c <= 0x10FFFF);
		}
		
		public static function supplemental(high:int, low:int):int {
			return (high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000;
		}
		
		public static function highSurrogate(c:int):int {
			return (((c - 0x00010000) >> 10) + 0xD800);
		}
		
		public static function lowSurrogate(c:int):int {
			return (((c - 0x00010000) & 0x3FF) + 0xDC00);
		}
		
		public static function isHighSurrogate(c:int):Boolean {
			return (0xD800 <= c && c <= 0xDBFF);
		}
		
		public static function isLowSurrogate(c:int):Boolean {
			return (0xDC00 <= c && c <= 0xDFFF);
		}
		
		public static function isValid(c:int):Boolean {
			return (c < 0x10000 && (CHARS[c] & MASK_VALID) != 0) || (0x10000 <= c && c <= 0x10FFFF);
		}
		
		public static function isInvalid(c:int):Boolean {
			return !isValid(c);
		}
		
		public static function isContent(c:int):Boolean {
			return (c < 0x10000 && (CHARS[c] & MASK_CONTENT) != 0) || (0x10000 <= c && c <= 0x10FFFF);
		}
		
		public static function isMarkup(c:int):Boolean {
			return c == 0x3C || c == 0x26 || c == 0x25;
		}
		
		public static function isSpace(c:int):Boolean {
			return c <= 0x20 && (CHARS[c] & MASK_SPACE) != 0;
		}
		
		public static function isNameStart(c:int):Boolean {
			return c < 0x10000 && (CHARS[c] & MASK_NAME_START) != 0;
		}
		
		public static function isName(c:int):Boolean {
			return c < 0x10000 && (CHARS[c] & MASK_NAME) != 0;
		}
		
		public static function isNCNameStart(c:int):Boolean {
			return c < 0x10000 && (CHARS[c] & MASK_NCNAME_START) != 0;
		}
		
		public static function isNCName(c:int):Boolean {
			return c < 0x10000 && (CHARS[c] & MASK_NCNAME) != 0;
		}

		public static function isPubid(c:int):Boolean {
			return c < 0x10000 && (CHARS[c] & MASK_PUBID) != 0;
		}
		
		/**
		* Check to see if a string is a valid Name according to [5]
		* in the XML 1.0 Recommendation:
		* 
		* [5] Name ::= (Letter | '_' | ':') (NameChar)*
		*
		* @param name string to check
		* @return true if name is a valid Name
		*/
		public static function isValidName(name:String):Boolean {
			if(name.length == 0) {
				return false;
			}
			var ch:int = name.charCodeAt(0);
			if(!isNameStart(ch)) {
				return false;
			}
			var nameLen:uint = name.length;
			for(var i:uint = 1; i < nameLen; i++) {
				ch = name.charCodeAt(i);
				if(!isName(ch)) {
					return false;
				}
			}
			return true;
		}
		
		/**
		* Check to see if a string is a valid NCName according to [4]
		* from the XML Namespaces 1.0 Recommendation
		*
		* [4] NCName ::= (Letter | '_') (NCNameChar)*
		* 
		* @param ncName string to check
		* @return true if name is a valid NCName
		*/
		public static function isValidNCName(ncName:String):Boolean {
			if(ncName.length == 0) {
				return false;
			}
			var ch:int = ncName.charCodeAt(0);
			if(!isNCNameStart(ch)) {
				return false;
			}
			var ncNameLen:uint = ncName.length;
			for(var i:uint = 1; i < ncNameLen; i++) {
				ch = ncName.charCodeAt(i);
				if(!isNCName(ch)) {
					return false;
				}
			}
			return true;
		}
		
		/**
		* Check to see if a string is a valid Nmtoken according to [7]
		* in the XML 1.0 Recommendation
		*
		* [7] Nmtoken ::= (NameChar)+
		* 
		* @param nmtoken string to check
		* @return true if nmtoken is a valid Nmtoken 
		*/
		public static function isValidNmtoken(nmtoken:String):Boolean {
			var nmtokenLen:uint = nmtoken.length;
			if(nmtokenLen == 0) {
				return false;
			}
			for(var i:uint = 0; i < nmtokenLen; i++) {
				if(!isName(nmtoken.charCodeAt(i))) {
					return false;
				}
			}
			return true;
		}
		
		/**
		* Returns true if the encoding name is a valid IANA encoding.
		* This method does not verify that there is a decoder available
		* for this encoding, only that the characters are valid for an
		* IANA encoding name.
		*
		* @param ianaEncoding The IANA encoding name.
		*/
		public static function isValidIANAEncoding(ianaEncoding:String):Boolean {
			if(ianaEncoding != null) {
				var length:uint = ianaEncoding.length;
				if(length > 0) {
					var c:int = ianaEncoding.charCodeAt(0);
					if((c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A)) {
						for(var i:uint = 1; i < length; i++) {
							c = ianaEncoding.charCodeAt(i);
							if((c < 0x41 || c > 0x5A) && (c < 0x61 && c > 0x7A) && (c < 0x30 || c > 0x39) && c != 0x2E && c != 0x5F && c != 0x2D) {
								return false;
							}
						}
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		* Returns true if the encoding name is a valid Java encoding.
		* This method does not verify that there is a decoder available
		* for this encoding, only that the characters are valid for an
		* Java encoding name.
		*
		* @param javaEncoding The Java encoding name.
		*/
		public static function isValidJavaEncoding(javaEncoding:String):Boolean {
			if(javaEncoding != null) {
				var length:uint = javaEncoding.length;
				if(length > 0) {
					for(var i:uint = 1; i < length; i++) {
						var c:int = javaEncoding.charCodeAt(i);
						if((c < 0x41 || c > 0x5A) && (c < 0x61 && c > 0x7A) && (c < 0x30 || c > 0x39) && c != 0x2E && c != 0x5F && c != 0x2D) {
							return false;
						}
					}
					return true;
				}
			}
			return false;
		}
		
		// other methods
		
		/**
		* Trims space characters as defined by production [3] in 
		* the XML 1.0 specification from both ends of the given string.
		* 
		* @param value the string to be trimmed
		* @return the given string with the space characters trimmed
		* from both ends
		*/
		public static function trim(value:String):String {
			var start:int;
			var end:int;
			var lengthMinusOne:int = value.length - 1;
			for(start = 0; start <= lengthMinusOne; ++start) {
				if(!isSpace(value.charCodeAt(start))) {
					break;
				}
			}
			for(end = lengthMinusOne; end >= start; --end) {
				if(!isSpace(value.charCodeAt(end))) {
					break;
				}
			}
			if(start == 0 && end == lengthMinusOne) {
				return value;
			}
			if(start > lengthMinusOne) {
				return "";
			}
			return value.substring(start, end + 1);
		}
	}
}