package worlds.room_select 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Keys;
	
	import worlds.room_select.unsaved_draft_warning.UnsavedDraftWarning;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class InputManager_RS extends InputManager 
	{
		private var rs:RoomSelect;
		private var udw:UnsavedDraftWarning;
		
		public const STATE_MAIN:uint = 0;	// RoomSelect
		public const STATE_UDW:uint = 1;	// UnsavedDraftWarning
		public const SCROLLING:uint = 2;	// Scrolling to diff room
		public var state:int = STATE_MAIN;
		
		
		
		public function InputManager_RS(rs:RoomSelect) 
		{
			this.rs = rs;
			
			
			super(mp);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			rs = null;
			udw = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function keyboard():void 
		{
			if (Input.pressed(Key.ANY)) keyPressed(Input.lastKey);
		}
		// -----------------------------------------------------------------------------
		
		
		private function keyPressed(key:int):void
		{
			switch (state)
			{
				case STATE_MAIN:
					
					
					if (Input.pressed(Keys.SELECT)) rs.navOut(rs.navGamePlay);
					else if (Input.pressed(Keys.CANCEL)) rs.navOut(rs.navTitleScreen);
					else if (Input.pressed(Keys.DIR)) rs.changeRoomInput();
					
					break;
					
				case STATE_UDW:
					
					
					udw = world.getInstance(Game.NAME_UnsavedDraftWarning) as UnsavedDraftWarning;
					udw.keyPressed();
					
					break;
					
				case SCROLLING:
					
					
					
					
					break;
			}
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}