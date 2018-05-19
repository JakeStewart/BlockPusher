package gui 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class PanelBackground extends EntityGame 
	{
		private var fill:Image = new Image(Images.MENUPANEL_FILL);
		public var outline:Image = new Image(Images.MENUPANEL_OUTLINE);
		
		private var scaleX:Number;
		private var scaleY:Number;
		private var color:uint;
		private var alpha:Number;
		
		
		
		public function PanelBackground(layer:int = 0, x:Number = 0, y:Number = 0, xOffset:Number = 0, yOffset:Number = 0, scaleX:Number = 1, scaleY:Number = 1, color:uint = 0x000000, alpha:Number = .7) 
		{
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			this.color = color;
			this.alpha = alpha;
			
			outline.scaleX = scaleX;
			outline.scaleY = scaleY;
			fill.scaleX = scaleX;
			fill.scaleY = scaleY;
			
			if (x == -1) x = (FP.halfWidth + xOffset) - (outline.scaledWidth * .5);
			if (y == -1) y = (FP.halfHeight + yOffset) - (outline.scaledHeight * .5);
			
			
			super(x, y, null, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_PanelBackground;
			addGraphic(fill);
			addGraphic(outline);
			
			setXY(x, y);
			setHomeXY(x, y);
			
			outline.color = color, fill.color = color;
			fill.alpha = alpha;
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
	}

}