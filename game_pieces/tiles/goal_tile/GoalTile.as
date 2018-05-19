package game_pieces.tiles.goal_tile 
{
	import net.flashpunk.Graphic;
	
	import game_pieces.tiles.Tile;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GoalTile extends Tile 
	{
		
		public function GoalTile(x:Number=0, y:Number=0, graphic:Graphic=null) 
		{
			super(x, y, graphic);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_GoalTile;
			graphic = Images.goalImg;
			epSetHitbox(Game.SPACESIZE, Game.SPACESIZE);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAdd(new GoalOutline(this));
		}
		// ---------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------
		
	}

}