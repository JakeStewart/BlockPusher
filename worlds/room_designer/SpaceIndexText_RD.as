package worlds.room_designer 
{
	import net.jacob_stewart.EntityPlus;
	
	import gui.SpaceIndexText;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SpaceIndexText_RD extends SpaceIndexText 
	{
		private var rd:RoomDesigner;
		
		
		
		public function SpaceIndexText_RD(host:EntityPlus, roomIndex:int=-1) 
		{
			super(host, roomIndex);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		// ---------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			visible = false;
			if (rd.f4Info && roomIndex != -1) visible = true; // a roomIndex of -1 means the gridSpace is empty
		}
		// ---------------------------------------------------------------------------------
		
		
		public function updateText(roomIndex:int):void
		{
			this.roomIndex = roomIndex;
			changeText(roomIndex.toString());
			centerOnPoint(textWidth, textHeight, host.x + Game.HALFSPACESIZE, host.y + Game.HALFSPACESIZE);
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}