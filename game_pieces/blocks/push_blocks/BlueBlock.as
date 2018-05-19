package game_pieces.blocks.push_blocks 
{
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class BlueBlock extends PushBlock 
	{
		
		public function BlueBlock() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			colors = [0x49B7E8, 0x7EDBFC, 0x409ADD];
			subType = Game.SUBTYPE_BlueBlock;
		}
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
	}

}