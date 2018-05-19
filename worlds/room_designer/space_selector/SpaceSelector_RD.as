package worlds.room_designer.space_selector 
{
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.JS;
	
	import game_pieces.blocks.auto_blocks.sequence_block.SequenceBlock_RD;
	import game_pieces.tiles.switch_tile.SwitchTile_RD;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_RD;
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SpaceSelector_RD extends SpaceSelector 
	{
		private var sc:SwitchClient_RD;
		private var sb:SequenceBlock_RD;
		private var ssGP:SpacesSelectorGamePiece;
		
		
		private const PLUSMINUS_SIZE:uint = 24;
		private var plusTextImg:Text = new Text("+", 0, 0, { size: PLUSMINUS_SIZE });
		private var minusTextImg:Text = new Text("-", 0, 0, { size: PLUSMINUS_SIZE });
		private var wrenchIconImg:Image = new Image(Images.WRENCHICON1);
		private var actionIcon:EntityGame = new EntityGame(0, 0, plusTextImg, Game.SPACESELECTOR_LAYER);
		private var aiCenterPoint:Point = new Point(0, 0);
		
		private var willChangeOnlyOne:Boolean = false;
		private var willChangeNone:Boolean = false;
		
		
		/**
		 * A list of indices related to ImageConstants.imgs that correspond with 
		 * tile types that can only be placed one at a time
		 */
		private var singleTypes:Array = 
		[
			Images.gamePieceSourceImages.indexOf(Images.GOALTILE), 
			Images.gamePieceSourceImages.indexOf(Images.SWITCHTILE1), 
			Images.gamePieceSourceImages.indexOf(Images.BLUEBLOCK1), 
			Images.gamePieceSourceImages.indexOf(Images.REDBLOCK1), 
			Images.gamePieceSourceImages.indexOf(Images.SEQUENCEBLOCK)
		];
		
		
		private var tileTypeName:SpaceSelector_TileTypeText;
		
		public var imgIndex:int = 0;
		private var imgIndexPrev:int = Images.gamePieceSourceImages.length - 1;
		private var imgIndexNext:int = 1;
		private var imgIndexOut:int;
		private var imgIndices:Array = [imgIndexPrev, imgIndex, imgIndexNext];
		
		private var ssGPList:Array = new Array(Images.gamePieceSourceImages.length);
		private var ssGPWorldList:Array = new Array(3);
		
		
		
		public function SpaceSelector_RD() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_SpaceSelector_RD;
			
			for (var i:uint = 0; i < ssGPList.length; i++) ssGPList[i] = new SpacesSelectorGamePiece(i);
			
			ssGPWorldList[0] = ssGPList[imgIndexPrev], ssGPWorldList[1] = ssGPList[imgIndex], ssGPWorldList[2] = ssGPList[imgIndexNext];
			ssGP = ssGPWorldList[0], ssGP.image.alpha = 0, ssGP = ssGPWorldList[2], ssGP.image.alpha = 0;
			
			tileTypeName = new SpaceSelector_TileTypeText(this);
			tileTypeName.imageIndex = imgIndex;
			addList.push(actionIcon, ssGPWorldList);
			
			// For GridSpace
			graphic = Images.floorImg; // For GridSpace
			visible = false; // For GridSpace
		}
		
		override public function added():void 
		{
			super.added();
			
			
			epAddList(addList);
			
			resetData();
		}
		
		override public function update():void 
		{
			updatePos();
			
			gs = collide(Game.TYPE_GridSpace, world.mouseX, world.mouseY) as GridSpace;
			
			if (gs) whenOverASpace();
			else whenNotOverASpace();
			
			
			super.update();
			
			
			updateActionIcon();
			updateTile();
			
			
			epVisible(qualVisible(), false, [ssGPWorldList[0], ssGPWorldList[2]]);
		}
		// -------------------------------------------------------------------------------------
		
		
		override public function whenOverASpace():void 
		{
			isQualifiedSpace = false;
			
			
			super.whenOverASpace();
			
			
			// public static var imgs:Array = [floorImg, wallImg, goalImg, holeImg, switchImg, blueImg, redImg, backAndForthImg, glowOrb1b];
			
			sc = collide(Game.TYPE_SwitchClient, world.mouseX, world.mouseY) as SwitchClient_RD;
			st = collide(Game.TYPE_SwitchTile, world.mouseX, world.mouseY) as SwitchTile_RD;
			sb = collide(Game.TYPE_SequenceBlock, world.mouseX, world.mouseY) as SequenceBlock_RD;
			
			switch(imgIndex)
			{
				case 0: // floorTileImg
					
					if (Input.check(Key.SHIFT))
					{
						if (gs.imgNum == 0)
						{
							if (!rd.hasPushBlock(gs.gridIndex) && !sb) isQualifiedSpace = true;
						}
					}
					else if (!sc && !sb && (gs.imgNum < 4 || gs.imgNum == 99) && gs.imgNum != 0)
					{
						if (!rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
					}
					
					break;
					
				case 1: // wallTileImg
					
					if (Input.check(Key.SHIFT))
					{
						if (gs.imgNum == 1)
						{
							if (!rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
						}
					}
					else if (!sc && (gs.imgNum < 4 || gs.imgNum == 99) && gs.imgNum != 1)
					{
						if (!rd.hasPushBlock(gs.gridIndex) && !sb) isQualifiedSpace = true;
					}
					
					break;
					
				case 2: // goalTileImg
					
					if (Input.check(Key.SHIFT))
					{
						if (gs.imgNum == 2)
						{
							if (!rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
						}
					}
					else if (!sc && !sb && gs.imgNum < 4 && gs.imgNum != 2)
					{
						if (!rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
					}
					
					break;
					
				case 3: // holeTileImg
					
					if (Input.check(Key.SHIFT))
					{
						if (gs.imgNum == 3)
						{
							if (!rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
						}
					}
					else if (!sc && !sb && (gs.imgNum < 4 || gs.imgNum == 99) && gs.imgNum != 3)
					{
						if (!rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
					}
					
					break;
					
				case 4: // switchTileImg
					
					if (Input.check(Key.SHIFT))
					{
						if (gs.imgNum == 4)
						{
							// isQualifiedSpace = true;
							
							// if (clicked) { Run function to remove the SwitchTileClient and all of it's clients }
							// 1. Removes the SwitchTile and it's clients
							// 2. Replaces the gs.graphic and gs.imgNum to FloorTile
						}
					}
					else if (!sc && gs.imgNum < 5)
					{
						isQualifiedSpace = true;
					}
					
					break;
					
				case 5: // blueBlockImg
					
					if (Input.check(Key.SHIFT))
					{
						if (rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
					}
					else if (gs.imgNum == 0 || gs.imgNum == 1 || gs.imgNum == 2 || gs.imgNum == 4)
					{
						if (!rd.hasPushBlock(gs.gridIndex) && !sb) isQualifiedSpace = true;
					}
					
					break;
					
				case 6: // redBlockImg
					
					if (Input.check(Key.SHIFT))
					{
						if (rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
					}
					else if (gs.imgNum == 0 || gs.imgNum == 1 || gs.imgNum == 2 || gs.imgNum == 4)
					{
						if (!rd.hasPushBlock(gs.gridIndex) && !sb) isQualifiedSpace = true;
					}
					
					break;
					
				case 7: // backAndForthImg
					
					if (Input.check(Key.SHIFT))
					{
						if (gs.sb) isQualifiedSpace = true;
					}
					else if (gs.imgNum == 0 && !gs.sc && !sb)
					{
						if (!rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
					}
					
					break;
					
				case 8: // orb
					
					if (Input.check(Key.SHIFT))
					{
						if (gs.orb) isQualifiedSpace = true;
					}
					else if (gs.imgNum != 1 && gs.imgNum != 99 && !gs.orb)
					{
						if (!rd.hasPushBlock(gs.gridIndex)) isQualifiedSpace = true;
					}
					
					break;
			}
		}
		
		override public function whenNotOverASpace():void 
		{
			super.whenNotOverASpace();
			
			
			isOverASpace = false;
			isQualifiedSpace = false;
		}
		
		override public function onMousePressed():void 
		{
			resetData();
			
			
			// public static var imgs:Array = [floorImg, wallImg, goalImg, holeImg, switchImg, blueImg, redImg, backAndForthImg];
			if (rd.im.state != rd.im.HUB)
			{
				willChangeNone = true;
			}
			else if (singleTypes.indexOf(imgIndex) != -1) // Goal, Switch, Blue, Red, Sequence
			{
				if (gs)
				{
					if (isQualifiedSpace)
					{
						willChangeOnlyOne = true;
						gridNumsToChange.push(gs.gridIndex);
					}
					else willChangeNone = true;
				}
				else willChangeNone = true;
			}
			else if (qualStartDrag())
			{
				super.onMousePressed(); // Starts the drag rectangle
			}
		}
		
		override public function onMouseDown():void 
		{
			if (qualUpdateDrag()) super.onMouseDown();
		}
		
		override public function onMouseReleased():void 
		{
			super.onMouseReleased();
			
			
			if (!willChangeNone)
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
				
				
				if (gridNumsToChange.length > 0) fillOrUnfill();
			}
			
			resetData();
		}
		// -------------------------------------------------------------------------------------
		
		
		override public function resetData():void 
		{
			super.resetData(); // resetDragData();
			
			
			willChangeOnlyOne = false, willChangeNone = false;
			gridNumsToChange.length = 0;
		}
		
		override public function resetDragData():void 
		{
			dragStartCoords.x = -1, dragStartCoords.y = -1;
			
			
			super.resetDragData();
		}
		
		override public function qualStartDrag():Boolean 
		{
			if (
				!willChangeOnlyOne && !willChangeNone	// Some tiles/blocks can only be placed one at a time
				&& JS.mouseIsOnScreen()					// Mouse pointer must be within the game screen
				&& rd.im.state == rd.im.HUB				// InputManager_RD.sectionNum must equal InputManager_RD.HUB
			) return true;
			
			
			return super.qualStartDrag(); // return false;
		}
		
		override public function qualUpdateDrag():Boolean 
		{
			if (
				!willChangeOnlyOne && !willChangeNone	// Some tiles/blocks can only be placed one at a time
				&& dragWasStarted()						// Checks if the drag rect was started since user could've been holding mouseDown while 'this' was unable to start the drag rect
			) return true;
			
			
			return super.qualUpdateDrag(); // return false;
		}
		// -------------------------------------------------------------------------------------
		
		
		private function qualVisible():Boolean
		{
			if (
				collideTypes([JS.TYPE_Button, JS.TYPE_TextButton], world.mouseX, world.mouseY)	// If mouse pointer is colliding with an entity of type "button" or "TextButton"
				|| rd.im.state != rd.im.HUB														// If InputManager.sectionNum is anything other than InputManager.HUB
			) return false;
			
			
			return true;
		}
		// -------------------------------------------------------------------------------------
		
		
		private function updatePos():void
		{
			var offset:int;
			x = world.mouseX - Game.HALFSPACESIZE, y = world.mouseY - Game.HALFSPACESIZE; // For GridSpace
			homeCoords.x = x, homeCoords.y = y; // For GridSpace
			tileTypeName.setXY(x, y);
			
			for (var i:uint = 0; i < 3; i++)
			{
				offset = 0;
				if (i == 0) offset = -Game.SSPSP;
				else if (i == 2) offset = Game.SSPSP;
				
				ssGP = ssGPWorldList[i];
				if (ssGP.tween)
				{
					if (!ssGP.tween.active) updateSSGPPos();
				}
				else
				{
					updateSSGPPos();
				}
			}
			
			
			function updateSSGPPos():void
			{
				ssGP.x = x + offset;
				ssGP.y = y;
			}
		}
		// -------------------------------------------------------------------------------------
		
		
		private function updateTile():void
		{
			if (rd.im.state == rd.im.HUB && !Input.mouseDown && !Input.mousePressed)
			{
				if (Input.pressed(Key.X)) changeTypeNext();
				if (Input.pressed(Key.Z)) changeTypePrev();
			}
		}
		
		public function changeTypeNext():void
		{
			imgIndex++;
			imgIndexOut = imgIndex - 1;
			if (imgIndex > ssGPList.length - 1)
			{
				imgIndex = 0;
				imgIndexOut = ssGPList.length - 1;
			}
			updateImgIndex();
			changeImage();
			Sounds.tick3();
		}
		
		public function changeTypePrev():void
		{
			imgIndex--;
			imgIndexOut = imgIndex + 1;
			if (imgIndex < 0)
			{
				imgIndex = ssGPList.length - 1;
				imgIndexOut = 0;
			}
			updateImgIndex();
			changeImage();
			Sounds.tick3();
		}
		
		private function updateImgIndex():void
		{
			imgIndexPrev = imgIndex - 1;
			if (imgIndexPrev < 0) imgIndexPrev = ssGPList.length - 1;
			
			imgIndexNext = imgIndex + 1;
			if (imgIndexNext > ssGPList.length - 1) imgIndexNext = 0;
			
			imgIndices[0] = imgIndexPrev, imgIndices[1] = imgIndex, imgIndices[2] = imgIndexNext;
		}
		
		private function changeImage():void
		{
			JS.cancelTweens(tweens);
			
			
			var posOrNeg:int = 1;
			if (Input.pressed(Key.X)) posOrNeg = -1;
			
			changeTypeTween(ssGPList[imgIndexOut], Game.SSPSP * posOrNeg); // out
			changeTypeTween(ssGPList[imgIndex], 0, updateSSGPWorldList); // in
			
			tweens.push(tileTypeName.changeText(imgIndex));
			
			graphic = Images.imgs[imgIndex]; // For GridSpace
		}
		
		public function changeTypeTween(ssGp:SpacesSelectorGamePiece, offset:int = 0, onComplete:Function = null):void
		{
			const DURATION:Number = .1;
			var alphaTo:Number = 0;
			if (offset == 0) alphaTo = 1;
			
			tweens.push(FP.tween(ssGp.image, { alpha: alphaTo }, DURATION, { tweener: ssGp } ));
			
			ssGp.tween = JS.tweenMultiAnchor(ssGp, this, { x: homeCoords.x + offset, y: homeCoords.y }, DURATION, null, onComplete);
			tweens.push(ssGp.tween);
		}
		
		private function updateSSGPWorldList():void
		{
			for (var i:uint = 0; i < ssGPList.length; i++)
			{
				ssGP = ssGPList[i];
				if (ssGP.world && imgIndices.indexOf(ssGP.imageIndex) == -1) epRemove(ssGP);
			}
			
			
			ssGPWorldList.length = 0;
			ssGPWorldList.push(ssGPList[imgIndexPrev]), ssGPWorldList.push(ssGPList[imgIndex]), ssGPWorldList.push(ssGPList[imgIndexNext]);
			for each (ssGP in ssGPWorldList) epAdd(ssGP);
			ssGP = ssGPWorldList[0], ssGP.image.alpha = 0;
			ssGP = ssGPWorldList[2], ssGP.image.alpha = 0;
		}
		// -------------------------------------------------------------------------------------
		
		
		private function updateActionIcon():void
		{
			aiCenterPoint.x = x - 6, aiCenterPoint.y = y - 6;
			
			actionIcon.graphic = plusTextImg;
			plusTextImg.x = aiCenterPoint.x - (plusTextImg.textWidth * .5);
			plusTextImg.y = aiCenterPoint.y - (plusTextImg.textHeight * .5);
			
			if (Input.check(Key.SHIFT))
			{
				actionIcon.graphic = minusTextImg;
				minusTextImg.x = aiCenterPoint.x - (minusTextImg.textWidth * .5);
				minusTextImg.y = aiCenterPoint.y - (minusTextImg.textHeight * .5);
			}
			else if (gs)
			{
				if (imgIndex == Images.gamePieceSourceImages.indexOf(Images.SWITCHTILE1) && gs.imgNum == 4)
				{
					actionIcon.graphic = wrenchIconImg;
					wrenchIconImg.x = aiCenterPoint.x - (wrenchIconImg.width * .5);
					wrenchIconImg.y = aiCenterPoint.y - (wrenchIconImg.height * .5);
				}
			}
		}
		// -------------------------------------------------------------------------------------
		
		
		private function fillOrUnfill():void
		{
			if (imgIndex == Images.gamePieceSourceImages.indexOf(Images.BLUEBLOCK1) || imgIndex == Images.gamePieceSourceImages.indexOf(Images.REDBLOCK1))
			{
				if (Input.check(Key.SHIFT))
				{
					rd.removePushBlock(gridNumsToChange[0]);
				}
				else
				{
					rd.addPushBlock(Images.imgs[imgIndex], gridNumsToChange[0]);
					
					gs = rd.gridSpaces[gridNumsToChange[0]];
					if (gs.imgNum == 1 || gs.imgNum == 3)
					{
						gs.imgNum = 0;
						gs.imgIndexHistory.push(0);
						gs.graphic = Images.floorImg;
					}
				}
			}
			else if (imgIndex == Images.gamePieceSourceImages.indexOf(Images.SWITCHTILE1) && gs.imgNum == 4)
			{
				rd.epAdd(rd.ste);
			}
			else if (imgIndex == Images.gamePieceSourceImages.indexOf(Images.SEQUENCEBLOCK))
			{
				if (Input.check(Key.SHIFT))
				{
					JS.splice(rd.sequenceBlocks, rd.epRemove(gs.sb));
				}
				else
				{
					rd.epAdd(rd.sbc);
				}
			}
			else if (imgIndex == Images.gamePieceSourceImages.indexOf(Images.GLOWORB1B))
			{
				if (Input.check(Key.SHIFT))
				{
					rd.removeOrbs(gridNumsToChange);
				}
				else
				{
					rd.addOrbs(gridNumsToChange);
				}
			}
			else
			{
				for (var j:uint = 0; j < gridNumsToChange.length; j++)
				{
					gs = rd.gridSpaces[gridNumsToChange[j]];
					
					if (Input.check(Key.SHIFT)) gs.unfillTile();
					else gs.fillTile();
				}
			}
			
			if (Input.check(Key.SHIFT)) Sounds.knock1();
			else Sounds.tick2();
			
			
			rd.updateRoomData();
		}
		// -------------------------------------------------------------------------------------
		
		
		
		// -------------------------------------------------------------------------------------
		
	}

}