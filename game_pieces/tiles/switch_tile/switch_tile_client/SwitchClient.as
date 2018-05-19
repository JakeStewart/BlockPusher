package game_pieces.tiles.switch_tile.switch_tile_client 
{
	import game_pieces.GamePiece;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchClient extends GamePiece 
	{
		public var activeNum:uint;
		public var inactiveNum:uint;
		
		public var hostRoomIndex:uint;
		public var hostGridIndex:uint;
		
		public var moves:int;
		public var movesLeft:int;
		public static const INFINITY_MOVES:int = -1;
		
		
		
		public function SwitchClient() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SwitchClient;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			graphic = Images.imgs[inactiveNum];
			epSetHitbox(Game.SPACESIZE, Game.SPACESIZE);
			
			updateMovesLeftText(moves);
		}
		// -------------------------------------------------------------------------------------------
		
		
		public function updateMovesLeftText(movesLeft:int):void
		{
			
		}
		// -------------------------------------------------------------------------------------------
		
		
		public function _SwitchClient(x:Number = 0, y:Number = 0, activeNum:uint = 99, inactiveNum:uint = 99, gridIndex:uint = 0, hostGridIndex:uint = 0, roomIndex:uint = 999, hostRoomIndex:uint = 999, moves:int = 0, outlineIndex1:uint = 0, outlineIndex2:int = -1):SwitchClient 
		{
			homeCoords.x = x, homeCoords.y = y;
			
			this.x = x, this.y = y;
			this.activeNum = activeNum;
			this.inactiveNum = inactiveNum;
			this.gridIndex = gridIndex;
			this.hostGridIndex = hostGridIndex;
			
			if (roomIndex != 999) this.roomIndex = roomIndex;
			if (hostRoomIndex != 999) this.hostRoomIndex = hostRoomIndex;
			
			this.moves = moves;
			
			updateMovesLeftText(moves);
			
			
			return this;
		}
		// -------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------
		
		
	}

}