package  
{
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Jacob Stewart
	 * A list of all the source images for the game
	 */
	public class Images 
	{
		[Embed(source = "../assets/images/Other/Glow_orb_01a.png")] public static const GLOWORB1A:Class;
		public static var glowOrb1a:Image = new Image(GLOWORB1A);
		[Embed(source = "../assets/images/Other/Glow_orb_01b.png")] public static const GLOWORB1B:Class;
		public static var glowOrb1b:Image = new Image(GLOWORB1B);
		
		
		[Embed(source = "../assets/images/GUI_elements/Other/1x1_White.png")] public static const PIXEL_1X1:Class;
		[Embed(source = "../assets/images/GUI_elements/Screen_tint_Black1.png")] public static const SCREENTINTBLACK:Class;
		[Embed(source = "../assets/images/GUI_elements/SaveFilePanel/SaveFilePanel_Fill1.png")] public static const SAVEFILEPANEL_FILL:Class;
		[Embed(source = "../assets/images/GUI_elements/SaveFilePanel/SaveFilePanel_Outline1.png")] public static const SAVEFILEPANEL_OUTLINE:Class;
		[Embed(source = "../assets/images/GUI_elements/MenuListSelector/MenuListSelectorOutline.png")] public static const MENULISTSELECTOR_OUTLINE:Class;
		[Embed(source = "../assets/images/GUI_elements/Keyboard_keys/Keyboard_key1.png")] public static const KEYBOARD_KEY1:Class;
		
		
		
		[Embed(source = "../assets/images/Game_pieces/Tiles/blank1.png")] public static const BLANKTILEIMG:Class;
		public static var blankTileImg:Image = new Image(BLANKTILEIMG);
		
		[Embed(source = "../assets/images/Game_pieces/Blocks/Block1.png")] public static const BLOCK1:Class;
		[Embed(source = "../assets/images/Game_pieces/Blocks/Blue_block.png")] public static const BLUEBLOCK1:Class;
		[Embed(source = "../assets/images/Game_pieces/Blocks/Red_block.png")] public static const REDBLOCK1:Class;
		[Embed(source = "../assets/images/Game_pieces/Blocks/Red_dot1.png")] public static const REDDOT1:Class;
		[Embed(source = "../assets/images/Game_pieces/Tiles/Floor_tile.png")] public static const FLOORTILEIMG:Class;
		[Embed(source = "../assets/images/Game_pieces/Tiles/Wall_tile.png")] public static const WALLTILEIMG:Class;
		[Embed(source = "../assets/images/Game_pieces/Tiles/Goal_block1.png")] public static const GOALTILE:Class;
		[Embed(source = "../assets/images/Game_pieces/Tiles/Hole_Tile.png")] public static const HOLETILE:Class;
		[Embed(source = "../assets/images/Game_pieces/Tiles/Switch_tile.png")] public static const SWITCHTILE1:Class;
		[Embed(source = "../assets/images/Game_pieces/Blocks/Auto_Move_Block.png")] public static const AUTOMOVEBLOCK:Class;
		[Embed(source = "../assets/images/Game_pieces/Tiles/Back_and_Forth_Tile_01.png")] public static const SEQUENCEBLOCK:Class;
		public static var block1Img:Image = new Image(BLOCK1);
		
		
		[Embed(source = "../assets/images/Game_pieces/Game_piece_Outline_01.png")] public static const GAMEPIECE_OUTLINE:Class;
		public static var gamePieceOutline1:Image = new Image(GAMEPIECE_OUTLINE);
		// [Embed(source = "../assets/images/Game_pieces/Game_piece_Outline_02.png")] public static const GAMEPIECE_OUTLINE:Class;
		
		[Embed(source = "../assets/images/Game_pieces/Tiles/Goal_Wide.png")] public static const GOALWIDE:Class;
		public static var goalWideImg:Image = new Image(GOALWIDE);
		[Embed(source = "../assets/images/Game_pieces/Tiles/Goal_outline1.png")] public static const GOALOUTLINE:Class;
		
		[Embed(source = "../assets/images/Game_pieces/Tiles/Switch_tile_Wide.png")] public static const SWITCHTILEWIDE:Class;
		[Embed(source = "../assets/images/Game_pieces/Tiles/Switch_block_S.png")] public static const SWITCHBLOCK_S:Class;
		[Embed(source = "../assets/images/Game_pieces/Tiles/Hole_tile_Background_01.png")] public static const HOLETILEBACKGROUND1:Class;
		public static var holeBg:Image = new Image(HOLETILEBACKGROUND1);
		
		[Embed(source = "../assets/images/Game_pieces/Blocks/Block_highlighter1.png")] public static const BLOCKHIGHLIGHTER:Class;
		public static var highlightImg:Image = new Image(BLOCKHIGHLIGHTER);
		public static var highlight2Img:Image = new Image(BLOCK1);
		[Embed(source = "../assets/images/Game_pieces/Blocks/Block_highlighter2.png")] public static const BLOCKHIGHLIGHTER2:Class;
		public static var blockHighlighter2Img:Image = new Image(BLOCKHIGHLIGHTER2);
		
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/MoveArrowUp_Normal.png")] public static const MOVEARROWUPNORMAL:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/MoveArrowUp_Hover.png")] public static const MOVEARROWUPHOVER:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/MoveArrowRight_Normal.png")] public static const MOVEARROWRIGHTNORMAL:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/MoveArrowRight_Hover.png")] public static const MOVEARROWRIGHTHOVER:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/MoveArrowDown_Normal.png")] public static const MOVEARROWDOWNNORMAL:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/MoveArrowDown_Hover.png")] public static const MOVEARROWDOWNHOVER:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/MoveArrowLeft_Normal.png")] public static const MOVEARROWLEFTNORMAL:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/MoveArrowLeft_Hover.png")] public static const MOVEARROWLEFTHOVER:Class;
		public static var arrowUpNormal:Image = new Image(MOVEARROWUPNORMAL);
		public static var arrowRightNormal:Image = new Image(MOVEARROWRIGHTNORMAL);
		public static var arrowDownNormal:Image = new Image(MOVEARROWDOWNNORMAL);
		public static var arrowLeftNormal:Image = new Image(MOVEARROWLEFTNORMAL);
		public static var arrowSources:Array = [MOVEARROWUPNORMAL, MOVEARROWRIGHTNORMAL, MOVEARROWDOWNNORMAL, MOVEARROWLEFTNORMAL];
		
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/Room_select_Next_room1.png")] public static const NEXTROOMARROW:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/Room_select_Previous_room1.png")] public static const PREVIOUSROOMARROW:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/Room_select_To_My_rooms.png")]public static const TOMYROOMSARROW:Class;
		[Embed(source = "../assets/images/GUI_elements/Move_arrows/Room_select_To_story_mode.png")] public static const TOGAMEROOMSARROW:Class;
		public static var rsArrow1Next:Image = new Image(NEXTROOMARROW);
		public static var rsArrow1Prev:Image = new Image(PREVIOUSROOMARROW);
		public static var rsArrow10Next:Image = new Image(MOVEARROWRIGHTNORMAL);
		public static var rsArrow10Prev:Image = new Image(MOVEARROWLEFTNORMAL);
		public static var toMyRoomsArrow:Image = new Image(TOMYROOMSARROW);
		public static var toGameRoomsArrow:Image = new Image(TOGAMEROOMSARROW);
		public static var rsArrows:Array = [rsArrow1Next, rsArrow1Prev, rsArrow10Next, rsArrow10Prev];
		// public static var audioLevelArrows:Array = [rsArrow10Prev /* index 0: Key.LEFT - Key.LEFT (37 - 37) */, null, rsArrow10Next /* index 2: Key.RIGHT - Key.LEFT (39 - 37) */];
		public static var audioLevelArrows:Array = [MOVEARROWLEFTNORMAL /* index 0: Key.LEFT - Key.LEFT (37 - 37) */, null, MOVEARROWRIGHTNORMAL /* index 2: Key.RIGHT - Key.LEFT (39 - 37) */];
		
		[Embed(source = "../assets/images/GUI_elements/Wrench_icon1.png")] public static const WRENCHICON1:Class;
		[Embed(source = "../assets/images/GUI_elements/Infinity_icon1.png")] public static const INFINITYICON1:Class;
		[Embed(source = "../assets/images/GUI_elements/Infinity_icon1_back.png")] public static const INFINITYICON1BACK:Class;
		public static var infinityIcon:Image = new Image(INFINITYICON1);
		public static var infinityIconBack:Image = new Image(INFINITYICON1BACK);
		
		[Embed(source = "../assets/images/GUI_elements/Lock_symbol.png")] public static const LOCKSYMBOL:Class;
		
		[Embed(source = "../assets/images/GUI_elements/Audio_level_Changer_bar_01.png")] public static const AUDIO_LEVEL_BAR:Class;
		
		
		[Embed(source = "../assets/images/Game_pieces/Blocks/Falling_block_Glow1.png")] public static const FALLINGBLOCKGLOW:Class;
		public static var fallingBlockGlow:Image = new Image(FALLINGBLOCKGLOW);
		
		
		[Embed(source = "../assets/images/GUI_elements/Ranking_blocks/Bronze_01.png")] public static const RANKINGBRONZE1:Class;
		[Embed(source = "../assets/images/GUI_elements/Ranking_blocks/Silver_01.png")] public static const RANKINGSILVER1:Class;
		[Embed(source = "../assets/images/GUI_elements/Ranking_blocks/Gold_01.png")] public static const RANKINGGOLD1:Class;
		public static var rankingNone:Image = new Image(HOLETILE);
		public static var rankingBronze:Image = new Image(RANKINGBRONZE1);
		public static var rankingSilver:Image = new Image(RANKINGSILVER1);
		public static var rankingGold:Image = new Image(RANKINGGOLD1);
		public static var rankingBlocks:Array = [rankingBronze, rankingSilver, rankingGold];
		
		
		[Embed(source = "../assets/images/GUI_elements/Other/Menu_panel_Outline_01.png")] public static const MENUPANEL_OUTLINE:Class;
		[Embed(source = "../assets/images/GUI_elements/Other/Menu_panel_Fill_01.png")] public static const MENUPANEL_FILL:Class;
		
		
		
		public static var floorImg:Image = new Image(FLOORTILEIMG);
		public static var wallImg:Image = new Image(WALLTILEIMG);
		// public static var goalImg:Image = new Image(GOALWIDE);
		public static var goalImg:Image = new Image(GOALTILE);
		public static var holeImg:Image = new Image(HOLETILE);
		public static var switchImg:Image = new Image(SWITCHTILE1);
		public static var blueImg:Image = new Image(BLUEBLOCK1);
		public static var redImg:Image = new Image(REDBLOCK1);
		public static var sequenceBlockImg:Image = new Image(SEQUENCEBLOCK);
		public static var imgs:Array = [floorImg, wallImg, goalImg, holeImg, switchImg, blueImg, redImg, sequenceBlockImg, glowOrb1b];
		
		public static var gamePieceSourceImages:Array = [FLOORTILEIMG, WALLTILEIMG, GOALTILE, HOLETILE, SWITCHTILE1, BLUEBLOCK1, REDBLOCK1, SEQUENCEBLOCK, GLOWORB1B];
		
	}

}