package worlds.room_designer.options_menu 
{
	import net.flashpunk.FP;
	
	import game_manual.Manual;
	import gui.options_menu.OptionsMenu;
	import gui.options_menu.OptionsMenuText;
	import worlds.room_designer.RoomDesigner;
	import worlds.room_designer.new_room.NewRoom;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OptionsMenu_RD extends OptionsMenu 
	{
		private var rd:RoomDesigner;
		
		private var newRoomText:OptionsMenuText;
		private var testRoomText:OptionsMenuText;
		private var exitText:OptionsMenuText;
		
		
		
		public function OptionsMenu_RD(rd:RoomDesigner) 
		{
			this.rd = rd;
			
			
			super();
		}
		
		override public function init():void 
		{
			newRoomText = new OptionsMenuText(3, startNewRoom, "Start New Room", panel.x + Game.OPTIONSPAD);
			testRoomText = new OptionsMenuText(4, navTestRoom, "Test Room", panel.x + Game.OPTIONSPAD);
			exitText = new OptionsMenuText(5, navTitleMenu, "Exit To Title Menu", panel.x + Game.OPTIONSPAD);
			options.push(newRoomText, testRoomText, exitText);
			textList.push(newRoomText, testRoomText, exitText);
			
			if (RoomData.draftIsEmpty()) newRoomText.epCollidable(false);
			if (rd.pushBlocks.length == 0) testRoomText.epCollidable(false);
			
			
			super.init();
			
			
			manualPage = Manual.PAGE_ROOMDESIGNER;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function exit():void 
		{
			if (state == STATE_HUB || state == STATE_TWEENING) rd.im.state = rd.im.HUB;
			super.exit();
		}
		
		private function startNewRoom():void
		{
			state = -1;
			world.add(new NewRoom);
			exit();
		}
		
		private function navTestRoom():void
		{
			FP.alarm(DURATION, testRoom);
			tweenOut();
		}
		
		private function testRoom():void
		{
			rd.testRoom();
		}
		
		private function navTitleMenu():void
		{
			exit();
			rd.wp.navTitleMenu(rd.wp.navTitleMenu);
			rd.im.state = -1;
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}