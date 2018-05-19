package worlds.title_screen.menu 
{
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TitleMenuButton extends TextButton 
	{
		public var btnsIndex:uint;
		private var menu:TitleScreenMenu;
		public var qualified:Boolean = true;
		public const ALPHAUNQUAL:Number = .35;
		private var alpha:Number;
		
		
		
		public function TitleMenuButton(btnsIndex:uint, onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.btnsIndex = btnsIndex;
			
			
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeSize(24);
			changeBackOffset(2);
			centerHor(textWidth), centerVer(textHeight);
			backAlpha = .7;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			menu = world.getInstance(Game.NAME_TitleScreenMenu) as TitleScreenMenu;
			if (collidePoint(x, y, world.mouseX, world.mouseY)) menu.selector.mouseIndex = btnsIndex;
			activationCheck();
			if (!qualified) backOffset = 1;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			menu = null;
		}
		// ------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateCollidable();
			
			
			super.update();
			
			
			if (menu.selector.selectors.indexOf(menu.selector.selector) == btnsIndex) changeState(HOVER);
		}
		
		private function updateCollidable():void
		{
			if (qualified) collidable = true;
			if (menu.tsm.currentSectionNum == menu.tsm.STATS || menu.tsm.currentSectionNum == menu.tsm.OPTIONS) collidable = false;
		}
		// ------------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (menu.selector.mouseIndex == menu.selector.selectors.indexOf(menu.selector.selector)) super.interactivity();
		}
		
		override public function changeState(state:int=-1):void // Need this so super.update() doesn't change alpha to normal
		{
			super.changeState(state);
		}
		// ------------------------------------------------------------------------------
		
		
		public function activationCheck():void
		{
			
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}