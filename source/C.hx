package;

import flixel.FlxG;

class C {
	public static inline var WIDTH = 464;
	public static inline var TITLE = "Omnixis";
	
	public static inline var UNIT = 16;
	public static inline var HEARTBEAT = 90;
	public static inline var HEARTBEAT_LV_1 = 90;
	public static inline var HEARTBEAT_LV_2 = 84;
	public static inline var HEARTBEAT_LV_3 = 78;
	public static inline var HEARTBEAT_LV_4 = 72;
	public static inline var HEARTBEAT_LV_5 = 66;
	public static inline var HEARTBEAT_LV_6 = 60;
	public static inline var HEARTBEAT_LV_7 = 54;
	public static inline var HEARTBEAT_LV_8 = 48;
	public static inline var BLOCKS_IN_A_ROW = 10;
	public static inline var NUM_OF_BLOCK_TYPES = 7;
	public static inline var SCORE_TEXT_WIDTH = 8;
	
	public static inline var POINTS_PER_BLOCK = 10;
	public static inline var COMBO_POINT_INCREMENT = 5;
	
	public static inline function unit(i:Int):Int {
		return i * UNIT;
	}
	
	public static inline function toUnit(f:Float):Int {
		return Math.floor(f / UNIT);
	}
	
	public static inline function state():BlocksState {
		return cast(FlxG.state, BlocksState);
	}
}