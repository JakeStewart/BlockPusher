package game_pieces.tiles.hole_tile 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import game_pieces.tiles.Tile;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class HoleTile extends Tile 
	{
		
		public function HoleTile(x:Number=0, y:Number=0) 
		{
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_HoleTile;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epVisible(false);
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}