package worlds.title_screen.menu.stats 
{
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class StatsText extends TextPlus 
	{
		
		public function StatsText(text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.STATSBASELAYER - 2) 
		{
			super(text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeBackOffset(2);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			var stats:Stats = world.getInstance(Game.NAME_Stats) as Stats;
			if (stats) stats.objectsToTween.splice(stats.objectsToTween.indexOf(this), 1);
		}
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
	}

}