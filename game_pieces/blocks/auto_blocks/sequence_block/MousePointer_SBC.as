package game_pieces.blocks.auto_blocks.sequence_block 
{
	import worlds.room_designer.GridSpace;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MousePointer_SBC extends MousePointerGame 
	{
		private var sbc:SequenceBlockCreator;
		private var gs:GridSpace;
		
		
		
		public function MousePointer_SBC(types:Array) 
		{
			super(types);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			sbc = world.getInstance(Game.NAME_SequenceBlockCreator) as SequenceBlockCreator;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			sbc = null;
			gs = null;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function qualified():Boolean 
		{
			gs = collide(Game.TYPE_GridSpace, world.mouseX, world.mouseY) as GridSpace;
			
			if (gs)
			{
				if (sbc.ss._isQualifiedSpace(gs)) return true;
			}
			
			
			return super.qualified();
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}