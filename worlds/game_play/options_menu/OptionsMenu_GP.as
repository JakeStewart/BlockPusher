package worlds.game_play.options_menu 
{
	import net.flashpunk.FP;
	
	import gui.options_menu.OptionsMenu;
	import gui.options_menu.OptionsMenuText;
	import worlds.game_play.GamePlayManager;
	import worlds.room_designer.RoomDesignerWorld;
	import worlds.title_screen.TitleScreenWorld;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OptionsMenu_GP extends OptionsMenu 
	{
		private var gpm:GamePlayManager;
		
		private var resetRoomText:OptionsMenuText;
		private var exitGameText:OptionsMenuText;
		private var editRoomText:OptionsMenuText;
		
		private var testingRoom:Boolean = false;
		
		
		
		public function OptionsMenu_GP(testingRoom:Boolean = false) 
		{
			this.testingRoom = testingRoom;
			
			
			super();
			
		}
		
		override public function init():void 
		{
			resetRoomText = new OptionsMenuText(3, runRoomReset, "Reset Room", panel.x + Game.OPTIONSPAD);
			
			if (testingRoom)
			{
				editRoomText = new OptionsMenuText(4, runEditRoom, "Edit Room", panel.x + Game.OPTIONSPAD);
				options.push(resetRoomText, editRoomText);
				textList.push(resetRoomText, editRoomText);
			}
			else
			{
				exitGameText = new OptionsMenuText(4, runExitGame, "Exit To Title Menu", panel.x + Game.OPTIONSPAD);
				options.push(resetRoomText, exitGameText);
				textList.push(resetRoomText, exitGameText);
			}
			
			
			super.init();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm.im.state = gpm.im.IDLE;
			
			gpm = null;
		}
		// ------------------------------------------------------------------------
		
		
		private function runRoomReset():void
		{
			FP.alarm(DURATION, gpm.newPuzzle);
			Sounds.select1();
			tweenOut();
		}
		
		private function resetRoom():void
		{
			gpm.newPuzzle();
		}
		
		private function runExitGame():void
		{
			FP.alarm(DURATION, exitGame);
			Sounds.select1();
			tweenOut();
		}
		
		private function exitGame():void
		{
			FP.world = new TitleScreenWorld(true);
		}
		
		private function runEditRoom():void
		{
			FP.alarm(DURATION, editRoom);
			Sounds.select1();
			tweenOut();
		}
		
		private function editRoom():void
		{
			FP.world = new RoomDesignerWorld;
		}
		
		override public function exit():void 
		{
			// if (state == STATE_HUB || state == STATE_TWEENING) gpm.im.state = gpm.im.IDLE;
			super.exit();
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}