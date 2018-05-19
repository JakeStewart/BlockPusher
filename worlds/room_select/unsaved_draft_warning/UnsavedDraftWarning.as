package worlds.room_select.unsaved_draft_warning 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.text.TextPlus;
	
	import worlds.room_select.RoomSelect;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class UnsavedDraftWarning extends EntityGame 
	{
		private var rs:RoomSelect;
		private var unsavedDraftWarningBtn:UnsavedDraftWarningButton;
		
		private static const BASELAYER:int = -7;
		public static const TEXTLAYER:int = BASELAYER - 1;
		
		private const ALPHA_SCREENTINT:Number = .7;
		private const DURATION_SCREENTINT:Number = .2;
		private var screenTint:ScreenTint = new ScreenTint(BASELAYER, 0);
		
		private const TEXT_MAXWIDTH:uint = Math.round(FP.width * .65);
		private const STR_ADDROOM:String = "Add design to playlist before starting a new one?";
		private const STR_SAVECHANGES:String = "Save changes to your design before starting a new one?";
		private const STR_REQUIREMENTS:String = "A design requires at least one blue or red block AND at least one goal tile before it can be saved.";
		private var warning1:TextPlus = new TextPlus(STR_SAVECHANGES, 0, 240, { size: 18, alignCenterX: FP.halfWidth, backOffset: 2 }, TEXTLAYER);
		private var warning2:TextPlus = new TextPlus(STR_REQUIREMENTS, 0, 420, { size: 18, alignCenterX: FP.halfWidth, backOffset: 2 }, TEXTLAYER);
		
		private const BTNSPACING:uint = 120;
		private const LEADING:uint = 50;
		private const BTNY:Number = Math.round(warning1.y + warning1.textHeight + LEADING);
		private var yesBtn:UnsavedDraftWarningButton = new UnsavedDraftWarningButton(0, save, "Yes", 0, BTNY, { alignCenterX: FP.halfWidth - BTNSPACING } );
		private var noBtn:UnsavedDraftWarningButton = new UnsavedDraftWarningButton(1, editRoom, "No", 0, BTNY, { alignCenterX: FP.halfWidth } );
		private var cancelBtn:UnsavedDraftWarningButton = new UnsavedDraftWarningButton(2, cancelEditRoom, "Cancel", 0, BTNY, { alignCenterX: FP.halfWidth + BTNSPACING } );
		private var btns:Array = [yesBtn, noBtn, cancelBtn];
		public var btnsIndex:uint = 0;
		public var mouseIndex:int = -1;
		
		private var guiList:Array = [warning1, btns];
		
		private var playlistFileName:String;
		private var draftRoomName:String;
		
		
		
		public function UnsavedDraftWarning(rs:RoomSelect) 
		{
			this.rs = rs;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_UnsavedDraftWarning;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rs.im.state = rs.im.STATE_UDW;
			if (!askSave()) rs.navRoomDesigner();
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			unsavedDraftWarningBtn = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			updateMouseIndex();
		}
		// --------------------------------------------------------------------------------------
		
		
		private function askSave():Boolean
		{
			Data.load(RoomData.getDraftName());
			playlistFileName = Data.readString("playlistFileName");
			draftRoomName = Data.readString("roomName");
			
			// If the design began from a room on the playlist
			if (playlistFileName != RoomData.NOTONFILE)
			{
				var xmlFileIndex:int = new int(playlistFileName.slice(RoomData.XMLFILEPREFIX.length, playlistFileName.length));
				xmlFileIndex--;
				
				if (xmlFileIndex > -1)
				{
					if (!RoomData.draftIsDifferent(playlistFileName, true, xmlFileIndex)) return false;
				}
				// If the design is NOT different from the playlist room it started from
				else if (!RoomData.draftIsDifferent(playlistFileName) && draftRoomName == rs.roomNameOut.text) return false;
			}
			
			warningSetup();
			epAdd(screenTint);
			screenTint.tween = FP.tween(screenTint.image, { alpha: ALPHA_SCREENTINT }, DURATION_SCREENTINT, { tweener: screenTint } );
			epAddList(guiList);
			
			
			return true;
		}
		
		private function warningSetup():void
		{
			if (playlistFileName == RoomData.NOTONFILE) warning1.changeText(STR_ADDROOM);
		}
		// --------------------------------------------------------------------------------------
		
		
		public function keyPressed():void
		{
			if (Input.pressed(Keys.SELECT))
			{
				if (btnsIndex == 0) save();
				else if (btnsIndex == 1) editRoom();
				else if (btnsIndex == 2) cancelEditRoom();
			}
			else if (Input.pressed(Keys.CANCEL))
			{
				cancelEditRoom();
			}
			else if (Input.pressed(Keys.HOR))
			{
				if (Input.pressed(Keys.LEFT) && btnsIndex > 0) btnsIndex--;
				else if (Input.pressed(Keys.RIGHT) && btnsIndex < 2) btnsIndex++;
			}
		}
		
		private function updateMouseIndex():void
		{
			unsavedDraftWarningBtn = collide(JS.TYPE_TextButton, world.mouseX, world.mouseY) as UnsavedDraftWarningButton;
			
			if (unsavedDraftWarningBtn) // while mouse is colliding with one of the btns
			{
				if (mouseIndex == -1)
				{
					// This will only happen once during collision and will not happen 
					// again until the mouse stops colliding and then collides again
					btnsIndex = unsavedDraftWarningBtn.btnsIndex;
					mouseIndex = unsavedDraftWarningBtn.btnsIndex;
				}
			}
			else mouseIndex = -1; // while mouse is NOT colliding with a unsavedDraftWarningBtn
		}
		// --------------------------------------------------------------------------------------
		
		
		private function deactivate(onComplete:Function):void
		{
			rs.im.state = -1;
			screenTint.tween.cancel();
			screenTint.tween = FP.tween(screenTint.image, { alpha: 0 }, DURATION_SCREENTINT, { complete: onComplete, tweener: screenTint } );
			epRemoveList(guiList);
		}
		
		private function editRoom():void
		{
			deactivate(rs.navRoomDesigner);
		}
		
		private function cancelEditRoom():void
		{
			deactivate(removeThis);
		}
		
		private function save():void
		{
			if (isPlayableRoom())
			{
				// save
				if (warning1.text == STR_ADDROOM) saveData(true); // Add room to playlist
				else if (warning1.text == STR_SAVECHANGES) saveData(false); // Save changes to playlist room
				
				deactivate(rs.navRoomDesigner);
			}
			else if (!warning2.world)
			{
				guiList.push(warning2);
				epAdd(warning2);
				
				if (warning2.front.width > TEXT_MAXWIDTH)
				{
					warning2.front.wordWrap = true, warning2.front.width = TEXT_MAXWIDTH;
					if (warning2.back) warning2.back.wordWrap = true, warning2.back.width = TEXT_MAXWIDTH;
					warning2.centerHor(TEXT_MAXWIDTH);
					warning2.front.align = "center";
					if (warning2.back) warning2.back.align = "center";
				}
			}
			
			
			function isPlayableRoom():Boolean
			{
				Data.load(RoomData.getDraftName());
				
				if (
				(Data.readUint("blueCount") > 0 || Data.readUint("redCount") > 0) 
				&& hasGoal() 
				) return true;
				
				
				return false;
			}
			
			function hasGoal():Boolean
			{
				for (var i:uint = 0; i < Data.readUint("roomWidth") * Data.readUint("roomHeight"); i++)
				{
					if (Data.readUint("imgNum" + (i + 1).toString()) == 2) return true;
				}
				
				return false;
			}
		}
		
		private function saveData(addingRoom:Boolean):void
		{
			var fileName:String = RoomData.getDraftName();
			var filePrefix:String = RoomData.getUserPrefix();
			
			var data:Array = RoomData.loadRoomData(fileName);
			
			// return [playlistFileName, roomName, COLUMN_COUNT, ROW_COUNT, imgNums, blues, reds, bfData, stData, stClientData, orbData, TOPLEFT_GRIDINDEX, MOVESQUALGOLD];
			playlistFileName = data[0];
			var roomName:String = data[1];
			const COLUMN_COUNT:uint = data[2];
			const ROW_COUNT:uint = data[3];
			var imgNums:Array = data[4];
			var blueRoomIndices:Array = data[5];
			var redRoomIndices:Array = data[6];
			var sbData:Array = data[7];
			var stData:Array = data[8];
			var stClientData:Array = data[9];
			var orbData:Array = data[10];
			var topLeft:uint = data[11];
			var movesQualGold:uint = data[12];
			
			if (playlistFileName != RoomData.NOTONFILE) fileName = playlistFileName;
			
			
			var names:Array = [fileName, roomName, filePrefix, playlistFileName];
			var data2:Array = [COLUMN_COUNT, ROW_COUNT, imgNums, blueRoomIndices, redRoomIndices, sbData, stData, stClientData, topLeft, movesQualGold, orbData];
			
			if (Game.developer && (playlistFileName == RoomData.NOTONFILE || RoomData.isXMLRoom(playlistFileName)))
			{
				var xmlRoomNum:int;
				if (RoomData.isXMLRoom(playlistFileName)) xmlRoomNum = new int(playlistFileName.slice(RoomData.XMLFILEPREFIX.length, playlistFileName.length));
				playlistFileName = RoomData.saveRoomDataXML(names, data2, xmlRoomNum, addingRoom);
			}
			else
			{
				playlistFileName = RoomData.saveRoomData(names, data2, addingRoom);
			}
		}
		// --------------------------------------------------------------------------------------
		
		
		override public function removeThis():Entity 
		{
			rs.im.state = rs.im.STATE_MAIN;
			
			
			return super.removeThis();
		}
		// --------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------
		
	}

}