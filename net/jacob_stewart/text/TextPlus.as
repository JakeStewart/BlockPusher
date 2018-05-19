package net.jacob_stewart.text 
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Ease;
	
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.JS;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TextPlus extends EntityPlus 
	{
		public var front:Text;
		public var back:Text;
		
		public var fontList:Array = ["default", "Arial", "Courier"];
		
		public var text:String;
		public var fontIndex:uint = 0;
		public var size:uint = Text.size;
		public var frontColor:uint = 0xFFFFFF;
		public var frontAlpha:Number = 1;
		
		public var includeBack:Boolean = true;
		public var backOffset:uint = 1;
		public var backColor:uint = 0x000000;
		public var backAlpha:Number = 1;
		
		public var textWidth:uint;
		public var textHalfWidth:Number;
		public var textHeight:uint;
		public var textHalfHeight:Number;
		
		
		
		public function TextPlus(text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.text = text;
			
			if (options)
			{
				if (options.hasOwnProperty("fontIndex")) this.fontIndex = options.fontIndex;
				if (options.hasOwnProperty("size")) this.size = options.size;
				if (options.hasOwnProperty("alignCenterX")) x = options.alignCenterX - (JS.getTextWidth(this.size, text) * .5);
				if (options.hasOwnProperty("alignCenterY")) y = options.alignCenterY - (JS.getTextHeight(this.size, text) * .5);
				if (options.hasOwnProperty("alignRight")) x = options.alignRight - JS.getTextWidth(this.size, text);
				if (options.hasOwnProperty("frontColor")) this.frontColor = options.frontColor;
				if (options.hasOwnProperty("frontAlpha")) this.frontAlpha = options.frontAlpha;
				
				if (options.hasOwnProperty("includeBack")) this.includeBack = options.includeBack;
				if (options.hasOwnProperty("backOffset")) this.backOffset = options.backOffset;
				if (options.hasOwnProperty("backColor")) this.backColor = options.backColor;
				if (options.hasOwnProperty("backAlpha")) this.backAlpha = options.backAlpha;
			}
			
			front = new Text(text, 0, 0, { font: fontList[fontIndex], size: size, color: frontColor, alpha: frontAlpha } );
			if (includeBack) back = new Text(text, backOffset, backOffset, { font: fontList[fontIndex], size: size, color: backColor, alpha: backAlpha } );
			
			
			super(x, y, null, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			if (back) addGraphic(back);
			addGraphic(front);
			
			setDimensionalVals();
			setHomeXY(x, y);
		}
		// -------------------------------------------------------------------------
		
		
		public function alignRight(alignX:Number):void
		{
			x = alignX - textWidth;
		}
		// -------------------------------------------------------------------------
		
		
		public function changeText(newText:String, alignCenter:Boolean = true, alignRight:Boolean = false):void
		{
			var centerX:Number = x + textHalfWidth;
			var rightX:Number = x + textWidth;
			
			text = front.text = newText;
			if (back) back.text = newText;
			setDimensionalVals();
			
			if (alignCenter) centerHor(textWidth, centerX);
			else if (alignRight) this.alignRight(rightX);
		}
		
		public function changeSize(size:uint, alignCenter:Boolean = true):void
		{
			var centerPoint:Point = new Point(x + textHalfWidth, y + textHalfHeight);
			
			this.size = size;
			front.size = size;
			if (back) back.size = size;
			
			setDimensionalVals();
			if (alignCenter) centerOnPoint(textWidth, textHeight, centerPoint.x, centerPoint.y);
		}
		
		public function changeColor(frontColor:uint = NaN, backColor:uint = NaN):void
		{
			if (!isNaN(frontColor))
			{
				this.frontColor = frontColor;
				front.color = frontColor;
			}
			
			if (!isNaN(backColor) && back)
			{
				this.backColor = backColor;
				back.color = backColor;
			}
		}
		
		public function changeAlpha(frontAlpha:Number = NaN, backAlpha:Number = NaN):void
		{
			if (!isNaN(frontAlpha))
			{
				this.frontAlpha = frontAlpha;
				front.alpha = frontAlpha;
			}
			
			if (!isNaN(backAlpha) && back)
			{
				this.backAlpha = backAlpha;
				back.alpha = backAlpha;
			}
		}
		
		public function changeBackOffset(offset:uint):void
		{
			backOffset = offset;
			if (back) back.x = offset, back.y = offset;
		}
		
		public function wordWrap(width:uint):void
		{
			front.wordWrap = true, front.width = width;
			if (back) back.wordWrap = true, back.width = width;
		}
		
		/**
		 * Alignment ("left", "center" or "right").
		 */
		public function align(value:String):void
		{
			front.align = value;
			if (back) back.align = value;
		}
		
		public function setStyle():void
		{
			
			
			/*
			tp.text.setStyle("color", { color: INFOTEXTCOLOR } );
			tp.text.richText = "<color>" + tp.text.text + "</color>";
			if (tp.text.width > 560) tp.text.wordWrap = true, tp.text.width = 560;
			*/
			
			
		}
		// -------------------------------------------------------------------------
		
		
		public function setDimensionalVals():void
		{
			textWidth = front.textWidth;
			textHalfWidth = textWidth * .5;
			textHeight = front.textHeight;
			textHalfHeight = textHeight * .5;
		}
		// -------------------------------------------------------------------------
		
		
		public function tweenAlpha(toAlpha:Number = 1, duration:Number = 0, ease:Function = null, onComplete:Function = null, delay:Number = 0):Array
		{
			var tweens:Array = new Array;
			
			tweens.push(FP.tween(front, { alpha: toAlpha }, duration, { complete: onComplete, ease: ease, tweener: this, delay: delay } ));
			if (back) tweens.push(FP.tween(back, { alpha: toAlpha }, duration, { ease: ease, delay: delay } ));
			
			
			return tweens;
		}
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
	}

}