package net.jacob_stewart 
{
	import net.flashpunk.Graphic;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Button extends EntityGame 
	{
		public const NORMAL:uint = 0;
		public const HOVER:uint = 1;
		public const DOWN:uint = 2;
		public var state:uint = NORMAL;
		
		public var clicked:Boolean = false;
		
		
		
		public function Button(x:Number=0, y:Number=0, graphic:Graphic=null, layer:int=0) 
		{
			super(x, y, graphic, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = JS.TYPE_Button;
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
			if (state == -1) state = this.state;
			
			switch(state)
			{
				case NORMAL:
					changeStateNormal();
					break;
				case HOVER:
					changeStateHover();
					break;
				case DOWN:
					changeStateDown();
					break;
			}
		}
		
		public function changeStateNormal():void
		{
			
		}
		
		public function changeStateHover():void
		{
			
		}
		
		public function changeStateDown():void
		{
			
		}
		// -------------------------------------------------------------
		
		
		public function click():void
		{
			
		}
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------
		
	}

}