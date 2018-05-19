package worlds.room_designer.switch_tile_editor 
{
	import flash.geom.Point;
	
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.text.TextPlus;
	
	import game_pieces.tiles.switch_tile.SwitchTile_RD;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_RD;
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.space_selector.SpaceSelector;
	import worlds.room_designer.space_selector.SpaceSelector_TileTypeText;
	import worlds.room_designer.switch_tile_editor.SwitchClientMovesSetter;
	import worlds.room_designer.switch_tile_editor.SwitchTileEditor;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * STCC = Switch Tile Client Creator
	 */
	public class SpaceSelector_STE extends SpaceSelector 
	{
		private var ste:SwitchTileEditor;
		private var sc:SwitchClient_RD;
		
		public var imgIndexA:int = 1;
		public var imgIndexB:int = 0;
		public var imgIndices:Array = [0, 1, 2, 3];
		// public static var imgs:Array = [floorImg, wallImg, goalImg, holeImg, switchImg, blueImg, redImg, backAndForthImg, glowOrb1b];
		
		private var plusText:Text = new Text("+");
		private var minusText:Text = new Text("-");
		
		private var aiCenterPoint:Point = new Point(0, 0);
		private var wrenchIconImg:Image = new Image(Images.WRENCHICON1);
		private var actionIcon:EntityPlus = new EntityPlus(0, 0, wrenchIconImg);
		
		
		private var willChangeOnlyOne:Boolean = false;
		private var willChangeNone:Boolean = false;
		
		public var moves:uint = 0;
		private var movesSetter:SwitchClientMovesSetter = new SwitchClientMovesSetter;
		private var movesText:TextPlus = new TextPlus("0");
		
		private var infinityIcon:EntityPlus = new EntityPlus(0, 0, Images.infinityIcon);
		
		private var tileTypeName:SpaceSelector_TileTypeText;
		
		
		
		public function SpaceSelector_STE() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_SpaceSelector_STE;
			
			plusText.size = 24;
			minusText.size = 24;
			
			actionIcon.layer = layer;
			infinityIcon.layer = layer - 1;
			movesText.layer = layer - 1;
			
			tileTypeName = new SpaceSelector_TileTypeText(this);
			
			addList.push(movesSetter, actionIcon, movesText, tileTypeName);
		}
		
		override public function added():void 
		{
			super.added();
			
			
			moves = 0;
			
			imgIndexA = 1, imgIndexB = 0;
			graphic = Images.imgs[imgIndices[imgIndexA]];
			
			
			ste = world.getInstance(Game.NAME_SwitchTileEditor) as SwitchTileEditor;
			gridIndex = ste.gridIndex;
			
			tileTypeName.imageIndex = imgIndices[imgIndexA];
			epAddList(addList);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			ste = null;
			sc = null;
		}
		// -----------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			updatePos();
			
			
			epVisible(true);
			isOverASpace = false;
			
			gs = collide(Game.TYPE_GridSpace, world.mouseX, world.mouseY) as GridSpace;
			sc = collide(Game.TYPE_SwitchClient, world.mouseX, world.mouseY) as SwitchClient_RD;
			
			if (gs) whenOverASpace();
			else whenNotOverASpace();
			
			
			super.update();
			
			
			updateActionIcon();
			checkTypeChangeRequest();
			
			
			if (Input.pressed(Key.TAB) && !Input.mouseDown && !Input.mousePressed) // Swap types
			{
				var indexA:uint = imgIndexA;
				var indexB:uint = imgIndexB;
				
				imgIndexA = indexB, imgIndexB = indexA;
			}
			
			graphic = Images.imgs[imgIndices[imgIndexA]];
			
			if (collideTypes([JS.TYPE_Button, JS.TYPE_TextButton], world.mouseX, world.mouseY)) epVisible(false);
		}
		
		override public function whenOverASpace():void 
		{
			super.whenOverASpace();
			
			
			st = collide(Game.TYPE_SwitchTile, world.mouseX, world.mouseY) as SwitchTile_RD;
			
			isQualifiedSpace = true;
			
			if (sc)
			{
				var clientGridNums:Array = ste.getAllClientGridIndices();
				if (clientGridNums.indexOf(sc.gridIndex) == -1) isQualifiedSpace = false;
			}
			else
			{
				if (Input.check(Key.SHIFT)) isQualifiedSpace = false;
				else if (
						(gs.imgNum > 3 && gs.imgNum != 99) 
						|| rd.hasPushBlock(gs.gridIndex) 
						|| gs.gridIndex == ste.gridIndex
						|| rd.hasSequenceBlock(gs.gridIndex)) isQualifiedSpace = false;
			}
		}
		
		override public function whenNotOverASpace():void 
		{
			super.whenNotOverASpace();
			
			
			isQualifiedSpace = false;
		}
		
		override public function onMousePressed():void 
		{
			resetData();
			willChangeNone = false, willChangeOnlyOne = false;
			
			if (Input.check(Key.SHIFT))
			{
				if (JS.mouseIsOnScreen()) super.onMousePressed(); // Drag rect starts
			}
			else
			{
				if (imgIndices[imgIndexA] == 2 || imgIndices[imgIndexB] == 2)
				{
					if (gs)
					{
						if (isQualifiedSpace)
						{
							gridNumsToChange.push(gs.gridIndex);
							willChangeOnlyOne = true;
						}
					}
					else
					{
						willChangeNone = true;
					}
				}
				else if (qualStartDrag())
				{
					super.onMousePressed(); // Drag rect starts
				}
			}
		}
		
		override public function onMouseDown():void 
		{
			if (Input.released(Key.SHIFT)) willChangeNone = true;
			if (qualUpdateDrag()) super.onMouseDown();
		}
		
		override public function onMouseReleased():void 
		{
			super.onMouseReleased();
			
			
			if (!willChangeNone)
			{
				if (Input.check(Key.SHIFT))
				{
					ste.removeClients(gridNumsToChange);
				}
				else
				{
					if (willChangeOnlyOne)
					{
						if (gs)
						{
							if (gs.gridIndex != gridNumsToChange[0]) gridNumsToChange.length = 0;
						}
						else
						{
							gridNumsToChange.length = 0;
						}
					}
					
					if (gridNumsToChange.length > 0)
					{
						ste.addClients(gridNumsToChange);
					}
				}
			}
			
			
			resetData();
		}
		// -----------------------------------------------------------------------------
		
		
		override public function qualStartDrag():Boolean 
		{
			if (
				!willChangeOnlyOne && !willChangeNone // Some tiles/blocks can only be placed one at a time
				&& imgIndices[imgIndexA] != 2 && imgIndices[imgIndexB] != 2 // Some tiles/blocks can only be placed one at a time
				&& JS.mouseIsOnScreen() // Mouse pointer must be within the game screen
			) return true;
			
			
			return super.qualStartDrag(); // return false;
		}
		
		override public function qualUpdateDrag():Boolean 
		{
			if (
				!willChangeOnlyOne && !willChangeNone // Some tiles/blocks can only be placed one at a time
				&& dragWasStarted() // Checks if the drag rect was started since user could've been holding mouseDown while 'this' was unable to start the drag rect
			) return true;
			
			
			return super.qualUpdateDrag(); // return false;
		}
		
		override public function resetData():void 
		{
			super.resetData(); // resetDragData()
			
			
			willChangeOnlyOne = false, willChangeNone = false;
			gridNumsToChange.length = 0;
		}
		// -----------------------------------------------------------------------------
		
		
		public function checkTypeChangeRequest():void
		{
			if (!Input.mouseDown && !Input.mousePressed && Input.pressed(Keys.CHANGE_TILE_TYPE))
			{
				if (Input.pressed(Key.X))
				{
					imgIndexA = imgIndexForward(imgIndexA);
					if (imgIndexA == imgIndexB) imgIndexB = imgIndexForward(imgIndexB);
				}
				
				if (Input.pressed(Key.Z))
				{
					imgIndexA = imgIndexBackward(imgIndexA);
					if (imgIndexA == imgIndexB) imgIndexB = imgIndexBackward(imgIndexB);
				}
				
				if (Input.pressed(Key.S))
				{
					imgIndexB = imgIndexForward(imgIndexB);
					if (imgIndexB == imgIndexA) imgIndexA = imgIndexForward(imgIndexA);
				}
				
				if (Input.pressed(Key.A))
				{
					imgIndexB = imgIndexBackward(imgIndexB);
					if (imgIndexB == imgIndexA) imgIndexA = imgIndexBackward(imgIndexA);
				}
				
				
				JS.cancelTweens(tweens);
				tweens.push(tileTypeName.changeText(imgIndices[imgIndexA]));
			}
		}
		
		public function imgIndexForward(_imgIndex:int):uint
		{
			_imgIndex++;
			if (_imgIndex > imgIndices.length - 1) _imgIndex = 0;
			return _imgIndex;
		}
		
		public function imgIndexBackward(_imgIndex:int):uint
		{
			_imgIndex--;
			if (_imgIndex < 0) _imgIndex = imgIndices.length - 1;
			return _imgIndex;
		}
		
		private function updatePos():void
		{
			x = world.mouseX - Game.HALFSPACESIZE, y = world.mouseY - Game.HALFSPACESIZE;
			tileTypeName.setXY(x, y);
			if (movesText.world || infinityIcon.world) updateMovesPos();
		}
		
		private function updateActionIcon():void
		{
			aiCenterPoint.x = x - 6, aiCenterPoint.y = y - 6;
			
			if (Input.check(Key.SHIFT))
			{
				actionIcon.graphic = minusText;
				minusText.x = aiCenterPoint.x - (minusText.textWidth * .5);
				minusText.y = aiCenterPoint.y - (minusText.textHeight * .5);
			}
			else
			{
				actionIcon.graphic = plusText;
				plusText.x = aiCenterPoint.x - (plusText.textWidth * .5);
				plusText.y = aiCenterPoint.y - (plusText.textHeight * .5);
			}
		}
		
		public function changeMoves(moves:int):void
		{
			this.moves = moves;
			
			if (moves == SwitchClient.INFINITY_MOVES)
			{
				if (movesText.world) epRemove(movesText);
				if (!infinityIcon.world) epAdd(infinityIcon);
			}
			else
			{
				if (infinityIcon.world) epRemove(infinityIcon);
				if (!movesText.world) epAdd(movesText);
				
				movesText.changeText(moves.toString());
			}
		}
		
		public function updateMovesPos():void
		{
			if (movesText.world) movesText.centerOnPoint(movesText.textWidth, movesText.textHeight, world.mouseX, world.mouseY);
			else if (infinityIcon.world) infinityIcon.centerOnTarget(this);
		}
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
		
		
		// -----------------------------------------------------------------------------
		
	}

}