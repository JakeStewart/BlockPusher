package gui.options_menu 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.graphics.Rectangle;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.text.TextButton;
	import net.jacob_stewart.text.TextPlus;
	
	import game_manual.Manual;
	import gui.PanelBackground;
	import gui.options_menu.audio_level_changer.AudioLevelChanger;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OptionsMenu extends EntityPlus 
	{
		public const STATE_HUB:uint = 0;
		public const STATE_MANUAL:uint = 1;
		public const STATE_TWEENING:uint = 2;
		public var state:int = STATE_TWEENING;
		
		
		private var manual:Manual;
		public var manualPage:uint = 0;
		
		private var screenTint:ScreenTint = new ScreenTint(Game.OPTIONSBASELAYER, 0);
		
		private const TINTALPHA:Number = .4;
		private const YOFFSET:uint = FP.height; // For the tweenIn()
		
		public var panel:PanelBackground = new PanelBackground(Game.OPTIONSBASELAYER - 1, -1, -1);
		
		private const PANELSIDEPAD:uint = 10;
		private const TITLEPAD:uint = 16;
		
		
		private const LINEPAD:uint = PANELSIDEPAD;
		private const LINEWIDTH:uint = JS.roundEven(Math.round(panel.outline.scaledWidth - (LINEPAD * 2)));
		private const LINEX1:Number = FP.halfWidth - (LINEWIDTH * .5);
		private const LINEX2:Number = LINEX1 + LINEWIDTH;
		public const LINEY:Number = Math.round(panel.y + JS.getTextHeight(24) + 26 + TITLEPAD);
		
		private const LINE_COLOR:uint = 0xFFFFFF;
		public const LINE_THICK:uint = 2;
		
		private var line:Rectangle = new Rectangle(LINEX2 - LINEX1, LINE_THICK, LINEX1, LINEY, Game.STATSBASELAYER - 2, 1, 1, LINE_COLOR);
		
		
		private const TITLESTR_HUB:String = "OPTIONS";
		private const TITLESTR_CONTROLS:String = "CONTROLS";
		private const TITLESTR_MANUAL:String = "MANUAL";
		private var title:TextPlus = new TextPlus(TITLESTR_HUB, 0, panel.y + TITLEPAD, { size: 24, alignCenterX: FP.halfWidth } );
		
		
		private const OPTIONS_AREA_Y:Number = LINEY + LINE_THICK;
		private const OPTIONS_AREA_HEIGHT:uint = (panel.outline.scaledHeight - Game.PANELTHICK) - (OPTIONS_AREA_Y - panel.y);
		private var spacing:uint;
		
		private var soundFX:OptionsMenuText = new OptionsMenuText(0, null, "Sound FX", panel.x + Game.OPTIONSPAD);
		private var music:OptionsMenuText = new OptionsMenuText(1, null, "Music", panel.x + Game.OPTIONSPAD);
		private var manualOption:OptionsMenuText = new OptionsMenuText(2, runManual, "Manual", panel.x + Game.OPTIONSPAD);
		public var options:Array = [soundFX, music, manualOption];
		
		public var selector:OptionsListSelector = new OptionsListSelector;
		
		private var exitBtnExitStates:Array = [STATE_HUB, STATE_TWEENING];
		private var exitBtnBackStates:Array = [STATE_MANUAL];
		private const STR_EXIT:String = "Exit";
		private const STR_BACK:String = "Back";
		private const EXITBTN_PAD_TOP:uint = 12;
		private const EXITBTN_PAD_SIDE:uint = 10;
		private const EXITBTN_SIZE:uint = 16;
		private var exitBtn:TextButton = new TextButton(exitBtnClick, STR_EXIT, panel.x + panel.outline.scaledWidth - JS.getTextWidth(EXITBTN_SIZE, STR_BACK) - EXITBTN_PAD_SIDE, panel.y + EXITBTN_PAD_TOP, { size: EXITBTN_SIZE }, Game.OPTIONSBASELAYER - 2);
		
		
		private var sfxLevelChanger:AudioLevelChanger;
		private var musicLevelChanger:AudioLevelChanger;
		private const STR_MUTE:String = "Mute";
		private const STR_UNMUTE:String = "Unmute";
		private var muteBtn:TextButton;
		
		
		public var textList:Array = [title, soundFX, music, manualOption, exitBtn];
		private var guiList:Array = [screenTint, panel, line, title, options, selector, exitBtn];
		
		
		public const DURATION:Number = .3;
		private var ease:Function = Ease.quintOut;
		private var tweens:Array = new Array;
		private var objectsToTween:Array = [this, panel, line, selector];
		
		
		private var stateObjectsHub:Array = [options, selector];
		private var stateObjectsManual:Array = new Array;
		private var stateObjects:Array = stateObjectsHub;
		
		public var mouseIndex:int = -1;
		public var option:OptionsMenuText;
		
		
		
		public function OptionsMenu() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_OptionsMenu;
			layer = Game.OPTIONSBASELAYER - 2;
			
			
			line.setHomeXY(line.x, line.y);
			
			spacing = Math.round(OPTIONS_AREA_HEIGHT / (options.length + 1));
			setOptionsY();
			for each (var option:TextPlus in options) option.setHomeXY(option.x, option.y);
			objectsToTween.push(options);
			
			selector.setCoords(options[0]); // sets homeCoords
			objectsToTween.push(selector);
			
			
			sfxLevelChanger = new AudioLevelChanger(0, soundFX.y + soundFX.textHalfHeight);
			musicLevelChanger = new AudioLevelChanger(1, music.y + music.textHalfHeight);
			muteBtn = new TextButton(muteBtnClick, getMuteBtnStr(), sfxLevelChanger.rightBtn.x + sfxLevelChanger.rightBtn.image.scaledWidth + 24, 0, { alignCenterY: sfxLevelChanger.centerCoordY + 1 }, Game.OPTIONSBASELAYER - 2);
			guiList.push(sfxLevelChanger, musicLevelChanger, muteBtn);
			objectsToTween.push(sfxLevelChanger, sfxLevelChanger.bars, sfxLevelChanger.arrowBtns, musicLevelChanger, musicLevelChanger.bars, musicLevelChanger.arrowBtns, muteBtn);
			stateObjectsHub.push(sfxLevelChanger.bars, sfxLevelChanger.arrowBtns, musicLevelChanger.bars, musicLevelChanger.arrowBtns, muteBtn);
			
			
			title.layer = layer;
			objectsToTween.push(textList);
			
			setStartY(objectsToTween);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList(guiList);
			tweenIn();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			// clear references to objects
			option = null;
			manual = null;
			tweens.length = 0;
			options.length = 0;
			textList.length = 0;
			guiList.length = 0;
			objectsToTween.length = 0;
			stateObjectsHub.length = 0;
			stateObjectsManual.length = 0;
		}
		// ------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateMouseIndex();
			updateExitBtn();
			updateMuteBtn();
		}
		
		private function updateMouseIndex():void
		{
			option = collide(JS.TYPE_TextButton, world.mouseX, world.mouseY) as OptionsMenuText;
			
			if (state == STATE_HUB && option) // while mouse is colliding with one of the btns
			{
				if (state != STATE_TWEENING && mouseIndex == -1 && selector.qualifiedIndices.indexOf(selector.optionsIndex) != -1)
				{
					// This will only happen once during collision and will not happen 
					// again until the mouse stops colliding and then collides again
					if (selector.optionsIndex != option.optionsIndex)
					{
						selector.optionsIndex = option.optionsIndex;
						selector.setY(options[selector.optionsIndex]);
						selector.qualifiedIndex = selector.qualifiedIndices.indexOf(selector.optionsIndex);
						mouseIndex = option.optionsIndex;
						
						Sounds.tick3();
					}
				}
			}
			
			
			if (!option) mouseIndex = -1; // while mouse is NOT colliding with a btn
			else mouseIndex = option.optionsIndex;
		}
		
		private function updateExitBtn():void
		{
			if (exitBtnExitStates.indexOf(state) != -1 && exitBtn.text != STR_EXIT) exitBtn.changeText(STR_EXIT, false);
			if (exitBtnBackStates.indexOf(state) != -1 && exitBtn.text != STR_BACK) exitBtn.changeText(STR_BACK, false);
		}
		
		private function updateMuteBtn():void
		{
			muteBtn.changeText(getMuteBtnStr(), false);
		}
		// ------------------------------------------------------------------------
		
		
		public function tweenIn():void
		{
			state = STATE_TWEENING;
			JS.cancelTweens(tweens);
			tweens.push(FP.tween(screenTint.image, { alpha: TINTALPHA }, DURATION, { tweener: screenTint } ));
			tweenEntities(objectsToTween, 0, 0, setStateHub);
			
			Sounds.openOptions2();
		}
		
		public function tweenOut():void
		{
			state = STATE_TWEENING;
			JS.cancelTweens(tweens);
			tweens.push(FP.tween(screenTint.image, { alpha: 0 }, DURATION, { tweener: screenTint } ));
			tweenEntities(objectsToTween, 0, YOFFSET, removeThis);
		}
		
		private function tweenEntities(entities:Array, xOffset:int = 0, yOffset:int = 0, _onComplete:Function=null):void
		{
			var onComplete:Function;
			entities = JS.getArrayAsFlat(entities);
			for each (var e:EntityPlus in entities)
			{
				onComplete = null;
				if (e == entities[entities.length - 1]) onComplete = _onComplete;
				tweens.push(FP.tween(e, { x: e.homeCoords.x + xOffset, y: e.homeCoords.y + yOffset }, DURATION, { complete: onComplete, ease: ease, tweener: e } ));
			}
		}
		// ------------------------------------------------------------------------
		
		
		public function changeSetting(key:int):void
		{
			if (options[selector.optionsIndex] == soundFX) sfxLevelChanger.changeAudioLevel(key);
			else if (options[selector.optionsIndex] == music) musicLevelChanger.changeAudioLevel(key);
		}
		
		private function onKeyCheck(key:int):void
		{
			if (options[selector.optionsIndex] == soundFX) sfxLevelChanger.onKeyCheck(key);
			else if (options[selector.optionsIndex] == music) musicLevelChanger.onKeyCheck(key);
		}
		// ------------------------------------------------------------------------
		
		
		private function setOptionsY():void
		{
			var option:OptionsMenuText;
			
			for (var i:uint = 0; i < options.length; i++)
			{
				option = options[i];
				option.centerVer(option.textHalfHeight, Math.round(OPTIONS_AREA_Y + ((i + 1) * spacing)));
			}
		}
		
		private function setStartY(list:Array):void
		{
			var e:EntityPlus;
			
			for (var i:uint = 0; i < list.length; i++)
			{
				if (list[i] is Array) setStartY(list[i]);
				else
				{
					e = list[i];
					e.y = e.homeCoords.y + YOFFSET;
				}
			}
		}
		// ------------------------------------------------------------------------
		
		
		public function optionSelected():void
		{
			if (state == STATE_HUB && selector.option.onSelect != null)
			{
				Sounds.select1();
				selector.option.select();
			}
		}
		
		private function runHub():void
		{
			epRemoveList(stateObjects);
			stateObjects = stateObjectsHub;
			epAddList(stateObjects);
			
			state = STATE_HUB;
			title.visible = true;
			title.changeText(TITLESTR_HUB);
		}
		
		private function runManual():void
		{
			manual = world.getInstance(Game.NAME_Manual) as Manual;
			if (!manual) manual = new Manual(manualPage);
			stateObjectsManual.push(manual);
			
			epRemoveList(stateObjects);
			stateObjects = stateObjectsManual;
			epAddList(stateObjects);
			
			state = STATE_MANUAL;
			title.visible = false;
		}
		// ------------------------------------------------------------------------
		
		
		private function exitBtnClick():void
		{
			// Sounds.knock1();
			exit();
		}
		
		public function exit():void
		{
			switch (state)
			{
				case STATE_HUB:
					
					
					tweenOut();
					
					break;
					
				case STATE_MANUAL:
					
					
					runHub();
					
					break;
					
				case STATE_TWEENING:
					
					
					tweenOut();
					
					break;
					
				case -1:
					
					
					tweenOut();
					
					break;
			}
			
			if (Input.pressed(Keys.CANCEL)) Sounds.knock1();
		}
		// ------------------------------------------------------------------------
		
		
		private function setStateHub():void
		{
			state = STATE_HUB;
		}
		// ------------------------------------------------------------------------
		
		
		private function muteBtnClick():void
		{
			SaveFileData.toggleMute();
			if (!Sounds.isMute()) Sounds.tick3();
			muteBtn.changeText(getMuteBtnStr(), false);
		}
		
		private function getMuteBtnStr():String
		{
			if (Sounds.isMute()) return STR_UNMUTE;
			return STR_MUTE;
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
	}

}