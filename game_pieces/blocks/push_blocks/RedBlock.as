package game_pieces.blocks.push_blocks 
{
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.EntityPlus;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class RedBlock extends PushBlock 
	{
		private var dotImg:Image = new Image(Images.REDDOT1);
		private var dot:EntityPlus;
		
		/**
		 * Stores either a value of 99 or GamePlayManager.movesMade value upon moving from home space
		 * An int is needed so a RedBlock is not moved back to its home space right after it's moved
		 */
		public var moveNum:uint = 99;
		
		
		
		public function RedBlock() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			colors = [0xEA5050, 0xfa7f7f, 0xcd3939];
			subType = Game.SUBTYPE_RedBlock;
			
			dot = new EntityPlus(0, 0, dotImg);
			dot.layer = -2;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAdd(dot);
			dot.x = x, dot.y = y;
		}
		// -------------------------------------------------------------------------
		
		
		override public function updateCollidable():void 
		{
			super.updateCollidable();
			
			
			if (collidable && roomIndex != homeSpace) collidable = false;
		}
		// -------------------------------------------------------------------------
		
		
		override public function makeMove(dirVal:uint):void 
		{
			super.makeMove(dirVal);
			
			
			moveNum = gpm.movesMade;
		}
		// -------------------------------------------------------------------------
		
		
		override public function _EntityGame(x:Number, y:Number, spaceNum:int = -1):EntityGame 
		{
			homeCoords.x = x, homeCoords.y = y;
			
			
			return super._EntityGame(x, y, spaceNum);
		}
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
	}

}