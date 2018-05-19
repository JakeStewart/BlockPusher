package worlds.room_designer.space_selector 
{
	import flash.geom.Point;
	
	import net.flashpunk.utils.Input;
	
	import game_pieces.tiles.switch_tile.SwitchTile_RD;
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SpaceSelector extends EntityGame 
	{
		public var rd:RoomDesigner;
		public var gs:GridSpace;
		public var st:SwitchTile_RD;
		
		public var isOverASpace:Boolean = false;
		public var isQualifiedSpace:Boolean = false;
		
		public var dragStartCoords:Point = new Point;
		private var dragMouseCoords:Point = new Point;
		private var dragRectCoords:Point = new Point;
		private var dragRectWidth:Number = 0;
		private var dragRectHeight:Number = 0;
		public var dragData:Array = [dragRectCoords.x, dragRectCoords.y, dragRectWidth, dragRectHeight];
		
		public var gridNumsToChange:Array = new Array;
		
		public var tweens:Array = new Array;
		
		
		
		public function SpaceSelector() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SpaceSelector;
			layer = Game.SPACESELECTOR_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			gridNumsToChange.length = 0;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			gs = null;
			st = null;
			tweens.length = 0;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			if (Input.mousePressed) onMousePressed();
			if (Input.mouseDown) onMouseDown();
			if (Input.mouseReleased) onMouseReleased();
		}
		
		public function whenOverASpace():void
		{
			isOverASpace = true;
		}
		
		public function whenNotOverASpace():void
		{
			isOverASpace = false;
		}
		
		public function onMousePressed():void
		{
			setCoords(dragStartCoords);
		}
		
		public function onMouseDown():void
		{
			setCoords(dragMouseCoords);
			setDimensions();
			updateDragData();
		}
		
		public function onMouseReleased():void
		{
			
		}
		// -----------------------------------------------------------------------------
		
		
		private function setCoords(p:Point):void
		{
			p.x = world.mouseX, p.y = world.mouseY;
		}
		
		private function setDimensions():void
		{
			dragRectWidth = Math.abs(dragMouseCoords.x - dragStartCoords.x);
			dragRectHeight = Math.abs(dragMouseCoords.y - dragStartCoords.y);
			
			if (dragMouseCoords.x < dragStartCoords.x) dragRectCoords.x = dragMouseCoords.x;
			else dragRectCoords.x = dragStartCoords.x;
			if (dragMouseCoords.y < dragStartCoords.y) dragRectCoords.y = dragMouseCoords.y;
			else dragRectCoords.y = dragStartCoords.y;
		}
		
		private function updateDragData():void
		{
			dragData[0] = dragRectCoords.x;
			dragData[1] = dragRectCoords.y;
			dragData[2] = dragRectWidth;
			dragData[3] = dragRectHeight;
		}
		
		public function resetDragData():void
		{
			dragData[0] = 0;
			dragData[1] = 0;
			dragData[2] = 0;
			dragData[3] = 0;
		}
		
		public function dragArea():int
		{
			return Math.round(dragRectWidth * dragRectHeight);
		}
		
		public function dragWasStarted():Boolean
		{
			if (dragStartCoords.x != -1 && dragStartCoords.y != -1) return true;
			
			
			return false;
		}
		
		/**
		 * Qualification check to start the drag rectangle
		 * @return	Returns true if the qualifications are met, false if they are not
		 */
		public function qualStartDrag():Boolean
		{
			return false;
		}
		
		/**
		 * Qualification check to update the drag rectangle
		 * @return	Returns true if the qualifications are met, false if they are not
		 */
		public function qualUpdateDrag():Boolean
		{
			return false;
		}
		
		public function resetData():void
		{
			resetDragData();
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}