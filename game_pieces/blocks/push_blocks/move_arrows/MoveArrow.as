package game_pieces.blocks.push_blocks.move_arrows 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import net.jacob_stewart.Button;
	
	import game_pieces.blocks.push_blocks.PushBlock;
	import worlds.game_play.GamePlayManager;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class MoveArrow extends Button 
	{
		private var gpm:GamePlayManager;
		private var alphaTo:Number;
		public var directionVal:uint;
		
		private var homeCoordsOffsets:Array = [ [6, -20], [40, 6], [6, 40], [ -20, 6] ];
		
		private var parentBlock:PushBlock;
		
		public var img:Image;
		public var normal:Image;
		public var hover:Image;
		public var down:Image;
		
		
		
		public function MoveArrow() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			layer = -4;
			type = Game.TYPE_MoveArrow;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
			
			img = normal;
			graphic = img;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			if (tween) tween.cancel();
			
			gpm = null;
			parentBlock = null;
			img = null;
		}
		// ------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updateCollidableAndVisible();
			
			
			super.update();
		}
		
		private function updateCollidableAndVisible():void
		{
			epCollidableAndVisible(false);
			if (gpm.blockPendingMove == parentBlock && parentBlock.directionIsAvailable[directionVal]) epCollidableAndVisible(true);
		}
		// ------------------------------------------------------------------------
		
		
		override public function click():void 
		{
			super.click();
			
			
			if (collidable) moveBlock();
		}
		
		override public function changeStateNormal():void 
		{
			normal.alpha = img.alpha;
			img = normal;
			graphic = img;
		}
		
		override public function changeStateHover():void 
		{
			hover.alpha = img.alpha;
			img = hover;
			graphic = img;
		}
		
		override public function changeStateDown():void 
		{
			down.alpha = img.alpha;
			img = down;
			graphic = img;
		}
		// ------------------------------------------------------------------------
		
		
		public function moveBlock():void
		{
			gpm.blockPendingMove.makeMove(directionVal);
			gpm.setBlockPendingMove(null);
		}
		// ------------------------------------------------------------------------
		
		
		public function activate():void
		{
			img.alpha = 1;
			alphaTo = 1;
			tweenAlpha();
			collidable = true;
		}
		
		public function deactivate():void
		{
			collidable = false;
		}
		
		public function setValues(parentBlock:PushBlock):void
		{
			this.parentBlock = parentBlock;
			homeCoords.x = this.parentBlock.x + homeCoordsOffsets[directionVal][0];
			homeCoords.y = this.parentBlock.y + homeCoordsOffsets[directionVal][1];
			x = homeCoords.x, y = homeCoords.y;
		}
		
		private function tweenAlpha():void
		{
			if (gpm.blockPendingMove == parentBlock)
			{
				if (alphaTo == 1) alphaTo = .3;
				else alphaTo = 1;
				tween = FP.tween(img, { alpha: alphaTo }, .5, { complete: tweenAlpha, tweener: this } );
			}
		}
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------
		
	}

}