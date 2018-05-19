package game_manual 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import net.jacob_stewart.JS;
	import net.jacob_stewart.Keys;
	import net.jacob_stewart.EntityPlus;
	import net.jacob_stewart.text.TextButton;
	import net.jacob_stewart.text.TextPlus;
	
	import gui.MenuArrow;
	import gui.options_menu.OptionsMenu;
	import worlds.room_designer.RoomDesigner;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class Manual extends EntityPlus 
	{
		
		public function Manual(manualPage:uint = 0) 
		{
			this.manualPage = manualPage;
			
			
			super();
		}
		
		override public function init():void 
		{
			super.init();
			
			
			name = Game.NAME_Manual;
		}
		
		override public function added():void 
		{
			super.added();
			
			
			active = true;
			rd = world.getInstance(Game.NAME_RoomDesigner) as RoomDesigner;
			oMenu = world.getInstance(Game.NAME_OptionsMenu) as OptionsMenu;
			
			const SECTIONCHANGEBTN_PAD:uint = 20;
			const SECTIONCHANGEBTN_CENTERY:uint = Math.round(oMenu.LINEY - (Images.arrowRightNormal.scaledHeight * .5) - 10);
			nextSectionBtn = new MenuArrow(updateChangeSection, 1, Math.round(oMenu.panel.x + oMenu.panel.outline.width - (Images.arrowRightNormal.scaledWidth * .5) - SECTIONCHANGEBTN_PAD), SECTIONCHANGEBTN_CENTERY, TEXTLAYER);
			prevSectionBtn = new MenuArrow(updateChangeSection, 3, Math.round(oMenu.panel.x + (Images.arrowLeftNormal.scaledWidth * .5) + SECTIONCHANGEBTN_PAD), SECTIONCHANGEBTN_CENTERY, TEXTLAYER);
			
			const PAGECHANGEBTN_PAD:uint = 10;
			pageUpBtn = new MenuArrow(updateChangePage, 0, FP.halfWidth, Math.round(oMenu.LINEY + oMenu.LINE_THICK + (Images.arrowUpNormal.scaledHeight * .5) + PAGECHANGEBTN_PAD), TEXTLAYER);
			pageDownBtn = new MenuArrow(updateChangePage, 2, FP.halfWidth, Math.round(oMenu.panel.y + oMenu.panel.outline.scaledHeight - (Images.arrowDownNormal.scaledHeight * .5) - PAGECHANGEBTN_PAD), TEXTLAYER);
			
			
			epAddList([title, nextSectionBtn, prevSectionBtn]);
			title.changeText(TITLES[manualPage]);
			
			infoPage = 0;
			addPageText();
		}
		
		override public function removed():void 
		{
			super.removed();
			
			
			rd = null;
			oMenu = null;
		}
		// ------------------------------------------------------------------------------
		
		
		override public function update():void 
		{
			super.update();
			
			
			updateChangePage();
			updateChangeSection();
			
			debug1();
		}
		
		public function updateChangePage(clickVal:int = -1):void
		{
			if (Input.pressed(Keys.UP) || Input.keys(Keys.UP).indexOf(clickVal) != -1)
			{
				if (pageUpBtn.world) pageUp();
			}
			
			if (Input.pressed(Keys.DOWN) || Input.keys(Keys.DOWN).indexOf(clickVal) != -1)
			{
				if (pageDownBtn.world) pageDown();
			}
		}
		
		public function updateChangeSection(clickVal:int = -1):void
		{
			if (Input.pressed(Keys.LEFT) || Input.keys(Keys.LEFT).indexOf(clickVal) != -1) prevSection();
			if (Input.pressed(Keys.RIGHT) || Input.keys(Keys.RIGHT).indexOf(clickVal) != -1) nextSection();
		}
		// ------------------------------------------------------------------------------
		
		
		private function pageUp():void
		{
			Sounds.tick3();
			pageUpBtn.onKeyPressed();
			epRemoveList(infoPageText);
			
			infoPage--;
			if (infoPage == 0) epRemove(pageUpBtn);
			addPageText();
		}
		
		private function pageDown():void
		{
			Sounds.tick3();
			pageDownBtn.onKeyPressed();
			epRemoveList(infoPageText);
			
			infoPage++;
			if (infoPage == info[manualPage].length - 1) epRemove(pageDownBtn);
			addPageText();
		}
		
		public function nextSection():void
		{
			Sounds.tick3();
			nextSectionBtn.onKeyPressed();
			changeSection(1);
		}
		
		public function prevSection():void
		{
			Sounds.tick3();
			prevSectionBtn.onKeyPressed();
			changeSection( -1);
		}
		
		private function changeSection(nextOrPrev:int):void
		{
			if (pageUpBtn.world) epRemove(pageUpBtn);
			if (pageDownBtn.world) epRemove(pageDownBtn);
			epRemoveList(infoPageText);
			
			manualPage += nextOrPrev;
			if (manualPage < 0) manualPage = TITLES.length - 1;
			else if (manualPage > (TITLES.length - 1)) manualPage = 0;
			
			infoPage = 0;
			
			title.changeText(TITLES[manualPage]);
			addPageText();
		}
		// ------------------------------------------------------------------------------
		
		
		private function addPageText():void
		{
			infoPageText.length = 0;
			
			var tp:TextPlus;
			var nextLineY:uint = SECTIONTITLE1Y;
			
			
			for (var i:uint = 0; i < sectionTitles[manualPage][infoPage].length; i++) // Each section
			{
				infoPageText.push(epAdd(new TextPlus(sectionTitles[manualPage][infoPage][i], LEFTMARGINX, nextLineY, { size: SECTIONTITLESIZE } )));
				
				tp = infoPageText[infoPageText.length - 1] as TextPlus;
				tp.layer = TEXTLAYER;
				
				nextLineY = tp.y + tp.textHeight + 8;
				
				for (var j:uint = 0; j < info[manualPage][infoPage][i].length; j++) // Each info line of section i // [Fault] exception, information=TypeError: Error #1010: A term is undefined and has no properties.
				{
					infoPageText.push(epAdd(new TextPlus(info[manualPage][infoPage][i][j], LEFTMARGINX, nextLineY, { size: INFOSIZE } )));
					
					tp = infoPageText[infoPageText.length - 1] as TextPlus;
					tp.layer = TEXTLAYER;
					
					
					tp.front.setStyle("color", { color: INFOTEXTCOLOR } );
					tp.front.richText = "<color>" + tp.text + "</color>";
					
					if (tp.front.width > 560)
					{
						tp.front.wordWrap = true, tp.front.width = 560;
						if (tp.back) tp.back.wordWrap = true, tp.back.width = 560;
					}
					
					nextLineY += tp.front.textHeight + 6;
				}
				
				nextLineY += 20;
			}
			
			if (info[manualPage].length - 1 > infoPage) epAdd(pageDownBtn);
			if (infoPage > 0) epAdd(pageUpBtn);
		}
		// ------------------------------------------------------------------------------
		
		
		
		private var mp:MousePointer_GM = new MousePointer_GM([JS.TYPE_TextButton]);
		private var rd:RoomDesigner;
		
		private static const TITLESTR_STORY:String = "STORY MODE";
		private static const TITLESTR_RS:String = "ROOM SELECT";
		private static const TITLESTR_RD:String = "ROOM DESIGNER";
		private static const TITLESTR_STE:String = "SWITCH TILE EDITOR";
		
		private var title:TextPlus = new TextPlus("TITLE", 0, 38, { size: 24, alignCenterX: FP.halfWidth, backOffset: 2 }, TEXTLAYER);
		private static const TITLES:Array = [TITLESTR_STORY, TITLESTR_RS, TITLESTR_RD, TITLESTR_STE];
		
		private var manualPage:uint = 99;
		public static var PAGE_STORYMODE:uint = TITLES.indexOf(TITLESTR_STORY);
		public static var PAGE_ROOMSELECT:uint = TITLES.indexOf(TITLESTR_RS);
		public static var PAGE_ROOMDESIGNER:uint = TITLES.indexOf(TITLESTR_RD);
		public static var PAGE_STE:uint = TITLES.indexOf(TITLESTR_STE);
		
		private const TEXTLAYER:int = -21;
		
		private const LEFTMARGINX:uint = 120;
		
		private const BASESIZE:uint = Text.size;
		private const INFOSIZE:uint = BASESIZE;
		private const SECTIONTITLESIZE:uint = INFOSIZE + 4;
		
		private const SECTIONTITLE1Y:uint = 120;
		
		private const INFOTEXTCOLOR:uint = 0xa0a0a0;
		// private const INFOTEXTCOLOR:uint = 0xa8a8a8;
		
		
		private var infoPage:uint = 0;
		private var infoPageText:Array = new Array;
		
		private var oMenu:OptionsMenu;
		
		private var pageUpBtn:MenuArrow;
		private var pageDownBtn:MenuArrow;
		private var nextSectionBtn:MenuArrow;
		private var prevSectionBtn:MenuArrow;
		// ------------------------------------------------------------------------------
		
		
		
		private var sectionTitles:Array = 
		[
			/* STORY MODE - Manual Section 0 */
			[
				/* Page  0 */
				[
					/* Section  1 */ ["Goals"],
					/* Section  2 */ ["Tiles"]
				],
				
				/* Page  1 */
				[
					/* Section  1 */ ["Push Blocks"],
					/* Section  2 */ ["Push Block Selection"],
					/* Section  3 */ ["Push Block Pushing"]
				]
			],
			
			/* PUZZLE SELECT - Manual Section 1 */
			[
				/* Page  0 */
				[
					/* Section  1 */ ["With the Mouse"],
					/* Section  2 */ ["With the Keyboard"]
				]
			],
			
			/* PUZZLE DESIGNER - Manual Section 2 */
			[
				/* Page  0 */
				[
					/* Section  1 */ ["Placing Blocks and Tiles"],
					/* Section  2 */ ["Removing Blocks and Tiles"],
					/* Section  3 */ ["Switch Tiles and Their Clients"],
					/* Section  4 */ ["Naming, Testing, and Adding to the Playlist"]
				]
			],
			
			/* SWITCH TILE EDITOR - Manual Section 3 */
			[
				/* Page  0 */
				[
					/* Section  1 */ ["Placing Switch Clients"],
					/* Section  2 */ ["Changing Active and Inactive Tile Types"],
					/* Section  3 */ ["Changing the Number of Moves Clients Stay Active"],
					/* Section  4 */ ["Removing Switch Clients"]
				]
			]
		];
		
		private var info:Array = 
		[
			
			/* STORY MODE - Manual Section 0 */
			[
				/* Page  0 */
				[
					/* Section  1 */
					[
						/* Line  1 */	["The goal of any room is to get all 'Goal' tiles covered with a block in as little moves as you can."]
						// /* Line  2 */	["Try doing this in as little moves as possible. Maybe something good will happen!"]
					],
					
					/* Section  2 */
					[
						/* Line  1 */	["FLOOR: The most basic and common of tiles. Move right across it with no resistance."],
						/* Line  2 */	["WALL: You shall not pass. You cannot get through or on top of a wall tile."],
						/* Line  3 */	["HOLE: You will fall through the floor into oblivion, never to be seen again... Unless the room is restarted."],
						/* Line  4 */	["GOAL: Like a floor tile, there is no resistance."],
						/* Line  5 */	["SWITCH: Touching this tile will cause its client tiles to change their tile type for a certain number of moves."],
						/* Line  6 */	["SWITCH CLIENT: Looks like any other tile but will turn into a different tile type for a certain number of moves when its host switch tile is touched."]
						// /* Line  6 */	["SWITCH CLIENT: Looks like any other tile but will turn into a different tile type for a certain number of moves when its host switch tile is touched. A client will not change if a block rests on top of it or its switch."]
						// /* Line  6 */	["SWITCH CLIENT: Looks like any other tile but will turn into a different tile type for a certain number of moves when its host switch tile is touched. The number of moves it will remain active is shown on top of itself. As long as a block is on top of a switch, the clients of that switch will remain active until that block moves, even if the client's moves-remaining counter is 0."]
					]
				],
				
				/* Page  1 */
				[
					/* Section  1 */
					[
						/* Line  1 */	["BLUE: Continues moving until it; runs into a wall, runs into a block, falls in a hole, falls off the edge of the room."],
						/* Line  2 */	["RED: Moves only ONE space from its home space and automatically moves back to its home space after the next move is completed."]
						// /* Line  2 */	["RED: Moves only ONE space from its home space. It will stay on that space until the next move is finished and then move back to its home space automatically. Its home space is a floor tile marked in the center with a red dot."]
					],
					
					/* Section  2 */
					[
						/* Line  1 */	["With the mouse: Click on the block."],
						/* Line  2 */	["With the keyboard: ARROW keys to highlight desired block. SPACEBAR to select it."],
						/* Line  3 */	["Deselect with ESC, SPACEBAR, or click different block."]
					],
					
					/* Section  3 */
					[
						/* Line  1 */	["With the mouse: Click on an arrow to push the block in that direction."],
						/* Line  2 */	["With the keyboard: Press an ARROW key to push the block in that direction."]
					]
				]
			],
			
			/* ROOM SELECT - Manual Section 1 */
			[
				/* Page  0 */
				[
					/* Section  1 */
					[
						/* Line  1 */	["Click the big arrow buttons to scroll through rooms 1 at a time."],
						/* Line  2 */	["Click on the little arrow buttons to scroll through rooms 10 at a time."],
						/* Line  3 */	["Click on the room to play it."]
					],
					
					/* Section  2 */
					[
						/* Line  1 */	["Press the LEFT or RIGHT arrow keys to scroll through rooms 1 at a time."],
						/* Line  2 */	["Hold SHIFT and press the LEFT or RIGHT arrow keys to scroll through rooms 10 at a time."],
						/* Line  3 */	["Press SPACE or ENTER to play a room."]
					]
				]
			],
			
			/* ROOM DESIGNER - Manual Section 2 */
			[
				/* Page  0 */
				[
					/* Section  1 */
					[
						// /* Line  1 */	["Click or hold click and drag."],
						// /* Line  2 */	["X and Z keys to change tile/block type."]
						/* Line  1 */	["Click or hold click and drag. X and Z keys change the type."]
					],
					
					/* Section  2 */
					[
						/* Line  1 */	["With the matching type under the mouse pointer, hold SHIFT and then click or click and drag."]
					],
					
					/* Section  3 */
					[
						/* Line  1 */	["Toggle Switch outlines and Switch Client move numbers with F8."],
						/* Line  2 */	["To remove a Switch tile or edit its clients, change the tile type under the mouse pointer to a Switch and then click on the Switch tile."]
					],
					
					/* Section  4 */
					[
						/* Line  1 */	["Click on the room name at the top to edit it."],
						/* Line  2 */	["You can test your design by selecting 'Test Room' in the options menu."],
						/* Line  3 */	["Your room must have at least ONE Push Block and Goal tile before it can be added to the playlist."]
					]
				]
			],
			
			/* SWITCH TILE EDITOR - Manual Section 3 */
			[
				/* Page  0 */
				[
					/* Section  1 */
					[
						/* Line  1 */	["Click or hold click and drag."]
					],
					
					/* Section  2 */
					[
						/* Line  1 */	["X and Z keys change active type. S and A keys change inactive type."],
						/* Line  2 */	["By mouse, change types with the 'Active Type' and 'Inactive Type' panels."]
					],
					
					/* Section  3 */
					[
						/* Line  1 */	["The number on the tile under the mouse pointer is the number of moves the Switch Clients you place will remain active."],
						/* Line  2 */	["Simply type a number to change the number of moves."],
						/* Line  3 */	["Press the CTRL key to make the number of moves infinite."]
					],
					
					/* Section  4 */
					[
						// /* Line  1 */	["Switch Clients can only be removed while in the Switch Tile Client Creator or the Switch Tile Client Editor."],
						// /* Line  2 */	["While holding SHIFT: click on a Switch Client or hold click and drag across multiple Switch Clients."]
						/* Line  1 */	["While holding SHIFT: click on a Switch Client or hold click and drag across multiple Switch Clients."]
					]
				]
			]
		];
		// ------------------------------------------------------------------------------
		
		
		private function debug1():void
		{
			if (Input.pressed(Key.T))
			{
				trace("pageDownBtn.world: ", pageDownBtn.world);
				trace("pageDownBtn.visible: ", pageDownBtn.visible);
				trace("pageDownBtn.collidable: ", pageDownBtn.collidable);
				trace("pageDownBtn.graphic: ", pageDownBtn.graphic, " pageDownBtn.image == pageDownBtn.graphic: ", pageDownBtn.image == pageDownBtn.graphic);
				trace("pageDownBtn.image.alpha: ", pageDownBtn.image.alpha);
				trace("pageDownBtn.x: ", pageDownBtn.x, " pageDownBtn.y: ", pageDownBtn.y);
				trace("");
			}
		}
		// ------------------------------------------------------------------------------
		
		
		
		// ------------------------------------------------------------------------------
		
	}

}