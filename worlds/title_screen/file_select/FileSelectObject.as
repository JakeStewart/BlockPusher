package worlds.title_screen.file_select 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.Button;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.graphics.EdgeFadeLine;
	import net.jacob_stewart.text.TextPlus;
	
	import worlds.title_screen.TitleScreenManager;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class FileSelectObject extends Button 
	{
		private var tsm:TitleScreenManager;
		private var fs:FileSelectManager;
		private var dsf:DeleteSaveFile;
		public var fileNum:uint;
		private var fileState:int;
		
		private const BASELAYER:int = -2;
		
		public var panelFillImage:Image = new Image(Images.SAVEFILEPANEL_FILL);
		private var panelOutlineImage:Image = new Image(Images.SAVEFILEPANEL_OUTLINE);
		private var panelFill:EntityGame = new EntityGame(0, 0, panelFillImage, BASELAYER);
		private var panelOutline:EntityGame = new EntityGame(0, 0, panelOutlineImage, BASELAYER);
		
		
		private const PADDING:uint = 20; // padding for all sides of panel
		private const HOMECOORDY:Number = Math.round(FP.height * Game.TSTAHP) + (PADDING * 2);
		
		private var padX:uint = Math.round((FP.width - (Game.MAXSAVEFILECOUNT * panelFillImage.width)) / (Game.MAXSAVEFILECOUNT + 1));
		private const HB_WIDTH:uint = JS.roundEven(Math.round(panelFillImage.width * .8));
		
		private var alphaOffset:Number = .2;
		private const NORMALOFFSET:Number = alphaOffset;
		private const HOVEROFFSET:Number = 0;
		private const DOWNOFFSET:Number = HOVEROFFSET;
		private var normalOffset:Number = NORMALOFFSET;
		private var hoverOffset:Number = HOVEROFFSET;
		private var downOffset:Number = DOWNOFFSET;
		
		
		public var line1:EdgeFadeLine;
		private const LINE1_SIDEPAD:uint = 20;
		private const LINE1_BOTTOMPAD:uint = 38;
		
		
		private var fileTitleStr:String;
		private var fileTitle:TextPlus;
		
		private var roomsCompleteStr:String = "Rooms Complete: ";
		private var roomsCompleteText:TextPlus;
		
		private var deleteFileBtn:DeleteButton;
		
		private var textList:Array = new Array;
		
		private const BLINKDURATION:Number = .1;
		private const BLINKLIMIT:uint = 16;
		private var blinkCount:uint = 0;
		private var blinkState:Boolean = false;
		
		private var highlighted:Boolean = false;
		
		
		
		public function FileSelectObject(fs:FileSelectManager, fileNum:uint, fileState:int) 
		{
			this.fs = fs;
			this.fileNum = fileNum;
			this.fileState = fileState;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_FileSelectObject;
			layer = BASELAYER;
			
			setCoords();
			epSetHitbox(HB_WIDTH, panelFillImage.height, -((panelFillImage.width - HB_WIDTH) * .5));
			setText();
			
			
			addList.push(textList, panelFill, panelOutline);
			fs.objectsToTween.push(this, panelFill, panelOutline);
			fs.objectsToTween.push(textList);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			tsm = world.getInstance(Game.NAME_TitleScreenManager) as TitleScreenManager;
			fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
			
			changeState(NORMAL);
			if (fs.fileHighlighted == fileNum) changeState(HOVER);
			
			
			epAddList(addList);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			tsm = null;
			fs = null;
			dsf = null;
			textList.length = 0;
		}
		// --------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			dsf = world.getInstance(Game.NAME_DeleteSaveFile) as DeleteSaveFile;
			
			
			super.update();
			
			
			updateHighlighted();
			updateAlpha();
		}
		
		private function updateHighlighted():void
		{
			if (tsm.currentSectionNum == tsm.FILESELECT)
			{
				changeState(NORMAL);
				
				if (fs.fileHighlighted == fileNum && !dsf)
				{
					if (!highlighted)
					{
						if (!tween.active) Sounds.tick3();
						highlighted = true;
					}
					
					changeState(HOVER);
				}
				else highlighted = false;
			}
		}
		
		private function updateAlpha():void
		{
			panelFillImage.alpha = getFillAlpha();
			panelOutlineImage.alpha = getOutlineAlpha();
		}
		// --------------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (fileNum == fs.fileHighlighted) super.interactivity();
		}
		
		override public function click():void 
		{
			super.click();
			
			
			if (tsm.currentSectionNum == tsm.FILESELECT && !dsf) tsm.navTitleMenu();
		}
		// --------------------------------------------------------------------------------
		
		
		private function getFillAlpha():Number
		{
			if (fs.fileHighlighted == fileNum && !blinkState) return .4;
			return .2;
		}
		
		private function getOutlineAlpha():Number
		{
			if (fs.fileHighlighted == fileNum && !blinkState) return 1;
			return .7;
		}
		// --------------------------------------------------------------------------------
		
		
		override public function changeStateNormal():void 
		{
			alphaOffset = normalOffset;
		}
		
		override public function changeStateHover():void 
		{
			alphaOffset = hoverOffset;
		}
		
		override public function changeStateDown():void 
		{
			alphaOffset = hoverOffset;
		}
		// --------------------------------------------------------------------------------
		
		
		public function onNewSaveFile():void
		{
			blink();
			
			
			fileTitle.changeText("File " + fileNum.toString());
			
			roomsCompleteText = new TextPlus(roomsCompleteStr + "0", 0, 0, { alignCenterX: homeCoords.x + (panelFillImage.width * .5), alignCenterY: y + (Math.round(panelFillImage.height / 3) * 2) } );
			epAdd(roomsCompleteText);
			
			deleteFileBtn = new DeleteButton(this);
			epAdd(deleteFileBtn);
			
			fs.objectsToTween.push(roomsCompleteText, deleteFileBtn);
		}
		
		public function onDeleteSaveFile():void
		{
			fileState = -1;
			
			JS.splice(fs.objectsToTween, deleteFileBtn);
			JS.splice(fs.objectsToTween, roomsCompleteText);
			
			JS.splice(fs.objectsToTween, line1);
			
			epRemoveList([deleteFileBtn, roomsCompleteText, line1]);
			fileTitle.changeText("New File");
		}
		// --------------------------------------------------------------------------------
		
		
		private function blink():void
		{
			if (!blinkState) blinkState = true; // Sets the alpha low
			else blinkState = false; // Sets the alpha high
			
			
			if (blinkCount < BLINKLIMIT)
			{
				FP.alarm(BLINKDURATION, blink);
				blinkCount++;
			}
			else
			{
				active = true, blinkState = false;
				blinkCount = 0;
			}
		}
		// --------------------------------------------------------------------------------
		
		
		private function setCoords():void
		{
			homeCoords.x = ((padX + panelFillImage.width) * (fileNum - 1)) + padX;
			homeCoords.y = HOMECOORDY;
			
			
			var posOrNeg:int = 1; // 1 will place right of screen, -1 will place left of screen
			if (fs.fromMenu) posOrNeg = -1;
			x = homeCoords.x + (FP.width * posOrNeg);
			y = homeCoords.y;
			
			panelFill.x = x, panelFill.y = y;
			panelFill.homeCoords.x = homeCoords.x;
			panelFill.homeCoords.y = homeCoords.y;
			panelOutline.centerOnPoint(panelOutlineImage.width, panelOutlineImage.height, panelFill.x + (panelFillImage.width * .5), panelFill.y + (panelFillImage.height * .5));
			panelOutline.homeCoords.x = (panelFill.homeCoords.x + (panelFillImage.width * .5)) - (panelOutlineImage.width * .5);
			panelOutline.homeCoords.y = (panelFill.homeCoords.y + (panelFillImage.height * .5)) - (panelOutlineImage.height * .5);
		}
		
		private function setText():void
		{
			// File Title text
			if (fileState == 1) fileTitleStr = "File " + fileNum.toString();
			else if (fileState == -1) fileTitleStr = "New File";
			
			fileTitle = new TextPlus(fileTitleStr, 0, 0, { size: 32, alignCenterX: homeCoords.x + (panelFillImage.width * .5), alignCenterY: y + Math.round(panelFillImage.height / 3), backOffset: 2, backAlpha: .5 } );
			fileTitle.centerHor(fileTitle.textWidth, x + (panelFillImage.width * .5));
			
			textList.push(fileTitle);
			
			
			
			// roomsCompleteText & deleteFileBtn & line1
			if (fileState == 1)
			{
				// roomsCompleteText
				roomsCompleteStr += SaveFileData.getRoomCompleteCount(fileNum).toString();
				
				roomsCompleteText = new TextPlus(roomsCompleteStr, 0, 0, { alignCenterX: homeCoords.x + (panelFillImage.width * .5), alignCenterY: y + (Math.round(panelFillImage.height / 3) * 2), backAlpha: .5 } );
				roomsCompleteText.centerHor(roomsCompleteText.textWidth, x + (panelFillImage.width * .5));
				
				textList.push(roomsCompleteText);
				
				
				// deleteFileBtn
				deleteFileBtn = new DeleteButton(this);
				textList.push(deleteFileBtn);
				
				
				// line1
				line1 = new EdgeFadeLine(layer - 1, panelFillImage.width - (LINE1_SIDEPAD * 2), x + (panelFillImage.width * .5), homeCoords.y + panelFillImage.height - LINE1_BOTTOMPAD);
				line1.setHomeXY(homeCoords.x + (panelFillImage.width * .5), homeCoords.y + panelFillImage.height - LINE1_BOTTOMPAD);
				addList.push(line1);
				fs.objectsToTween.push(line1);
			}
		}
		
		public function setStackOrder(layerOffset:int):void
		{
			layer = BASELAYER + layerOffset;
			panelFill.layer = layer;
			panelOutline.layer = layer;
			fileTitle.layer = layer - 1;
			roomsCompleteText.layer = layer - 1;
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
	}

}