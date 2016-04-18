package;

import flixel.math.FlxPoint;
import openfl.ui.Keyboard;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;

class Player extends BlockGroup {
	
	public var center(default, null):Block;
	private var coreBlocks:Array<Block>;
	
	public function new() {
		super();
		
		coreBlocks = new Array<Block>();
		for (i in -1...2) for (j in -1...2) {
			var b = addBlock(i, j, WHITE);
			coreBlocks.push(b);
			if (i == 0 && j == 0)
				center = b;
		}
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if(alive) {
			var moveCommand = new MoveCommand(this, 0, 0);
			
			if (FlxG.keys.anyJustPressed([Keyboard.A, Keyboard.LEFT]))
				moveCommand.dx -= 1;
			if (FlxG.keys.anyJustPressed([Keyboard.S, Keyboard.DOWN]))
				moveCommand.dy += 1;
			if (FlxG.keys.anyJustPressed([Keyboard.D, Keyboard.RIGHT]))
				moveCommand.dx += 1;
			if (FlxG.keys.anyJustPressed([Keyboard.W, Keyboard.UP]))
				moveCommand.dy -= 1;
				
			try {
				moveAndMerge(moveCommand, [this]);
			}
			catch (e:Dynamic) {
				trace(e); // ????????????
			}
		}
	}
	
	override public function kill():Void {
		alive = false;
	}
	
	public function isCoreBlock(b:Block):Bool {
		return coreBlocks.indexOf(b) >= 0;
	}
	
/**
 *  This eliminates rows that are large enough.
 * 
 *  This is probably the worst function I've written in several years.
 *  Lol, good functions do one thing?  How about 5000 things?
 *  And to top it off, we'll give this a bad name and use magical 99999999999999's in it.
 * 
 *  And I'll leave it mostly uncommented so future me has a good laugh.
 * 
 *  @return number of blocks destroyed
 */
	public function eliminateRows():{numOfBlocks:Int, avgX:Float, avgY:Float} {
		var minXUnit = 999999999;
		var minYUnit = 999999999;
		var maxXUnit = -999999999;
		var maxYUnit = -999999999;
		for (block in this) {
			var bx = C.toUnit(block.x);
			var by = C.toUnit(block.y);
			if (bx < minXUnit) minXUnit = bx;
			else if (bx > maxXUnit) maxXUnit = bx;
			if (by < minYUnit) minYUnit = by;
			else if (by > maxYUnit) maxYUnit = by;
		}
		
		var rows = maxYUnit - minYUnit + 1;
		var columns = maxXUnit - minXUnit + 1;
		var blockArray = new Array<Block>();
		for (i in 0...(columns * rows))
			blockArray.push(null);
			
		for (block in this) {
			var bx = C.toUnit(block.x);
			var by = C.toUnit(block.y);
			var index = (bx - minXUnit) + (by - minYUnit) * columns;
			if (blockArray[index] != null)
				removeBlock(block);  // removes weird overlapping incidences
			else
				blockArray[index] = block;
		}
		
		var blocksToRemove = new Array<Block>();
		for (r in 0...rows) {
			var candidates = new Array<Block>();
			for (c in 0...columns) {
				var block = blockArray[r * columns + c];
				if (isCoreBlock(block)) {
					candidates = new Array<Block>();
					break;
				}
				else if (block != null)
					candidates.push(block);
				else {
					if (candidates.length >= C.BLOCKS_IN_A_ROW)
						blocksToRemove = blocksToRemove.concat(candidates);
					candidates = new Array<Block>();
				}
			}
			if (candidates.length >= C.BLOCKS_IN_A_ROW)
				blocksToRemove = blocksToRemove.concat(candidates);
		}
		
		for (c in 0...columns) {
			var candidates = new Array<Block>();
			for (r in 0...rows) {
				var block = blockArray[r * columns + c];
				if (isCoreBlock(block)) {
					candidates = new Array<Block>();
					break;
				}
				else if (block != null)
					candidates.push(block);
				else {
					if (candidates.length >= C.BLOCKS_IN_A_ROW)
						blocksToRemove = blocksToRemove.concat(candidates);
					candidates = new Array<Block>();
				}
			}
			if (candidates.length >= C.BLOCKS_IN_A_ROW)
				blocksToRemove = blocksToRemove.concat(candidates);
		}
		
		var blocksRemoved = blocksToRemove.length;
		var avgX = 0.0;
		var avgY = 0.0;
		
		for (block in blocksToRemove) {
			var bx = C.toUnit(block.x);
			var by = C.toUnit(block.y);
			avgX += block.x;
			avgY += block.y;
			blockArray[(bx - minXUnit) + (by - minYUnit) * columns] = null;
			removeBlock(block);
		}
		
		avgX /= blocksRemoved;
		avgY /= blocksRemoved;
		
	//  Connected Components
		var components = new Array<Array<Block>>();
		var visited = blockArray.map(function(b) {  return b == null ? true : false; });
		//var visited = Lambda.array(Lambda.map(blockArray, function(b) {  return b == null ? true : false; }));
		var isVisited = function(block:Block) {
			var bx = C.toUnit(block.x);
			var by = C.toUnit(block.y);
			return visited[(bx - minXUnit) + (by - minYUnit) * columns];
		};
		
		for (b in this) {
			if (isVisited(b))
				continue;
			var component = new Array<Block>();
			var queue = new Array<Block>();
			queue.push(b);
			while (queue.length > 0) {
				var curBlock = queue.shift();
				component.push(curBlock);
				var c = C.toUnit(curBlock.x) - minXUnit;
				var r = C.toUnit(curBlock.y) - minYUnit;
				visited[c + r * columns] = true;
				if (r - 1 >= 0 && !visited[c + (r - 1) * columns])
					queue.push(blockArray[c + (r - 1) * columns]);
				if (r + 1 < rows && !visited[c + (r + 1) * columns])
					queue.push(blockArray[c + (r + 1) * columns]);
				if (c - 1 >= 0 && !visited[c - 1 + r * columns])
					queue.push(blockArray[c - 1 + r * columns]);
				if (c + 1 < columns && !visited[c + 1 + r * columns])
					queue.push(blockArray[c + 1 + r * columns]);
			}
			components.push(component);
		}
	//  /Connected Components
	
		for (component in components) {
			if (component.indexOf(center) >= 0 || component.length <= 0)
				continue;
			var dir = Direction.DOWN;
			var dx = component[0].x - center.x;
			var dy = component[0].y - center.y;
			if (Math.abs(dx) > Math.abs(dy)) {
				if (dx > 0) dir = Direction.LEFT;
				else dir = Direction.RIGHT;
			}
			else {
				if (dy > 0) dir = Direction.UP;
			}
			var group = new AutoBlockGroup(dir);
			for (block in component) {
				this.remove(block);
				group.add(block);
			}
			C.state().blockGroups.add(group);
		}
		
		if (blocksRemoved > 0)
			for (b in coreBlocks)
				b.flash();
		
		return {
			numOfBlocks: blocksRemoved,
			avgX: avgX,
			avgY: avgY
		};
	}
	
	public function isBeyondCamera():Bool {
		var w = FlxG.camera.width;
		var h = FlxG.camera.height;
		var bounds = new FlxRect(center.x - w / 2, center.y - h /2, w, h);
		for (b in this) {
			var p = new FlxPoint(b.x, b.y);
			if (!p.inRect(bounds))
				return true;
		}
		return false;
	}
	
}