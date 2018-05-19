package  
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Keys;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * For managing input to avoid conflicts
	 */
	public class InputManager extends EntityGame 
	{
		public var clicked:Boolean = false;
		public var mp:MousePointerGame;
		
		
		
		public function InputManager(mp:MousePointerGame) 
		{
			this.mp = mp;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_InputManager;
			name = Game.NAME_InputManager;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			mp = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			keyboard();
			mouse();
		}
		// -----------------------------------------------------------------------------
		
		
		public function activate():void
		{
			epActive(true);
		}
		// -----------------------------------------------------------------------------
		
		
		public function keyboard():void
		{
			if (Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER)) selectKeys();
			else if (Input.pressed(Key.ESCAPE)) escapeKey();
			else if (Input.pressed(Keys.DIR)) arrowKeys(Input.lastKey);
			else if (Input.pressed(Key.ANY)) anyKey(Input.lastKey);
		}
		
		public function selectKeys():void
		{
			
		}
		
		public function escapeKey():void
		{
			
		}
		
		public function arrowKeys(key:int):void
		{
			
		}
		
		public function anyKey(key:int):void
		{
			
		}
		// -----------------------------------------------------------------------------
		
		
		public function mouse():void
		{
			mouseCollide();
			if (Input.mousePressed) mousePressed();
			if (Input.mouseReleased) mouseReleased();
			if (Input.mouseDown) mouseDown();
		}
		
		public function mouseCollide():void
		{
			
		}
		
		public function mousePressed():void
		{
			
		}
		
		public function mouseReleased():void
		{
			
		}
		
		public function mouseDown():void
		{
			
		}
		
		public function click():void
		{
			
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}