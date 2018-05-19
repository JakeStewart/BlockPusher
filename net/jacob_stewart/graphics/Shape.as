package net.jacob_stewart.graphics 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Shape extends EntityPlus 
	{
		public var image:Image;
		
		public var scaleX:Number;
		public var scaleY:Number;
		public var color:uint;
		public var alpha:Number;
		
		
		
		public function Shape(x:Number=0, y:Number=0, layer:int=0, scaleX:Number=1, scaleY:Number=1, color:uint=0xFFFFFF, alpha:Number=1) 
		{
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			this.color = color;
			this.alpha = alpha;
			
			
			super(x, y, null, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			setScale(scaleX, scaleY);
			graphic = image;
		}
		// --------------------------------------------------------------------------------
		
		
		public function setColor(color:uint):void
		{
			this.color = color;
			image.color = color;
		}
		
		public function setAlpha(alpha:uint):void
		{
			this.alpha = alpha;
			image.alpha = alpha;
		}
		
		public function setScale(scaleX:Number=1, scaleY:Number=1):void
		{
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			image.scaleX = scaleX;
			image.scaleY = scaleY;
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
	}

}