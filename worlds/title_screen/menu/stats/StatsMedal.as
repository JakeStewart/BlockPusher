package worlds.title_screen.menu.stats 
{
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class StatsMedal extends EntityGame 
	{
		private var medalNum:uint = 0; // 0: Bronze, 1: Silver, 2: Gold
		private var _centerX:Number = 0;
		private var _centerY:Number = 0;
		
		
		public function StatsMedal(medalNum:uint = 0, centerX:Number = 0, centerY:Number = 0) 
		{
			this.medalNum = medalNum;
			this._centerX = centerX;
			this._centerY = centerY;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = Game.STATSBASELAYER - 2;
			
			centerOnPoint(Game.SPACESIZE, Game.SPACESIZE, _centerX, _centerY);
			graphic = Images.rankingBlocks[medalNum];
			
			homeCoords.x = x, homeCoords.y = y;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			var stats:Stats = world.getInstance(Game.NAME_Stats) as Stats;
			if (stats) stats.objectsToTween.splice(stats.objectsToTween.indexOf(this), 1);
		}
		// -------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------
		
	}

}