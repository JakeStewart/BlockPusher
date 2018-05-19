package worlds.room_select 
{
	import net.flashpunk.utils.Data;
	
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class DeleteRoomButton extends TextButton 
	{
		private var rs:RoomSelect;
		private const ALPHA_OFFSETLOW:Number = .7;
		private var alphaOffset:Number = 1;
		private var userPrefix:String = RoomData.getUserPrefix();
		
		
		
		public function DeleteRoomButton(onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeBackOffset(2);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rs = world.getInstance(Game.NAME_RoomSelect) as RoomSelect;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			rs = null;
		}
		// ---------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateCollidable();
			updateVisible();
			updateAlphaOffset();
			
			
			super.update();
		}
		
		private function updateCollidable():void
		{
			epCollidable(false);
			if (rs.fileNamePrefix + rs.fileNameIndex.toString() != RoomData.XMLFILEPREFIX + "1") // Don't delete the first Story Mode Room
			{
				if (rs.im.state == rs.im.STATE_MAIN && rs.fileNamePrefix == userPrefix) epCollidable(true);
			}
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (rs.fileNamePrefix == userPrefix) epVisible(true);
		}
		
		private function updateAlphaOffset():void
		{
			alphaOffset = 1;
			if (rs.im.state != rs.im.STATE_MAIN || rs.fileNamePrefix + rs.fileNameIndex.toString() == RoomData.XMLFILEPREFIX + "1") alphaOffset = ALPHA_OFFSETLOW;
		}
		// ---------------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		
		override public function click():void 
		{
			super.click();
			
			
			deleteRoom();
		}
		
		override public function changeState(state:int=-1):void 
		{
			changeAlpha(getStateAlpha() * alphaOffset, (getStateAlpha() * backAlpha) * alphaOffset);
		}
		// ---------------------------------------------------------------------------------
		
		
		private function deleteRoom():void
		{
			// FIRST TEST ON USER CREATIONS!
			
			Data.load(RoomData.getDraftName());
			var draftPlaylistFileName:String = Data.readString("playlistFileName");
			if (draftPlaylistFileName == rs.fileNamePrefix + rs.fileNameIndex.toString())
			{
				Data.writeString("playlistFileName", RoomData.NOTONFILE);
				Data.save(draftPlaylistFileName);
			}
			
			var fileNamePrefix:String = rs.fileNamePrefix;
			var roomCount:uint = RoomData.getRoomCount(fileNamePrefix);
			
			
			
			if (rs.fileNameIndex == roomCount) // Last room
			{
				RoomData.eraseRoom(fileNamePrefix + rs.fileNameIndex.toString());
			}
			else // Not Last room
			{
				for (var i:uint = rs.fileNameIndex; i < roomCount; i++)
				{
					// return [playlistFileName, roomName, COLUMN_COUNT, ROW_COUNT, imgNums, blues, reds, bfData, stData, stClientData, orbData, TOPLEFT_GRIDINDEX, MOVESQUALGOLD];
					var nextRoomData:Array = RoomData.loadRoomData(fileNamePrefix + (i + 1).toString());
					
					
					// var names:Array = [fileName, roomName, RoomData.getUserPrefix(), playlistFileName];
					// var data:Array = [columnCount, rowCount, imgNums, blues, reds, bfData, stData, stClientData, topLeft, movesQualGold, orbData];
					var names:Array = [fileNamePrefix + i.toString(), nextRoomData[1], fileNamePrefix, fileNamePrefix + i.toString()];
					var data:Array = [nextRoomData[2], nextRoomData[3], nextRoomData[4], nextRoomData[5], nextRoomData[6], nextRoomData[7], nextRoomData[8], nextRoomData[9], nextRoomData[10], nextRoomData[11], nextRoomData[12]];
					
					RoomData.saveRoomData(names, data, false);
					
					
					if (i == roomCount - 1) RoomData.eraseRoom(fileNamePrefix + roomCount.toString()); // Last room
				}
			}
			
			
			
			rs.deleteRoom();
		}
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
	}

}