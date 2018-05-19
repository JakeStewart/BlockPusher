package net.jacob_stewart.graphics 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class ScreenTint extends EntityPlus 
	{
		public var image:Image;
		
		
		
		public function ScreenTint(layer:int=0, alpha:Number=.7, color:uint=0x000000) 
		{
			image = Image.createRect(FP.width, FP.height, color, alpha);
			
			
			super(0, 0, image, layer);
		}
		// ----------------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------------
		
	}

}