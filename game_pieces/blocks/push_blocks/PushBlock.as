package game_pieces.blocks.push_blocks 
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.Button;
	import net.jacob_stewart.JS;
	
	import collectables.Orb_GP;
	import game_pieces.GamePiece;
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlock_GP;
	import game_pieces.blocks.push_blocks.move_arrows.*;
	import game_pieces.tiles.floor_tile.FloorTile;
	import game_pieces.tiles.goal_tile.GoalTile;
	import game_pieces.tiles.hole_tile.HoleTile;
	import game_pieces.tiles.switch_tile.SwitchTile_GP;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_GP;
	import game_pieces.tiles.wall_tile.WallTile;
	import worlds.game_play.GamePlayManager;
	import worlds.game_play.Room;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * PushBlock is the base class for BlueBlock and RedBlock
	 */
	
	public class PushBlock extends Button 
	{
		private var img:Image = new Image(Images.BLOCK1);
		
		/**
		 * PushBlock is not collidable during InputManager_GP.MOVING state
		 * This is so Block can collide with a SwitchTile
		 */
		public var hb2:PushBlockHitbox2;
		
		/**
		 * Stores the 3 hex color values for normal, hover, and down button interactivity
		 */
		public var colors:Array = new Array(3);
		
		/**
		 * Stores the 4 MoveArrow instances for this Block instance
		 */
		public var arrows:Array = new Array(4);
		
		/**
		 * Indicates if a move direction is available by true or false
		 * Indices 0-3 represent up, right, down, left 
		 */
		public var directionIsAvailable:Array = [false, false, false, false];
		
		/**
		 * Stores the difference between this Block's current space number and its adjacent cardinal direction space numbers
		 * Indices 0-3 represent up, right, down, left
		 */
		private var adjacentSpaceDiff:Array = [0, 1, 0, -1];
		
		/**
		 * The max number of spaces this block can move
		 */
		private var maxSpaceMoves:uint = 1;
		
		/**
		 * If the Block will fall in a hole this move
		 */
		public var willFallinHole:Boolean = false;
		
		/**
		 * If the Block will fall off the grid this move
		 */
		public var willFallOffGrid:Boolean = false;
		
		/**
		 * The home space number of the Block
		 */
		public var homeSpace:uint;
		
		/**
		 * The space number the Block will move to
		 */
		private var moveToSpaceNum:uint;
		
		/**
		 * The x and y coordinates for the Block to move to
		 */
		private var destinationCoords:Point = new Point;
		
		/**
		 * The duration of the tween when moving the Block
		 */
		private var duration:Number;
		
		/**
		 * Stores the state constants of InputManager_GP that qualify the Block to be collidable
		 */
		private var collidableStates:Array = new Array;
		
		/**
		 * Stores the state constants of InputManager_GP that qualify the Block to be clickable
		 */
		private var clickableStates:Array = new Array;
		
		private var room:Room;
		public var gpm:GamePlayManager;
		private var mm:PushBlockMoveManager;
		private var sb:SequenceBlock_GP;
		private var bh:PushBlockHighlighter;
		private var orb:Orb_GP;
		
		
		
		public function PushBlock() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = Game.PUSHBLOCK_LAYER;
			type = Game.TYPE_PushBlock;
			epSetHitbox(Game.SPACESIZE, Game.SPACESIZE);
			graphic = img;
			
			hb2 = new PushBlockHitbox2(this);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			room = world.getInstance(Game.NAME_Room) as Room;
			mm = world.getInstance(Game.NAME_PushBlockMoveManager) as PushBlockMoveManager;
			
			collidableStates.push(gpm.im.IDLE, gpm.im.PENDINGMOVE);
			clickableStates.push(gpm.im.IDLE, gpm.im.PENDINGMOVE);
			
			willFallinHole = false;
			willFallOffGrid = false;
			
			hb2.x = x, hb2.y = y;
			epAdd(hb2);
			
			createMoveArrows();
			setMoveArrowValues();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			room = null;
			mm = null;
			sb = null;
			bh = null;
			orb = null;
		}
		// ------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateCollidable();
			
			
			super.update();
			
			
			updateLayer();
			updateCollectOrb();
		}
		
		public function updateCollidable():void
		{
			collidable = false;
			if (collidableStates.indexOf(gpm.im.state) != -1) collidable = true;
		}
		
		private function updateLayer():void
		{
			layer = -3, world.sendToBack(this);
			if (gpm.blockPendingMove == this)
			{
				if (layer > world.layerNearest) layer = world.layerNearest - 1;
			}
			if (gpm.blockPendingMove == this) layer = -4;
		}
		
		private function updateCollectOrb():void
		{
			orb = hb2.collide(Game.TYPE_Orb, hb2.x, hb2.y) as Orb_GP;
			if (orb) orb.collect();
		}
		// ------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		// ------------------------------------------------------------------------
		
		
		override public function changeStateNormal():void 
		{
			img.color = colors[NORMAL];
		}
		
		override public function changeStateHover():void 
		{
			img.color = colors[HOVER];
		}
		
		override public function changeStateDown():void 
		{
			img.color = colors[DOWN];
		}
		// ------------------------------------------------------------------------
		
		
		override public function click():void 
		{
			super.click();
			
			
			if (qualClick()) toggleSelectBlock();
		}
		// ------------------------------------------------------------------------
		
		
		/**
		 * Determines if the Block currently qualifies as clickable
		 * @return	true if qualfies, false if doesn't qualify
		 */
		public function qualClick():Boolean
		{
			if (clickableStates.indexOf(gpm.im.state) != -1) return true;
			return false;
		}
		// ------------------------------------------------------------------------
		
		
		public function toggleSelectBlock():void
		{
			var arrow:MoveArrow;
			
			if (gpm.blockPendingMove == this)
			{
				gpm.im.state = gpm.im.IDLE;
				gpm.setBlockPendingMove(null);
				
				for each (arrow in arrows) arrow.deactivate();
			}
			else
			{
				gpm.im.state = gpm.im.PENDINGMOVE;
				gpm.setBlockPendingMove(this);
				
				// For mouse click
				bh = world.getInstance(Game.NAME_PushBlockHighlighter) as PushBlockHighlighter;
				bh.setSelectedBlock(this);
				
				for (var j:uint = 0; j < 4; j++)
				{
					arrow = arrows[j];
					if (directionIsAvailable[j]) arrow.activate();
				}
			}
			
			Sounds.tick2();
		}
		// ------------------------------------------------------------------------
		
		
		public function setValues(roomIndex:uint, spaceCountHor:uint, spaceCountVer:uint, instanceNum:uint):void
		{
			this.roomIndex = roomIndex;
			homeSpace = this.roomIndex;
			
			adjacentSpaceDiff[0] = -spaceCountHor, adjacentSpaceDiff[2] = spaceCountHor;
			willFallinHole = false;
			
			if (this is BlueBlock)
			{
				maxSpaceMoves = spaceCountVer;
				if (spaceCountHor >= spaceCountVer) maxSpaceMoves = spaceCountHor;
			}
		}
		// ------------------------------------------------------------------------
		
		
		private function createMoveArrows():void
		{
			arrows[0] = world.create(MoveArrowUp);
			arrows[1] = world.create(MoveArrowRight);
			arrows[2] = world.create(MoveArrowDown);
			arrows[3] = world.create(MoveArrowLeft);
			
			children.push(arrows[0]);
			children.push(arrows[1]);
			children.push(arrows[2]);
			children.push(arrows[3]);
		}
		
		public function setMoveArrowValues():void
		{
			var arrow:MoveArrow;
			var gp:GamePiece;
			
			
			for (var i:uint = 0; i < 4; i++)
			{
				directionIsAvailable[i] = false;
				
				
				if (isBorderSpace(roomIndex, i))
				{
					directionIsAvailable[i] = true; // Allow for user to move off the grid
				}
				else
				{
					var roomIndexInCheck:int = roomIndex + adjacentSpaceDiff[i];
					
					
					if (!hasBlock(roomIndexInCheck))
					{
						gp = room.spaces[roomIndexInCheck];
						
						
						if (gp is FloorTile || gp is GoalTile || gp is HoleTile || gp is SwitchTile_GP) directionIsAvailable[i] = true;
						
						if (gp is SwitchClient_GP)
						{
							var sc:SwitchClient_GP = room.spaces[roomIndexInCheck];
							
							if (sc.isActive)
							{
								if (sc.activeNum == Game.ID_FLOOR || sc.activeNum == Game.ID_GOAL || sc.activeNum == Game.ID_HOLE) directionIsAvailable[i] = true;
							}
							else
							{
								if (sc.inactiveNum == Game.ID_FLOOR || sc.inactiveNum == Game.ID_GOAL || sc.inactiveNum == Game.ID_HOLE) directionIsAvailable[i] = true;
							}
							
							// public static var imgs:Array = [floorImg, wallImg, goalImg, holeImg, switchImg, blueImg, redImg, backAndForthImg, glowOrb1b];
						}
					}
				}
				
				
				arrow = arrows[i];
				arrow.setValues(this); // sets the moveArrow's x & y
			}
		}
		
		private function hasBlock(spaceNum:int):Boolean
		{
			for each (var block:EntityGame in JS.getArrayAsFlat([room.pushBlocks, room.sequenceBlocks]))
			{
				if (block.roomIndex == spaceNum) return true;
			}
			
			return false;
		}
		
		private function isBorderSpace(spaceIndex:uint, dirVal:uint):Boolean
		{
			for (var i:uint = 0; i < room.borderIndices[dirVal].length; i++)
			{
				if (spaceIndex == room.borderIndices[dirVal][i]) return true;
			}
			
			
			return false;
		}
		// ------------------------------------------------------------------------
		
		
		public function makeMove(dirVal:uint):void
		{
			gpm.im.state = gpm.im.MOVING;
			
			gpm.incrementMovesMade();
			room.blockHighlighter.movedHistory.unshift(this);
			for each (var arrow:MoveArrow in arrows) arrow.deactivate();
			
			
			willFallinHole = false;
			willFallOffGrid = false;
			duration = Game.PUSHBLOCK_MOVERATE;
			moveToSpaceNum = roomIndex + adjacentSpaceDiff[dirVal];
			
			if (this is RedBlock)
			{
				if (moveToSpaceNum > -1 && moveToSpaceNum < room.spaces.length)
				{
					var gp:GamePiece = room.spaces[moveToSpaceNum];
					
					if (gp is HoleTile) willFallinHole = true;
					else if (gp is SwitchClient_GP)
					{
						var sc:SwitchClient_GP = room.spaces[moveToSpaceNum];
						
						if (sc.isActive)
						{
							if (sc.activeNum == Game.ID_HOLE) willFallinHole = true;
						}
						else if (sc.inactiveNum == Game.ID_HOLE) willFallinHole = true;
					}
				}
				else moveOffGridSetup(dirVal, roomIndex);
			}
			
			if (this is BlueBlock) setMoveToSpaceNum(dirVal); // Also sets duration
			
			
			if (!willFallOffGrid) destinationCoords.x = room.spaces[moveToSpaceNum].x, destinationCoords.y = room.spaces[moveToSpaceNum].y;
			roomIndex = moveToSpaceNum;
			
			
			mm.makeMove(this, destinationCoords, duration);
			
			Sounds.tick4();
		}
		// ------------------------------------------------------------------------
		
		
		private function setMoveToSpaceNum(dirVal:uint):void // Only for BlueBlock
		{
			if (isBorderSpace(roomIndex, dirVal)) // Will move off grid
			{
				moveOffGridSetup(dirVal, roomIndex);
			}
			else
			{
				var roomIndexInCheck:int = moveToSpaceNum;
				
				for (var i:uint = 1; i < maxSpaceMoves + 1; i++)
				{
					if (isBorderSpace(roomIndexInCheck, dirVal)) // Will move off grid
					{
						moveOffGridSetup(dirVal, roomIndexInCheck);
						duration = Game.PUSHBLOCK_MOVERATE * i;
						i = maxSpaceMoves + 1;
					}
					else
					{
						roomIndexInCheck = roomIndex + (adjacentSpaceDiff[dirVal] * i);
						var spaceInCheck:EntityGame = room.spaces[roomIndexInCheck];
						
						if (!hasBlock(roomIndexInCheck))
						{
							if (spaceInCheck is FloorTile || spaceInCheck is GoalTile)
							{
								moveToSpaceNum = roomIndexInCheck;
							}
							else if (spaceInCheck is WallTile)
							{
								duration = Game.PUSHBLOCK_MOVERATE * (i - 1);
								i = maxSpaceMoves + 1;
							}
							else if (spaceInCheck is HoleTile)
							{
								moveToSpaceNum = roomIndexInCheck;
								
								willFallinHole = true;
								duration = Game.PUSHBLOCK_MOVERATE * i;
								i = maxSpaceMoves + 1;
							}
							else if (spaceInCheck is SwitchTile_GP)
							{
								moveToSpaceNum = roomIndexInCheck;
								
								var st:SwitchTile_GP = room.spaces[roomIndexInCheck];
								for each (var sc:SwitchClient_GP in st.clients)
								{
									if (!sc.isActive) sc.isPendingActivation = true;
								}
							}
							else if (spaceInCheck is SwitchClient_GP)
							{
								var sc2:SwitchClient_GP = room.spaces[roomIndexInCheck];
								
								if (sc2.isPendingActivation || sc2.isActive) scReaction(sc2.activeNum);
								else scReaction(sc2.inactiveNum);
								
								function scReaction(typeNum:uint):void
								{
									switch(typeNum)
									{
										case Game.ID_FLOOR: // Floor
											
											moveToSpaceNum = roomIndexInCheck;
											
											break;
											
										case Game.ID_GOAL: // Goal
											
											moveToSpaceNum = roomIndexInCheck;
											
											break;
											
										case Game.ID_HOLE: // Hole
											
											moveToSpaceNum = roomIndexInCheck;
											
											willFallinHole = true;
											duration = Game.PUSHBLOCK_MOVERATE * i;
											i = maxSpaceMoves + 1;
											
											break;
											
										case Game.ID_WALL: // Wall
											
											duration = Game.PUSHBLOCK_MOVERATE * (i - 1);
											i = maxSpaceMoves + 1;
											
											break;
									}
								}
							}
						}
						else
						{
							duration = Game.PUSHBLOCK_MOVERATE * (i - 1);
							i = maxSpaceMoves + 1;
						}
					}
				}
			}
		}
		
		private function moveOffGridSetup(dirVal:uint, spaceIndex:uint):void
		{
			switch(dirVal)
			{
				case 0: // Up
					destinationCoords.x = x, destinationCoords.y = room.spaces[spaceIndex].y - Game.SSPSP;
					break;
				case 1: // Right
					destinationCoords.x = room.spaces[spaceIndex].x + Game.SSPSP, destinationCoords.y = y;
					break;
				case 2: // Down
					destinationCoords.x = x, destinationCoords.y = room.spaces[spaceIndex].y + Game.SSPSP;
					break;
				case 3: // Left
					destinationCoords.x = room.spaces[spaceIndex].x - Game.SSPSP, destinationCoords.y = y;
					break;
			}
			
			
			willFallinHole = true;
			willFallOffGrid = true;
		}
		// ------------------------------------------------------------------------
		
		
		public function onFinishMove():void
		{
			if (willFallinHole || willFallOffGrid) fallInHole();
		}
		
		public function fallInHole():void
		{
			if (this is BlueBlock) room.pushBlocks[0].splice(room.pushBlocks[0].indexOf(this), 1);
			else if (this is RedBlock) room.pushBlocks[1].splice(room.pushBlocks[1].indexOf(this), 1);
			
			
			
			var count:uint = room.pushBlocks[0].length + room.pushBlocks[1].length;
			
			for (var i:uint = 0; i < count; i++)
			{
				if (room.blockHighlighter.movedHistory.indexOf(this) != -1)
				{
					room.blockHighlighter.movedHistory.splice(room.blockHighlighter.movedHistory.indexOf(this), 1);
				}
			}
			
			
			room.epRecycle(this);
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}