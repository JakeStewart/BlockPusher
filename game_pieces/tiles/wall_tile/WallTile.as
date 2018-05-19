package game_pieces.tiles.wall_tile 
{
	import net.flashpunk.Graphic;
	
	import game_pieces.tiles.Tile;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class WallTile extends Tile 
	{
		
		public function WallTile(x:Number=0, y:Number=0, graphic:Graphic=null) 
		{
			super(x, y, graphic);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_WallTile;
			img.color = 0x1A1A1A;
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}