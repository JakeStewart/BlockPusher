package gui.options_menu 
{
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Keys;
	
	import gui.ListSelector;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class OptionsListSelector extends ListSelector 
	{
		public var optionsMenu:OptionsMenu;
		public var option:OptionsMenuText;
		
		public var optionsIndex:uint = 0;
		public var qualifiedIndices:Array = new Array;
		public var qualifiedIndex:uint = 0;
		
		private const RADIUS:uint = 6;
		private const PADDING:uint = 40;
		private const YCORRECTION:uint = 2;
		private var yOffset:uint = RADIUS;
		
		
		
		public function OptionsListSelector(x:Number=0, y:Number=0, layer:int=0, size:uint=12, color:uint=0xFFFFFF, alphaOffset:Number=1)  
		{
			super(x, y, layer, size, color, alphaOffset);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_OptionsListSelector;
			layer = Game.OPTIONSBASELAYER - 2;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			optionsMenu = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu;
			setQualifiedIndices();
			option = optionsMenu.options[optionsIndex];
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			optionsMenu = null;
			option = null;
		}
		// ---------------------------------------------------------------------------------
		
		
		public function changeSelection(key:int):void 
		{
			if (optionsMenu.state == optionsMenu.STATE_HUB)
			{
				// set optionsIndex
				if (Input.pressed(Keys.UP) || Input.pressed(Keys.DOWN))
				{
					if (Input.pressed(Keys.UP))
					{
						if (qualifiedIndex - 1 < 0) qualifiedIndex = qualifiedIndices.length - 1;
						else qualifiedIndex--;
					}
					else if (Input.pressed(Keys.DOWN))
					{
						if (qualifiedIndex + 1 > qualifiedIndices.length - 1) qualifiedIndex = 0;
						else qualifiedIndex++;
					}
					
					Sounds.tick3();
				}
				
				optionsIndex = qualifiedIndices[qualifiedIndex];
				option = optionsMenu.options[optionsIndex];
				
				// set new y
				setY(option);
			}
		}
		// ---------------------------------------------------------------------------------
		
		
		private function setQualifiedIndices():void
		{
			for (var i:uint = 0; i < optionsMenu.options.length; i++)
			{
				option = optionsMenu.options[i];
				if (option.collidable || option.text == "Sound FX" || option.text == "Music") qualifiedIndices.push(i);
			}
		}
		
		public function setCoords(option:OptionsMenuText):void
		{
			// set x
			x = Math.round(option.x - ((RADIUS * 2) + PADDING));
			
			// set y
			setY(option);
			
			// set homeCoords
			homeCoords.x = x;
		}
		
		public function setY(option:OptionsMenuText):void
		{
			this.option = option; // Need this for OptionsMenuText alpha
			y = Math.round(option.y + option.textHalfHeight - YCORRECTION - yOffset);
			homeCoords.y = y;
		}
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------
		
	}

}