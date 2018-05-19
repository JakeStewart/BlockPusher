package worlds.room_designer 
{
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ChangeTypeViaClick_RD extends ChangeTypeViaClick 
	{
		private var rd:RoomDesigner;
		private var visibleStates:Array = new Array;
		
		
		
		public function ChangeTypeViaClick_RD() 
		{
			super();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			visibleStates.push(rd.im.HUB, rd.im.OPTIONS, rd.im.NAMER, rd.im.NEWROOM, rd.im.ADDROOM);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateCollidable();
			updateVisible();
		}
		
		private function updateCollidable():void
		{
			epCollidable(false);
			if (rd.im.state == rd.im.HUB) epCollidable(true);
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (visibleStates.indexOf(rd.im.state) != -1) epVisible(true);
		}
		// -----------------------------------------------------------------------------
		
		
		override public function clickKeyZ():void 
		{
			super.clickKeyZ();
			
			
			rd.ss.changeTypePrev();
		}
		
		override public function clickKeyX():void 
		{
			super.clickKeyX();
			
			
			rd.ss.changeTypeNext();
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}