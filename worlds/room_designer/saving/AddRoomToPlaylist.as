package worlds.room_designer.saving 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.text.TextPlus;
	
	import gui.ConfirmOrCancelText;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class AddRoomToPlaylist extends EntityGame 
	{
		private var rd:RoomDesigner;
		
		private var screenTint:ScreenTint = new ScreenTint(Game.SCREENTINT_LAYER);
		private var warning1:TextPlus = new TextPlus("This room will be added to the playlist", 0, 240, { size: 18, alignCenterX: FP.halfWidth } );
		// "This room has already been added to the playlist but has been modified since it was last saved. Do you wish add this to the playlist as another room or just save the changes?"
		private var confirmOrCancel:ConfirmOrCancelText = new ConfirmOrCancelText;
		private var guiList:Array = [screenTint, warning1, confirmOrCancel];
		
		
		
		public function AddRoomToPlaylist() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_AddRoomToPlaylist;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			rd.im.state = rd.im.ADDROOM;
			epAddList(guiList);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			rd.im.state = rd.im.HUB;
			rd.addRoomBtn.activationCheck();
			
			rd = null;
			guiList.length = 0;
		}
		// -------------------------------------------------------------------------------
		
		
		public function addRoom():void
		{
			rd.saveRoomData(null, true); // Also gives RoomDesigner.playlistFileName a value
			rd.updateDraftData(); // So the draft file has a value for 'Data.readString("playlistFileName")'
			
			rd.addRoomBtn.statusText.changeText(rd.addRoomBtn.hasBeenAddedStr, true);
			rd.addRoomBtn.statusText.changeAlpha(rd.addRoomBtn.HASBEENHALPHA);
			
			world.remove(this);
		}
		
		public function cancelAddRoom():void
		{
			world.remove(this);
		}
		// -------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------
		
	}

}