package worlds.title_screen.file_select 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.Keys;
	
	import worlds.title_screen.TitleScreenSection;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class FileSelectManager extends TitleScreenSection 
	{
		public var fileHighlighted:uint = 1;
		public var mouseFileNum:int = -1;
		
		public var fromMenu:Boolean;
		
		private var fileObjectList:Array = new Array;
		private var fo:FileSelectObject;
		
		
		
		public function FileSelectManager(fromMenu:Boolean = false) 
		{
			this.fromMenu = fromMenu;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_FileSelectManager;
			name = Game.NAME_FileSelectManager;
			
			x = FP.width;
			if (fromMenu) x = -FP.width;
			
			
			fileHighlighted = SaveFileData.getSaveFileInUse();
			if (fileHighlighted == 0) fileHighlighted = 1;
			
			
			var fileState:int;
			for (var i:uint = 0; i < Game.MAXSAVEFILECOUNT; i++)
			{
				Data.load("SaveFilesInfo");
				fileState = Data.readInt("File" + (i + 1).toString() + "State");
				
				fileObjectList.push(new FileSelectObject(this, i + 1, fileState));
			}
		}
		
		override public function added():void 
		{
			super.added();
			
			
			sectionNum = tsm.FILESELECT;
			epAddList(fileObjectList);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			fo = null;
			fileObjectList.length = 0;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateMouseFileNum();
		}
		
		private function updateMouseFileNum():void
		{
			if (tween && tsm.currentSectionNum == tsm.FILESELECT)
			{
				if (!tween.active && tsm.mp.fso && mouseFileNum == -1) // while mouse is colliding with a FileSelectObject
				{
					// This will only happen once during collision and will not happen 
					// again until the mouse stops colliding and then collides again
					fileHighlighted = tsm.mp.fso.fileNum;
					mouseFileNum = tsm.mp.fso.fileNum;
				}
			}
			
			if (!tsm.mp.fso) mouseFileNum = -1; // while mouse is NOT colliding with a btn
			else mouseFileNum = tsm.mp.fso.fileNum;
		}
		// -----------------------------------------------------------------------------
		
		
		public function fileSelected():void
		{
			if (SaveFileData.getSaveFileState(fileHighlighted) == -1)
			{
				Sounds.newSaveFile1();
				SaveFileData.newSaveFile(fileHighlighted);
				
				fo = fileObjectList[fileHighlighted - 1]; // 'fileHighlighted - 1' is the index value
				fo.onNewSaveFile();
			}
			else
			{
				SaveFileData.setSaveFileInUse(fileHighlighted);
				Sounds.tick1();
			}
		}
		
		public function deleteSaveFile():void
		{
			tsm.currentSectionNum = tsm.DELETESAVEFILE;
			world.add(new DeleteSaveFile(fileObjectList[fileHighlighted - 1]));
		}
		// -----------------------------------------------------------------------------
		
		
		public function changeFileHighlighted(key:int):void
		{
			var leftOrRight:int = 1;
			if (Input.keys(Keys.LEFT).indexOf(key) != -1) leftOrRight = -1;
			if (fileHighlighted + leftOrRight > 0 && fileHighlighted + leftOrRight < fileObjectList.length + 1) fileHighlighted += leftOrRight;
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}