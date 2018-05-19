package game_pieces.blocks.push_blocks 
{
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class PushBlockHitbox2 extends EntityGame 
	{
		public var host:PushBlock;
		
		
		
		public function PushBlockHitbox2(host:PushBlock) 
		{
			this.host = host;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_PushBlockHitbox2;
			setHitbox(Game.SPACESIZE, Game.SPACESIZE);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			host = null;
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}