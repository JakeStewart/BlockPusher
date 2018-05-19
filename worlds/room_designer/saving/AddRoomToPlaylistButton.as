package worlds.room_designer.saving 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.text.TextPlus;
	
	import worlds.room_designer.TextButton_RD;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class AddRoomToPlaylistButton extends TextButton_RD 
	{
		public var notYetAddedStr:String = "Not yet added!";
		public var hasBeenAddedStr:String = "Added to playlist!";
		public var statusText:TextPlus;
		
		private const NOTYETALPHA:Number = .5;
		public const HASBEENHALPHA:Number = .6;
		
		
		
		public function AddRoomToPlaylistButton(onClick:Function=null, text:String="ADD ROOM", x:Number=0, y:Number=544, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeSize(20);
			centerHor(textWidth);
			statusText = new TextPlus(notYetAddedStr, 0, y + 24, { alignCenterX: FP.halfWidth, frontAlpha: NOTYETALPHA, includeBack: false } );
		}
		
		override public function added():void 
		{
			super.added();
			
			
			activationCheck();
			visibleStates.push(rd.im.HUB, rd.im.OPTIONS);
			if (rd.playlistFileName != RoomData.NOTONFILE) statusText.changeText(hasBeenAddedStr), statusText.changeAlpha(HASBEENHALPHA);
			epAdd(statusText);
		}
		// --------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (visibleStates.indexOf(rd.im.state) != -1) epVisible(true);
		}
		// --------------------------------------------------------------------------------------
		
		
		override public function click():void 
		{
			deactivate();
			world.add(new AddRoomToPlaylist);
		}
		
		override public function activationCheck():void 
		{
			super.activationCheck(); // Calls deactivate();
			
			
			if (rd.saveQualifier.isPlayableRoom())
			{
				if (rd.playlistFileName == RoomData.NOTONFILE) activate();
				else
				{
					if (RoomData.isXMLRoom(rd.playlistFileName))
					{
						var roomNum:uint = new uint(rd.playlistFileName.slice(RoomData.XMLFILEPREFIX.length, rd.playlistFileName.length));
						if (roomNum <= RoomData.roomDataClasses.length)
						{
							if (RoomData.draftIsDifferent(rd.playlistFileName, true, roomNum - 1)) activate();
						}
					}
					else if (RoomData.draftIsDifferent(rd.playlistFileName)) activate();
				}
			}
		}
		// --------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------
		
	}

}