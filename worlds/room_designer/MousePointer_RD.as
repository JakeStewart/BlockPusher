package worlds.room_designer 
{
	import worlds.room_designer.options_menu.OptionsMenu_RD;
	import worlds.room_designer.new_room.NewRoom;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MousePointer_RD extends MousePointerGame 
	{
		private var rd:RoomDesigner;
		private var newRoom:NewRoom;
		private var optionsMenu:OptionsMenu_RD;
		private var qualifiedStates:Array = new Array;
		
		
		
		public function MousePointer_RD(types:Array) 
		{
			super(types);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			qualifiedStates.push(rd.im.HUB);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			newRoom = null;
			optionsMenu = null;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function qualified():Boolean 
		{
			// NewRoom
			if (rd.im.state == rd.im.NEWROOM)
			{
				newRoom = world.getInstance(Game.NAME_NewRoom) as NewRoom;
				if (newRoom)
				{
					// If colliding with an option but that option is not the highlighted option
					if (newRoom.mouseIndex != -1 && newRoom.mouseIndex != newRoom.btnsIndex) return false;
				}
			}
			
			
			
			// OptionsMenuText
			if (rd.im.state == rd.im.OPTIONS)
			{
				optionsMenu = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_RD;
				if (optionsMenu)
				{
					if (optionsMenu.option)
					{
						// If colliding with an option but that option is not the highlighted option
						if (
						optionsMenu.mouseIndex != optionsMenu.selector.optionsIndex 
						|| optionsMenu.option.text == "Sound FX" || optionsMenu.option.text == "Music" 
						) return false;
					}
				}
			}
			
			
			// Other
			if (rd.ss.isQualifiedSpace && qualifiedStates.indexOf(rd.im.state) != -1) return true;
			
			
			return super.qualified();
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}