package game_pieces.tiles.switch_tile 
{
	import game_pieces.tiles.Tile;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchTile extends Tile 
	{
		public var clients:Array = new Array;
		
		
		
		public function SwitchTile(x:Number=0, y:Number=0) 
		{
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SwitchTile;
			graphic = Images.switchImg;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			clients.length = 0;
		}
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
	}

}