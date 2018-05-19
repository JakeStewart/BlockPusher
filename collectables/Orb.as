package collectables 
{
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.tweens.AlphaPulse;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Orb extends EntityGame 
	{
		private const HBSIZE:uint = 16;
		
		
		
		public function Orb(x:Number=0, y:Number=0, graphic:Graphic=null, layer:int=Game.PUSHBLOCK_LAYER - 1) 
		{
			super(x, y, Images.glowOrb1a, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_Orb;
			epSetHitbox(HBSIZE, HBSIZE, -((Images.glowOrb1a.scaledWidth - HBSIZE) * .5), -((Images.glowOrb1a.scaledHeight - HBSIZE) * .5));
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAdd(new AlphaPulse(addGraphic(new Image(Images.GLOWORB1B)) as Image, 1, .2));
		}
		// -------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------
		
	}

}