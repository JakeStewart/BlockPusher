package worlds.game_play 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import game_pieces.GamePiece;
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlock_GP;
	import game_pieces.blocks.push_blocks.PushBlock;
	import game_pieces.blocks.push_blocks.PushBlockHighlighter;
	import game_pieces.blocks.push_blocks.PushBlockMoveManager;
	import game_pieces.blocks.push_blocks.BlueBlock;
	import game_pieces.blocks.push_blocks.RedBlock;
	import game_pieces.tiles.floor_tile.FloorTile;
	import game_pieces.tiles.goal_tile.GoalTile;
	import game_pieces.tiles.hole_tile.HoleTile;
	import game_pieces.tiles.switch_tile.SwitchTile_GP;
	import game_pieces.tiles.wall_tile.WallTile;
	import collectables.Orb_GP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Room extends EntityGame 
	{
		private var gpm:GamePlayManager;
		private var mm:PushBlockMoveManager = new PushBlockMoveManager;
		public var roomTimer:RoomTimer = new RoomTimer;
		
		private var fileNameIndex:uint;
		private var fileNamePrefix:String;
		public var roomData:Array;
		
		private var columnCount:uint;
		private var rowCount:uint;
		private var rowIndices:Array = new Array;
		private var columnIndices:Array = new Array;
		
		private var imgNums:Array = new Array;
		private var blueBlockIndices:Array = new Array;
		private var redBlockIndices:Array = new Array;
		private var sbData:Array = new Array;
		private var stData:Array = new Array;
		private var stClientData:Array = new Array;
		private var orbData:Array = new Array;
		
		public var pushBlocks:Array = new Array;
		private var switchTiles:Array = new Array;
		public var sequenceBlocks:Array = new Array;
		public var orbs:Array = new Array;
		
		public var borderIndices:Array = new Array;
		public var goalIndices:Array = new Array;
		
		public var spaces:Array = new Array;
		public var blockHighlighter:PushBlockHighlighter = new PushBlockHighlighter;
		private var tileClasses:Array = [FloorTile, WallTile, GoalTile, HoleTile, SwitchTile_GP];
		
		
		
		public function Room(fileNameIndex:uint = 1, fileNamePrefix:String = null) 
		{
			this.fileNameIndex = fileNameIndex;
			this.fileNamePrefix = fileNamePrefix;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_Room;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			gpm.room = this;
			epAdd(mm);
			buildPuzzle();
			epAdd(roomTimer);
			gpm.gameText.updateOrbText(gpm.orbsCollectedCount(), orbs.length);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			pushBlocks.length = 0;
			switchTiles.length = 0;
			sequenceBlocks.length = 0;
			orbs.length = 0;
			spaces.length = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			// testing();
		}
		// -------------------------------------------------------------
		
		
		private function buildPuzzle():void
		{
			var fileName:String;
			if (fileNameIndex == 0) fileName = RoomData.getDraftName(); // TestRoom: "RoomDraft_User(Save file number in use)"
			else fileName = fileNamePrefix + fileNameIndex.toString(); // Story mode room (xml file): "Room_(Room number)" OR User designed room: "User(Save file number)_Room_(Room number)"
			
			
			
			if (fileNameIndex > 0 && fileNameIndex <= RoomData.roomDataClasses.length && fileNamePrefix == RoomData.XMLFILEPREFIX)
			{
				roomData = RoomData.loadRoomDataXML(fileNameIndex - 1);
			}
			else
			{
				roomData = RoomData.loadRoomData(fileName);
			}
			
			
			// RoomData.loadRoomData(fileName) return [playlistFileName, roomName, COLUMN_COUNT, ROW_COUNT, imgNums, blues, reds, bfData, stData, stClientData, orbData, TOPLEFT_GRIDINDEX, MOVESQUALGOLD];
			gpm.gameText.setRoomName(roomData[1]);
			columnCount = roomData[2];
			rowCount = roomData[3];
			imgNums = roomData[4];
			blueBlockIndices = roomData[5];
			redBlockIndices = roomData[6];
			sbData = roomData[7];
			stData = roomData[8];
			stClientData = roomData[9];
			orbData = roomData[10];
			
			
			
			
			borderIndices = Game.getBorderIndices(columnCount, rowCount);
			rowIndices.length = rowCount, setRowIndices();
			columnIndices.length = columnCount, setColumnIndices();
			
			addTiles();
			addSwitchTiles();
			addSequenceBlocks();
			addOrbs();
			addPushBlocks();
			
			gpm.movesMade = 0;
			gpm.gameText.updateMovesMadeNum(0);
			gpm.roomGUIToggle(gpm.gameText.guiList, true);
			
			epAdd(blockHighlighter);
		}
		
		private function setRowIndices():void
		{
			for (var i:uint = 0; i < rowCount; i++)
			{
				rowIndices[i] = (new Array(columnCount));
				for (var j:uint = 0; j < columnCount; j++) rowIndices[i][j] = (columnCount * i) + j;
			}
		}
		
		private function setColumnIndices():void
		{
			for (var i:uint = 0; i < columnCount; i++)
			{
				columnIndices[i] = (new Array(rowCount));
				for (var j:uint = 0; j < rowCount; j++) columnIndices[i][j] = (columnCount * j) + i;
			}
		}
		
		private function addTiles():void
		{
			spaces.length = columnCount * rowCount;
			
			var imgNum:uint; // To keep imgNums from being modified
			var coords:Array = RoomData.getAllSpaceCoords(columnCount, rowCount, Game.SPACESIZE, Game.SPACEPADDING);
			
			for (var i:uint = 0; i < spaces.length; i++)
			{
				// [floorTileImg, wallTileImg, goalTileImg, holeTileImg, switchTileImg, blueBlockImg, redBlockImg]
				imgNum = imgNums[i];
				
				if (imgNum == 2) goalIndices.push(i);
				if (imgNum == 4) imgNum = 0; // If SwitchTile, set FloorTile (Will swap later)
				
				if (imgNum != 99)
				{
					spaces[i] = Game.createGameEntity(tileClasses[imgNum], coords[i].x, coords[i].y, i);
				}
				else
				{
					var hole:HoleTile;
					
					spaces[i] = Game.createGameEntity(tileClasses[3], coords[i].x, coords[i].y, i);
					hole = spaces[i], hole.visible = false;
				}
				
				
				children.push(spaces[i]);
			}
		}
		
		private function addSwitchTiles():void
		{
			var st:SwitchTile_GP;
			var stSpaceNum:uint;
			
			for (var s:uint = 0; s < stData.length; s++) // Each SwitchTile
			{
				stSpaceNum = stData[s][1]; // roomIndex
				switchTiles.push(new SwitchTile_GP(stClientData[s], stSpaceNum, spaces[stSpaceNum].x, spaces[stSpaceNum].y));
				
				st = switchTiles[s];
				epAdd(st);
				spaces[stSpaceNum] = st;
			}
		}
		
		private function addSequenceBlocks():void
		{
			for (var i:uint = 0; i < sbData.length; i++) sequenceBlocks.push(epAdd(new SequenceBlock_GP(sbData[i][1], sbData[i][3])));
		}
		
		private function addOrbs():void
		{
			var e:EntityGame;
			var orb:Orb_GP;
			for (var i:uint = 0; i < orbData.length; i++)
			{
				e = spaces[orbData[i][1]]; // roomIndex
				orb = epAdd(new Orb_GP) as Orb_GP;
				orb.x = e.x, orb.y = e.y;
				orbs.push(orb);
			}
		}
		
		private function addPushBlocks():void
		{
			var pb:PushBlock;
			
			pushBlocks.push(new Array); // Blue blocks
			pushBlocks.push(new Array); // Red blocks
			
			createBlocks(BlueBlock, pushBlocks[0], blueBlockIndices);
			createBlocks(RedBlock, pushBlocks[1], redBlockIndices);
			
			function createBlocks(_class:Class, _blocks:Array, spaceNums:Array):void
			{
				for (var i:uint = 0; i < spaceNums.length; i++)
				{
					_blocks.push(Game.createGameEntity(_class, spaces[spaceNums[i]].x, spaces[spaceNums[i]].y, spaceNums[i]));
					
					pb = _blocks[_blocks.length - 1];
					pb.setValues(spaceNums[i], columnCount, rowCount, i);
					
					children.push(pb);
				}
			}
		}
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
		
		private function testing():void
		{
			testing1();
		}
		
		private function testing1():void
		{
			if (Input.pressed(Key.T))
			{
				var ary:Array = new Array;
				world.getAll(ary);
				
				for (var i:uint = 0; i < ary.length; i++)
				{
					if (ary[i] is GamePiece) trace(i, ":", ary[i] + ",", ary[i].name + ",", ary[i].roomIndex);
					else trace(i, ":", ary[i] + ",", ary[i].name);
				}
			}
		}
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
	}

}