package net.jacob_stewart.graphics 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class EdgeFadeLine extends EntityPlus 
	{
		public var length:uint;
		public var xCenter:Number;
		public var yCenter:Number;
		public var horizontal:Boolean;
		public var horValue:uint = 1; // Needs to be 0 or 1
		public var verValue:uint = 0; // Needs to be 0 or 1
		public var color:uint;
		public var alphaOffset:uint;
		public var thick:uint;
		
		private var lengthL3:uint;
		private var lengthL2:uint;
		private var lengthL1:uint;
		
		private const TAILBASELENGTH:uint = 4;
		private const TAILENDLENGTH:uint = Math.round(TAILBASELENGTH * .5);
		
		
		
		public function EdgeFadeLine(layer:int, length:uint, xCenter:Number, yCenter:Number, horizontal:Boolean = true, color:uint=0xFFFFFF, alphaOffset:Number=1, thick:uint=1) 
		{
			this.length = length;
			this.xCenter = xCenter;
			this.yCenter = yCenter;
			this.horizontal = horizontal;
			this.color = color;
			this.alphaOffset = alphaOffset;
			this.thick = thick;
			
			if (!horizontal) horValue = 0, verValue = 1;
			
			
			super(getCoord(xCenter, length, horValue, verValue), getCoord(yCenter, length, verValue, horValue), null, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			lengthL3 = length;
			lengthL2 = lengthL3 - (TAILENDLENGTH * 2);
			lengthL1 = lengthL2 - (TAILBASELENGTH * 2);
			
			var image:Image;
			
			addGraphic(Image.createRect(getScaleVal(lengthL3, horValue, verValue), getScaleVal(lengthL3, verValue, horValue), color, .25 * alphaOffset));
			
			image = addGraphic(Image.createRect(getScaleVal(lengthL2, horValue, verValue), getScaleVal(lengthL2, verValue, horValue), color, .5 * alphaOffset)) as Image;
			image.x = getOffset(lengthL2, horValue), image.y = getOffset(lengthL2, verValue);
			
			image = addGraphic(Image.createRect(getScaleVal(lengthL1, horValue, verValue), getScaleVal(lengthL1, verValue, horValue), color, 1 * alphaOffset)) as Image;
			image.x = getOffset(lengthL1, horValue), image.y = getOffset(lengthL1, verValue);
		}
		// --------------------------------------------------------------------------------
		
		
		override public function setHomeXY(x:Number, y:Number):void // parameters x, y should be passed as center coordinates
		{
			super.setHomeXY(getCoord(x, length, horValue, verValue), getCoord(y, length, verValue, horValue));
		}
		// --------------------------------------------------------------------------------
		
		
		private function getOffset(length:uint, axisVal:uint):Number
		{
			return ((lengthL3 - length) * .5) * axisVal;
		}
		
		private function getCoord(centerCoord:Number, length:uint, axisVal:uint, axisVal2:uint):Number
		{
			return centerCoord - ((length * .5) * axisVal) - (Math.round((thick * .5)) * axisVal2);
		}
		
		private function getScaleVal(length:uint, axisVal1:uint, axisVal2:uint):uint
		{
			return (length * axisVal1) + (thick * axisVal2);
		}
		// --------------------------------------------------------------------------------
		
	}

}