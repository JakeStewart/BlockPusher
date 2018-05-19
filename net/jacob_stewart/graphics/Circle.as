package net.jacob_stewart.graphics 
{
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Circle extends Shape 
	{
		public var radius:uint;
		
		
		
		public function Circle(radius:uint=1, x:Number=0, y:Number=0, layer:int=0, scaleX:Number=1, scaleY:Number=1, color:uint=0xFFFFFF, alpha:Number=1) 
		{
			this.radius = radius;
			
			
			super(x, y, layer, scaleX, scaleY, color, alpha);
		}
		
		override public function init():void 
		{
			image = Image.createCircle(radius, color, alpha);
			
			
			super.init();
		}
		// --------------------------------------------------------------------------------
		
		
		public function setRadius(value:Number):void
		{
			radius = Math.round(value);
			if (radius < 1) radius = 1;
			image = Image.createCircle(radius, color, alpha);
			graphic = image;
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
	}

}