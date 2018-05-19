package game_pieces.blocks.push_blocks.move_arrows 
{
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MoveArrowDown extends MoveArrow 
	{
		
		public function MoveArrowDown() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			normal = new Image(Images.MOVEARROWDOWNNORMAL);
			hover = new Image(Images.MOVEARROWDOWNHOVER);
			down = normal;
			
			directionVal = 2;
			
			epSetHitbox(20, 12);
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}