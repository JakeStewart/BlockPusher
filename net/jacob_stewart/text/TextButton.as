package net.jacob_stewart.text 
{
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.JS;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TextButton extends TextPlus 
	{
		private var onClick:Function;
		public var clicked:Boolean = false;
		
		public const NORMAL:uint = 0;
		public const HOVER:uint = 1;
		public const DOWN:uint = 2;
		public var state:uint;
		
		public const NORMALALPHA:Number = .6;
		public const HOVERALPHA:Number = 1;
		public const DOWNALPHA:Number = NORMALALPHA;
		
		public var normalAlpha:Number = NORMALALPHA;
		public var hoverAlpha:Number = HOVERALPHA;
		public var downAlpha:Number = DOWNALPHA;
		
		public var visibleStates:Array = new Array;
		
		
		
		public function TextButton(onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.onClick = onClick;
			
			
			super(text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = JS.TYPE_TextButton;
			epSetHitbox();
		}
		// -------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			state = NORMAL;
			if (collidable) interactivity();
			if (Input.mouseReleased) clicked = false;
			changeState();
		}
		
		public function interactivity():void
		{
			if (JS.collideMouse(this)) whileCollideMouse();
			else if (clicked) state = HOVER;
		}
		
		public function whileCollideMouse():void
		{
			if (clicked) state = DOWN;
			else state = HOVER;
			
			if (Input.mousePressed) clicked = true;
			if (clicked && Input.mouseReleased) click();
		}
		
		public function changeState(state:int = -1):void 
		{
			if (state != -1) this.state = state;
			changeAlpha(getStateAlpha(), getStateAlpha() * backAlpha);
		}
		// -------------------------------------------------------------
		
		
		public function click():void
		{
			if (onClick != null) onClick();
		}
		
		public function getStateAlpha():Number
		{
			switch(state)
			{
				case NORMAL:
					return normalAlpha;
					break;
				case HOVER:
					return hoverAlpha;
					break;
				case DOWN:
					return downAlpha;
					break;
			}
			
			return normalAlpha;
		}
		// -------------------------------------------------------------
		
		
		override public function changeText(newText:String, alignCenter:Boolean = true, alignRight:Boolean = false):void 
		{
			super.changeText(newText, alignCenter, alignRight);
			epSetHitbox();
		}
		
		override public function changeSize(size:uint, alignCenter:Boolean = true):void 
		{
			super.changeSize(size, alignCenter);
			epSetHitbox();
		}
		
		override public function epSetHitbox(width:uint = 0, height:uint = 0, originX:int = 3, originY:int = 3):void 
		{
			super.epSetHitbox(textWidth + 4, textHeight + 4, originX, originY);
		}
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
	}

}