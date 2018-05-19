package game_pieces.blocks.push_blocks.move_arrows 
{
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MoveArrowLeft extends MoveArrow 
	{
		
		public function MoveArrowLeft() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			normal = new Image(Images.MOVEARROWLEFTNORMAL);
			hover = new Image(Images.MOVEARROWLEFTHOVER);
			down = normal;
			
			directionVal = 3;
			
			epSetHitbox(12, 20);
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}