package worlds.room_designer.gold_medal_moves 
{
	import net.jacob_stewart.JS;
	import net.jacob_stewart.text.TextButton;
	import net.jacob_stewart.text.TextPlus;
	
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GoldMedalMovesBtn extends TextButton 
	{
		private var rd:RoomDesigner;
		public var movesText:TextPlus;
		
		
		
		public function GoldMedalMovesBtn(onClick:Function=null, text:String="Gold medal moves: ", x:Number=0, y:Number=0, options:Object=null, layer:int=Game.TEXTLAYER) 
		{
			super(onClick, text, x, y, options, layer);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_GoldMedalMovesBtn;
			centerHor(textWidth, Game.TEXTCENXR);
			centerVer(textHeight, Game.TOPAREAVERCEN);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			setXY(x - JS.getTextWidth(size, "A"), y); // So that this.textStr + movesText are together centered on GUI_Constants.TEXTCENXR
			movesText = new TextPlus(rd.movesQualGold.toString(), x + textWidth, y, { size: size } );
			epAdd(movesText);
			
			visibleStates.push(rd.im.HUB, rd.im.OPTIONS, rd.im.NAMER, rd.im.MEDAL);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
		}
		// -------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateCollidable();
			updateVisible();
		}
		
		private function updateCollidable():void
		{
			collidable = false;
			if (rd.im.state == rd.im.HUB) collidable = true;
		}
		
		private function updateVisible():void
		{
			epVisible(false);
			if (visibleStates.indexOf(rd.im.state) != -1) epVisible(true);
		}
		// -------------------------------------------------------------------------
		
		override public function click():void 
		{
			super.click();
			
			
			collidable = false;
			world.add(new SetGoldMedalMoves);
		}
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------
		
	}

}