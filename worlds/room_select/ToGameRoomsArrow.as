package worlds.room_select 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.Button;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ToGameRoomsArrow extends Button 
	{
		private var rs:RoomSelect;
		private var image:Image = new Image(Images.TOGAMEROOMSARROW);
		
		private const SCREENPAD:uint = 12;
		
		private const NORMALALPHA:Number = .6;
		private const HOVERALPHA:Number = 1;
		private const DOWNALPHA:Number = NORMALALPHA;
		private var normalAlpha:Number = NORMALALPHA;
		private var hoverAlpha:Number = HOVERALPHA;
		private var downAlpha:Number = DOWNALPHA;
		private var alphaStateVals:Array = [NORMALALPHA, HOVERALPHA, DOWNALPHA];
		private var alphaOffset:Number = 1;
		private const ALPHAOFFSETLOW:Number = .7; // .5
		
		private var text:TextPlus = new TextPlus("Game Rooms", 0, SCREENPAD + image.height + 8, { alignCenterX: FP.halfWidth, backOffset: 2, backAlpha: .3 } );
		private const TEXTLOWALPHA:Number = .6; // .4
		private var userFilePrefix:String = RoomData.getUserPrefix();
		
		
		
		public function ToGameRoomsArrow() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -6;
			graphic = image;
			x = FP.halfWidth - (image.width * .5);
			y = SCREENPAD;
			epSetHitbox(text.textWidth, (text.y + text.textHeight) - y, x - text.x);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rs = world.getInstance(Game.NAME_RoomSelect) as RoomSelect;
			epAdd(text);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			rs = null;
		}
		// -------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateStates();
			updateTextAlpha();
			
			
			super.update();
		}
		
		private function updateStates():void
		{
			epCollidable(false);
			if (rs.fileNamePrefix == userFilePrefix && rs.collidable && rs.im.state == rs.im.STATE_MAIN) epCollidable(true);
			
			epVisible(false);
			if (rs.fileNamePrefix == userFilePrefix) epVisible(true);
			
			alphaOffset = 1;
			if (!rs.collidable || rs.im.state != rs.im.STATE_MAIN) alphaOffset = ALPHAOFFSETLOW;
		}
		
		private function updateTextAlpha():void
		{
			text.changeAlpha(1, 1);
			if (!rs.collidable || rs.im.state != rs.im.STATE_MAIN) text.changeAlpha(TEXTLOWALPHA, TEXTLOWALPHA);
		}
		// -------------------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		
		override public function click():void 
		{
			super.click();
			
			
			rs.navGameRooms();
		}
		
		override public function changeState(state:int = -1):void 
		{
			if (state == -1) state = this.state;
			image.alpha = alphaStateVals[state] * alphaOffset;
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}