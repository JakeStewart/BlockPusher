package worlds.room_select 
{
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class EditRoomButton extends TextButton 
	{
		private var rs:RoomSelect;
		private const ALPHA_OFFSETLOW:Number = .7;
		private var alphaOffset:Number = 1;
		private var userPrefix:String = RoomData.getUserPrefix();
		
		
		
		public function EditRoomButton(onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
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
		// -----------------------------------------------------------------------------
		
		
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
			if (rs.im.state == rs.im.STATE_MAIN)
			{
				if (rs.fileNamePrefix == userPrefix) epCollidable(true);
				else
				{
					if (rs.fileNameIndex != rs.uncompletedRoomNum || Game.developer) epCollidable(true);
				}
			}
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (rs.fileNameIndex != rs.uncompletedRoomNum || Game.developer) epVisible(true);
		}
		
		private function updateAlphaOffset():void
		{
			alphaOffset = 1;
			if (rs.im.state != rs.im.STATE_MAIN) alphaOffset = ALPHA_OFFSETLOW;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		
		override public function changeState(state:int=-1):void 
		{
			if (state == -1) state = this.state;
			changeAlpha(getStateAlpha() * alphaOffset, (getStateAlpha() * backAlpha) * alphaOffset);
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}