package worlds.title_screen.menu 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	
	import gui.ListSelector;
	import worlds.title_screen.TitleScreenWorld;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MenuListSelector extends EntityGame 
	{
		private var menu:TitleScreenMenu;
		private var btn:TitleMenuButton;
		public var option:TitleMenuButton;
		public var selector:ListSelector;
		
		
		private const RADIUS:uint = 6;
		private const PADDING:uint = 60;
		private const YCORRECTION:uint = 2;
		private var yOffset:uint = RADIUS; // Square
		
		public var mouseIndex:int = -1;
		private var qualifiedIndex:uint = 0;
		private var qualifiedIndices:Array = new Array;
		
		public var selectors:Array = new Array;
		
		
		
		public function MenuListSelector(menu:TitleScreenMenu) 
		{
			this.menu = menu; // So that setCoords() can be called in init() so that homeCoords is set before added()
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_MenuListSelector;
			layer = -4;
			
			
			setQualifiedIndices();
			option = getWidest();
			createSelectors(Math.round(option.x - ((RADIUS * 2) + PADDING)), option.homeCoords.x - ((RADIUS * 2) + PADDING));
			
			selector = selectors[0];
			selector.visible = true;
			option = menu.btns[0];
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList(selectors);
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			menu = null;
			btn = null;
			option = null;
			selector = null;
			selectors.length = 0;
		}
		// -------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateMouseIndex();
		}
		
		private function updateMouseIndex():void
		{
			btn = collide(JS.TYPE_TextButton, world.mouseX, world.mouseY) as TitleMenuButton;
			
			
			if (tween && btn)
			{
				if (!tween.active && mouseIndex == -1 && qualifiedIndices.indexOf(btn.btnsIndex) != -1)
				{
					mouseIndex = btn.btnsIndex;
					qualifiedIndex = qualifiedIndices.indexOf(btn.btnsIndex);
					if (option != menu.btns[btn.btnsIndex]) changeSelector(btn.btnsIndex);
				}
			}
			
			if (!btn) mouseIndex = -1; // while mouse is NOT colliding with a btn
			else mouseIndex = btn.btnsIndex;
		}
		// -------------------------------------------------------------------------------------
		
		
		public function keyPressed(key:int):void
		{
			// set qualifiedIndex
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
			}
			
			
			// set new selector & option
			changeSelector(qualifiedIndices[qualifiedIndex]);
		}
		// -------------------------------------------------------------------------------------
		
		
		private function changeSelector(index:uint):void
		{
			Sounds.tick3();
			
			// set new selector
			selector.epVisible(false);
			
			selector = selectors[index];
			selector.epVisible(true);
			
			// set new option
			option = menu.btns[index];
		}
		
		private function createSelectors(x:Number, homeX:Number):void
		{
			for (var i:uint = 0; i < menu.btns.length; i++)
			{
				option = menu.btns[i];
				selectors.push(new ListSelector(x, getY(option), layer));
				
				selector = selectors[selectors.length - 1];
				selector.visible = false;
				
				
				// set homeCoords
				if (menu.fromGame) selector.setHomeXY(homeX, selector.y - FP.height);
				else selector.setHomeXY(homeX, selector.y);
				
				menu.objectsToTween.push(selector);
			}
		}
		
		private function getWidest():TitleMenuButton
		{
			var comparer:TitleMenuButton;
			var widest:uint = 0;
			
			for (var i:uint = 1; i < menu.btns.length; i++)
			{
				option = menu.btns[i - 1];
				comparer = menu.btns[i];
				
				if (comparer.textWidth > option.textWidth) widest = i;
			}
			
			return menu.btns[widest];
		}
		
		private function getY(option:TitleMenuButton):Number
		{
			return Math.round(option.y + option.textHalfHeight - YCORRECTION - yOffset);
		}
		// -------------------------------------------------------------------------------------
		
		
		private function setQualifiedIndices():void
		{
			for (var i:uint = 0; i < menu.btns.length; i++)
			{
				option = menu.btns[i];
				if (option.qualified) qualifiedIndices.push(i);
			}
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
		
	}

}