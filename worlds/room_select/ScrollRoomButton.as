package worlds.room_select 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Button;
	import net.jacob_stewart.Keys;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ScrollRoomButton extends Button 
	{
		private var rs:RoomSelect;
		public var img:Image;
		
		private static const SCREENPAD1X:uint = 30;
		private static const SCREENPAD10X:uint = 20;
		public static const CENTERXSCREENOFFSET1X:uint = Math.round(SCREENPAD1X + (Images.rsArrow1Next.width * .5));
		private static const CENTERXSCREENOFFSET10X:uint = Math.round(SCREENPAD10X + (Images.rsArrow10Next.width * .5));
		
		private const NORMALALPHA:Number = .6;
		private const HOVERALPHA:Number = 1;
		private var normalAlpha:Number = NORMALALPHA;
		private var hoverAlpha:Number = HOVERALPHA;
		private var downAlpha:Number = normalAlpha;
		
		private var roomDiff:int;
		public var arrowNum:uint;
		
		private const SCREENEDGE_PAD_SIDE:uint = 20;
		private const SCREENEDGE_PAD_TOP:uint = 30;
		
		private var keyName:String;
		
		
		
		public function ScrollRoomButton(arrowNum:uint, x:Number=0, y:Number=0) 
		{
			this.arrowNum = arrowNum;
			
			
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -6;
			
			img = Images.rsArrows[arrowNum];
			graphic = img;
			
			setValues();
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rs = world.getInstance(Game.NAME_RoomSelect) as RoomSelect;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			rs = null;
		}
		// --------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateCollidable();
			updateVisible();
			
			
			super.update();
			
			
			alphaWithKeyHeld();
		}
		
		private function updateCollidable():void
		{
			epCollidable(true);
			if (isUnqualifiedRoom() || rs.im.state != rs.im.STATE_MAIN) epCollidable(false);
		}
		
		private function updateVisible():void
		{
			epVisible(true);
			if (isUnqualifiedRoom()) epVisible(false);
		}
		
		private function alphaWithKeyHeld():void
		{
			if (Input.check(keyName))
			{
				if (arrowNum < 2 && !Input.check(Key.SHIFT)) changeState(HOVER);
				else if (arrowNum > 1 && Input.check(Key.SHIFT)) changeState(HOVER);
			}
		}
		// --------------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		
		override public function click():void 
		{
			super.click();
			
			
			rs.changeRoom(roomDiff);
		}
		// --------------------------------------------------------------------------------
		
		
		override public function changeStateNormal():void 
		{
			img.alpha = normalAlpha;
		}
		
		override public function changeStateHover():void 
		{
			img.alpha = hoverAlpha;
		}
		
		override public function changeStateDown():void 
		{
			img.alpha = downAlpha;
		}
		// --------------------------------------------------------------------------------
		
		
		private function isUnqualifiedRoom():Boolean
		{
			if (arrowNum == 0 || arrowNum == 2) // Next
			{
				if (rs.fileNameIndex == rs.roomCount || rs.fileNameIndex >= rs.uncompletedRoomNum) return true;
			}
			else // Prev
			{
				if (rs.fileNameIndex == 1) return true;
			}
			
			
			return false;
		}
		
		private function setValues():void
		{
			switch (arrowNum)
			{
				case 0: // Next room x1
					
					x = FP.width - CENTERXSCREENOFFSET1X - (img.width * .5);
					y = FP.halfHeight - (img.height * .5);
					epSetHitbox(35, 62);
					roomDiff = 1;
					keyName = Keys.RIGHT;
					
					break;
				
				case 1: // Prev room x1
					
					x = CENTERXSCREENOFFSET1X - (img.width * .5);
					y = FP.halfHeight - (img.height * .5);
					epSetHitbox(35, 62);
					roomDiff = -1;
					keyName = Keys.LEFT;
					
					break;
				
				case 2: // Next room x10
					
					x = FP.screen.width - img.width - SCREENEDGE_PAD_SIDE;
					y = SCREENEDGE_PAD_TOP;
					epSetHitbox(12, 20);
					roomDiff = 10;
					keyName = Keys.RIGHT;
					
					break;
				
				case 3: // Prev room x10
					
					x = SCREENEDGE_PAD_SIDE;
					y = SCREENEDGE_PAD_TOP;
					epSetHitbox(12, 20);
					roomDiff = -10;
					keyName = Keys.LEFT;
					
					break;
			}
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}