package worlds.room_designer.saving 
{
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.TextButton_RD;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SaveChangesButton extends TextButton_RD 
	{
		
		public function SaveChangesButton(onClick:Function=null, text:String="SAVE CHANGES", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			centerHor(textWidth, Game.TEXTCENXR);
			centerVer(textHeight, Game.BOTTOMAREAVERCEN);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			visibleStates.push(rd.im.HUB, rd.im.OPTIONS);
			activationCheck();
		}
		// ------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateVisible();
			
			
			super.update();
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (visibleStates.indexOf(rd.im.state) != -1)
			{
				// If it's activated
				if (collidable) epVisible(true);
			}
		}
		// ------------------------------------------------------------------------------
		
		
		override public function click():void
		{
			deactivate();
			saveRoomData();
		}
		
		override public function activate():void 
		{
			super.activate();
			
			
			hoverAlpha = 1;
		}
		
		override public function deactivate():void 
		{
			super.deactivate();
			
			
			hoverAlpha = .3; // tp.text.alpha will stick at 1 after SaveButton is clicked because mouse is over it
		}
		
		
		override public function activationCheck():void 
		{
			super.activationCheck(); // Calls deactivate()
			
			
			if (rd.playlistFileName != RoomData.NOTONFILE && rd.saveQualifier.isPlayableRoom()) // Needs to qualify as playable room
			{
				var xmlFileIndex:int = new int(rd.playlistFileName.slice(RoomData.XMLFILEPREFIX.length, rd.playlistFileName.length));
				xmlFileIndex--;
				
				if (xmlFileIndex > -1 && Game.developer)
				{
					if (RoomData.draftIsDifferent(rd.playlistFileName, true, xmlFileIndex) || rd.saveQualifier.isDifferentRoomName()) activate();
				}
				else if (RoomData.draftIsDifferent(rd.playlistFileName) || rd.saveQualifier.isDifferentRoomName()) activate();
			}
		}
		
		private function saveRoomData():void
		{
			rd.saveRoomData(rd.playlistFileName);
			deactivate();
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}