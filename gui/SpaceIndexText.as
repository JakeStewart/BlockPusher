package gui 
{
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SpaceIndexText extends TextPlus 
	{
		public var roomIndex:int;
		public var host:EntityPlus;
		
		
		
		public function SpaceIndexText(host:EntityPlus, roomIndex:int = -1) 
		{
			this.host = host;
			this.roomIndex = roomIndex;
			
			
			super(roomIndex.toString(), 0, 0, { alignCenterX: host.x + Game.HALFSPACESIZE, alignCenterY: host.y + Game.HALFSPACESIZE }, -5);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SpaceIndexText;
			changeAlpha(NaN, .4);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			host = null;
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}