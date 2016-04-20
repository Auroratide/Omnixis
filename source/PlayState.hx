package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.system.FlxSound;

class PlayState extends BlocksState {
	
	private var score:Int;
	//private var counter:Int = 0;
	private var rand:FlxRandom;
	
	public var paused(default, null):Bool;
	
	//public var blocks(default, null):FlxTypedGroup<Block>;
	//public var blockGroups(default, null):FlxTypedGroup<BlockGroup>;
	//public var player(default, null):Player;
	
	private var scoreText:FlxText;
	private var deltaScoreTexts:Array<DeltaScoreText>;
	private var deltaScoreTextLayer:FlxTypedGroup<DeltaScoreText>;
	private var pausedText:FlxText;
	
	private var background:FlxSprite;
	
	private var elapsedBeats:Int;
	
/*  Flixel API
 *  ==========================================================================*/
	override public function create():Void {
		super.create();
		FlxG.mouse.visible = false;
		paused = false;
		
		beats = C.HEARTBEAT_LV_1;
		elapsedBeats = 0;
		
		background = new FlxSprite(C.unit(-3), C.unit(-3));
		background.loadGraphic(AssetPaths.background__png);
		this.add(background);
		
		//blocks = new FlxTypedGroup<Block>();
		//blockGroups = new FlxTypedGroup<BlockGroup>();
		this.add(blocks);
		
		player = new Player();
		this.add(player);
		
		player.move(C.toUnit(C.WIDTH / 2), C.toUnit(C.WIDTH / 2));
		
		//FlxG.camera.targetOffset.set(-C.WIDTH / 2, -C.WIDTH / 2);
		FlxG.camera.follow(player.center, LOCKON, 0.1);
		
		this.add(blockGroups);
		
		rand = new FlxRandom();
		
		score = 0;
		scoreText = new FlxText(0, 0, FlxG.camera.width, "0000000", 16);
		scoreText.scrollFactor.set(0, 0);
		
		deltaScoreTexts = new Array<DeltaScoreText>();
		deltaScoreTextLayer = new FlxTypedGroup<DeltaScoreText>();
		this.add(deltaScoreTextLayer);
		add(scoreText);
		
		pausedText = new FlxText(0, 84, C.WIDTH, "Paused", 32);
		pausedText.scrollFactor.set(0, 0);
		pausedText.alignment = FlxTextAlign.CENTER;
		this.add(pausedText);
		pausedText.visible = false;
		
		for (i in 0...4)
			blockGroups.add(generateRandomGroup());
			
		FlxG.sound.load(AssetPaths.threeTone2__ogg, 1).play();
	}

	override public function update(elapsed:Float):Void {
		if(!paused) {
			super.update(elapsed);
			//++counter;
			
			var w = FlxG.camera.width * 2;
			var h = FlxG.camera.height * 2;
			FlxG.worldBounds.set(player.center.x - w / 2, player.center.y - h / 2, w, h);
			
			background.x = player.center.x - w / 4 - 8;
			background.y = player.center.y - h / 4 - 8;
			
			if (heartbeat()) {
				++elapsedBeats;
				for (g in blockGroups) {
					if (g.isOutOfBounds()) {
						blockGroups.remove(g);
						g.destroy();
					}
				}
				if(player.alive && elapsedBeats % 2 == 0) {
					blockGroups.add(generateRandomGroup());
				}
			}
			
			if (player.alive) {
				var info = player.eliminateRows();
				if (info.numOfBlocks > 0)
					FlxG.sound.load(AssetPaths.zap1__ogg).play(true);
				var dScore = blocksToScore(info.numOfBlocks);
				if (dScore > 0)
					showDeltaScoreText(info.avgX, info.avgY, dScore);
				
				updateScoreText();
				updateBeats();
				
				if (FlxG.keys.justPressed.ESCAPE || player.isBeyondCamera())
					gameOver();
				else if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.P)
					pause();
			}
		}
		else {
			if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.P)
			    unpause();
		}
	}
	
/*  Public Methods
 *  ==========================================================================*/
	//public function heartbeat():Bool {
	//	return counter % C.HEARTBEAT == 0;
	//}
	
	public function blocksToScore(numOfBlocks:Int):Int {
		if (numOfBlocks < 0)
			return 0;
		var scoreBefore = score;
		if (numOfBlocks <= 10)
			score += C.POINTS_PER_BLOCK * numOfBlocks;
		else {
			score += C.POINTS_PER_BLOCK * 10;
			var x = numOfBlocks - 10;
			var factor:Float = C.COMBO_POINT_INCREMENT / 2.0;
			score += Math.ceil(factor * x * x + (factor + C.POINTS_PER_BLOCK) * x);
		}
		return score - scoreBefore;
	}
	
	public function showDeltaScoreText(x:Float, y:Float, amount:Int):DeltaScoreText {
		var txt:DeltaScoreText = null;
		var i = 0;
		while (txt == null && i < deltaScoreTexts.length) {
			if (!deltaScoreTexts[i].alive)
				txt = deltaScoreTexts[i];
			++i;
		}
		if (txt == null) {
			txt = new DeltaScoreText();
			deltaScoreTexts.push(txt);
			deltaScoreTextLayer.add(txt);
		}
		txt.appear(x, y, amount);
		return txt;
	}
	
	public function updateScoreText():Void {
		var s = Std.string(score);
		while (s.length < C.SCORE_TEXT_WIDTH)
			s = "0" + s;
		scoreText.text = s;
	}
	
	public function updateBeats():Void {
		switch(elapsedBeats) {
			case 10:  beats = C.HEARTBEAT_LV_2;
			case 21:  beats = C.HEARTBEAT_LV_3;
			case 44:  beats = C.HEARTBEAT_LV_4;
			case 69:  beats = C.HEARTBEAT_LV_5;
			case 100: beats = C.HEARTBEAT_LV_6;
			case 145: beats = C.HEARTBEAT_LV_7;
			case 200: beats = C.HEARTBEAT_LV_8;
			default:
				if (elapsedBeats > 200 && (elapsedBeats+200) % 120 == 0 && beats > 30)
					beats -= 2;
		}
	}
	
	/*
	public function overlaps(group:BlockGroup):Array<BlockGroup> {
		var arr = new Array<BlockGroup>();
		for (g in blockGroups) {
			if (g != group && FlxG.overlap(g, group))
				arr.push(g);
		}
		return arr;
	}
	*/
	
	public function generateRandomGroup():BlockGroup {
		var newGroupX = player.center.x;
		var newGroupY = player.center.y;
		var newGroupDir = Direction.DOWN;
		
		var w = FlxG.camera.width;
		var h = FlxG.camera.height;
		switch(rand.int(0, 3)) {
			case 0:
				newGroupDir = Direction.DOWN;
				newGroupY -= 2*h / 3;
				newGroupX += rand.float( -w / 2, w / 2);
			case 1:
				newGroupDir = Direction.LEFT;
				newGroupX += 2*w / 3;
				newGroupY += rand.float( -h / 2, h / 2);
			case 2:
				newGroupDir = Direction.UP;
				newGroupY += 2*h / 3;
				newGroupX += rand.float( -w / 2, w / 2);
			case 3:
				newGroupDir = Direction.RIGHT;
				newGroupX -= 2*w / 3;
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
	
	public function pause():Void {
		if (!paused) {
			paused = true;
			pausedText.visible = true;
			blocks.forEach(function(b) {  b.darken(); } );
			FlxG.sound.music.volume = 0.1;
		}
	}
	
	public function unpause():Void {
		if (paused) {
			paused = false;
			pausedText.visible = false;
			blocks.forEach(function(b) {  b.lighten(); });
			FlxG.sound.music.volume = 0.5;
		}
	}
	
	private function gameOver():Void {
		FlxG.mouse.visible = true;
		FlxG.sound.load(AssetPaths.zapThreeToneDown__ogg).play();
		player.kill();
		blocks.forEach(function(b) {  b.darken(); });
		player.forEach(function(b) {  b.darken(0.3); });
		
		var title = new FlxText(0, 84, C.WIDTH, "Game Over", 32);
		title.scrollFactor.set(0, 0);
		title.alignment = FlxTextAlign.CENTER;
		
		var highscore:Null<Int> = FlxG.save.data.highscore;
		if (highscore == null) {
			highscore = 0;
			FlxG.save.data.highscore = 0;
			FlxG.save.flush();
		}
		if (score > highscore) {
			FlxG.save.data.highscore = score;
			FlxG.save.flush();
			var newHighscore = new FlxText(0, 148, C.WIDTH, "New Highscore!", 24);
			newHighscore.alignment = FlxTextAlign.CENTER;
			newHighscore.scrollFactor.set(0, 0);
			this.add(newHighscore);
		}
		
		var finalScoreText = new FlxText(0, 196, C.WIDTH, scoreText.text, 24);
		finalScoreText.scrollFactor.set(0, 0);
		finalScoreText.alignment = FlxTextAlign.CENTER;
		
		scoreText.kill();
		
		var playBtn = new FlxButton(0, 248, "Play Again", function() {  FlxG.switchState(new PlayState()); });
		playBtn.x = C.WIDTH / 2 - playBtn.width / 2;
		var menuBtn = new FlxButton(0, 272, "Main Menu", function() {  FlxG.switchState(new MenuState()); });
		menuBtn.x = C.WIDTH / 2 - menuBtn.width / 2;
		
		this.add(title);
		this.add(finalScoreText);
		this.add(playBtn);
		this.add(menuBtn);
	}
}