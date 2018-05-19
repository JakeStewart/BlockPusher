package worlds.room_designer 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.Button;
	import net.jacob_stewart.EntityPlus;
	
	import collectables.Orb;
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlock_RD;
	import game_pieces.tiles.goal_tile.GoalOutline;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_RD;	
	import worlds.room_designer.SpaceIndexText_RD;
	import worlds.room_designer.space_selector.SpaceSelector;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GridSpace extends Button 
	{
		private var rd:RoomDesigner;
		private var ss:SpaceSelector;
		public var sc:SwitchClient_RD;
		public var sb:SequenceBlock_RD;
		public var orb:Orb;
		
		private const COLOR_EMPTYSPACE:uint = 0x6e6a68; // Looks better than Globals.SCREENCOLOR
		private const LAYERBASE:int = -2;
		
		// public static var imgs:Array = [floorImg, wallImg, goalImg, holeImg, switchImg, blueImg, redImg, backAndForthImg, glowOrb1b];
		private var image:Image = new Image(Images.BLOCK1);
		public var imgNum:uint = 99;
		public var imgIndexHistory:Array = [99];
		
		private var highlightImg:Image = new Image(Images.BLOCKHIGHLIGHTER);
		private var highlight:EntityPlus = new EntityPlus(0, 0, highlightImg);
		private var highlight2Img:Image = new Image(Images.BLOCK1);
		private var highlight2:EntityPlus = new EntityPlus(0, 0, highlight2Img);
		public var state0Alpha:Number = .3;
		
		public var columnNum:uint;
		public var rowNum:uint;
		
		private var isUnderDragRect:Boolean = false;
		private var isQualifiedSpace:Boolean = false;
		
		public var indexText:SpaceIndexText_RD;
		private var qualifiedStates:Array = new Array;
		
		
		
		public function GridSpace(x:Number=0, y:Number=0) 
		{
			super(x, y);
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_GridSpace;
			name = type + gridIndex.toString();
			
			image.color = COLOR_EMPTYSPACE;
			epSetHitbox(Game.SPACESIZE, Game.SPACESIZE);
			
			
			setLayers();
			
			highlight2.visible = false;
			highlight2Img.alpha = .1;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			qualifiedStates.push(rd.im.HUB, rd.im.STE, rd.im.SBC);
			
			epAdd(highlight);
			
			highlight2.x = x, highlight2.y = y;
			epAdd(highlight2);
			
			epAdd(indexText);
			
			epAdd(new GoalOutline(this));
			
			
			if (imgNum == 99) graphic = image;
			else graphic = Images.imgs[imgNum];
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			// restoring defaults
			imgNum = 99;
			imgIndexHistory.length = 0, imgIndexHistory.push(99);
			state0Alpha = .3;
			isUnderDragRect = false, isQualifiedSpace = false;
			
			highlight2.visible = false;
			highlight2Img.alpha = .1;
			
			indexText.updateText( -1);
			
			rd = null;
			ss = null;
			sc = null;
			sb = null;
			orb = null;
		}
		
		override public function update():void 
		{
			changeState(0);
			
			sb = collide(Game.TYPE_SequenceBlock, x, y) as SequenceBlock_RD;
			sc = collide(Game.TYPE_SwitchClient, x, y) as SwitchClient_RD; // If a SwitchTileClient is on top of 'this'
			orb = collide(Game.TYPE_Orb, x, y) as Orb;
			
			
			if (qualifiedStates.indexOf(rd.im.state) != -1)
			{
				if (collidePoint(x, y, world.mouseX, world.mouseY)) whileCollideMouse();
				if (Input.mouseDown) whileMouseDown();
				if (Input.mouseReleased) isUnderDragRect = false;
			}
			
			visible = true;
			if (sc || sb) visible = false;
		}
		// ----------------------------------------------------------------------------------------
		
		
		override public function changeStateNormal():void 
		{
			image.alpha = 1;
			highlightImg.alpha = state0Alpha;
			highlight2.visible = false;
		}
		
		override public function changeStateHover():void 
		{
			image.alpha = 1;
			highlightImg.alpha = 1;
			highlight2.visible = true;
		}
		
		override public function changeStateDown():void 
		{
			image.alpha = .6;
			highlightImg.alpha = .6;
		}
		// ----------------------------------------------------------------------------------------
		
		
		override public function whileCollideMouse():void // mouse is colliding with 'this'
		{
			if (rd.ss.world || rd.ste.ss.world || rd.sbc.ss.world) // It's possible none are in the world
			{
				// Find out which SpaceSelector is in the world & assign it to ss
				if (rd.ss.world) ss = rd.ss;
				else if (rd.ste.ss.world) ss = rd.ste.ss;
				else if (rd.sbc.ss.world) ss = rd.sbc.ss;
				
				if (ss.isQualifiedSpace) changeState(1);
			}
		}
		
		private function whileMouseDown():void
		{
			if (rd.ss.world || rd.ste.ss.world) // It's possible none are in the world
			{
				// Find out which SpaceSelector is in the world & assign it to ss
				if (rd.ss.world) ss = rd.ss;
				else if (rd.ste.ss.world) ss = rd.ste.ss;
				
				
				if (collideRect(x, y, ss.dragData[0], ss.dragData[1], ss.dragData[2], ss.dragData[3]))
				{
					if (!isUnderDragRect) // First frame drag rect collides w/ 'this'
					{
						isQualifiedSpace = false;
						
						
						if (rd.im.state == rd.im.STE) // Client creator
						{
							if (isSTEQualified()) isQualifiedSpace = true;
						}
						else if (ss.graphic == Images.glowOrb1b)
						{
							if (Input.check(Key.SHIFT))
							{
								if (orb) isQualifiedSpace = true;
							}
							else
							{
								if (!orb && imgNum != 1 && imgNum != 99)
								{
									if (!rd.hasPushBlock(gridIndex)) isQualifiedSpace = true;
								}
							}
						}
						else if (!sc && !sb && imgNum != 4 && imgNum != 2 && rd.im.state == rd.im.HUB)
						{
							// rd.ss tile under mouse will only be floor, wall or hole at this point
							
							if (Input.check(Key.SHIFT))
							{
								if (graphic == ss.graphic)
								{
									if (!rd.hasPushBlock(gridIndex)) isQualifiedSpace = true;
								}
							}
							else
							{
								if (graphic != ss.graphic)
								{
									if (!rd.hasPushBlock(gridIndex) && !sb) isQualifiedSpace = true;
								}
							}
						}
						
						if (isQualifiedSpace) ss.gridNumsToChange.push(gridIndex);
					}
					
					isUnderDragRect = true;
					
					
					if (isQualifiedSpace) changeState(1);
				}
				else
				{
					// For SpaceSelector.gridNumsToChange
					if (isUnderDragRect) ss.gridNumsToChange.splice(ss.gridNumsToChange.indexOf(gridIndex), 1);
					isUnderDragRect = false;
				}
			}
		}
		
		private function isSTEQualified():Boolean
		{
			if (sc)
			{
				if (rd.ste.getAllClientGridIndices().indexOf(sc.gridIndex) != -1) return true;
				return false;
			}
			
			if (!sb && !rd.hasPushBlock(gridIndex) && !Input.check(Key.SHIFT))
			{
				if ((imgNum < 4 || imgNum == 99) && gridIndex != ss.gridIndex) return true;
			}
			
			
			return false;
		}
		// ----------------------------------------------------------------------------------------
		
		
		public function fillTile(revert:Boolean = false):void
		{
			if (revert) // For STE_MainMenu.deleteSwitchTile() && SwitchClientCreator_RD.cancelCreator()
			{
				if (imgIndexHistory[imgIndexHistory.length - 1] == 4) imgIndexHistory.pop();
				imgNum = getPrevNum();
				if (imgNum == 99) imgNum = 0;
				if (imgIndexHistory.length == 0) imgIndexHistory.push(imgNum);
				
				state0Alpha = 0;
				graphic = Images.imgs[imgNum];
				
				
				function getPrevNum():uint
				{
					for (var i:uint = imgIndexHistory.length - 1; i > -1; i--)
					{
						if (imgIndexHistory[i] != 4) return imgIndexHistory[i];
					}
					
					
					return 0;
				}
			}
			else if (rd.ss.imgIndex < 4)
			{
				imgNum = rd.ss.imgIndex, imgIndexHistory.push(imgNum);
				graphic = rd.ss.graphic, state0Alpha = 0;
			}
			else if (rd.ss.imgIndex == 4)
			{
				rd.epAdd(rd.ste);
			}
			
			if ((imgNum == 1 || imgNum == 99) && orb) rd.removeOrbs([gridIndex]);
		}
		
		public function unfillTile():void
		{
			if (imgNum != 99)
			{
				rd.removePushBlock(gridIndex);
				
				if (imgNum == 2)
				{
					imgNum = 0;
					graphic = Images.imgs[imgNum];
				}
				else
				{
					imgNum = 99;
					graphic = image;
					state0Alpha = .3;
					if (orb) rd.removeOrbs([gridIndex]);
				}
				
				imgIndexHistory.push(imgNum);
				
				x = homeCoords.x, y = homeCoords.y;
				epSetHitbox(Game.SPACESIZE, Game.SPACESIZE);
			}
		}
		// ----------------------------------------------------------------------------------------
		
		
		private function cloneNeighbor(diff:int):void
		{
			// setDefaults();
			
			var gs:GridSpace;
			gs = rd.gridSpaces[gridIndex + diff];
			
			imgNum = gs.imgNum;
			for (var i:uint = 0; i < gs.imgIndexHistory.length; i++) imgIndexHistory.push(gs.imgIndexHistory[i]);
		}
		// ----------------------------------------------------------------------------------------
		
		
		public function setLayers(offSet:int = 0):void
		{
			layer = LAYERBASE + offSet;
			
			highlight.layer = (LAYERBASE + 1) + offSet;
			highlight2.layer = (LAYERBASE - 1) + offSet;
		}
		
		private function setPosition(x:Number, y:Number):void
		{
			this.x = x, this.y = y;
			homeCoords.x = x, homeCoords.y = y;
			
			var offset:uint = (highlightImg.width - Game.SPACESIZE) * .5;
			highlight.x = homeCoords.x - offset, highlight.y = homeCoords.y - offset;
		}
		// ----------------------------------------------------------------------------------------
		
		
		override public function _EntityGame(x:Number, y:Number, gridIndex:int = -1):EntityGame 
		{
			setPosition(x, y);
			this.gridIndex = gridIndex;
			
			indexText = new SpaceIndexText_RD(this);
			
			
			return super._EntityGame(x, y, gridIndex);
		}
		// ----------------------------------------------------------------------------------------
		
		
		
		// ----------------------------------------------------------------------------------------
		
	}

}