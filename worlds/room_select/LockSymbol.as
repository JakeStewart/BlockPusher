package worlds.room_select 
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class LockSymbol extends EntityGame 
	{
		private var rs:RoomSelect;
		private var image:Image = new Image(Images.LOCKSYMBOL);
		
		private const XOFFSET:uint = 6;
		private const CENTERPOINT:Point = new Point(FP.width - ScrollRoomButton.CENTERXSCREENOFFSET1X - XOFFSET, FP.halfHeight);
		
		private const ALPHA:Number = 1;
		private const ALPHAOFFSET_LOW:Number = .7;
		private var alphaOffset:Number = 1;
		
		private var visibleStates:Array = new Array;
		
		
		
		public function LockSymbol() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -6;
			graphic = image;
			centerOnPoint(image.scaledWidth, image.scaledHeight, CENTERPOINT.x, CENTERPOINT.y);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rs = world.getInstance(Game.NAME_RoomSelect) as RoomSelect;
			visibleStates.push(rs.im.STATE_MAIN, rs.im.SCROLLING, rs.im.STATE_UDW);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			rs = null;
		}
		// ----------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateVisibility();
			updateAlpha();
		}
		
		private function updateVisibility():void
		{
			visible = false;
			if (rs.fileNameIndex == rs.uncompletedRoomNum && visibleStates.indexOf(rs.im.state) != -1) visible = true;
		}
		
		private function updateAlpha():void
		{
			alphaOffset = 1;
			if (rs.im.state != rs.im.STATE_MAIN) alphaOffset = ALPHAOFFSET_LOW;
			image.alpha = ALPHA * alphaOffset;
		}
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
	}

}