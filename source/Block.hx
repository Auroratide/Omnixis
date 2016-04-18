package;

import flixel.FlxSprite;

//  Notes
//  Blocks themselves do not move autonomously.  Blockgroups move.
//  A block can be in a blockgroup of size 1

class Block extends FlxSprite {
	
	public static inline var FLASH_ANIM = "flash";
	
	public function new(x:Float, y:Float, color:Color) {
		super(x, y);
		loadGraphic(switch(color) {
			case RED:     AssetPaths.rblock_anim__png;
			case GREEN:   AssetPaths.gblock_anim__png;
			case BLUE:    AssetPaths.bblock_anim__png;
			case YELLOW:  AssetPaths.yblock_anim__png;
			case CYAN:    AssetPaths.cblock_anim__png;
			case MAGENTA: AssetPaths.mblock_anim__png;
			case ORANGE:  AssetPaths.oblock_anim__png;
			case WHITE:   AssetPaths.wblock_anim__png;
		}, true, 16, 16);
		animation.add(FLASH_ANIM, [1, 2, 3, 4, 5, 6, 7, 8, 9, 0], 20, false);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
	
	override public function destroy():Void {
		C.state().blocks.remove(this);
		super.destroy();
	}
	
	public function flash():Void {
		animation.play(FLASH_ANIM);
	}
	
	public function darken(?factor:Float = 0.2):Void {
		this.setColorTransform(factor, factor, factor);
	}
	
	public function lighten():Void {
		this.setColorTransform(1, 1, 1);
	}
	
}