package worlds.game_play 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.graphics.EdgeFadeLine;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MovesDividerLine extends EdgeFadeLine 
	{
		private const SCREENPAD:uint = 8;
		private const HALF_LENGTH:uint = 30;
		private const LENGTH:uint = HALF_LENGTH * 2;
		private const XCENTER:Number = FP.halfWidth;
		private const YCENTER:Number = FP.height - (HALF_LENGTH + SCREENPAD);
		
		
		
		public function MovesDividerLine(layer:int, length:uint = LENGTH, xCenter:Number = 0, yCenter:Number = 0, horizontal:Boolean = false, color:uint=0xFFFFFF, alphaOffset:Number=1, thick:uint=1) 
		{
			super(layer, length, XCENTER, YCENTER, horizontal, color, alphaOffset, thick);
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
	}

}