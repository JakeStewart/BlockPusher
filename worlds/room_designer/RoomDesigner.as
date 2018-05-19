package worlds.room_designer 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.other.RunFunctionOnAdd;
	
	import collectables.Orb;
	import game_pieces.GamePiece;
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlock_RD;
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlockCreator;
	import game_pieces.tiles.switch_tile.SwitchTile_RD;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_RD;
	import worlds.WorldGame;
	import worlds.room_designer.gold_medal_moves.GoldMedalMovesBtn;
	import worlds.room_designer.options_menu.OpenOptionsBtn_RD;
	import worlds.room_designer.options_menu.OptionsMenu_RD;
	import worlds.room_designer.room_namer.RoomNamerBtn;
	import worlds.room_designer.saving.AddRoomToPlaylistButton;
	import worlds.room_designer.saving.SaveChangesButton;
	import worlds.room_designer.saving.SaveQualificationChecker;
	import worlds.room_designer.space_selector.SpaceSelector_RD;
	import worlds.room_designer.switch_tile_editor.SwitchTileEditor;
	import worlds.room_tester.RoomTesterWorld;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomDesigner extends EntityGame 
	{
		public var wp:WorldGame;
		private var block:GamePiece;
		private var gs:GridSpace;
		private var st:SwitchTile_RD;
		private var sc:SwitchClient_RD;
		private var sb:SequenceBlock_RD;
		private var optionsMenu:OptionsMenu_RD;
		
		public var im:InputManager_RD;
		public var mp:MousePointer_RD = new MousePointer_RD([JS.TYPE_Button, JS.TYPE_TextButton, Game.TYPE_KeyboardKeyButton]);
		public var ss:SpaceSelector_RD;
		
		private var changeTypeViaClick:ChangeTypeViaClick_RD = new ChangeTypeViaClick_RD;
		
		public var gridSpaces:Array = new Array(Game.MAXCOLUMNCOUNT * Game.MAXROWCOUNT);
		public var pushBlocks:Array = new Array;
		
		
		private var topLeft:uint = 0;
		private var roomIndices:Array = new Array;
		
		private var columnCount:uint = 0;
		private var rowCount:uint = 0;
		
		
		public var f4Info:Boolean = false;
		public var f8Info:Boolean = true;
		
		public var ste:SwitchTileEditor = new SwitchTileEditor;
		public var switchTiles:Array = new Array;
		
		public var sbc:SequenceBlockCreator = new SequenceBlockCreator;
		public var sequenceBlocks:Array = new Array;
		
		private var orbs:Array = new Array;
		
		private var fileName:String = null;
		
		
		/**
		 * Should match the file name (SharedObject or XML) of a room
		 * on the playlist that the current design originated from.
		 * "null" indicates the design did not originate
		 * from a room in a playlist and was started from blank.
		 */
		public var playlistFileName:String = RoomData.NOTONFILE;
		
		
		private var xmlRoomNum:int;
		public var movesQualGold:int = 1;
		
		public var roomName:String = "Untitled";
		public var saveQualifier:SaveQualificationChecker = new SaveQualificationChecker;
		
		
		private var title:RoomDesignerTitle = new RoomDesignerTitle;
		public var roomNamerBtn:RoomNamerBtn = new RoomNamerBtn(null, roomName);
		public var addRoomBtn:AddRoomToPlaylistButton = new AddRoomToPlaylistButton;
		private var saveChangesBtn:SaveChangesButton = new SaveChangesButton;
		public var goldMedalMovesBtn:GoldMedalMovesBtn = new GoldMedalMovesBtn;
		private var openOptions:OpenOptionsBtn_RD = new OpenOptionsBtn_RD(runOptionsMenu);
		private var guiList:Array = [addRoomBtn, saveChangesBtn, goldMedalMovesBtn, roomNamerBtn, openOptions, title, changeTypeViaClick];
		
		private var levelAndRoomText:LevelAndRoomText = new LevelAndRoomText;
		
		
		
		public function RoomDesigner(wp:WorldGame, fileName:String = null, xmlRoomNum:int = -1) 
		{
			this.wp = wp;
			this.fileName = fileName;
			this.xmlRoomNum = xmlRoomNum;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_RoomDesigner;
			im = new InputManager_RD(mp, this);
			ss = new SpaceSelector_RD;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList([im, mp, ss]);
			
			addEmptyGrid();
			if (fileName != null || !RoomData.draftIsEmpty()) loadFile();
			else if (Game.autoDesign && Game.developer) epAdd(new AutoDesign);
			
			epAdd(saveQualifier);
			epAddList(guiList);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			wp = null;
			block = null;
			gs = null;
			st = null;
			sc = null;
			sb = null;
			optionsMenu = null;
			gridSpaces.length = 0;
			pushBlocks.length = 0;
			switchTiles.length = 0;
			sequenceBlocks.length = 0;
			orbs.length = 0;
			guiList.length = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			// testing();
		}
		// ------------------------------------------------------------------
		
		
		private function loadFile():void
		{
			var data:Array;
			
			if (fileName == "xml")
			{
				data = RoomData.loadRoomDataXML(xmlRoomNum - 1);
			}
			else // draft or user created room. From RoomSelect, title menu, or RoomTester
			{
				if (fileName == null) fileName = RoomData.getDraftName();
				data = RoomData.loadRoomData(fileName);
			}
			
			
			
			// RoomData.loadRoomData(fileName) return [playlistFileName, roomName, COLUMN_COUNT, ROW_COUNT, imgNums, blues, reds, bfData, stData, stClientData, orbData, TOPLEFT_GRIDINDEX, MOVESQUALGOLD];
			playlistFileName = data[0];
			roomName = data[1];
			columnCount = data[2];
			rowCount = data[3];
			var imgNums:Array = data[4];
			var blueRoomIndices:Array = data[5];
			var redRoomIndices:Array = data[6];
			var sbData:Array = data[7];
			var stData:Array = data[8];
			var stClientData:Array = data[9];
			var orbData:Array = data[10];
			topLeft = data[11];
			movesQualGold = data[12];
			
			
			// If dev loads a xml room from RoomSelect then exits RoomDesigner
			// then navs to RoomDesigner from the title menu, xmlRoomNum will be -1.
			// So a check is needed to determine if the draft loaded is a xml room
			// and if so, change xmlRoomNum to the proper number
			if (RoomData.isXMLRoom(playlistFileName)) xmlRoomNum = new uint(playlistFileName.slice(RoomData.XMLFILEPREFIX.length, playlistFileName.length));
			
			if (movesQualGold < 1) movesQualGold = 1;
			if (playlistFileName != RoomData.NOTONFILE) setLevelAndRoomText();
			updateSpaceIndexText();
			
			
			for (var i:uint = 0; i < roomIndices.length; i++)
			{
				if (imgNums[i] != 99)
				{
					gs = gridSpaces[roomIndices[i]];
					gs.imgNum = imgNums[i];
					gs.graphic = Images.imgs[imgNums[i]];
					gs.imgIndexHistory.push(imgNums[i]);
					gs.state0Alpha = 0;
				}
			}
			
			
			// SwitchTile, SwitchClient
			var clientGridIndices:Array = new Array;
			for (var r:uint = 0; r < stData.length; r++) // Each SwitchTile
			{
				clientGridIndices.length = 0, clientGridIndices.length = stClientData[r].length;
				
				for (var s:uint = 0; s < stClientData[r].length; s++) // Each Client
				{
					var cData:Array = stClientData[r][s];
					SwitchClient_RD(world.create(SwitchClient_RD))._SwitchClient(cData[0], cData[1], cData[2], cData[3], cData[4], cData[5], cData[6], cData[7], cData[8], stData[r][2], stData[r][3]);
					clientGridIndices[s] = stClientData[r][s][4]; // client gridIndex
				}
				
				gs = gridSpaces[stData[r][0]]; // gridIndex
				switchTiles.push(SwitchTile_RD(world.create(SwitchTile_RD))._SwitchTile_RD(gs.x, gs.y, gs.gridIndex, clientGridIndices, stData[r][2], stData[r][3]));
			}
			
			
			// BackAndForthTile
			for (var k:uint = 0; k < sbData.length; k++)
			{
				sequenceBlocks.push(new SequenceBlock_RD(sbData[k][2], sbData[k][0]));
				epAdd(sequenceBlocks[sequenceBlocks.length - 1]);
			}
			
			
			// Orbs
			var orb:Orb;
			for (var t:uint = 0; t < orbData.length; t++)
			{
				orb = epAdd(new Orb) as Orb;
				orb.gridIndex = orbData[t][0];
				gs = gridSpaces[orb.gridIndex];
				orb.x = gs.x, orb.y = gs.y;
				orbs.push(orb);
			}
			
			
			// PushBlock
			for (var m:uint = 0; m < blueRoomIndices.length; m++) addPushBlock(Images.blueImg, roomIndices[blueRoomIndices[m]]);
			for (var p:uint = 0; p < redRoomIndices.length; p++) addPushBlock(Images.redImg, roomIndices[redRoomIndices[p]]);
			
			
			
			epAdd(new RunFunctionOnAdd(updateRoomData));
		}
		
		private function addEmptyGrid():void
		{
			var columnNum:uint = 0;
			var rowNum:uint = 0;
			
			var count:uint = 0;
			var coords:Array = RoomData.getAllSpaceCoords(Game.MAXCOLUMNCOUNT, Game.MAXROWCOUNT, Game.SPACESIZE, Game.SPACEPADDING);
			
			for (var i:uint = 0; i < gridSpaces.length; i++)
			{
				gridSpaces[i] = Game.createGameEntity(GridSpace, coords[i].x, coords[i].y);
				
				gs = gridSpaces[i];
				gs.gridIndex = i;
				gs.columnNum = columnNum;
				gs.rowNum = rowNum;
				
				children.push(gs);
				
				count++, columnNum++;
				
				if (count == Game.MAXCOLUMNCOUNT)
				{
					count = 0;
					columnNum = 0;
					rowNum++;
				}
			}
		}
		
		private function setLevelAndRoomText():void
		{
			var roomNum:uint = getRoomNum();
			
			
			var lnum:uint = ((roomNum - 1) / 10) + 1;
			var rnum:uint = ((roomNum - 1) % 10) + 1;
			
			levelAndRoomText.changeText(lnum, rnum);
			if (RoomData.isUserRoom(playlistFileName)) levelAndRoomText.changeColor();
			if (!levelAndRoomText.world) epAdd(levelAndRoomText);
		}
		
		private function getRoomNum():uint
		{
			for (var i:int = playlistFileName.length - 1; i > 0; i--)
			{
				if (playlistFileName.charAt(i) == "_")
				{
					return new uint(playlistFileName.slice(i + 1, playlistFileName.length));
				}
			}
			
			
			return 0;
		}
		// ------------------------------------------------------------------
		
		
		public function updateRoomData():void
		{
			updateRoomDimensions();
			updateSpaceIndexText();
			updateMovableBlocks();
			updateSwitchTiles();
			updateSequenceBlocks();
			updateOrbs();
			
			updateDraftData();
			
			
			if (addRoomBtn.world) addRoomBtn.activationCheck();
			if (saveChangesBtn.world) saveChangesBtn.activationCheck();
		}
		
		private function updateRoomDimensions():void
		{
			topLeft = 0;
			columnCount = 0, rowCount = 0;
			
			var bottomRight:uint = (Game.MAXCOLUMNCOUNT * Game.MAXROWCOUNT) - 1;
			
			
			if (gridIsOccupied())
			{
				var column:uint = 0;
				var row:uint = 0;
				var index:int = 0;
				var topSpaceIndex:uint = 0;
				
				
				var topLeftColumnNum:uint = 0;
				var topLeftRowNum:uint = 0;
				
				gs = gridSpaces[0];
				
				if (gs.imgNum == 99)
				{
					index = 0, topSpaceIndex = 0;
					column = getColumn(1);
					topLeftColumnNum = column;
					
					index = 0;
					row = getRow(1) / Game.MAXCOLUMNCOUNT;
					topLeftRowNum = row;
					
					topLeft = getCornerIndex();
				}
				
				
				var bottomRightColumnNum:uint = Game.MAXCOLUMNCOUNT - 1;
				var bottomRightRowNum:uint = Game.MAXROWCOUNT - 1;
				
				gs = gridSpaces[bottomRight];
				
				if (gs.imgNum == 99)
				{
					index = Game.MAXCOLUMNCOUNT - 1, topSpaceIndex = Game.MAXCOLUMNCOUNT - 1; // Start at top of last column
					column = (Game.MAXCOLUMNCOUNT - 1) - getColumn( -1);
					bottomRightColumnNum = column;
					
					index = (Game.MAXCOLUMNCOUNT * Game.MAXROWCOUNT) - 1; // Start at last GridSpace
					row = getRow( -1) / Game.MAXCOLUMNCOUNT;
					bottomRightRowNum = row;
					
					bottomRight = getCornerIndex();
				}
				
				
				columnCount = bottomRightColumnNum - topLeftColumnNum + 1;
				rowCount = bottomRightRowNum - topLeftRowNum + 1;
			}
			
			
			function getColumn(posOrNeg:int):uint
			{
				for (var j:uint = 0; j < Game.MAXCOLUMNCOUNT; j++)
				{
					for (var k:uint = 0; k < Game.MAXROWCOUNT; k++)
					{
						gs = gridSpaces[index];
						if (gs.imgNum != 99) return j;
						
						index += Game.MAXCOLUMNCOUNT;
					}
					
					topSpaceIndex += posOrNeg;
					index = topSpaceIndex;
				}
				
				
				return 99;
			}
			
			function getRow(posOrNeg:int):uint
			{
				for (var i:uint = 0; i < gridSpaces.length; i++)
				{
					gs = gridSpaces[index];
					if (gs.imgNum != 99) return index;
					
					index += posOrNeg;
				}
				
				
				return 99;
			}
			
			function getCornerIndex():uint
			{
				return (row * Game.MAXCOLUMNCOUNT) + column;
			}
			
			
			function gridIsOccupied():Boolean
			{
				for (var m:uint = 0; m < gridSpaces.length; m++)
				{
					gs = gridSpaces[m];
					if (gs.imgNum != 99) return true;
				}
				
				
				return false;
			}
		}
		
		private function updateSpaceIndexText():void
		{
			var count:uint = 0;
			var index:uint = 0;
			
			
			for (var k:uint = 0; k < Game.MAXCOLUMNCOUNT * Game.MAXROWCOUNT; k++)
			{
				gs = gridSpaces[k];
				gs.indexText.updateText( -1);
			}
			
			
			roomIndices.length = 0;
			for (var i:uint = 0; i < rowCount; i++)
			{
				index = topLeft + (Game.MAXCOLUMNCOUNT * i);
				
				for (var j:uint = 0; j < columnCount; j++)
				{
					gs = gridSpaces[index];
					gs.indexText.updateText(count);
					gs.roomIndex = count;
					
					roomIndices.push(index);
					
					index++;
					count++;
				}
			}
		}
		
		private function updateMovableBlocks():void
		{
			for each (block in pushBlocks)
			{
				for (var i:uint = 0; i < roomIndices.length; i++)
				{
					if (block.gridIndex == roomIndices[i])
					{
						block.roomIndex = i;
						i = roomIndices.length;
					}
				}
			}
		}
		
		private function updateSwitchTiles():void
		{
			for each (st in switchTiles) // Each SwitchTile
			{
				st.roomIndex = getRoomIndex(st.gridIndex);
				
				for each (sc in st.clients) // Each client of the SwitchTile
				{
					sc.roomIndex = getRoomIndex(sc.gridIndex);
					sc.hostRoomIndex = getRoomIndex(sc.hostGridIndex);
				}
			}
		}
		
		private function updateSequenceBlocks():void
		{
			for each (sb in sequenceBlocks)
			{
				sb.roomIndex = getRoomIndex(sb.gridIndex);
				
				for (var i:uint = 0; i < sb.sequenceGridIndices.length; i++)
				{
					sb.sequenceRoomIndices[i] = getRoomIndex(sb.sequenceGridIndices[i]);
				}
			}
		}
		
		private function updateOrbs():void
		{
			for each (var orb:Orb in orbs) orb.roomIndex = getRoomIndex(orb.gridIndex);
		}
		
		private function getRoomIndex(gridIndex:uint):uint
		{
			for (var i:uint = 0; i < roomIndices.length; i++)
			{
				if (gridIndex == roomIndices[i]) return i;
			}
			
			
			return 999;
		}
		// ------------------------------------------------------------------
		
		
		public function addPushBlock(img:Image, gridIndex:uint):void
		{
			gs = gridSpaces[gridIndex];
			
			pushBlocks.push(Game.createGameEntity(GamePiece, gs.x, gs.y));
			block = pushBlocks[pushBlocks.length - 1];
			
			block.layer--;
			block.graphic = img;
			block.gridIndex = gridIndex;
			children.push(block);
			
			if (gs.orb) removeOrbs([gs.gridIndex]);
		}
		
		public function removePushBlock(gridIndex:uint):void
		{
			var count:uint = pushBlocks.length;
			
			for (var i:uint = 0; i < count; i++)
			{
				block = pushBlocks[i];
				if (block.gridIndex == gridIndex)
				{
					epRemove(block);
					pushBlocks.splice(i, 1);
					i = count;
				}
			}
		}
		
		public function addOrbs(gridIndices:Array):void
		{
			var orb:Orb;
			for (var i:uint = 0; i < gridIndices.length; i++)
			{
				orb = epAdd(new Orb) as Orb;
				orb.gridIndex = gridIndices[i];
				gs = gridSpaces[orb.gridIndex];
				orb.x = gs.x, orb.y = gs.y;
				orbs.push(orb);
			}
		}
		
		public function removeOrbs(gridIndices:Array):void
		{
			var orb:Orb;
			for (var i:uint = 0; i < gridIndices.length; i++)
			{
				for each (orb in orbs)
				{
					if (orb.gridIndex == gridIndices[i]) JS.splice(orbs, epRemove(orbs[orbs.indexOf(orb)]));
				}
			}
		}
		
		public function hasPushBlock(gridIndex:uint):Boolean
		{
			for each (block in pushBlocks)
			{
				if (block.gridIndex == gridIndex) return true;
			}
			
			
			return false;
		}
		
		public function hasSequenceBlock(gridIndex:uint):Boolean
		{
			for each (var sb:SequenceBlock_RD in sequenceBlocks)
			{
				if (sb.gridIndex == gridIndex) return true;
			}
			
			
			return false;
		}
		// ------------------------------------------------------------------
		
		
		public function toggleInfo(F4:Boolean = false, F8:Boolean = false):void
		{
			// indexText, movesLeftText, outlines, bfSequenceText
			
			if (F4)
			{
				if (f4Info) f4Info = false;
				else f4Info = true;
			}
			else if (F8 && !f4Info && switchTiles.length > 0)
			{
				if (f8Info) f8Info = false;
				else f8Info = true;
			}
		}
		// ------------------------------------------------------------------
		
		
		private function moveRoom():void
		{
			switch (Input.lastKey)
			{
				case 37: // LEFT
					
					if (isRowOrColumnEmpty(0, Game.MAXCOLUMNCOUNT, Game.MAXROWCOUNT)) // Left-most column
					{
						
					}
					
					break;
					
				case 38: // UP
					
					if (isRowOrColumnEmpty(0, 1, Game.MAXCOLUMNCOUNT)) // Top row
					{
						
					}
					
					break;
					
				case 39: // RIGHT
					
					if (isRowOrColumnEmpty(Game.MAXCOLUMNCOUNT - 1, Game.MAXCOLUMNCOUNT, Game.MAXROWCOUNT)) // Right-most column
					{
						
					}
					
					break;
					
				case 40: // DOWN
					
					if (isRowOrColumnEmpty(Game.MAXCOLUMNCOUNT * (Game.MAXROWCOUNT - 1), 1, Game.MAXCOLUMNCOUNT)) // Bottom row
					{
						
					}
					
					break;
			}
			
			
			function isRowOrColumnEmpty(index:uint, diff:int, count:uint):Boolean
			{
				for (var i:uint = 0; i < count; i++)
				{
					gs = gridSpaces[index];
					if (gs.imgNum != 99) return false;
					
					index += diff;
				}
				
				
				return true;
			}
		}
		// ------------------------------------------------------------------
		
		
		public function testRoom():void
		{
			updateDraftData();
			FP.world = new RoomTesterWorld;
		}
		
		public function startNewRoom():void
		{
			RoomData.eraseRoom(RoomData.getDraftName());
			FP.world = new RoomDesignerWorld;
		}
		
		public function runOptionsMenu():void
		{
			optionsMenu = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_RD;
			
			if (!optionsMenu) world.add(new OptionsMenu_RD(this)); // No epAdd, OptionsMenu will remove itself from the world
			else optionsMenu.tweenIn();
			im.state = im.OPTIONS;
		}
		// ------------------------------------------------------------------
		
		
		public function updateDraftData():void
		{
			saveRoomData(RoomData.getDraftName(), false, true);
		}
		
		public function saveRoomData(fileName:String, isAddingRoom:Boolean = false, isDraftSave:Boolean = false):void
		{
			var imgNums:Array = new Array(roomIndices.length);
			for (var m:uint = 0; m < roomIndices.length; m++)
			{
				gs = gridSpaces[roomIndices[m]];
				imgNums[m] = gs.imgNum;
			}
			
			
			
			var blues:Array = new Array;
			var reds:Array = new Array;
			
			for each (block in pushBlocks)
			{
				if (block.graphic == Images.blueImg) blues.push(block.roomIndex);
				else reds.push(block.roomIndex);
			}
			
			
			
			var stData:Array = new Array(switchTiles.length);
			var stClientData:Array = new Array(switchTiles.length);
			
			for (var i:uint = 0; i < switchTiles.length; i++)
			{
				st = switchTiles[i];
				stData[i] = new Array(4);
				stData[i][0] = st.gridIndex, stData[i][1] = st.roomIndex;
				stData[i][2] = st.outlineIndices[0], stData[i][3] = st.outlineIndices[1];
				
				
				stClientData[i] = new Array(st.clients.length);
				for (var j:uint = 0; j < st.clients.length; j++)
				{
					sc = st.clients[j];
					
					stClientData[i][j] = new Array(Game.STC_DATA_COUNT);
					stClientData[i][j][0] = sc.x;
					stClientData[i][j][1] = sc.y;
					stClientData[i][j][2] = sc.activeNum;
					stClientData[i][j][3] = sc.inactiveNum;
					stClientData[i][j][4] = sc.gridIndex;
					stClientData[i][j][5] = sc.hostGridIndex;
					stClientData[i][j][6] = sc.roomIndex;
					stClientData[i][j][7] = sc.hostRoomIndex;
					stClientData[i][j][8] = sc.moves;
				}
			}
			
			
			var sb:SequenceBlock_RD;
			var sbData:Array = new Array(sequenceBlocks.length);
			for (var r:uint = 0; r < sequenceBlocks.length; r++)
			{
				sb = sequenceBlocks[r];
				
				sbData[r] = new Array(4);
				sbData[r][0] = sb.gridIndex;
				sbData[r][1] = sb.roomIndex;
				sbData[r][2] = sb.sequenceGridIndices;
				sbData[r][3] = sb.sequenceRoomIndices;
			}
			
			
			var orb:Orb;
			var orbData:Array = new Array(orbs.length);
			for (var s:uint = 0; s < orbs.length; s++)
			{
				orb = orbs[s];
				
				orbData[s] = new Array(2);
				orbData[s][0] = orb.gridIndex;
				orbData[s][1] = orb.roomIndex;
			}
			
			
			
			
			var names:Array = [fileName, roomName, RoomData.getUserPrefix(), playlistFileName];
			var data:Array = [columnCount, rowCount, imgNums, blues, reds, sbData, stData, stClientData, topLeft, movesQualGold, orbData];
			
			
			if (isDraftSave || !Game.developer) // user saving, draft saving
			{
				playlistFileName = RoomData.saveRoomData(names, data, isAddingRoom, isDraftSave);
			}
			else // dev only, adding xml (story mode) rooms or saving changes to them
			{
				playlistFileName = RoomData.saveRoomDataXML(names, data, xmlRoomNum, isAddingRoom);
			}
			
			
			
			if (playlistFileName != RoomData.NOTONFILE) setLevelAndRoomText();
			if (addRoomBtn.world) addRoomBtn.activationCheck();
			// Make sure there's a blank room file at the end of all the room files with topLeftGridIndex value of -1
		}
		// ------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------
		
		
		private function testing():void
		{
			test1();
		}
		
		private function test1():void
		{
			if (Input.pressed(Key.T))
			{
				trace("roomName: ", roomName);
				trace("roomNamerBtn.textStr: ", roomNamerBtn.text);
				trace("roomNamerBtn.size: ", roomNamerBtn.size);
				trace("width: ", JS.getTextWidth(roomNamerBtn.size, roomNamerBtn.text));
			}
		}
		// ------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------
	}

}