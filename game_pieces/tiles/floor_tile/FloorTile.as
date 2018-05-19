package game_pieces.tiles.floor_tile 
{
	import net.flashpunk.Graphic;
	
	import game_pieces.tiles.Tile;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class FloorTile extends Tile 
	{
		
		public function FloorTile(x:Number=0, y:Number=0, graphic:Graphic=null) 
		{
			super(x, y, graphic);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_FloorTile;
			img.color = 0x938F8C;
			epSetHitbox(Game.SPACESIZE, Game.SPACESIZE);
		}
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
	}

}