package worlds.room_select.unsaved_draft_warning 
{
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class UnsavedDraftWarningButton extends TextButton 
	{
		private var udw:UnsavedDraftWarning;
		public var btnsIndex:uint;
		private const ALPHA_NORMAL:Number = .4;
		
		
		
		public function UnsavedDraftWarningButton(btnsIndex:uint, onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.btnsIndex = btnsIndex;
			
			
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = UnsavedDraftWarning.TEXTLAYER;
			changeSize(24);
			changeBackOffset(2);
			normalAlpha = ALPHA_NORMAL;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			udw = world.getInstance(Game.NAME_UnsavedDraftWarning) as UnsavedDraftWarning;
			
			// If the mouse pointer is already over a btn when the btns are added,
			// we don't want that btn to be highlighted, we want it to default to 'Yes' option
			if (collidePoint(x, y, world.mouseX, world.mouseY)) udw.mouseIndex = btnsIndex;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			udw = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			if (udw.btnsIndex == btnsIndex) changeState(HOVER);
		}
		// --------------------------------------------------------------------------------------
		
		
		override public function interactivity():void 
		{
			if (udw.mouseIndex == udw.btnsIndex) super.interactivity();
		}
		// --------------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------------
		
	}

}