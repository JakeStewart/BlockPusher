package worlds.room_select 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.Button;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ToMyRoomsArrow extends Button 
	{
		private var rs:RoomSelect;
		private var image:Image = new Image(Images.TOMYROOMSARROW);
		
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
		
		private const TEXT_Y:Number = FP.height - SCREENPAD - image.height - JS.getTextHeight(16) - 8;
		private var text:TextPlus = new TextPlus("My Rooms", 0, TEXT_Y, { alignCenterX: FP.halfWidth, backOffset: 2, backAlpha: .3 } );
		private const TEXTLOWALPHA:Number = .6; // .4
		
		
		
		public function ToMyRoomsArrow() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -6;
			graphic = image;
			x = FP.halfWidth - (image.width * .5);
			y = FP.height - (image.height + SCREENPAD);
			epSetHitbox(text.textWidth, (y - text.y) + image.height, x - text.x, y - text.y);
			if (RoomData.getRoomCount(RoomData.getUserPrefix()) == 0) epCollidableAndVisible(false);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rs = world.getInstance(Game.NAME_RoomSelect) as RoomSelect;
			epAdd(text);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
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
			if (rs.fileNamePrefix == RoomData.XMLFILEPREFIX && rs.collidable && rs.im.state == rs.im.STATE_MAIN) epCollidable(true);
			
			epVisible(false);
			if (rs.fileNamePrefix == RoomData.XMLFILEPREFIX) epVisible(true);
			
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
			
			
			rs.navUserRooms();
		}
		
		override public function changeState(state:int = -1):void 
		{
			if (state == -1) state = this.state;
			image.alpha = alphaStateVals[state] * alphaOffset;
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}