package worlds.title_screen.file_select 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.text.TextPlus;
	
	import gui.ConfirmOrCancelText;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class DeleteSaveFile extends EntityGame 
	{
		private var fs:FileSelectManager;
		private var fo:FileSelectObject;
		private var dsfBtn:DeleteSaveFileButton;
		private var saveFileNum:uint;
		
		private static const BASELAYER:int = -4;
		public static const TEXTLAYER:int = BASELAYER - 2;
		private const TEXTAREAY:uint = 22; // Math.round(FP.height / 4)
		private const LEADING:uint = 6;
		private const CONFIRMCANCEL_PAD_CENTER:uint = 80;
		private const CONFIRMCANCEL_PAD_TOP:uint = 24;
		
		private var screenTint:ScreenTint = new ScreenTint(BASELAYER, .8);
		private var fileText:TextPlus = new TextPlus("File ", 0, TEXTAREAY, { size: 30, alignCenterX: FP.halfWidth, backOffset: 2 }, TEXTLAYER);
		private var warning1:TextPlus = new TextPlus("This save file will be deleted.", 0, TEXTAREAY, { size: 18, alignCenterX: FP.halfWidth, backOffset: 2 }, TEXTLAYER); // y = TEXTAREAY + fileText.textHeight + (LEADING * 2)
		private var warning2:TextPlus = new TextPlus("You will lose any progress AND any user created rooms on it.", 0, warning1.y + warning1.textHeight + LEADING, { size: 18, alignCenterX: FP.halfWidth, backOffset: 2 }, TEXTLAYER);
		private var confirm:DeleteSaveFileButton = new DeleteSaveFileButton(0, deleteSaveFile, "CONFIRM", 0, warning2.y + warning2.textHeight + LEADING + CONFIRMCANCEL_PAD_TOP, { alignCenterX: FP.halfWidth - CONFIRMCANCEL_PAD_CENTER } );
		private var cancel:DeleteSaveFileButton = new DeleteSaveFileButton(1, cancelDeleteFile, "CANCEL", 0, warning2.y + warning2.textHeight + LEADING + CONFIRMCANCEL_PAD_TOP, { alignCenterX: FP.halfWidth + CONFIRMCANCEL_PAD_CENTER } );
		private var btns:Array = [confirm, cancel];
		public var confirmOrCancel:ConfirmOrCancelText = new ConfirmOrCancelText(TEXTLAYER, warning2.y + warning2.textHeight + LEADING + 8); // Math.round((FP.height / 6) * 5)
		public var btnsIndex:uint = 1;
		public var mouseIndex:int = -1;
		
		
		
		public function DeleteSaveFile(fo:FileSelectObject) 
		{
			this.fo = fo;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_DeleteSaveFile;
			saveFileNum = fo.fileNum;
			addList.push(screenTint, warning1, warning2, confirm, cancel);
			fileText.changeText(fileText.text + saveFileNum.toString());
			fo.setStackOrder( -3);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
			
			btnsCollidable(false);
			epAddList(addList);
			Sounds.warning1();
			FP.alarm(1, addConfirmText);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			btnsCollidable(true);
			fo.setStackOrder(0);
			fs.tsm.currentSectionNum = fs.tsm.FILESELECT;
			
			fs = null;
			fo = null;
			dsfBtn = null;
			btns.length = 0;
		}
		// ---------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateMouseIndex();
		}
		
		private function updateMouseIndex():void
		{
			dsfBtn = collide(JS.TYPE_TextButton, world.mouseX, world.mouseY) as DeleteSaveFileButton;
			
			if (dsfBtn) // while mouse is colliding with one of the btns
			{
				if (mouseIndex == -1)
				{
					// This will only happen once during collision and will not happen 
					// again until the mouse stops colliding and then collides again
					btnsIndex = dsfBtn.btnsIndex;
					mouseIndex = dsfBtn.btnsIndex;
				}
			}
			else mouseIndex = -1; // while mouse is NOT colliding with a btn
		}
		// ---------------------------------------------------------------------------------------
		
		
		public function keyPressed():void
		{
			if (Input.pressed(Keys.SELECT))
			{
				if (btnsIndex == 0) deleteSaveFile();
				else if (btnsIndex == 1) cancelDeleteFile();
			}
			else if (Input.pressed(Keys.CANCEL))
			{
				cancelDeleteFile();
			}
			else if (Input.pressed(Keys.HOR))
			{
				if (Input.pressed(Keys.LEFT) && btnsIndex > 0) btnsIndex--;
				else if (Input.pressed(Keys.RIGHT) && btnsIndex < 1) btnsIndex++;
			}
		}
		
		private function addConfirmText():void
		{
			// epAdd(confirmOrCancel);
		}
		// ---------------------------------------------------------------------------------------
		
		
		private function deleteSaveFile():void
		{
			SaveFileData.deleteSaveFile(saveFileNum);
			fo.onDeleteSaveFile();
			Sounds.wave1();
			
			
			if (SaveFileData.getSaveFileState(SaveFileData.getSaveFileInUse()) == -1) // Means the current save file being used just got deleted
			{
				if (SaveFileData.setSaveFileInUse(getNextSaveFileNumToUse()) != 0) // If there's still an existing created save file. This also sets save file in use
				{
					fs.fileHighlighted = SaveFileData.getSaveFileInUse();
				}
				else fs.fileHighlighted = 1;
			}
			
			
			world.remove(this);
			
			
			
			function getNextSaveFileNumToUse():uint
			{
				for (var i:uint = 1; i < Game.MAXSAVEFILECOUNT + 1; i++)
				{
					if (SaveFileData.getSaveFileState(i) == 1) return i;
				}
				
				
				return 0;
			}
		}
		
		private function cancelDeleteFile():void
		{
			Sounds.knock1();
			world.remove(this);
		}
		// ---------------------------------------------------------------------------------------
		
		
		private function btnsCollidable(state:Boolean):void
		{
			var deleteBtns:Array = new Array;
			world.getClass(DeleteButton, deleteBtns);
			for each (var deleteBtn:DeleteButton in deleteBtns) deleteBtn.epCollidable(state);
		}
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------
		
	}

}