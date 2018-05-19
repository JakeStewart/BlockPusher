package worlds.title_screen 
{
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import worlds.title_screen.TitleScreenManager;
	import worlds.title_screen.file_select.DeleteSaveFile;
	import worlds.title_screen.file_select.FileSelectManager;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class InputManager_TS extends InputManager 
	{
		private var tsm:TitleScreenManager;
		private var fs:FileSelectManager;
		private var dsf:DeleteSaveFile;
		public var deleteSaveFileAlarm:Alarm;
		
		private const DELETESAVEFILEKEY:int = Key.DELETE;
		
		
		
		public function InputManager_TS(mp:MousePointerGame, tsm:TitleScreenManager) 
		{
			this.tsm = tsm;
			
			
			super(mp);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			tsm = null;
			fs = null;
			dsf = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function keyboard():void 
		{
			super.keyboard();
			
			
			deleteSaveFileCheck();
		}
		
		override public function selectKeys():void 
		{
			super.selectKeys();
			
			
			tsm.keyPressed(Input.lastKey);
		}
		
		override public function escapeKey():void 
		{
			super.escapeKey();
			
			
			tsm.keyPressed(Input.lastKey);
		}
		
		override public function arrowKeys(key:int):void 
		{
			super.arrowKeys(key);
			
			
			tsm.keyPressed(key);
		}
		// -----------------------------------------------------------------------------
		
		
		override public function mousePressed():void 
		{
			super.mousePressed();
			
			
			clicked = true;
		}
		
		override public function mouseDown():void 
		{
			super.mouseDown();
			
			
			
		}
		
		override public function mouseReleased():void 
		{
			super.mouseReleased();
			
			
			
		}
		
		override public function click():void 
		{
			super.click();
			
			
			
		}
		// -----------------------------------------------------------------------------
		
		
		private function deleteSaveFileCheck():void
		{
			fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
			if (fs && tsm.currentSectionNum == tsm.FILESELECT)
			{
				if (!fs.tween.active && Input.pressed(DELETESAVEFILEKEY)) deleteSaveFileAlarm = FP.alarm(2, deleteSaveFile);
			}
			
			if (Input.released(DELETESAVEFILEKEY) && deleteSaveFileAlarm != null) deleteSaveFileAlarm.cancel(), deleteSaveFileAlarm = null;
		}
		
		private function deleteSaveFile():void
		{
			deleteSaveFileAlarm = null;
			
			fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
			dsf = world.getInstance(Game.NAME_DeleteSaveFile) as DeleteSaveFile;
			
			if (fs && !dsf && tsm.currentSectionNum == tsm.FILESELECT)
			{
				if (!fs.tween.active && Input.check(DELETESAVEFILEKEY)) fs.deleteSaveFile();
			}
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}