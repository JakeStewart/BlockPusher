package worlds.room_designer.space_selector 
{
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	
	import net.jacob_stewart.text.TextPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SpaceSelector_TileTypeText extends EntityGame 
	{
		private var ss:SpaceSelector;
		// public static var imgs:Array = [floorImg, wallImg, goalImg, holeImg, switchImg, blueImg, redImg, backAndForthImg, glowOrb1b];
		private var nameStrs:Array = ["Floor", "Wall", "Goal", "Hole", "Switch", "Blue Block", "Red Block", "Sequence", "Orb"];
		public var text:TextPlus = new TextPlus(nameStrs[0], 0, 0, { includeBack: false }, Game.SPACESELECTOR_LAYER - 1);
		private const TILE_PAD:uint = 6;
		private const TWEEN_DURATION:Number = 1;
		private var ease:Function = Ease.quintIn;
		
		public var imageIndex:uint = 0;
		
		
		
		public function SpaceSelector_TileTypeText(ss:SpaceSelector) 
		{
			this.ss = ss;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = Game.SPACESELECTOR_LAYER - 1;
			
			addList.push(this, text);
			ss.addList.push(addList);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			ss.tweens.push(changeText(imageIndex));
		}
		// -------------------------------------------------------------------------------------
		
		
		public function changeText(imageIndex:uint):Tween
		{
			text.changeText(nameStrs[imageIndex]);
			text.changeAlpha(1);
			text.tween = FP.tween(text.front, { alpha: 0 }, TWEEN_DURATION, { ease: ease, tweener: text } );
			
			
			return text.tween;
		}
		// -------------------------------------------------------------------------------------
		
		
		override public function setXY(x:Number, y:Number):void
		{
			this.x = text.centerHor(text.textWidth, x + Game.HALFSPACESIZE);
			this.y = y + Game.SPACESIZE + TILE_PAD;
			text.setXY(this.x, this.y);
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}