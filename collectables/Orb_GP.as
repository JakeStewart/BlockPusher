package collectables 
{
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.utils.Ease;
	
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_GP;
	import worlds.game_play.GamePlayManager;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Orb_GP extends Orb 
	{
		private var gpm:GamePlayManager;
		private var sc:SwitchClient_GP;
		public var collected:Boolean;
		private const SECONDS:Number = 1;
		
		
		
		public function Orb_GP(x:Number=0, y:Number=0, graphic:Graphic=null, layer:int=Game.PUSHBLOCK_LAYER - 1) 
		{
			super(x, y, graphic, layer);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			gpm = world.getInstance(Game.NAME_GamePlayManager) as GamePlayManager;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			gpm = null;
			sc = null;
		}
		// -------------------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateCollidable();
			updateVisible();
		}
		
		private function updateCollidable():void
		{
			collidable = true;
			if (collected) collidable = false;
		}
		
		private function updateVisible():void
		{
			visible = true;
			sc = collide(Game.TYPE_SwitchClient, x, y) as SwitchClient_GP;
			if (sc)
			{
				if (sc.isActive && sc.activeNum == 1) visible = false;
				if (!sc.isActive && sc.inactiveNum == 1) visible = false;
			}
		}
		// -------------------------------------------------------------------------------------------
		
		
		public function collect():void
		{
			collected = true;
			Sounds.collect1();
			gpm.gameText.updateOrbText(gpm.orbsCollectedCount(), gpm.room.orbs.length);
			FP.tween(this, { x: gpm.gameText.orb.x, y: gpm.gameText.orb.y }, (FP.distance(x, y, gpm.gameText.orb.x, gpm.gameText.orb.y) / speed) / FP.assignedFrameRate, { complete: removeThis, ease: Ease.quintOut, tweener: this } );
		}
		
		/**
		 * Returns a Number that represents speed in pixels per frame based
		 * off of moving from x: 0 to x: FP.width in SECONDS
		 */
		private function get speed():Number { return FP.width / (FP.assignedFrameRate * SECONDS); }
		// -------------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------------
		
	}

}