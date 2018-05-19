package game_pieces.blocks.push_blocks.move_arrows 
{
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MoveArrowUp extends MoveArrow 
	{
		
		public function MoveArrowUp() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			normal = new Image(Images.MOVEARROWUPNORMAL);
			hover = new Image(Images.MOVEARROWUPHOVER);
			down = normal;
			
			directionVal = 0;
			
			epSetHitbox(20, 12);
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}