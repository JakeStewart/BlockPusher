package net.jacob_stewart.graphics 
{
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Rectangle extends Shape 
	{
		public var rWidth:uint;
		public var rHeight:uint;
		
		
		
		public function Rectangle(rWidth:uint=1, rHeight:uint=1, x:Number=0, y:Number=0, layer:int=0, scaleX:Number=1, scaleY:Number=1, color:uint=0xFFFFFF, alpha:Number=1) 
		{
			this.rWidth = rWidth;
			this.rHeight = rHeight;
			
			
			super(x, y, layer, scaleX, scaleY, color, alpha);
		}
		
		override public function init():void 
		{
			image = Image.createRect(rWidth, rHeight, color, alpha);
			
			
			super.init();
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
	}

}