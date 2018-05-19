package game_pieces.tiles.switch_tile.switch_tile_client 
{
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MovesRemainingText_GP extends MovesRemainingText 
	{
		private var host:SwitchClient_GP;
		
		
		
		public function MovesRemainingText_GP(host:SwitchClient_GP, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.host = host;
			
			
			super(text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			visible = false;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			host = null;
		}
		// -------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisible();
		}
		
		private function updateVisible():void
		{
			visible = false;
			if (host.isActive && host.movesLeft > 0) visible = true;
		}
		// -------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------
		
	}

}