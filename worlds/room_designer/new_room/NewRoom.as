package worlds.room_designer.new_room 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.text.TextPlus;
	
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class NewRoom extends EntityGame 
	{
		private var rd:RoomDesigner;
		private var newRoomBtn:NewRoomButton;
		
		private static const BASELAYER:int = -5;
		public static const TEXTLAYER:int = BASELAYER - 1;
		
		private const ALPHA_SCREENTINT:Number = .7;
		private const DURATION_SCREENTINT:Number = .2;
		private var screenTint:ScreenTint = new ScreenTint(BASELAYER, 0);
		
		private const TEXT_MAXWIDTH:uint = Math.round(FP.width * .65);
		private const STR_ADDROOM:String = "Add design to playlist before starting a new one?";
		private const STR_SAVECHANGES:String = "Save changes to your design before starting a new one?";
		private const STR_REQUIREMENTS:String = "A design requires at least one blue or red block AND at least one goal tile before it can be saved.";
		private var warning1:TextPlus = new TextPlus(STR_SAVECHANGES, 0, 240, { size: 18, alignCenterX: FP.halfWidth, backOffset: 2 }, TEXTLAYER);
		private var warning2:TextPlus = new TextPlus(STR_REQUIREMENTS, 0, 420, { size: 18, alignCenterX: FP.halfWidth, backOffset: 2 }, TEXTLAYER);
		
		private const BTNSPACING:uint = 120;
		private const LEADING:uint = 50;
		private const BTNY:Number = Math.round(warning1.y + warning1.textHeight + LEADING);
		private var yesBtn:NewRoomButton = new NewRoomButton(0, save, "Yes", 0, BTNY, { alignCenterX: FP.halfWidth - BTNSPACING } );
		private var noBtn:NewRoomButton = new NewRoomButton(1, startNewRoom, "No", 0, BTNY, { alignCenterX: FP.halfWidth} );
		private var cancelBtn:NewRoomButton = new NewRoomButton(2, cancelNewRoom, "Cancel", 0, BTNY, { alignCenterX: FP.halfWidth + BTNSPACING} );
		private var btns:Array = [yesBtn, noBtn, cancelBtn];
		public var btnsIndex:uint = 0;
		
		private var guiList:Array = [warning1, btns];
		
		public var mouseIndex:int = -1;
		
		
		
		public function NewRoom() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_NewRoom;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			rd.im.state = rd.im.NEWROOM;
			
			if (!askSave()) rd.startNewRoom();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			newRoomBtn = null;
			btns.length = 0;
			guiList.length = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			updateMouseIndex();
		}
		// --------------------------------------------------------------------------------------
		
		
		private function askSave():Boolean
		{
			// If the design began from a room on the playlist
			if (rd.playlistFileName != RoomData.NOTONFILE)
			{
				var xmlFileIndex:int = new int(rd.playlistFileName.slice(RoomData.XMLFILEPREFIX.length, rd.playlistFileName.length));
				xmlFileIndex--;
				
				if (xmlFileIndex > -1)
				{
					if (!RoomData.draftIsDifferent(rd.playlistFileName, true, xmlFileIndex)) return false;
				}
				// If the design is NOT different from the playlist room it started from AND the room name is NOT different from the playlist room it started from
				else if (!RoomData.draftIsDifferent(rd.playlistFileName) && !rd.saveQualifier.isDifferentRoomName()) return false;
			}
			
			
			warningSetup();
			epAdd(screenTint);
			screenTint.tween = FP.tween(screenTint.image, { alpha: ALPHA_SCREENTINT }, DURATION_SCREENTINT, { tweener: screenTint } );
			epAddList(guiList);
			
			
			return true;
		}
		// --------------------------------------------------------------------------------------
		
		
		public function keyPressed():void
		{
			if (Input.pressed(Keys.SELECT))
			{
				Sounds.select1();
				
				if (btnsIndex == 0) save();
				else if (btnsIndex == 1) startNewRoom();
				else if (btnsIndex == 2) cancelNewRoom();
			}
			else if (Input.pressed(Keys.CANCEL))
			{
				cancelNewRoom();
			}
			else if (Input.pressed(Keys.HOR))
			{
				if (Input.pressed(Keys.LEFT) && btnsIndex > 0) changeBtnsIndex(btnsIndex - 1);
				else if (Input.pressed(Keys.RIGHT) && btnsIndex < 2) changeBtnsIndex(btnsIndex + 1);
			}
		}
		
		private function updateMouseIndex():void
		{
			newRoomBtn = collide(JS.TYPE_TextButton, world.mouseX, world.mouseY) as NewRoomButton;
			
			if (newRoomBtn) // while mouse is colliding with one of the btns
			{
				if (mouseIndex == -1)
				{
					// This will only happen once during collision and will not happen 
					// again until the mouse stops colliding and then collides again
					changeBtnsIndex(newRoomBtn.btnsIndex);
					mouseIndex = newRoomBtn.btnsIndex;
				}
			}
			else
			{
				mouseIndex = -1; // while mouse is NOT colliding with a btn
			}
		}
		
		private function changeBtnsIndex(btnsIndex:uint):void
		{
			this.btnsIndex = btnsIndex;
			Sounds.tick3();
		}
		// --------------------------------------------------------------------------------------
		
		
		private function deactivate(onComplete:Function):void
		{
			rd.im.state = -1;
			screenTint.tween.cancel();
			screenTint.tween = FP.tween(screenTint.image, { alpha: 0 }, DURATION_SCREENTINT, { complete: onComplete, tweener: screenTint } );
			epRemoveList(guiList);
		}
		
		public function startNewRoom():void
		{
			deactivate(rd.startNewRoom);
		}
		
		public function cancelNewRoom():void
		{
			Sounds.knock1();
			deactivate(removeThis);
		}
		
		private function save():void
		{
			if (rd.saveQualifier.isPlayableRoom()) // make sure it's a playable room
			{
				// save
				if (warning1.text == STR_ADDROOM) // Add room to playlist
				{
					rd.saveRoomData(null, true); // Also gives RoomDesigner.playlistFileName a value
					rd.updateDraftData(); // So the draft file has a value for 'Data.readString("playlistFileName")'
					
					rd.addRoomBtn.statusText.changeText(rd.addRoomBtn.hasBeenAddedStr);
					rd.addRoomBtn.statusText.changeAlpha(rd.addRoomBtn.HASBEENHALPHA);
				}
				else if (warning1.text == STR_SAVECHANGES) // Save changes to playlist room
				{
					rd.saveRoomData(rd.playlistFileName);
				}
				
				
				deactivate(rd.startNewRoom);
			}
			else if (!warning2.world)
			{
				guiList.push(warning2);
				epAdd(warning2);
				
				if (warning2.front.width > TEXT_MAXWIDTH)
				{
					warning2.front.wordWrap = true, warning2.front.width = TEXT_MAXWIDTH;
					if (warning2.back) warning2.back.wordWrap = true, warning2.back.width = TEXT_MAXWIDTH;
					warning2.centerHor(TEXT_MAXWIDTH);
					warning2.front.align = "center";
					if (warning2.back) warning2.back.align = "center";
				}
			}
		}
		// --------------------------------------------------------------------------------------
		
		
		override public function removeThis():Entity 
		{
			rd.im.state = rd.im.HUB;
			
			
			return super.removeThis();
		}
		// --------------------------------------------------------------------------------------
		
		
		private function warningSetup():void
		{
			if (rd.playlistFileName == RoomData.NOTONFILE) warning1.changeText(STR_ADDROOM);
		}
		// --------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------
		
	}

}