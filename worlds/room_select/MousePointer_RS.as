package worlds.room_select 
{
	import worlds.room_select.unsaved_draft_warning.UnsavedDraftWarning;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MousePointer_RS extends MousePointerGame 
	{
		private var rs:RoomSelect;
		private var udw:UnsavedDraftWarning;
		
		
		
		public function MousePointer_RS(rs:RoomSelect, types:Array) 
		{
			this.rs = rs;
			
			
			super(types);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_MousePointer_RS;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			rs = null;
			udw = null;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function qualified():Boolean 
		{
			// UnsavedDraftWarning
			if (rs.im.state == rs.im.STATE_UDW)
			{
				udw = world.getInstance(Game.NAME_UnsavedDraftWarning) as UnsavedDraftWarning;
				if (udw)
				{
					// If colliding with an option but that option is not the highlighted option
					if (udw.mouseIndex != -1 && udw.mouseIndex != udw.btnsIndex) return false;
				}
			}
			
			
			return super.qualified();
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}