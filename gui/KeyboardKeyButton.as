package gui 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.Button;
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class KeyboardKeyButton extends Button 
	{
		private const BASELAYER:int = -2;
		private var image:Image = new Image(Images.KEYBOARD_KEY1);
		private var alphaStateVals:Array = [.73, 1, .5];
		
		private var onClick:Function;
		
		private const TEXTSIZE:uint = 24;
		private const TEXT_XYCORRECTION:uint = 1;
		private const BACKALPHA_OFFSET:Number = 0;
		
		private var keyName:String;
		private var key:int;
		private var text:TextPlus;
		
		
		
		public function KeyboardKeyButton(keyName:String, key:int, onClick:Function=null, x:Number=0, y:Number=0, alignX:Number=0, alignY:Number=0) 
		{
			this.keyName = keyName;
			this.key = key;
			this.onClick = onClick;
			
			if (x == -1) x = centerHor(image.width, alignX);
			if (y == -1) y = centerHor(image.height, alignY);
			
			
			super(x, y, null, BASELAYER);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_KeyboardKeyButton;
			
			text = new TextPlus(keyName, 0, 0, { size: TEXTSIZE, alignCenterX: x + (image.width * .5) + TEXT_XYCORRECTION, alignCenterY: y + (image.height * .5) + TEXT_XYCORRECTION }, BASELAYER - 1);
			
			changeState(NORMAL);
			
			graphic = image;
			epSetHitboxTo(image);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList([text]);
		}
		
		override public function update():void 
		{
			super.update();
			
			
			if (Input.pressed(key)) changeState(HOVER);
		}
		
		override public function interactivity():void 
		{
			if (collidable) super.interactivity();
		}
		
		override public function changeState(state:int = -1):void 
		{
			if (state == -1) state = this.state;
			image.alpha = alphaStateVals[state];
			text.changeAlpha(alphaStateVals[state], alphaStateVals[state] * BACKALPHA_OFFSET);
		}
		
		override public function click():void 
		{
			if (onClick != null) onClick();
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}