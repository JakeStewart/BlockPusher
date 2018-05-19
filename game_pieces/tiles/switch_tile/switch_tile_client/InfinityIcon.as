package game_pieces.tiles.switch_tile.switch_tile_client 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class InfinityIcon extends EntityGame 
	{
		private var host:Entity;
		
		
		
		public function InfinityIcon(host:Entity) 
		{
			this.host = host;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = host.layer + 1;
			addGraphic(Images.infinityIconBack);
			addGraphic(Images.infinityIcon);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			centerOnPoint(Images.infinityIcon.width, Images.infinityIcon.height, host.x + Game.HALFSPACESIZE, host.y + Game.HALFSPACESIZE);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			host = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function centerOnPoint(width:uint, height:uint, pX:Number, pY:Number):void 
		{
			super.centerOnPoint(width, height, pX, pY);
			Images.infinityIconBack.x = Game.SWITCHCLIENT_MOVES_BACKOFFSET, Images.infinityIconBack.y = Game.SWITCHCLIENT_MOVES_BACKOFFSET;
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}