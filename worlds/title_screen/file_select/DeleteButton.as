package worlds.title_screen.file_select 
{
	import net.jacob_stewart.text.TextButton;
	
	import worlds.title_screen.InputManager_TS;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class DeleteButton extends TextButton 
	{
		private var host:FileSelectObject;
		private var fs:FileSelectManager;
		private var dsf:DeleteSaveFile;
		private var im:InputManager_TS;
		
		
		
		public function DeleteButton(host:FileSelectObject, onClick:Function=null, text:String="Delete File", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			this.host = host;
			
			
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			changeAlpha(NaN, .3);
			layer = host.layer - 1;
			setHomeXY(Math.round((host.homeCoords.x + (host.panelFillImage.width * .5)) - textHalfWidth), host.homeCoords.y + host.panelFillImage.height - textHeight - 10);
			setXY(Math.round((host.x + (host.panelFillImage.width * .5)) - textHalfWidth), homeCoords.y);
			collidable = false;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			im = world.getInstance(Game.NAME_InputManager) as InputManager_TS;
			fs = world.getInstance(Game.NAME_FileSelectManager) as FileSelectManager;
		}
		
		override public function clearReferences():void 
		{
			super.clearReferences();
			
			
			host = null;
			fs = null;
			dsf = null;
			im = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			epCollidableAndVisible(false);
			
			if (tween != null && fs.fileHighlighted == host.fileNum)
			{
				dsf = world.getInstance(Game.NAME_DeleteSaveFile) as DeleteSaveFile;
				
				if (!dsf)
				{
					epVisible(true);
					if (!tween.active) epCollidable(true);
					
					if (im.deleteSaveFileAlarm != null)
					{
						if (im.deleteSaveFileAlarm.active) changeState(1);
					}
				}
			}
		}
		
		override public function click():void 
		{
			fs.deleteSaveFile();
		}
		// ---------------------------------------------------------------------------------------
		
		
		
		// ---------------------------------------------------------------------------------------
		
	}

}