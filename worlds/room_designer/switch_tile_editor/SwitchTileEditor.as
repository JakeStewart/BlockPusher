package worlds.room_designer.switch_tile_editor 
{
	import net.flashpunk.FP;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.graphics.ScreenTint;
	import net.jacob_stewart.text.TextButton;
	import net.jacob_stewart.text.TextPlus;
	
	import game_manual.Manual;
	import game_pieces.tiles.switch_tile.SwitchOutline;
	import game_pieces.tiles.switch_tile.SwitchTile_RD;
	import game_pieces.tiles.switch_tile.switch_tile_client.SwitchClient_RD;
	import worlds.room_designer.GridSpace;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class SwitchTileEditor extends EntityGame 
	{
		private var rd:RoomDesigner;
		private var gs:GridSpace;
		private var st:SwitchTile_RD;
		private var sc:SwitchClient_RD;
		
		public var ss:SpaceSelector_STE = new SpaceSelector_STE;
		private var mp:MousePointer_STE = new MousePointer_STE([JS.TYPE_Button, JS.TYPE_TextButton]);
		
		private var typeChangerActive:TileTypeChanger;
		private var typeChangerInactive:TileTypeChanger;
		
		private var movesSetter:SwitchClientMovesSetter = new SwitchClientMovesSetter;
		
		private var newClients:Array = new Array;
		private var stClientsPendingRemoval:Array = new Array;
		private var newClientGridNums:Array = new Array;
		private var stClientGridNums:Array = new Array;
		
		
		private var title:TextPlus = new TextPlus("SWITCH TILE EDITOR", 0, 14, { size: 24, alignCenterX: FP.halfWidth } );
		private var doneBtn:TextButton = new TextButton(finishEditing, "DONE", 0, 0, { size: 22, alignCenterX: FP.halfWidth, alignCenterY: Game.BOTTOMAREAVERCEN, includeBack: false } );
		private var deleteSwitchBtn:TextButton = new TextButton(deleteSwitchTile, "DELETE SWITCH TILE", 0, 0, { alignCenterX: Game.TEXTCENXR, alignCenterY: Game.TOPAREAVERCEN + 12, includeBack: false } );
		
		
		private var outlineIndices:Array = new Array(2);
		
		private var screenTint:ScreenTint = new ScreenTint(Game.SCREENTINT_LAYER, .2);
		private var switchPlaceHolder:EntityGame;
		private var switchPlaceHolderOutline:SwitchOutline;
		
		
		
		public function SwitchTileEditor() 
		{
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			type = Game.TYPE_SwitchTileEditor;
			name = Game.NAME_SwitchTileEditor;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			newClients.length = 0;
			stClientsPendingRemoval.length = 0;
			newClientGridNums.length = 0;
			stClientGridNums.length = 0;
			
			
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			rd.wp.manualPage = Manual.PAGE_STE;
			rd.active = false;
			rd.im.state = rd.im.STE;
			
			gridIndex = rd.ss.gs.gridIndex;
			gs = rd.gridSpaces[gridIndex];
			gs.setLayers( -2);
			
			
			
			st = gs.collide(Game.TYPE_SwitchTile, gs.x, gs.y) as SwitchTile_RD;
			
			if (st)
			{
				st.setStackOrder( -5);
				updateClientsOffered(st.clients);
				for each (sc in st.clients) stClientGridNums.push(sc.gridIndex);
				outlineIndices = st.outlineIndices;
			}
			else
			{
				switchPlaceHolder = new EntityGame(gs.x, gs.y, Images.switchImg);
				switchPlaceHolder.layer = gs.layer - 2;
				epAdd(switchPlaceHolder);
				outlineIndices = getOutlineIndices();
				switchPlaceHolderOutline = new SwitchOutline(switchPlaceHolder, 2, 1, 1, SwitchOutline.outlineColors[outlineIndices[0]], SwitchOutline.outlineColors[outlineIndices[1]]);
				epAdd(switchPlaceHolderOutline);
			}
			
			
			
			rd.epRemove(rd.ss), rd.epRemove(rd.mp);
			epAdd(ss), epAdd(mp); // This needs to be here before STCC_TileTypeChangerGUI is initialized
			
			
			
			gs = rd.gridSpaces[0];
			typeChangerActive = new TileTypeChanger("Active Type", gs.x + gs.width - 8);
			
			gs = rd.gridSpaces[rd.gridSpaces.length - 1];
			typeChangerInactive = new TileTypeChanger("Inactive Type", gs.x + 8);
			
			epAdd(typeChangerActive), epAdd(typeChangerInactive);
			
			
			
			epAdd(movesSetter);
			epAdd(screenTint);
			epAdd(title);
			epAdd(doneBtn);
			if (st) epAdd(deleteSwitchBtn);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd.active = true;
			
			gs = rd.gridSpaces[gridIndex];
			gs.setLayers();
			
			rd.wp.manualPage = Manual.PAGE_ROOMDESIGNER;
			rd.epAdd(rd.ss), rd.epAdd(rd.mp);
			
			if (st)
			{
				if (st.world) st.setStackOrder();
			}
			for each (sc in newClients) sc.setStackOrder(0);
			
			rd.updateRoomData();
			
			noClientsOffered();
			
			rd.im.state = rd.im.HUB;
			
			
			rd = null;
			gs = null;
			st = null;
			sc = null;
			switchPlaceHolder = null;
			switchPlaceHolderOutline = null;
			newClients.length = 0;
			stClientsPendingRemoval.length = 0;
			newClientGridNums.length = 0;
			stClientGridNums.length = 0;
		}
		// -------------------------------------------------------------------------------------------------
		
		
		public function addClients(gridIndices:Array):void
		{
			var cData:Array = new Array;
			
			for (var i:uint = 0; i < gridIndices.length; i++)
			{
				if (gridIndices[i] != gridIndex)
				{
					// Change the properties of a current or new SwitchClient of the Switch being edited
					if (stClientGridNums.indexOf(gridIndices[i]) != -1 || newClientGridNums.indexOf(gridIndices[i]) != -1)
					{
						if (stClientGridNums.indexOf(gridIndices[i]) != -1) setSC(st.clients);
						else setSC(newClients);
						
						sc.activeNum = ss.imgIndices[ss.imgIndexA], sc.inactiveNum = ss.imgIndices[ss.imgIndexB];
						sc.moves = ss.moves, sc.updateMovesLeftText(ss.moves);
						
						
						function setSC(clients:Array):void
						{
							for (var j:uint = 0; j < clients.length; j++)
							{
								sc = clients[j];
								if (sc.gridIndex == gridIndices[i]) j = clients.length;
							}
						}
					}
					else // Create a new SwitchClient
					{
						// Find the GridSpace and change it to a Floor tile
						gs = rd.gridSpaces[gridIndices[i]];
						gs.imgNum = Game.ID_FLOOR, gs.imgIndexHistory.push(gs.imgNum);
						gs.graphic = Images.imgs[gs.imgNum], gs.state0Alpha = 0;
						
						
						// Create a new SwitchClient
						newClientGridNums.push(gridIndices[i]);
						
						cData.length = 0;
						cData.push(gs.homeCoords.x);
						cData.push(gs.homeCoords.y);
						cData.push(ss.imgIndices[ss.imgIndexA]); // SwitchTileClient.activeNum
						cData.push(ss.imgIndices[ss.imgIndexB]); // SwitchTileClient.inactiveNum
						cData.push(gridIndices[i]); // SwitchTileClient.gridIndex
						cData.push(gridIndex); // SwitchTile.gridIndex (host)
						cData.push(gs.roomIndex); // SwitchTileClient.roomIndex
						cData.push(rd.gridSpaces[gridIndex].roomIndex); // SwitchTile.roomIndex (host)
						cData.push(ss.moves);
						
						newClients.push(SwitchClient_RD(world.create(SwitchClient_RD))._SwitchClient(cData[0], cData[1], cData[2], cData[3], cData[4], cData[5], cData[6], cData[7], cData[8], outlineIndices[0], outlineIndices[1]));
					}
				}
			}
			
			Sounds.tick2();
		}
		
		public function getAllClientGridIndices():Array
		{
			var indices:Array = stClientGridNums;
			indices = indices.concat(newClientGridNums);
			
			
			return indices;
		}
		
		public function removeClients(gridIndices:Array):void
		{
			for (var i:uint = 0; i < gridIndices.length; i++)
			{
				if (newClientGridNums.indexOf(gridIndices[i]) > -1)
				{
					removeNewClient();
					newClientGridNums.splice(newClientGridNums.indexOf(gridIndices[i]), 1);
				}
				else if (stClientGridNums.indexOf(gridIndices[i]) > -1)
				{
					hideSTClient();
					stClientGridNums.splice(stClientGridNums.indexOf(gridIndices[i]), 1);
				}
			}
			
			Sounds.tick2();
			
			
			// The client is removed from the world in finishEditing(), but 
			// unhidden if cancelCreator is called
			function hideSTClient():void
			{
				for (var j:uint = 0; j < st.clients.length; j++)
				{
					sc = st.clients[j];
					if (sc.gridIndex == gridIndices[i])
					{
						stClientsPendingRemoval.push(sc);
						sc.epActive(false), sc.epCollidableAndVisible(false);
						j = st.clients.length;
					}
				}
			}
			
			function removeNewClient():void
			{
				for (var j:int = 0; j < newClients.length; j++)
				{
					sc = newClients[j];
					if (sc.gridIndex == gridIndices[i])
					{
						JS.splice(newClients, world.remove(sc));
						j = newClients.length;
					}
				}
			}
		}
		// --------------------------------------------------------------------------------
		
		
		private function noClientsOffered():void
		{
			if (st) setClientsOffered(st.clients, 0);
		}
		
		private function updateClientsOffered(clients:Array):void
		{
			// Set all of this SwitchTile's clients to normal
			noClientsOffered();
			
			// Set all clients passed to display as modifiable
			setClientsOffered(clients, -4);
		}
		
		private function setClientsOffered(clients:Array, layerOffset:int):void
		{
			for (var i:uint = 0; i < clients.length; i++)
			{
				sc = clients[i];
				
				if (layerOffset == 0 && sc.highlight.world) sc.epRemove(sc.highlight);
				else sc.epAdd(sc.highlight);
				
				sc.setStackOrder(layerOffset);
				sc.highlight.visible = false;
			}
		}
		// --------------------------------------------------------------------------------
		
		
		public function finishEditing():void
		{
			if (!st) // Adding a new Switch
			{
				gs = rd.gridSpaces[gridIndex];
				gs.imgNum = 4, gs.imgIndexHistory.push(4);
				st = rd.switchTiles[rd.switchTiles.push(SwitchTile_RD(world.create(SwitchTile_RD))._SwitchTile_RD(gs.x, gs.y, gridIndex, newClientGridNums, outlineIndices[0], outlineIndices[1], true))];
			}
			else if (newClientGridNums.length > 0) // Editing a Switch
			{
				for each (sc in stClientsPendingRemoval)
				{
					st.epRemove(sc);
					st.clients.splice(st.clients.indexOf(sc), 1);
				}
				
				st.getNewClients(newClientGridNums);
			}
			
			
			Sounds.select1();
			world.remove(this);
		}
		
		public function cancelCreator():void
		{
			if (!st) // Adding a new Switch
			{
				gs = rd.gridSpaces[gridIndex];
				gs.fillTile(true);
			}
			else // Editing a Switch
			{
				for each (sc in stClientsPendingRemoval) sc.epActive(true), sc.epCollidableAndVisible(true);
			}
			
			
			for (var i:uint = 0; i < newClients.length; i++)
			{
				sc = newClients[i];
				world.remove(sc);
			}
			
			
			Sounds.knock1();
			world.remove(this);
		}
		// --------------------------------------------------------------------------------
		
		
		private function deleteSwitchTile():void
		{
			for each (sc in newClients) sc.removeThis();
			newClients.length = 0;
			
			var gs:GridSpace;
			gs = rd.gridSpaces[gridIndex];
			gs.fillTile(true);
			
			
			rd.switchTiles.splice(rd.switchTiles.indexOf(st), 1);
			world.remove(st);
			
			
			Sounds.knock1();
			world.remove(this);
		}
		// --------------------------------------------------------------------------------
		
		
		private function getOutlineIndices():Array
		{
			var indices:Array = [0, -1];
			var st1:SwitchTile_RD;
			
			
			if (rd.switchTiles.length > 0)
			{
				var colorComboUseCounts:Array = new Array(SwitchOutline.outlineColorCombos.length);
				
				for (var i:uint = 0; i < SwitchOutline.outlineColorCombos.length; i++)
				{
					colorComboUseCounts[i] = 0;
					for (var j:uint = 0; j < rd.switchTiles.length; j++)
					{
						st1 = rd.switchTiles[j];
						
						if (st1.outlineIndices[0] == SwitchOutline.outlineColorCombos[i][0] 
						&& st1.outlineIndices[1] == SwitchOutline.outlineColorCombos[i][1]) colorComboUseCounts[i]++;
					}
				}
				
				
				var count:int = 0;
				while (count > -1)
				{
					// Find the first combo with the lowest use count
					for (var k:uint = 0; k < colorComboUseCounts.length; k++)
					{
						if (colorComboUseCounts[k] == count)
						{
							indices[0] = SwitchOutline.outlineColorCombos[k][0];
							indices[1] = SwitchOutline.outlineColorCombos[k][1];
							count = -1;
						}
					}
					
					if (count != -1) count++;
				}
			}
			
			
			return indices;
			
			
			/*
			SwitchOutline.outlineColorCombos: Confirmed correct with trace test. On 2/10/2015
			
			0,-1
			1,-1
			2,-1
			3,-1
			4,-1
			5,-1
			6,-1
			7,-1
			8,-1
			9,-1
			10,-1
			
			0,2
			0,3
			0,4
			0,7
			0,9
			0,10
			
			1,2
			1,3
			1,4
			1,6
			1,7
			1,9
			1,10
			
			2,0
			2,1
			2,4
			2,6
			2,9
			2,10
			
			3,0
			3,1
			3,4
			3,6
			3,9
			
			4,0
			4,1
			4,2
			4,3
			4,6
			4,7
			4,8
			4,10
			
			5,0
			5,1
			5,2
			5,3
			5,7
			5,8
			5,10
			
			6,2
			6,3
			6,4
			6,7
			6,8
			6,9
			6,10
			
			7,0
			7,4
			7,6
			7,9
			7,10
			
			8,0
			8,2
			8,3
			8,4
			8,6
			8,7
			8,9
			
			9,0
			9,1
			9,2
			9,3
			9,6
			9,7
			9,8
			9,10
			
			10,0
			10,1
			10,2
			10,4
			10,6
			10,7
			10,9
			*/
			
			
		}
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
		
		
		// --------------------------------------------------------------------------------
		
	}

}