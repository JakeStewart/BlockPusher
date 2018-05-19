package game_pieces.blocks.auto_blocks.sequence_block 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.text.TextButton;
	import net.jacob_stewart.text.TextPlus;
	
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SequenceBlockCreator extends EntityGame 
	{
		private var rd:RoomDesigner;
		private var gs:GridSpace;
		
		public var ss:SpaceSelector_SBC = new SpaceSelector_SBC;
		private var mp:MousePointer_SBC = new MousePointer_SBC([JS.TYPE_Button, JS.TYPE_TextButton]);
		
		public var screenTint:ScreenTint = new ScreenTint(Game.SCREENTINT_LAYER);
		private var title:TextPlus = new TextPlus("SEQUENCE BLOCK CREATOR", 0, 14, { size: 24, alignCenterX: FP.halfWidth } );
		private var doneBtn:TextButton = new TextButton(finishCreating, "DONE", 0, 0, { size: 22, alignCenterX: FP.halfWidth, alignCenterY: Game.BOTTOMAREAVERCEN } );
		private var guiList:Array = [screenTint, title, doneBtn];
		
		
		private var sequenceGridIndices:Array;
		
		private var gsState0Alpha:Number;
		
		
		
		public function SequenceBlockCreator() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SequenceBlockCreator;
			name = Game.NAME_SequenceBlockCreator;
			layer = -6;
			graphic = Images.sequenceBlockImg;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			rd.im.state = rd.im.SBC;
			
			
			gridIndex = rd.ss.gs.gridIndex;
			
			gs = rd.gridSpaces[gridIndex];
			gsState0Alpha = gs.state0Alpha;
			gs.state0Alpha = .8;
			x = gs.x, y = gs.y;
			
			sequenceGridIndices = new Array;
			
			epAdd(ss), epAdd(mp);
			epAddList(guiList);
			rd.epRemove(rd.ss), rd.epRemove(rd.mp);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd.im.state = rd.im.HUB;
			
			rd.epAdd(rd.ss), rd.epAdd(rd.mp);
			gs.state0Alpha = gsState0Alpha;
			
			rd.updateRoomData();
			
			rd = null;
			gs = null;
		}
		// ------------------------------------------------------------------
		
		
		public function addSequenceIndex(gridIndex:uint):void
		{
			sequenceGridIndices.push(gridIndex);
			
			var e:Entity = rd.gridSpaces[gridIndex];
			epAdd(new TextPlus(sequenceGridIndices.length.toString(), 0, 0, { size: 20, alignCenterX: e.x + Game.HALFSPACESIZE, alignCenterY: e.y + Game.HALFSPACESIZE } ));
		}
		
		
		public function finishCreating():void
		{
			Sounds.select1();
			// check if user didn't specify any move to spaces
			
			rd.sequenceBlocks.push(new SequenceBlock_RD(sequenceGridIndices, gridIndex));
			rd.epAdd(rd.sequenceBlocks[rd.sequenceBlocks.length - 1]);
			
			world.remove(this);
		}
		
		public function cancelCreator():void
		{
			world.remove(this);
		}
		// ------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------
		
	}

}