package gui.options_menu 
{
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OptionsMenuText extends TextButton 
	{
		private var optionsMenu:OptionsMenu;
		public var optionsIndex:uint;
		public var onSelect:Function;
		
		private const ALPHA_UNQUALIFIED:Number = .2;
		private const ALPHA_NORMAL:Number = .5;
		
		
		
		public function OptionsMenuText(optionsIndex:uint, onSelect:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.OPTIONSBASELAYER - 2) 
		{
			this.optionsIndex = optionsIndex;
			this.onSelect = onSelect;
			
			
			super(onSelect, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeSize(20, false);
			changeBackOffset(2);
			normalAlpha = ALPHA_NORMAL;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			optionsMenu = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			optionsMenu = null;
		}
		// -------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateAlpha();
			if (optionsMenu.selector.optionsIndex == optionsIndex) changeState(1);
		}
		
		private function updateAlpha():void
		{
			normalAlpha = ALPHA_NORMAL;
			if (!collidable) normalAlpha = ALPHA_UNQUALIFIED;
		}
		// -------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (optionsMenu.mouseIndex == optionsMenu.selector.optionsIndex) super.interactivity();
		}
		
		public function select():void
		{
			if (onSelect != null) onSelect();
		}
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
	}

}