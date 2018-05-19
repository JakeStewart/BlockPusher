package worlds.room_designer.switch_tile_editor 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchClientMovesSetter extends EntityGame 
	{
		private var ss:SpaceSelector_STE;
		
		private var key:int = 0;
		private var moves:int = 0;
		
		
		
		public function SwitchClientMovesSetter() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SwitchClientMovesSetter;
			name = Game.NAME_SwitchClientMovesSetter;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			key = 0;
			moves = 0;
			
			ss = world.getInstance(Game.NAME_SpaceSelector_STE) as SpaceSelector_STE;
			ss.changeMoves(moves);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			ss = null;
		}
		// -------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			if (Input.pressed(Key.ANY))
			{
				key = Input.lastKey;
				
				if (key >= 48 && key <= 57) updateNumbersEntered(48);
				if (key >= 96 && key <= 105) updateNumbersEntered(96);
				if (Input.pressed(Key.CONTROL)) updateNumbersEntered(SwitchClient.INFINITY_MOVES);
			}
		}
		
		private function updateNumbersEntered(diff:int):void
		{
			if (diff == SwitchClient.INFINITY_MOVES)
			{
				moves = SwitchClient.INFINITY_MOVES;
			}
			else if (moves == 0 || moves > 9 || moves == SwitchClient.INFINITY_MOVES)
			{
				moves = key - diff;
			}
			else
			{
				moves *= 10;
				if (key - diff > 0) moves += (key - diff);
			}
			
			
			ss.changeMoves(moves);
		}
		// -------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------
		
	}

}