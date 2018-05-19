package worlds.room_designer.switch_tile_editor 
{
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MousePointer_STE extends MousePointerGame 
	{
		private var ss:SpaceSelector_STE;
		
		
		
		public function MousePointer_STE(types:Array) 
		{
			super(types);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			ss = world.getInstance(Game.NAME_SpaceSelector_STE) as SpaceSelector_STE;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			ss = null;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function qualified():Boolean 
		{
			if (ss.isQualifiedSpace) return true;
			return super.qualified();
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}