package game_pieces.tiles.switch_tile 
{
	import net.jacob_stewart.JS;
	
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_GP;
	import worlds.game_play.GamePlayManager;
	import worlds.game_play.Room;
	import worlds.game_play.SpaceIndexText_GP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchTile_GP extends SwitchTile 
	{
		private var gpm:GamePlayManager;
		private var room:Room;
		
		private var sc:SwitchClient_GP;
		private var clientData:Array = new Array;
		
		private var hasCollided:Boolean = false;
		
		
		
		public function SwitchTile_GP(clientData:Array, roomIndex:uint, x:Number=0, y:Number=0) 
		{
			this.clientData = clientData;
			this.roomIndex = roomIndex;
			indexText = new SpaceIndexText_GP(this, roomIndex);
			
			
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			epSetHitbox(4, 4, -14, -14);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			room = world.getInstance(Game.NAME_Room) as Room;
			
			addClients();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			room = null;
			sc = null;
		}
		// ---------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateCollideGamePiece();
		}
		
		private function updateCollideGamePiece():void
		{
			if (collideTypes([Game.TYPE_PushBlockHitbox2, Game.TYPE_SequenceBlock], x, y))
			{
				if (!hasCollided) collisionArrival();
				hasCollided = true;
			}
			else
			{
				hasCollided = false;
			}
		}
		// ---------------------------------------------------------------------------------
		
		
		private function collisionArrival():void
		{
			for each (sc in clients) sc.activate();
		}
		
		public function onFinishMove():void
		{
			for each (sc in clients) sc.onFinishMove();
		}
		// ---------------------------------------------------------------------------------
		
		
		private function addClients():void
		{
			for (var i:uint = 0; i < clientData.length; i++)
			{
				var data:Array = new Array(Game.STC_DATA_COUNT);
				data = clientData[i];
				clients.push(SwitchClient_GP(world.create(SwitchClient_GP))._SwitchClient(room.spaces[data[6]].x, room.spaces[data[6]].y, data[2], data[3], data[4], data[5], data[6], data[7], data[8]));
			}
			
			
			for each (sc in clients)
			{
				room.epRemove(room.spaces[sc.roomIndex]);
				room.spaces[sc.roomIndex] = sc;
				children.push(sc);
			}
		}
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
	}

}