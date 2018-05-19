package worlds.room_designer.saving 
{
	import flash.system.System;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	
	import game_pieces.tiles.switch_tile.SwitchTile_RD;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_RD;
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SaveQualificationChecker extends EntityGame 
	{
		private var rd:RoomDesigner;
		
		
		
		public function SaveQualificationChecker() 
		{
			super();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		// ----------------------------------------------------------------------------------------
		
		
		public function isPlayableRoom():Boolean
		{
			if (rd.pushBlocks.length > 0 && hasGoal()) return true;
			
			
			return false;
			
			
			
			function hasGoal():Boolean
			{
				var gs:GridSpace;
				for (var i:uint = 0; i < rd.gridSpaces.length; i++)
				{
					gs = rd.gridSpaces[i];
					if (gs.imgNum == 2) return true;
				}
				
				for each (var st:SwitchTile_RD in rd.switchTiles)
				{
					for each (var sc:SwitchClient_RD in st.clients)
					{
						if (sc.activeNum == 2 || sc.inactiveNum == 2) return true;
					}
				}
				
				
				return false;
			}
		}
		
		public function isDifferentRoomName():Boolean
		{
			var xmlFileIndex:int = new int(rd.playlistFileName.slice(RoomData.XMLFILEPREFIX.length, rd.playlistFileName.length));
			xmlFileIndex--;
			
			if (xmlFileIndex > -1)
			{
				var room:XML = FP.getXML(RoomData.roomDataClasses[xmlFileIndex]);
				if (room.@roomName != rd.roomName)
				{
					System.disposeXML(room);
					return true;
				}
			}
			else
			{
				Data.load(rd.playlistFileName);
				if (Data.readString("roomName") != rd.roomName) return true;
			}
			
			
			return false;
		}
		// ----------------------------------------------------------------------------------------
		
		
		public static function getXMLFileIndex(rd_PlaylistFileName:String):int
		{
			if (rd_PlaylistFileName.substring(0, RoomData.XMLFILEPREFIX.length) == RoomData.XMLFILEPREFIX) // If rd_PlaylistFileName is a xml file name ("Room_X")
			{
				return new int(rd_PlaylistFileName.slice(RoomData.XMLFILEPREFIX.length, RoomData.XMLFILEPREFIX.length + 1)) - 1;
			}
			
			
			return -1;
		}
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
	}

}