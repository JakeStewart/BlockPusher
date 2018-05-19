package game_pieces.blocks.push_blocks.move_arrows 
{
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MoveArrowRight extends MoveArrow 
	{
		
		public function MoveArrowRight() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			normal = new Image(Images.MOVEARROWRIGHTNORMAL);
			hover = new Image(Images.MOVEARROWRIGHTHOVER);
			down = normal;
			
			directionVal = 1;
			
			epSetHitbox(12, 20);
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}