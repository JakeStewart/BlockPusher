package worlds.game_play 
{
	import game_pieces.blocks.push_blocks.PushBlock;
	import worlds.game_play.options_menu.OptionsMenu_GP;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MousePointer_GP extends MousePointerGame 
	{
		private var gpm:GamePlayManager;
		private var optionsMenu:OptionsMenu_GP;
		private var pb:PushBlock;
		
		
		
		public function MousePointer_GP(types:Array) 
		{
			super(types);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_MousePointer_GP;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			optionsMenu = null;
			pb = null;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function qualified():Boolean 
		{
			if (gpm.im.state == gpm.im.OPTIONS)
			{
				optionsMenu = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_GP;
				if (optionsMenu)
				{
					if (optionsMenu.option) // If colliding with an option
					{
						// If colliding with an option but that option is not the highlighted option
						if (
						optionsMenu.mouseIndex != optionsMenu.selector.optionsIndex 
						|| optionsMenu.option.text == "Sound FX" || optionsMenu.option.text == "Music" 
						) return false;
					}
				}
			}
			
			pb = collide(Game.TYPE_PushBlock, world.mouseX, world.mouseY) as PushBlock;
			if (pb)
			{
				if (pb.qualClick()) return true;
			}
			
			
			return super.qualified();
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
	}

}