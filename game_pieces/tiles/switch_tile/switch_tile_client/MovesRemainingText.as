package game_pieces.tiles.switch_tile.switch_tile_client 
{
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MovesRemainingText extends TextPlus 
	{
		
		public function MovesRemainingText(text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeBackOffset(Game.SWITCHCLIENT_MOVES_BACKOFFSET);
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}