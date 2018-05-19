package worlds.room_select 
{
	import flash.utils.getQualifiedClassName;
	
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Button;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.graphics.OverlayFadeIn;
	import net.jacob_stewart.text.TextPlus;
	
	import collectables.Orb;
	import worlds.game_play.GamePlayWorld;
	import worlds.room_designer.RoomDesignerWorld;
	import worlds.room_select.unsaved_draft_warning.UnsavedDraftWarning;
	import worlds.title_screen.TitleScreenWorld;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RoomSelect extends Button 
	{
		public var im:InputManager_RS;
		public var uncompletedRoomNum:uint;
		
		private var gp:EntityGame;
		private var mp:MousePointer_RS;
		
		private var collidableStates:Array = new Array;
		
		
		private var roomNameY:Number = Game.ROOMNAME_PADY;
		
		public var roomNameOut:TextPlus = new TextPlus("Untitled1", 0, roomNameY, { size: Game.SIZE_ROOMNAME, alignCenterX: FP.halfWidth, backOffset: 2, backAlpha: .5 } );
		private var roomNameIn:TextPlus = new TextPlus("Untitled2", 0, roomNameY, { size: Game.SIZE_ROOMNAME, alignCenterX: FP.halfWidth + FP.width, backOffset: 2, backAlpha: .5 } );
		
		
		private var nextRoomArrow1Btn:ScrollRoomButton = new ScrollRoomButton(0); // Next room x1
		private var prevRoomArrow1Btn:ScrollRoomButton = new ScrollRoomButton(1); // Prev room x1
		private var nextRoomArrow10Btn:ScrollRoomButtonX10 = new ScrollRoomButtonX10(2); // Next room x10
		private var prevRoomArrow10Btn:ScrollRoomButtonX10 = new ScrollRoomButtonX10(3); // Prev room x10
		private var toGameRoomsBtn:ToGameRoomsArrow = new ToGameRoomsArrow;
		private var toMyRoomsBtn:ToMyRoomsArrow = new ToMyRoomsArrow;
		private var arrowBtns:Array = [nextRoomArrow1Btn, prevRoomArrow1Btn, nextRoomArrow10Btn, prevRoomArrow10Btn, toGameRoomsBtn, toMyRoomsBtn];
		
		private var lock:LockSymbol = new LockSymbol;
		private var editRoomBtn:EditRoomButton = new EditRoomButton(editRoom, "EDIT ROOM", 0, 0, { alignCenterX: FP.halfWidth + Game.RSBSBCO, alignCenterY: Game.BOTTOMAREAVERCEN } );
		private var deleteRoomBtn:DeleteRoomButton = new DeleteRoomButton(null, "DELETE ROOM", 0, 0, { alignCenterX: FP.halfWidth - Game.RSBSBCO, alignCenterY: Game.BOTTOMAREAVERCEN } );
		private var levelText:LevelAndRoomText = new LevelAndRoomText("Level 1");
		private var roomText:LevelAndRoomText = new LevelAndRoomText("Room 1");
		private var roomStats:RoomStats = new RoomStats;
		private var guiList:Array = [roomNameOut, roomNameIn, lock, nextRoomArrow1Btn, prevRoomArrow1Btn, nextRoomArrow10Btn, prevRoomArrow10Btn, editRoomBtn, deleteRoomBtn, levelText, roomText, toGameRoomsBtn, toMyRoomsBtn, roomStats];
		
		
		private var roomData:Array;
		private var spaceCoords:Array;
		
		public var fileNameIndex:int = 1;
		private var roomDiff:uint = 1;
		private var roomCount_Game:uint; // The number of rooms on the playlist
		private var roomCount_User:uint;
		public var roomCount:uint;
		
		
		private var roomTiles1:Array = new Array;
		private var roomTiles2:Array = new Array;
		
		
		private var screenOffSet:int = 0;
		private const SCROLLDURATION_GAMEWIDTH:Number = .5;
		private const SCROLLDURATION_GAMEHEIGHT:Number = SCROLLDURATION_GAMEWIDTH * (FP.height / FP.width);
		private var scrollDuration:Number;
		private var scrollTweenProp:String;
		
		
		// gameRoomNum stores the last game room viewed in RoomSelect
		// so if the user arrows down to view user created rooms and
		// then moves back up to game rooms, it will show the last game room viewed
		// userRoomNum works the same, just stores the last user room num viewed
		private var gameRoomNum:uint = 1;
		private var userRoomNum:uint = 1;
		public var fileNamePrefix:String = RoomData.XMLFILEPREFIX;
		
		private var upState:Boolean;
		private var downState:Boolean;
		
		
		
		public function RoomSelect() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_RoomSelect;
			mp = new MousePointer_RS(this, [JS.TYPE_Button, JS.TYPE_TextButton]);
			im = new InputManager_RS(this);
			collidableStates.push(im.STATE_MAIN);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			roomCount_Game = RoomData.roomDataClasses.length; // The number of rooms on the playlist
			
			roomCount_User = RoomData.getRoomCount(RoomData.getUserPrefix());
			roomCount = roomCount_Game;
			
			
			uncompletedRoomNum = SaveFileData.getRoomCompleteCount(SaveFileData.getSaveFileInUse());
			if (uncompletedRoomNum < roomCount_Game) uncompletedRoomNum++;
			
			
			epAddList([guiList, mp, im]);
			
			
			editRoomBtn.epCollidableAndVisible(true);
			prevRoomArrow1Btn.epCollidableAndVisible(false);
			prevRoomArrow10Btn.epCollidableAndVisible(false);
			
			
			loadRoomData();
			roomNameOut.changeText(roomData[1]);
			
			previewRoom(roomTiles1);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			gp = null;
			arrowBtns.length = 0;
			guiList.length = 0;
			roomTiles1.length = 0;
			roomTiles2.length = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			updateCollidable();
			
			// deBug2();
		}
		
		private function updateCollidable():void
		{
			collidable = false;
			if (collidableStates.indexOf(im.state) != -1) collidable = true;
		}
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		
		override public function click():void 
		{
			super.click();
			
			
			navOut(navGamePlay);
		}
		// ---------------------------------------------------------------------------------
		
		
		public function changeRoomInput():void
		{
			roomDiff = 1;
			if (Input.check(Key.SHIFT)) roomDiff = 10;
			
			
			if (Input.pressed(Keys.RIGHT) && fileNameIndex < roomCount)
			{
				if (fileNamePrefix == RoomData.XMLFILEPREFIX && fileNameIndex < uncompletedRoomNum) changeRoom(roomDiff);
				else if (fileNamePrefix == RoomData.getUserPrefix()) changeRoom(roomDiff);
			}
			else if (Input.pressed(Keys.LEFT) && fileNameIndex > 1) changeRoom( -roomDiff);
			else if (Input.pressed(Keys.UP)) navGameRooms();
			else if (Input.pressed(Keys.DOWN)) navUserRooms();
		}
		
		public function navGameRooms():void
		{
			if (fileNamePrefix == RoomData.getUserPrefix())
			{
				fileNamePrefix = RoomData.XMLFILEPREFIX;
				roomCount = roomCount_Game;
				
				
				upState = false, downState = false;
				setUpAndDownGUIState();
				upState = false, downState = true;
				FP.alarm(scrollDuration, setUpAndDownGUIState);
				
				toGameRoomsBtn.epCollidableAndVisible(false);
				editRoomBtn.epCollidableAndVisible(false);
				
				
				roomNameY = Game.ROOMNAME_PADY;
				changeRoom(0);
			}
		}
		
		public function navUserRooms():void
		{
			if (fileNamePrefix == RoomData.XMLFILEPREFIX && roomCount_User > 0)
			{
				fileNamePrefix = RoomData.getUserPrefix();
				roomCount = roomCount_User;
				
				
				upState = false, downState = false;
				setUpAndDownGUIState();
				upState = true, downState = false;
				FP.alarm(scrollDuration, setUpAndDownGUIState);
				
				toMyRoomsBtn.epCollidableAndVisible(false);
				
				
				roomNameY = FP.height - Game.ROOMNAME_PADY - JS.getTextHeight(Game.SIZE_ROOMNAME);
				changeRoom(0);
				FP.alarm(scrollDuration, activateEditRoomBtn);
			}
		}
		
		private function setUpAndDownGUIState():void
		{
			toGameRoomsBtn.epCollidableAndVisible(upState);
			toMyRoomsBtn.epCollidableAndVisible(downState);
		}
		// ---------------------------------------------------------------------------------
		
		
		public function changeRoom(roomDiff:int):void
		{
			Sounds.tick3();
			
			collidable = false, im.active = false, im.state = im.SCROLLING;
			for each (var button:Button in arrowBtns) button.collidable = false;
			
			if (roomDiff == 0) scrollTweenProp = "y", scrollDuration = SCROLLDURATION_GAMEHEIGHT;
			else scrollTweenProp = "x", scrollDuration = SCROLLDURATION_GAMEWIDTH;
			
			setFileNameIndex(roomDiff);
			screenOffSet = getScreenOffset(roomDiff);
			
			changeLevelAndRoomNumText();
			
			loadRoomData();
			setNextRoomName();
			
			
			previewRoom(roomTiles2);
			screenOffSet *= -1;
			setScrollRooms();
		}
		
		private function setFileNameIndex(roomDiff:int):void
		{
			if (scrollTweenProp == "y") // Scrolling UP or DOWN
			{
				if (fileNamePrefix == RoomData.XMLFILEPREFIX) fileNameIndex = gameRoomNum; // UP
				else if (fileNamePrefix == RoomData.getUserPrefix()) fileNameIndex = userRoomNum; // DOWN
			}
			else if (scrollTweenProp == "x") // Scrolling LEFT or RIGHT
			{
				fileNameIndex += roomDiff;
				if (fileNameIndex <= 0) fileNameIndex = 1;
				else if (fileNamePrefix == RoomData.XMLFILEPREFIX && fileNameIndex > uncompletedRoomNum) fileNameIndex = uncompletedRoomNum;
				else if (fileNameIndex > roomCount) fileNameIndex = roomCount;
				
				if (fileNamePrefix == RoomData.XMLFILEPREFIX) gameRoomNum = fileNameIndex;
				else if (fileNamePrefix == RoomData.getUserPrefix()) userRoomNum = fileNameIndex;
			}
		}
		
		private function getScreenOffset(roomDiff:int):int
		{
			var posOrNeg:int = -1;
			
			if (roomDiff == 0) // scroll up or down
			{
				if (fileNamePrefix == RoomData.getUserPrefix()) posOrNeg = 1; // DOWN key
				return FP.height * posOrNeg;
			}
			else // scroll left or right
			{
				if (roomDiff > 0) posOrNeg = 1; // RIGHT key
				return FP.width * posOrNeg;
			}
			
			
			return 0;
		}
		
		private function changeLevelAndRoomNumText():void
		{
			var levelNum:uint = ((fileNameIndex - 1) / 10) + 1;
			var roomNum:uint = ((fileNameIndex - 1) % 10) + 1;
			
			levelText.changeText("Level " + levelNum.toString());
			roomText.changeText("Room " + roomNum.toString());
		}
		
		private function setNextRoomName():void
		{
			roomNameIn.changeText(roomData[1]);
			roomNameIn.centerHor(roomNameIn.textWidth, FP.halfWidth), roomNameIn.setXY(roomNameIn.x, roomNameY);
			
			if (scrollTweenProp == "x") roomNameIn.setXY(roomNameIn.x + screenOffSet, roomNameIn.y);
			else if (scrollTweenProp == "y") roomNameIn.setXY(roomNameIn.x, roomNameIn.y + screenOffSet);
		}
		// ---------------------------------------------------------------------------------
		
		
		private function loadRoomData():void
		{
			if (fileNamePrefix == RoomData.getUserPrefix()) roomData = RoomData.loadRoomData(fileNamePrefix + fileNameIndex.toString());
			else roomData = RoomData.loadRoomDataXML(fileNameIndex - 1);
		}
		
		
		
		private function previewRoom(roomTiles:Array):void
		{
			var scWalls:Array = new Array;
			
			// return [playlistFileName, roomName, COLUMN_COUNT, ROW_COUNT, imgNums, blues, reds, bfData, stData, stClientData, orbData, TOPLEFT_GRIDINDEX, MOVESQUALGOLD];
			var columnCount:uint = roomData[2];
			var rowCount:uint = roomData[3];
			var imgNums:Array = roomData[4];
			var blues:Array = roomData[5];
			var reds:Array = roomData[6];
			var sbData:Array = roomData[7];
			// var stData:Array = roomData[8];
			var stClientData:Array = roomData[9];
			var orbData:Array = roomData[10];
			
			
			
			roomTiles.length = columnCount * rowCount;
			spaceCoords = RoomData.getAllSpaceCoords(columnCount, rowCount, Game.SPACESIZE, Game.SPACEPADDING);
			
			
			
			for (var i:uint = 0; i < roomTiles.length; i++)
			{
				roomTiles[i] = world.create(EntityGame);
				gp = roomTiles[i];
				gp.graphic = Images.imgs[imgNums[i]];
				
				
				if (imgNums[i] == Game.ID_GOAL) gp.graphic = Images.goalWideImg;
				else if (isHole(imgNums[i])) gp.graphic = Images.blankTileImg;
				
				
				setCoords(gp, i);
			}
			
			
			setPushBlocks(blues, Game.ID_BLUEBLOCK);
			setPushBlocks(reds, Game.ID_REDBLOCK);
			setSequenceBlocks();
			setSwitchClients();
			setOrbs();
			
			
			// Set HitBox to size of room
			var roomWidth:uint = ((Game.SPACESIZE + Game.SPACEPADDING) * columnCount) - Game.SPACEPADDING;
			var roomHeight:uint = ((Game.SPACESIZE + Game.SPACEPADDING) * rowCount) - Game.SPACEPADDING;
			epSetHitbox(roomWidth, roomHeight, -spaceCoords[0].x, -spaceCoords[0].y);
			
			
			
			
			// LOCAL FUNCTIONS -----------------------------------------------------
			function setCoords(gp:EntityGame, spaceIndex:uint):void
			{
				var image:Image = gp.graphic as Image;
				gp.centerOnPoint(image.width, image.height, spaceCoords[spaceIndex].x + Game.HALFSPACESIZE, spaceCoords[spaceIndex].y + Game.HALFSPACESIZE);
				if (scrollTweenProp == "x") gp.x += screenOffSet;
				else if (scrollTweenProp == "y") gp.y += screenOffSet;
			}
			
			function isHole(imgNum:uint):Boolean
			{
				if (imgNum == Game.ID_HOLE || imgNum == 99) return true;
				return false;
			}
			
			function setPushBlocks(spaceNums:Array, imageIndex:uint):void
			{
				for (var s:uint = 0; s < spaceNums.length; s++) // Each Block
				{
					gp = roomTiles[spaceNums[s]] as EntityGame;
					gp.graphic = Images.imgs[imageIndex];
				}
			}
			
			function setSequenceBlocks():void
			{
				for (var r:uint = 0; r < sbData.length; r++) // Each SequenceBlock
				{
					gp = roomTiles[sbData[r][1]] as EntityGame;
					gp.graphic = Images.sequenceBlockImg;
				}
				
				
				// sbData[r][0] = sb.gridIndex;
				// sbData[r][1] = sb.roomIndex;
				// sbData[r][2] = sb.sequenceGridIndices;
				// sbData[r][3] = sb.sequenceRoomIndices;
			}
			
			function setSwitchClients():void
			{
				var blockRoomIndices:Array = allBlockRoomIndices();
				for (var k:uint = 0; k < stClientData.length; k++) // Each SwitchTile
				{
					for (var m:uint = 0; m < stClientData[k].length; m++) // Each Client
					{
						gp = roomTiles[stClientData[k][m][6]]; // client roomIndex
						
						if (blockRoomIndices.indexOf(stClientData[k][m][7]) != -1) // If the host SwitchTile has a Block on it
						{
							gp.graphic = Images.imgs[stClientData[k][m][2]]; // client activeNum
							if (isHole(stClientData[k][m][2])) gp.graphic = Images.blankTileImg;
						}
						else
						{
							gp.graphic = Images.imgs[stClientData[k][m][3]]; // client inactiveNum
							if (isHole(stClientData[k][m][3])) gp.graphic = Images.blankTileImg;
						}
						
						if (gp.graphic == Images.imgs[Game.ID_WALL]) scWalls.push(stClientData[k][m][6]);
						
						
						// stClientData[i][j][0] = sc.x;
						// stClientData[i][j][1] = sc.y;
						// stClientData[i][j][2] = sc.activeNum;
						// stClientData[i][j][3] = sc.inactiveNum;
						// stClientData[i][j][4] = sc.gridIndex;
						// stClientData[i][j][5] = sc.hostGridIndex;
						// stClientData[i][j][6] = sc.roomIndex;
						// stClientData[i][j][7] = sc.hostRoomIndex;
						// stClientData[i][j][8] = sc.moves;
					}
				}
				
				
				function allBlockRoomIndices():Array
				{
					var indices:Array = blues.concat(reds);
					for (var u:uint = 0; u < sbData.length; u++) indices.push(sbData[u][1]);
					return indices;
				}
			}
			
			function setOrbs():void
			{
				for (var t:uint = 0; t < orbData.length; t++)
				{
					if (scWalls.indexOf(orbData[t][1]) == -1) // If orb is not covered by SwitchClient as wall tile
					{
						gp = world.create(Orb) as Orb;
						roomTiles.push(gp);
						gp.graphic = Images.glowOrb1a;
						setCoords(gp, orbData[t][1]);
					}
				}
				
				// orbData[t][0] = orb.gridIndex;
				// orbData[t][1] = orb.roomIndex;
			}
		}
		// ---------------------------------------------------------------------------------
		
		
		private function setScrollRooms():void
		{
			FP.tween(roomNameOut, { x: toCoord("x", roomNameOut.x), y: toCoord("y", roomNameOut.y) }, scrollDuration, { tweener: roomNameOut } );
			FP.tween(roomNameIn, { x: toCoord("x", roomNameIn.x), y: toCoord("y", roomNameIn.y) }, scrollDuration, { tweener: roomNameIn } );
			
			var onComplete:Function;
			var allRoomTiles:Array = roomTiles1.concat(roomTiles2);
			for (var i:uint = 0; i < allRoomTiles.length; i++)
			{
				if (i == allRoomTiles.length - 1) onComplete = onScrollFinish;
				FP.tween(allRoomTiles[i], { x: toCoord("x", allRoomTiles[i].x), y: toCoord("y", allRoomTiles[i].y) }, scrollDuration, { complete: onComplete, tweener: allRoomTiles[i] } );
			}
			
			
			function toCoord(axis:String, baseCoord:Number):Number
			{
				if (scrollTweenProp == axis) return baseCoord + screenOffSet;
				return baseCoord;
			}
		}
		
		private function onScrollFinish():void
		{
			roomNameOut.epVisible(true);
			for each (var gp1:EntityGame in roomTiles1) gp1.epVisible(true);
			
			roomNameOut.changeText(roomNameIn.text);
			roomNameOut.setXY(roomNameOut.x, roomNameY); // If scroll up and down
			roomNameOut.centerHor(roomNameOut.textWidth);
			roomNameIn.centerHor(roomNameIn.textWidth, FP.halfWidth + FP.width);
			roomStats.changeStats();
			
			
			for (var i:uint = 0; i < roomTiles1.length; i++) world.recycle(roomTiles1[i]);
			
			roomTiles1.length = 0;
			for each (var gp:EntityGame in roomTiles2) roomTiles1.push(gp);
			
			
			for each (var button:Button in arrowBtns) button.epCollidableAndVisible(true);
			if (fileNamePrefix == RoomData.XMLFILEPREFIX) toGameRoomsBtn.epCollidableAndVisible(false);
			else if (fileNamePrefix == RoomData.getUserPrefix()) toMyRoomsBtn.epCollidableAndVisible(false);
			if (fileNameIndex == roomCount) nextRoomArrow1Btn.epCollidableAndVisible(false), nextRoomArrow10Btn.epCollidableAndVisible(false);
			else if (fileNameIndex == 1) prevRoomArrow1Btn.epCollidableAndVisible(false), prevRoomArrow10Btn.epCollidableAndVisible(false);
			
			collidable = true, im.active = true, im.state = im.STATE_MAIN;
		}
		// ---------------------------------------------------------------------------------
		
		
		public function deleteRoom():void
		{
			collidable = false, im.active = false;
			for each (var button:Button in arrowBtns) button.collidable = false;
			
			roomNameOut.epVisible(false);
			for each (var gp:EntityGame in roomTiles1) gp.epVisible(false);
			
			
			
			roomCount_Game = RoomData.getRoomCount(RoomData.XMLFILEPREFIX); // The number of rooms on the playlist
			roomCount_User = RoomData.getRoomCount(RoomData.getUserPrefix());
			
			if (fileNamePrefix == RoomData.XMLFILEPREFIX && roomCount > roomCount_Game) roomCount = roomCount_Game;
			else if (fileNamePrefix == RoomData.getUserPrefix() && roomCount > roomCount_User) roomCount = roomCount_User;
			if (fileNameIndex > roomCount) fileNameIndex = roomCount;
			
			
			
			if (roomCount > 0)
			{
				scrollTweenProp = "x";
				scrollDuration = SCROLLDURATION_GAMEWIDTH;
				
				screenOffSet = FP.width
				if (fileNameIndex > roomCount) screenOffSet = -FP.width;
				
				loadRoomData();
				setNextRoomName();
				previewRoom(roomTiles2);
				
				screenOffSet *= -1;
				setScrollRooms();
			}
			else if (roomCount_User == 0 && fileNamePrefix == RoomData.getUserPrefix()) // All user rooms have been deleted. Scroll up to Story Mode Rooms
			{
				fileNamePrefix = RoomData.XMLFILEPREFIX;
				roomCount = roomCount_Game;
				
				
				upState = false, downState = false;
				setUpAndDownGUIState();
				upState = false, downState = true;
				FP.alarm(scrollDuration, setUpAndDownGUIState);
				
				toGameRoomsBtn.epCollidableAndVisible(false);
				editRoomBtn.epCollidableAndVisible(false);
				
				
				roomNameY = Game.ROOMNAME_PADY;
				changeRoom(0);
			}
		}
		// ---------------------------------------------------------------------------------
		
		
		public function navOut(navFunction:Function):void
		{
			collidable = false, im.active = false;
			for each (var button:Button in arrowBtns) button.collidable = false;
			
			if (navFunction == navTitleScreen) Sounds.knock1();
			else Sounds.select1();
			
			epAdd(new OverlayFadeIn(Game.OVERLAYDURATION, navFunction, Game.SCREENCOLOR));
		}
		
		public function navGamePlay():void
		{
			if (toMyRoomsBtn.visible) fileNamePrefix = RoomData.XMLFILEPREFIX;
			else fileNamePrefix = RoomData.getUserPrefix();
			
			
			FP.world = new GamePlayWorld(fileNameIndex, fileNamePrefix);
		}
		
		private function editRoom():void
		{
			if (draftUnsaved()) world.add(new UnsavedDraftWarning(this));
			else navOut(navRoomDesigner);
			
			
			function draftUnsaved():Boolean
			{
				if (!RoomData.draftIsEmpty()) // Loads 'Data.load(RoomData.getDraftName())'
				{
					var playlistFileName:String = Data.readString("playlistFileName");
					
					if (playlistFileName == RoomData.NOTONFILE) return true;
					else
					{
						var xmlFileIndex:int = new int(playlistFileName.slice(RoomData.XMLFILEPREFIX.length, playlistFileName.length));
						xmlFileIndex--;
						
						if (xmlFileIndex > -1)
						{
							if (RoomData.draftIsDifferent(playlistFileName, true, xmlFileIndex)) return true;
						}
						else
						{
							if (RoomData.draftIsDifferent(playlistFileName)) return true;
						}
					}
				}
				
				
				return false;
			}
		}
		
		public function navRoomDesigner():void
		{
			if (fileNamePrefix == RoomData.getUserPrefix()) FP.world = new RoomDesignerWorld(fileNamePrefix + fileNameIndex.toString());
			else FP.world = new RoomDesignerWorld("xml", fileNameIndex);
		}
		
		private function activateEditRoomBtn():void
		{
			editRoomBtn.epCollidableAndVisible(true);
		}
		
		public function navTitleScreen():void
		{
			FP.world = new TitleScreenWorld(true);
		}
		// ---------------------------------------------------------------------------------
		
		
		private function deBug1():void
		{
			trace("deBug1");
			deBug3();
			// trace("tweenCheck.percent: ", tweenCheck.percent);
			trace("");
		}
		
		private function deBug2():void
		{
			// if (Input.pressed(Key.T)) debugBol1 = true;
		}
		
		private function deBug3():void
		{
			trace("roomNameIn xCenter: ", roomNameIn.x + roomNameIn.textHalfWidth);
			trace("roomNameIn.front xCenter: ", roomNameIn.front.x + (roomNameIn .front.textWidth * .5));
			// trace("roomNameOut xCenter: ", roomNameOut.x + roomNameOut.textHalfWidth);
			// trace("roomNameOut.front xCenter: ", roomNameOut.front.x + (roomNameOut.front.textWidth * .5));
		}
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
	}

}