package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;

class MenuState extends BlocksState {
	
	private var title:FlxText;
	private var playBtn:FlxButton;
	private var highscore:FlxText;
	private var instructions:FlxText;
	private var arrows:FlxSprite;
	private var about:FlxText;
	private var musicText:FlxText;
	private var background:FlxSprite;
	
	override public function create():Void {
		if (FlxG.sound.music == null) 
			FlxG.sound.playMusic(AssetPaths.TheLift_cut__ogg, 0.5);
			
		super.create();
		player = null;
		
		background = new FlxSprite(0, 0);
		background.loadGraphic(AssetPaths.background__png);
		
		title = new FlxText(0, 84, C.WIDTH, C.TITLE, 36);
		title.alignment = FlxTextAlign.CENTER;
		
		playBtn = new BigButton(0, 172, "Play", function() {  FlxG.switchState(new PlayState()); });
		playBtn.x = C.WIDTH / 2 - playBtn.width / 2;
		
		highscore = new FlxText(0, 232, C.WIDTH, "Highscore\n" + getHighscore(), 16);
		highscore.alignment = FlxTextAlign.CENTER;
		
		instructions = new FlxText(0, 360, C.WIDTH, "Amass blocks on yourself\nScore by lining ten or more in a row\nBut be careful!\nBlocks lined up with the white core don't die\nOh yeah...\nand don't let the blocks build to the edge of the screen!");
		instructions.antialiasing = false;
		instructions.alignment = FlxTextAlign.CENTER;
		arrows = new FlxSprite(0, 312);
		arrows.loadGraphic(AssetPaths.arrows__png);
		arrows.x = C.WIDTH / 2 - arrows.width / 2;
		
		about = new FlxText(0, C.WIDTH - 32, C.WIDTH, "Made by Timothy Foster (@tfAuroratide) for Ludum Dare 35");
		about.alignment = FlxTextAlign.CENTER;
		
		musicText = new FlxText(0, C.WIDTH - 20, C.WIDTH, "Music: The Lift by Kevin MacLeod (CC-BY 3.0)", 8);
		musicText.alignment = FlxTextAlign.CENTER;
		
		this.add(background);
		this.add(blockGroups);
		this.add(blocks);
		this.add(title);
		this.add(playBtn);
		this.add(highscore);
		this.add(instructions);
		this.add(arrows);
		this.add(about);
		this.add(musicText);
		
		FlxG.worldBounds.set( -100, -100, C.WIDTH + 200, C.WIDTH + 200);
	}

	public function getHighscore():String {
		if (FlxG.save.data.highscore == null) {
			FlxG.save.data.highscore = 0;
			FlxG.save.flush();
			return "00000000";
		}
		
		var s = Std.string(FlxG.save.data.highscore);
		while (s.length < C.SCORE_TEXT_WIDTH)
			s = "0" + s;
		return s;
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (heartbeat()) {
			for (g in blockGroups) {
				if (g.isOutOfBounds()) {
					blockGroups.remove(g);
					g.destroy();
				}
			}
			
			var g = generateRandomGroup();
			blockGroups.add(g);
			g.forEachAlive(function(b) {  b.setColorTransform(0.2, 0.2, 0.2); });
		}
	}
	
	public function generateRandomGroup():BlockGroup {
		var rand = new FlxRandom();
		var newGroupX = C.WIDTH / 2;
		var newGroupY = C.WIDTH / 2;
		var newGroupDir = Direction.DOWN;
		
		var w = FlxG.camera.width;
		var h = FlxG.camera.height;
		switch(rand.int(0, 3)) {
			case 0:
				newGroupDir = Direction.DOWN;
				newGroupY -= h / 2 + 32;
				newGroupX += rand.float( -w / 2, w / 2);
			case 1:
				newGroupDir = Direction.LEFT;
				newGroupX += w / 2 + 32;
				newGroupY += rand.float( -h / 2, h / 2);
			case 2:
				newGroupDir = Direction.UP;
				newGroupY += h / 2 + 32;
				newGroupX += rand.float( -w / 2, w / 2);
			case 3:
				newGroupDir = Direction.RIGHT;
				newGroupX -= w / 2 + 32;
				newGroupY += rand.float( -h / 2, h / 2);
			default: 
		}
		
		var realX = C.toUnit(newGroupX);
		var realY = C.toUnit(newGroupY);
		
		return switch(rand.int(1, C.NUM_OF_BLOCK_TYPES)) {
			case 1: new SquareGroup(realX, realY, newGroupDir);
			case 2: new TGroup(realX, realY, newGroupDir);
			case 3: new LongGroup(realX, realY, newGroupDir);
			case 4: new LeftSGroup(realX, realY, newGroupDir);
			case 5: new RightSGroup(realX, realY, newGroupDir);
			case 6: new LeftLGroup(realX, realY, newGroupDir);
			case 7: new RightLGroup(realX, realY, newGroupDir);
			default: new SquareGroup(realX, realY, newGroupDir);
		};
	}
}

private class BigButton extends FlxButton {
	public function new(x:Float, y:Float, txt:String, f:Void->Void) {
		super(x, y, txt, f);
		label.scale.set(2, 2);
		label.offset.set(-39, -10);
		scale.set(2, 2);
		label.width = this.width * 2;
		label.height = this.height * 2;
		updateHitbox();
	}
}