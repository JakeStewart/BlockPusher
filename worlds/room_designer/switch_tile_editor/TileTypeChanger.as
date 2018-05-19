package worlds.room_designer.switch_tile_editor 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class TileTypeChanger extends EntityGame 
	{
		private var ss:SpaceSelector_STE;
		
		private var typeText:TextPlus;
		private var imgIndex:uint;
		
		private var arrowY:uint;
		private const ARROWPADDING:uint = 20;
		
		private var arrowNext:TileTypeChangerButton;
		private var arrowPrev:TileTypeChangerButton;
		
		
		
		public function TileTypeChanger(text:String, x:Number=0, y:Number = 560) 
		{
			typeText = new TextPlus(text, 0, y - 26, { alignCenterX: x } );
			
			
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -6;
			x -= 16;
			
			if (x < FP.halfWidth) imgIndex = 1;
			else imgIndex = 0;
			
			arrowY = (y + 16) - 10;
			arrowNext = new TileTypeChangerButton(true, x + 32 + ARROWPADDING, arrowY);
			arrowPrev = new TileTypeChangerButton(false, x - 12 - ARROWPADDING, arrowY);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAdd(typeText);
			
			ss = world.getInstance(Game.NAME_SpaceSelector_STE) as SpaceSelector_STE;
			graphic = Images.imgs[ss.imgIndices[imgIndex]];
			
			epAddList([arrowNext, arrowPrev]);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			ss = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			if (x < FP.halfWidth)
			{
				if (imgIndex != ss.imgIndexA) imgIndex = ss.imgIndexA;
			}
			else
			{
				if (imgIndex != ss.imgIndexB) imgIndex = ss.imgIndexB;
			}
			
			graphic = Images.imgs[ss.imgIndices[imgIndex]];
		}
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------
		
	}

}