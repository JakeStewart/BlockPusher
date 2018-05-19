package worlds.title_screen 
{
	import net.jacob_stewart.JS;
	
	import worlds.title_screen.file_select.DeleteSaveFile;
	import worlds.title_screen.file_select.FileSelectManager;
	import worlds.title_screen.file_select.FileSelectObject;
	import worlds.title_screen.menu.MenuListSelector;
	import worlds.title_screen.menu.TitleMenuButton;
	import worlds.title_screen.menu.options.OptionsMenu_TS;
	import worlds.title_screen.press_space_screen.PressSpaceScreen;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MousePointer_TS extends MousePointerGame 
	{
		private var tsm:TitleScreenManager;
		private var ps:PressSpaceScreen;
		private var fs:FileSelectManager;
		public var fso:FileSelectObject;
		private var menuBtn:TitleMenuButton;
		private var selector:MenuListSelector;
		private var dsf:DeleteSaveFile;
		private var optionsMenu:OptionsMenu_TS;
		
		
		
		public function MousePointer_TS(types:Array) 
		{
			super(types);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			tsm = world.getInstance(Game.NAME_TitleScreenManager) as TitleScreenManager;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			tsm = null;
			ps = null;
			fs = null;
			fso = null;
			menuBtn = null;
			selector = null;
			dsf = null;
			optionsMenu = null;
		}
		// ---------------------------------------------------------------------------------------------------------
		
		
		override public function qualified():Boolean 
		{
			switch (tsm.currentSectionNum)
			{
				case tsm.SPACESCREEN:
					
					
					ps = world.getInstance(Game.NAME_PressSpaceScreen) as PressSpaceScreen;
					if (ps)
					{
						if (collideWith(ps, world.mouseX, world.mouseY)) return true;
					}
					
					break;
					
				case tsm.FILESELECT:
					
					
					fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
					fso = collide(Game.TYPE_FileSelectObject, world.mouseX, world.mouseY) as FileSelectObject; // This needs to go first for FileSelectManager.updateMouseFileNum()
					
					if (fs)
					{
						if (fs.mouseFileNum != -1)
						{
							// If colliding with an option but that option is not the highlighted option
							if (fs.mouseFileNum != fs.fileHighlighted) return false;
							else if (fso && fs.mouseFileNum == fs.fileHighlighted)
							{
								if (fso.line1)
								{
									// If mouse is in the delete file area but not on the delete file TextButton
									if (!collide(JS.TYPE_TextButton, world.mouseX, world.mouseY) && world.mouseY > fso.line1.y) return false;
								}
								
								return true;
							}
						}
					}
					
					break;
					
				case tsm.TITLEMENU:
					
					
					menuBtn = collide(JS.TYPE_TextButton, world.mouseX, world.mouseY) as TitleMenuButton;
					if (menuBtn)
					{
						selector = world.getInstance(Game.NAME_MenuListSelector) as MenuListSelector;
						if (menuBtn.btnsIndex != selector.selectors.indexOf(selector.selector)) return false;
					}
					
					break;
					
				case tsm.STATS:
					
					
					
					break;
					
				case tsm.OPTIONS:
					
					
					optionsMenu = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu_TS;
					if (optionsMenu)
					{
						if (optionsMenu.option)
						{
							// If colliding with an option but that option is not the highlighted option
							if (
							optionsMenu.mouseIndex != optionsMenu.selector.optionsIndex 
							|| optionsMenu.option.text == "Sound FX" || optionsMenu.option.text == "Music" 
							) return false;
						}
					}
					
					break;
					
				case tsm.DELETESAVEFILE:
					
					
					dsf = world.getInstance(Game.NAME_DeleteSaveFile) as DeleteSaveFile;
					if (dsf)
					{
						if (dsf.mouseIndex != -1 && dsf.mouseIndex == dsf.btnsIndex) return true;
					}
					
					return false;
					
					break;
			}
			
			
			return super.qualified();
		}
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------------------------
		
		
	}

}