package game_pieces.tiles.goal_tile 
{
	import net.flashpunk.Entity;
	
	import game_pieces.GamePieceOutline;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GoalOutline extends GamePieceOutline 
	{
		
		public function GoalOutline(host:Entity, layerOffset:int=0, scaleX:Number=1, scaleY:Number=1, color:uint=0xFFFFFF, alpha:Number=1) 
		{
			super(host, layerOffset, scaleX, scaleY, color, alpha);
		}
		
		override public function init():void 
		{
			layerOffset = 1;
			color = 0x333333;
			
			
			super.init();
		}
		// ----------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (host.graphic == Images.goalImg) epVisible(true);
		}
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
	}

}