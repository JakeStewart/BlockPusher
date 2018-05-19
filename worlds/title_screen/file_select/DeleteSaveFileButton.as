package worlds.title_screen.file_select 
{
	import net.jacob_stewart.text.TextButton;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class DeleteSaveFileButton extends TextButton 
	{
		private var dsf:DeleteSaveFile;
		public var btnsIndex:uint;
		private const ALPHA_NORMAL:Number = .4;
		private var highlighted:Boolean = true;
		
		
		
		public function DeleteSaveFileButton(btnsIndex:uint, onClick:Function=null, text:String="TextPlus", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.btnsIndex = btnsIndex;
			
			
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = DeleteSaveFile.TEXTLAYER;
			changeSize(24);
			changeBackOffset(2);
			normalAlpha = ALPHA_NORMAL;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			dsf = world.getInstance(Game.NAME_DeleteSaveFile) as DeleteSaveFile;
			
			// If the mouse pointer is already over a btn when the btns are added,
			// we don't want that btn to be highlighted, we want it to default to 'Yes' option
			if (collidePoint(x, y, world.mouseX, world.mouseY)) dsf.mouseIndex = btnsIndex;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			dsf = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			if (dsf.btnsIndex == btnsIndex)
			{
				if (!highlighted) Sounds.tick3();
				highlighted = true;
				changeState(1);
			}
			else highlighted = false;
		}
		
		override public function interactivity():void 
		{
			if (dsf.mouseIndex == dsf.btnsIndex) super.interactivity();
		}
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------
		
	}

}