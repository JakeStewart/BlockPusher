package documentation 
{
	/**
	 * ...
	 * @author Jacob Stewart
	 */
	public class GameNotes 
	{
		
		/*
		BLOCK PUSHING GAME
		
		Each block has a limited amount of moves.
		User is limited to a total number of moves.
		Certain modes or difficulties determine how many moves the user gets.
		
		Goal: Get any type of block on each goal square
		Finishing a room in a certain number of moves determines your score for the room/level
		
		Several different types of blocks:
			Blue: Will keep moving until it hits a wall or another block
			Red:
				A limited move block
				Can only move 1 space at a time:
					Only to the 4 spaces surrounding it's home space:
						After the move following the RedBlock move, the RedBlock will move back to it's home space
						The home space has a red dot in the middle of it
					Has a limited number of moves
			Orange: 
				Moves diagonal
				Moves in a Z pattern
				Moves in a square pattern returning to it's home space after 4 moves
				Teleports:
					Teleports to a teleport square of the user's choice
					The teleport square it teleports to is determined by a pre-determined sequence
				The distance it moves is determined by the type of floor
			Automated Block:
				-
				Moves on a pre-determined path:
					-
					These paths could be mathematical, like a pattern that's a puzzle in itself to figure out
				Moves one block each turn after the turn is done
			AI Blocks:
				Makes moves to hinder the player
			Bounce blocks:
				A block that causes other blocks to bounce off it
			Responsive block:
				-
				A block that responds in some way:
					When another block runs into it
					When another block lands adjacent to it
			Twins/Mimics:
				-
				Blocks that mimic the movement of a block the user moves.
				Blocks that move in the opposite direction of a block the user moves.
				
		Tile types:
			Floor tile
			Switch tile:
				Will cause a certain action when a block moves across or lands on it
				
				SwitchTileClients:
					
					If a MovableBlock is still sitting on a client's parent when it's 
					moveCount runs out, it's moveCount will remain at 0 until the 
					MovableBlock leaves it's parent.
					
					If a MovableBlock is still sitting on a client when that client's
					moveCount runs out, the MovableBlock will be obliterated.
					
				
				SwitchTileCreator Class:
					-
					In Room Designer mode, when the user lays a SwitchTile, the SwitchTileCreator will
					appear and ask the user various questions which will customize
					the switch tile.
					
					There will be a "FINISHED" button at question 1.
						The user can finish the customization without answering any questions. The 
						SwitchTile will simply do nothing when touched.
					
					After the SwitchTile has been customized, the user can hold the 'S' key & click 
					on the SwitchTile to display what it will do.
						- In this mode, user can click an "EDIT" button to edit the SwitchTile's affects
					
					These questions could be:
						-
						1. Choose what happens when a block touches this Switch Tile: (A series of text buttons are below)
							- Turn tiles into a hole
							- Turn tiles into a bounce tile
							- Turn tiles into a floor tile
							- Turn tiles into a wall tile
							
						2. How many moves after it's touched will the tiles be affected?
							- User can input a number or click a check box next to a "FOREVER" Text
							- If user inputs 0, the SwitchTile's affect will only last the move it was touched
							
						The user can then select one or multiple tiles before clicking a continue button
						The tiles can be selected one at a time by clicking or with a drag area rectangle function
						Any selected tile can be unselected in the same manner
						
						The SwitchTileCreator then loops back to question 1.
			Hole:
				If a block moves on or across a hole, it falls in it & does not respawn
			Teleport tile:
				If a block moves across or lands on a teleport tile, it will be teleported to 
				the sister teleport tile and keep going if unobstructed.
				
			Glass tile:
				* Will break after a certain amount of times a block hits it
				* Cracks visibly get worse each hit
				
			ToggleTile:
				* Is 2 different tile types
				* Will switch types when a move is made
				
			Back-and-Forth Tile:
				* Moves back and forth between two tiles
				* Moves on player move finish
				* A black dot is in the center of each Floor Tile
				* Could move to four different spaces surrounding its home space
					* User in RoomDesigner decides the sequence
					* Moves back to home space before moving to the next tile in the sequence
				
				* Need to account for blocks in the way of a move
				
			Path Tile:
				* Moves along a path
				* Can be a wall, hole, goal, switch
				* A line path appears as the Path Tile makes its move then dissapears
				
			Back-and-Forth Tile 2:
				* Moves like a BlueBlock (until it runs into something)
				* Only moves on one directional axis (up and down or left and right)
				
			Laser Tile:
				* Shoots a deadly laser
				* Laser is constant
				* Laser stops at a block, wall, etc..
				
		Secret rooms:
			-
			Some Switch Tiles will reveal hidden goal spaces. 
				Get a movable block on the hidden goal space to access a secret room.
				
		Enemies: Some tiles have enemies that you can kill by squishing with the push
				 of a block.  
				
		RoomDesigner:
			-
			A SwitchTileClient can be on top of a SwitchTile, but not it's host SWitchTile
			A SwitchTileClient's reaction can be to turn on or off when it's activated
			
			
			Draft file: A record of the current user room design in RoomDesigner
				When loading a room from RoomSelect and there is an unsaved draft, the user
				is prompted with a warning message that the draft will be replaced by the 
				room being loaded.
					If the draft is a playlist room that has NOT been modified since its 
					last save, there will NOT be any warning prompt.
					If the draft file is empty, there will NOT be any warning prompt.
				Need something to signify what room is being edited
			Entering RoomDesigner scenarios
				From TitleMenu
					load the current draft if not empty
				From RoomSelect
					Need to know the file name
					RoomSelect prompts warning that current draft will be erased
						Give option to add current draft to playlist
							What if the current draft doesn't qualify as a playable room?
						User can press ESC to cancel to they can finish the current draft first.
					RoomDesigner checks the fileName:String passed
						if (fileName != null) {user is naving from RoomSelect to RoomDesigner to edit a room}
						else {load the current draft if not empty}
				From RoomTester
					load the current draft if not empty
			

		
		LevelData:
			var ld:Array = [level1, level2, level3, ...];
			var level1:Array = [room1, room2, room3, ...];
			var room1:Array = [roomWidth, roomHeight, firstRoomBlockCoords, ...];
			var roomWidth:uint = 5;
			var roomHeight:uint = 5;
			
			var roomDimensions:Array = [ [[5, 5], [5, 5], [6, 5]], [[6, 6], [6, 6], [7, 6]], [[7, 7], [8, 7], [8, 8]] ];
			
			5x5, g 16 24, b 37 39, r 18, i null
			6x6, g 27 27 35 36 b 21 45 42 51
			
			
			
		CHECKLIST FOR ADDING NEW GAME ELEMENTS:
			
			SaveFileData					*
				loadStatsData()				*
				saveRoomCompleteData()		*
				newSaveFile()				*
				
			RoomData						*
				loadRoomData()				*
				loadRoomDataXML()			*
				saveRoomData()				*
				saveRoomDataXML()			*
				eraseRoom()					*
				draftIsDifferent()			*
				
			Images							*
				
			RoomDesigner					*
				RoomDesigner				*
					loadFile()				*
					updateRoomData()		*
					saveRoomData()			*
					
				SpaceSelector_TileTypeText	*
					nameStrs				*
					
				SpacesSelectorGamePiece		*
				SpaceSelector_RD			*
				SaveQualificationChecker	*
				SaveChangesButton			*
					activationCheck()		*
				GridSpace
					setLayers()
				
			RoomSelect
				RoomSelect					*
					previewRoom()			*
					setScrollRooms()		*
					
					
				UnsavedDraftWarning			*
					save()					*
					saveData()				*
					
				RoomStats
				
			Stats
				
			Game play
				RoomCompleteScreen			
				Room						*
				GamePlayText				*
				GamePlayManager				*
				
			Update data in xml files
					
					
				
		KONGREGATE Game Description Info:
		
		A block pushing puzzle game with 50+ puzzles and a feature that allows the user to design and play their own puzzles.
		A block pushing puzzle game with 50+ puzzles. Users can also design and play their own puzzles!

		Game Play:
		ENTER/SPACE: Select, Complete, Accept, Action
		ESC/BACKSPACE: Open options, Back out, Cancel, Deselect
		Arrow keys/WASD: Push block, Highlight next block
		R: Retry room
		M: Mute sound

		Room Designer:
		Click: Place game piece
		Hold SHIFT then Click: Remove game piece
		X/Z: Change game piece type
		N: Name room
		F4/F8: Toggle game piece info
		X/Z: Cycle active type (Switch Tile Editor)
		A/S: Cycle inactive type (Switch Tile Editor)
		TAB: Swap active and inactive type (Switch Tile Editor)
		CTRL: Set switch client moves to infinite (Switch Tile Editor)

		Title Menu: 
		Hold DELETE: Delete save file (File Select)
			
			
			
		THINGS TO DO: **********************************************************************************
			
		1: - DONE
			What happens when SwitchTileClients are placed on GoalTiles?
			
			It acts the same as usual, it's activeImg or inactiveImg will
			be ImageConstants.goalImg, the other will be floor, wall or hole.
			
			Shouldn't be too big a deal since onFinishMove(), GameManager
			will still check if all the movable block's indices match up
			with all the GoalTile indices.
			
		2: SCRAPPING
			If a movable block is placed on a SwitchTile, the SwitchTile 'S'
			should still be visible so the designer of the room can easily
			see there's a SwitchTile under the movable block
			
		3: NAH
			For Room Editor mode, create a toggle that lets the user see
			what the room looks like in playable mode.
			(Isn't that the same as Test Room mode?)
			
		4:- DONE
			When adding SwitchTileClients, the SwitchTileCustomizer should
			push a 'new SwitchTile' into a switchTiles array in RoomDesigner,
			then send the client data over to that SwitchTile so it can create
			clients right then and there. If SwitchTileCustomizer is cancelled,
			SwitchTileCustomizer removes the SwitchTile in creation by
			re.switchTiles.pop(). Then it removes all of the clients it just
			created by putting all clients in the world into an array and matching
			them up to an array of grid indices of the clients it just created.
			
			When the SwitchTile is created, SwitchTileCustomizer sends an array
			of grid indices of the clients that were just created. In SwitchTile.added(),
			an array is populated of all the clients in the world, which are then matched
			to the array of grid indices. SwitchTile then pushes the ones that match
			into an array.
			
		5:- DONE
			Hover state for EmptySpaceBlock should be brighter if it's a qualified
			to change. Can possibly use Image.color & Image.tinting in the changeState().
			
		6:- DONE
			Need to add functionality that lets the user modify the properties of 
			SwitchTileClients in RoomDesigner.
			
			While BlockUnderMouse graphic is set to a switch tile, hovering over a SwitchTile
			will replace the plus icon with a wrench icon. Click on that SwitchTile to go into
			Switch Tile Editor mode. ScreenTint alpha goes to .8, re.guiActive = true. The
			SwitchTile and any of it's clients' layers change to above the ScreenTint layer.
			
			* Menus:
				
				* There is a main menu where the user selects which clients to modify
				* There is a submenu where the user selects the new properties for the selected clients
				* Pressing ESC in the submenu will go back to the main menu discarding any changes made in the submenu
					* Add ESC text in submenu:
						* ESC: Discard changes
				
			* Option buttons displayed include: 
				-
				ADD MORE CLIENTS
				
			* Information text displayed includes:
				-
				* Click on a client to adjust it's properties
				* Select multiple clients with click and drag
				* Hold TAB and click on a client to adjust its group's properties
				* Hold SHIFT and select clients to delete them
				* ESC: Discard all changes
				
			* Any modify properties scenario will activate the same GUI:
				-
				Every client selected will adopt these new properties
				
				* A clickable field for entering a new moves number
				* 2 lists of block types with their image:
					-
					1. Active type, the image along with the text is clickable
					2. Inactive type, the image along with the text is clickable
						
						Since there are only 3 block types for SwitchTileClients and
						two are already being used, there will only be one option.
						
						Or, all 3 options will display. If the user chooses the same
						type as it's other type, the next type in line will be set
						for it's other type.
					
				* Swap function: If a group has been selected, user can click a button to swap the types
					
					SWAP TYPES: A button that will swap the types
					
				* Info text: ESC: Discard changes
					
			* The user can drag over multiple clients to edit a group instead of editing
			  one at a time.
				
				Grouping will need to be added to code for this to work.
				
				Or, from the main SwitchTileEditor menu, hovering over any SwitchTileClient
				highlights it's whole group. Clicking on that group goes into a main menu for
				the group. Then the user can choose to edit one at a time or drag select multiple clients.
				The group main menu will have the option of editing all their info at once.
				Once the user completes this, a check is done to group clients with matching properties.
					
			
		7: - DONE
			RoomDesigner: Add the ability to put a movable block on a WallTile or HoleTile.
			This will have to change the EmptySpaceBlock from wall or hole to floor.
			
		8:
			Room idea: THE CLUB
			
				It's overcrowded with BlueBlocks and there are a few RedBlocks.
				There are a few Walls and a few Holes.
				The GoalTile(s) is behind a Wall that needs to be removed with a SwitchTile.
				Try to move BlueBlocks into Holes or off the grid.
			
		9:
			Different SwitchTile idea:
			
				SwitchTileClients only stay on for the move they're activated unless
				a movable block stays on it's host's tile.
			
		10:- DONE
			Need manual for each mode so the user knows which keys do what.
			
		11:
			SwitchTile image looks too small
			
		12:
			326, 416
			327, 417
			
		13:- DONE
			-
			Room naming:
				-
				DONE - Limit the amount of characters the user can type.
				DONE - Add ability to use characters like exclamation points.
				DONE - Fix numpad adds letters instead of numbers.
				
				Make sure everything that needs to know if a room has been 
				named or not has been adjusted properly.
			
		14: NO LONGER NEEDED
			-
			SwitchTileCustomizer:
				-
				Clean up the look of Step1
				Clean up the look of Step2
				Step2:
					-
					DONE - Center the user input moves number field horizontally and make the text size larger
					Add blinking cursor to the user input moves number field
					
		15:- DONE
			Fix New Room button in RoomDesigner (erase & load empty grid)
			
		16:- DONE
			Adjust SwitchTile outline color brightness. Some are too loud.
			
		17: NO LONGER NEEDED
			Change the 'continue' button in SwitchTileCustomizer Step3 to say
			something different like "Add different blocks"
			
		18: DONE
			In SwitchTileCustomizer Step3, add the moves number chosen to show on
			top of the BlockUnderMouse image
			
		19: NO LONGER NEEDED
			In SwitchTileCustomizer Step3, pressing the 'continue' button to go
			to Step1 doesn't change the screentint back to .7
			
		20:
			RoomDesigner, SwithTileCustomizer and SwithTile idea-
			When holding SHIFT to delete, the space highlight tints red
			
		21: DONE and REVAMPED
			
			SwitchTileCustomizer
			
			* Only 2 steps:
				* Step1: 
					* "Enter the number of moves the client(s) will stay active:"
					* Choose the active tile type:
					* Choose the inactive tile type:
				* Step2:
					* Place the tiles.
			
		22: DONE
			
			MouseProximityAlphaAdjust Class
			
			public var objs:Array = new Array();
			
			private var mouseCoords:EntityPlus = new EntityPlus();
			private var distance:Number;
			
			
			public function MouseProximityAlphaAdjust(_objs:Array, x:Number=0, y:Number=0, width:Number=0, height:Number=0) 
			{
				objs = _objs;
				
				
				super(x, y, width, height);
			}
			
		23: DONE
			
			RoomDesigner SwitchTile & SwitchTileClient-
			Add ability to hide outlines & client moves text
			
		24: SCRAPPED
			New way to save
			
			Every isFilled gridSpace contains all the data a save needs
			
		25: SCRAPPED
			New game mode: Casual mode - 
			
			* This is how you get to Puzzle Select screen
			* Lets user start from any puzzle that has been completed in Story Mode
			* Has separate scoring records from Story Mode
			
		26: DONE
			Idea
			
			There is only a Story Mode
				* I think it's pointless to make the user start at the first puzzle every time since its exactly the same every time
				* The user however, can use Puzzle Select to go to any puzzle they've completed to try and improve their score
			
			From the Title Screen Menu:
				* Clicking Story Mode will start user at first puzzle
				* Clicking Puzzle Select will let the user start from the next puzzle from the last completed puzzle
			
		27: DONE but not extensively tested
			Need a way for you and the user to delete puzzles
				Fix RoomDesigner ADD ROOM and Save Changes functions
			
		28: DONE
			User saving for story mode.
			Track the amount of moves for each room.
			
		29: DONE
			Need a room complete screen in story mode
			
		30: DONE
			Need to be able to remove SwitchTiles
			
		31: %%%%%%%%%%%%
			RoomDesigner: Create a way for the user to move the room around the
			grid in case they run out of grid room in a certain direction.
			
		32: DONE - Ended up making this as the HoleTile
			New Switch Tile Client tile type option: Blank tile
				* This allows sections of the room to be invisible until the Switch Tile is touched
				* Shows as dashed outline
			
		33: DONE
			What happens when a block is over a client that changes to a hole when
			its moves counter is done?
			
			It will not change.
			
		34: DONE
			Add ability to move a SwitchTile to a different space
				In SwitchTileEditor
					Click and hold on the SwitchTile, then drag to desired space
						If Mouse.released on unqualified area, SwitchTile goes back to home
						Update data, but only after SwitchTileEditor is done
							SwitchTileEditor gridIndex
							SwitchTile gridIndex
							SwitchTile client data
								hostGridIndex
								hostRoomIndex
							GridSpace data
			
		35: %%%%%%%%%%%%
			Add ability to turn off outlines in Client Creator and maybe Switch Editor
			
		36: DONE - Now have about 66 differnt color outlines
			
			Need to create larger list of outline colors for SwitchTile
			Max SwitchTile's possible is 192 since a SwitchTile does not have
			to have a client
			
			
		37: %%%%%%%%%%%%
			Catogorizing
			
			Tiles: FloorTile, GoalTile, HoleTile, SwitchTile
			Blocks: Blue, Red, Wall, BackAndForth
			Other: SwitchClient
			
			GamePieces
				Static
					FloorTile
					WallTile
					Goal
					Hole
					Switch
				Dynamic
					BlueBlock
					RedBlock
					BackAndForthTile
					SwitchClient
			
			
		38: 
			Saving and Loading
			
			In RoomData, have different loading functions specific to each scenario
			to avoid confusion
			
		39: 
			RoomDesigner
			
			Create a class that allows you to draw MovableBlock paths.
			The basis of this idea is to start a puzzle's design by drawing a random
			path then building the rest of the puzzle around it.
			
		40: DONE
			RoomSelect
			
			Add ability to view user created rooms & story mode rooms
			Have text: "Locked" in front of room if previous room isn't yet completed.
			
		41: DONE
			TitleScreen
			
			Fresh install of game:
				Choose 1 of 3 empty files
				
				New Game
				Continue (low alpha, not interactive)
				Room Selector
				Room Designer
				Stats (low alpha, not interactive)
				Options
			
		42: 
			What's the benefit/value/difference of starting at puzzle 1 vs. starting
			at a further room using room select?
			
		43: DONE
			RoomDesigner OptionsMenu
			
			
		44: DONE
			Need to add Moves Best text in game play and RoomCompleteScreen
			
			
		45: %%%%%%%%%%%%
			Need to set audio levels upon opening BlockPusher application
			
		46: DONE
			BlockHighlighter
			
				Store the last BlueBlock moved and last RedBlock moved
				So after moving a RedBlock, BlockHighlighter highlights the last BlueBlock moved
			
		47: DONE BUT NOT WELL TESTED
			RoomTester idea:
			
				Pressing ESC goes right back to RoomDesigner and saves your progress
				on the room you were testing. You need to reset the room or complete
				it to start it fresh.
			
		48: DONE
			Stats: For rooms not tried yet, put something else in moves best instead of 0
			
		49: DONE
			MenuListSelectObject is 5 Draw objects. They all get tweened. When user
			presses UP or DOWN, the visible state is toggled on the requested one.
			
		50: DONE
			Need a way to delete save files.
			
		51: DONE BUT NOT WELL TESTED
			Set a width limit for Room names.
			
		52: DONE
			Need better image/symbolism for HoleTiles
				HoleTiles are blank but show as dashed outlines in RoomDesigner
			
		53: DONE
			Update MousePointer classes.
			Pointer is not changing to hand symbol on many objects.
			
		54: DONE BUT NOT WELL TESTED
			For each action, need a way for both mouse and keyboard to execute.
			
		55: 
			In RoomTester, you should be able to toggle things like SwitchClient 
			movesRemainingText and SwitchOutlines.
			
		56: DONE
			Update Manual
			
		57: DONE
			Update MousePointer for SwitchClientCreator
			
		58: DONE
			SwitchClientCreator
				SwitchTile doesn't have outline until after creating
			
		59: 
			In RoomDesigner, I created about 56 SwitchTiles, each with 1 client.
			Loading the room took about 10/20 seconds. We're going to need to 
			create a loading bar... That was in debug mode. Release mode took
			less time but still wasn't immeadiate.
			
		60: Attempted, couldn't figure out a better way
			
			Re-do the way BlockHighlighter choses the next Block
			
		61: 
			
			RoomDesigner nav ideas
				ESCAPE goes strait to title menu
				Key.T goes strait to TestRoom
				Moving to TestRoom tweens all tiles into position
					From TestRoom to RoomDesigner tweens all tiles into position
			
		62: 
			
			TestRoom idea
				Key.F8 displays all SwitchOutlines and SwitchClient.moves
			
		63: SCRAPPED
			
			Controls menu
			
		64: %%%%%%%%%%%%
			There aren't any backout nav buttons for the mouse in TitleScreenWorld
			However, EXIT GAME button in title menu will close the program
			
			
		65: DONE
			BackAndForthTiles should show their sequence numbers in GamePlay
			
			
		66: DONE
			NewRoom should check if there are any unsaved changes
				If so;
					Give 3 options
						Save and Start New Room
						Start New Room Without Saving
						Cancel
					Give 3 options with warning message
						Save changes to your design before starting a new one?
						Add design to playlist before starting a new one?
						Yes
						No
						Cancel
						
						This may not work since you can't add a design to the playlist unless it qualifies first
							A solution would be to automatically add the qualifying elements and then save/add to playlist
								BlueBlock-
									Search the first available empty GridSpace, then place a FloorTile and a BlueBlock
									If no empty GridSpace avail, Search the first available FloorTile, then place a BlueBlock
									If no FloorTile avail, Search the first available WallTile, then place a FloorTile and a BlueBlock
									If no WallTile avail, Search the first available HoleTile, then place a FloorTile and a BlueBlock
									If no HoleTile avail, Search the first available GoalTile, then place a BlueBlock
									If no GoalTile avail, Search the first available SwitchTile, then place a BlueBlock
										What happens in GamePlay when a room is loaded and a Block is already on a SwitchTile?
								GoalTile-
			
		67: 
			Should there be a limit to how many of a certain Tile/Block the user can place?
				Like Goals and Switches
					The limit for Goals would be (192 / 2) - 12 = 84. 
						((total possible spaces) divided in half) minus a full row of wall pieces so movable blocks have something to stop at.
			
			
		68: DONE
			Idea for conflcts with mouse selection and keyboard selection of multiple options
				
				On added(), if the mouse is colliding, it cannot select or highlight anything until 
				it moves off of the hitbox. Then it is allowed to highlight and select an option.
				
				If the keyboard changes the highlighted option at any time, the mouse is not allowed
				to highlight an option until it moves off of the option it's currently on if any.
				
		69: DONE
			Impliment THINGS TO DO #66 for when selecting a room in RoomSelect to edit and getting
			the unsaved draft warning.
			
			
		70: DONE
			Impliment THINGS TO DO #68 for OptionsMenu
			
			
		71: DONE
			Impliment mouse interactivity for RoomDesigner things like
			changing tile type in SpaceSelector_RD
			
			
		72: DONE
			RoomDesigner
				Add Level and Room number text if editing a playlist room
				
				
		73: DONE
			GamePlay
				Add OPTIONS TextButton so mouse can open OptionsMenu
				
				
		74: 
			Might need a blank room file at the end of all the room files with topLeftGridIndex value of -1
				RoomData.getRoomCount() checks it.
				
				
		75: 
			New TileTypeChanger for SwitchClientCreator/Editor
				Lists tile types veritcally on each side of the grid,
				active type on left, inactive type on right.
				Shows every tile type if there is room.
				Chosen type is outlined by a white outline
					White outline's layer is above the tiles and position is static
				Change type arrows are at top and bottom of list.
				Each tile is a button.
				Clicking on a tile or arrow scroll tween the next or chosen inside
				the white outline.
				Name text of the tile type sits next to the white outlined tile.
					While scoll tween is active, type name text fades out to 0 alpha then 
					fades in to 1 alpha as the new name.
				Hovering over a tile displays tile type text.
				
				
		76: DONE
			Allow for blocks to start on Goals.
			
			
		77: DONE - RoomDesigner won't allow you to move an autoblock over a hole
			However, it will allow you to place a hole over a autoblock sequence tile
			Impliment checks for Auto blocks falling in holes or off grid
			
			
			
		78: DONE
			Allow for Auto blocks to move over SwitchTiles
			
			
		79: DONE
			Medals
				Add way to set and edit medal qualifications in RoomDesigner
				
				
		80: DONE
			Add moves best text to room select
			
			
		81: DONE
			Add medals to room select
			
			
		82: DONE
			Add retry option to room completion screen
			
		83: DONE
			Stats page down button should only be available if player has
			made it to the next level.
			
		84: DONE
			Let story mode rooms be editable to players.
			Changes saved will not change the story mode room, just add a new room to My Rooms (user created rooms)
			
		85: 
			Go back through all saving related code & fashion as if dev isn't 
			using it (like the final product/release version). THEN add in dev privledges code
			so that it's easy to decern from release version and easy to turn off.
			
		86: DONE
			In RoomData.loadRoomData & RoomData.loadRoomDataXML, move playlistFileName to first index in
			the return array.
			
		87: DONE
			Need to indicate in RoomDesigner if design is or isn't on a playlist.
				levelText and roomText could be blank if design isn't on a playlist
				levelText and roomText could be different colors to indicate whether the design is from the story mode playlist or from the user creations playlist
			
		88: DONE
			When nav'ing to RoomDesigner from title menu and draft is from a room on a playlist
			but that playlist file has been deleted (from RoomSelect), a check is needed
			so RoomDesigner takes this into account
			
		89: DONE
			Rename rooms with better names, not generic ones like 'Room A'
			
				Name ideas:
					RandomWordGenerator.com/phrase
					Fish out of water
						Meaning: Someone being in a situation that they are unfamiliar or unsuited for.
					Everything But The Kitchen Sink
						Meaning: Including nearly everything possible.
					Password
					Rain on Your Parade
						Meaning: To spoil someone's fun or plans; ruining a pleasurable moment.
					Jig Is Up
						Meaning: For a ruse or trick to be discovered; to be caught.
					Close But No Cigar
						Meaning: Coming close to a successful outcome only to fall short at the end.
					No-Brainer
					There's No I in Team
						Meaning: To not work alone, but rather, together with others in order to achieve a certain goal.
					Jumping the Gun
						Meaning: Something that occurs too early before preparations are ready. Starting too soon.
					Lickety Split
						Meaning: To go at a quick pace; no delaying!
					Back to Square One
					In the Red
						Meaning: Losing money. Being in debt.
					Shot In the Dark
						Meaning: An attempt that has little chance for success.
					Easy As Pie
					Mmmm, pie...
					Hands Down
						Meaning: Anything that's easy or has no difficulty; something that is a certainty.
					An Arm and a Leg
						Meaning: Something that is extremely expensive.
					Wild Goose Chase
						Meaning: Futilely pursuing something that will never be attainable.
					Between a Rock and a Hard Place
						Meaning: Being faced with two difficult choices.
					Right Off the Bat
						Meaning: Immediately, done in a hurry; without delay.
					Jaws of Death
						Meaning: Being in a dangerous or very deadly situation.
					Give a Man a Fish
						Meaning: It's better to teach a person how to do something than to do that something for them.
					On the Ropes
						Meaning: Being in a situation that looks to be hopeless!
					A Piece of Cake
					Two Down, One to Go
					Throw In the Towel
						Meaning: Giving up; to surrender.
					Stack
						Stacker
						Stack it
					Follow Me
					As it Seems
					Delay
					Obstacle
					Invite
					Betray
					
					
					
			
		90: DONE
			Add sounds for deleting save files
				For warning message
				When confirming deletion
			
		91: 
			Finish all input managers
			
		92: DONE
			BFTileCreator should let you set a bf client that is also a
			switch tile client IF one of the switch tile client's states
			is a floor, goal, hole, or switchtile
				If a bftile shares a switchtile client, when mouse'ing over
				the bftile to show its sequence numbers, the switch client's
				number needs to be invisible
			
		93: 
			Every level has one secret room
			
		94: DONE
			Change var re:RoomDesigner in TextButton_RD to rd:RoomDesigner
			
		95: DONE
			Change var re:RoomDesigner in SpaceSelector_RD to rd:RoomDesigner
			
		96: DONE
			Redo EntityTextPlus.tweenText()
			
		97: DONE
			Implement a puzzle timer
				Changes color from gold to silver to bronze depending on what ranking range the player is in
			
		98: DONE
			Add best time to RoomSelect
			
		99: 
			Instead of extending objects like Block from Button, extend from EntityGame
			and add in Button interactivity as a component
			
		100: DONE
			Add in collectables, like coins, that give a new challenge and
			way to grade the player.
				RoomDesigner: If a Block is placed where an Orb is, the Orb is removed
				RoomDesigner: Orbs can be placed on Floor, Hole, Goal, Switch
				Game play: Can they be hidden by things like SwitchClients & BFTiles?
				Blocks cannot start on an Orb
				
		101: DONE
			UnsavedDraftWarning.saveData() needs to account for xml saves
			
		102: DONE
			RoomTester: RoomTimer overlapping EditRoomButton
			
		103: DONE
			Redo InfinityIcon class 	- DONE
			Redo OverlayFadeIn class	- DONE
			Redo LockSymbol class		- DONE
			Redo GamePieceColorOutline class - DONE
			
		104: DONE - SwitchClients will deactivate if a Block is on top, unless its inactive state is a Wall
			Currently, SwitchClients will not change to inactive state if a block
			is on top of it. If inactive state is a Hole, should it be able to 
			switch to inactive state so block falls in hole? Should the only situation 
			that it won't switch to inactive state while block is on top of it be if 
			the inactive state is a Wall?
			
		105: 
			DONE - Add sound for collecting an orb
			DONE - Add sound for placing SwitchClients
			DONE - Add sounds for completing and cancelling SwitchTileEditor
			DONE - Add sound for deleting SwitchTile in SwitchTileEditor
			DONE - Add sound for RoomFailedScreen
			DONE - Add sound for pressing space in RoomFailedScreen and RoomCompletedScreen
			DONE - Add sound for RoomNamer
			Add sound for 
			
		106: 
			Test designing and adding user created rooms
			
		107: DONE
			Add outline for new SwitchTile in SwitchTileEditor
			
		108: DONE
			Redo Block.setMoveToSpaceNum()
			
		109: 
			Add some sort of animation and/or sound when a block 
			falls in a hole
			
		110: 
			Should the player be allowed to move to the next room only 
			if they get a good enough ranking?
			
		111: DONE
			Add clickable way to move to next room in RoomCompleteScreen and RoomFailedScreen
			
		112: DONE - BackAndForthTile and related classes renamed to SequenceBlock
			Rename BackAndForthTile to AutoBlock and move in blocks folder
			
		113: DONE
			Rename all objects related to PushBlock
			
		114: DONE
			Arrange/organize rooms to match difficulty
			
			Room Moving Process:
			Must be done one room at a time.
			Swap 2 rooms:
				1. Open each xml file
				2. Swap each playlistFileName
				3. Save and close each xml file
				4. Rename each file in Windows Explorer or FlashDevelop Project panel by swapping their names
				5. Run SaveFileData.swapRoomData() to swap the stats
					This must be done for each save file
					
		115: 
			Idea
			SwitchClients with 0 moves should not last until the end of the 
			move. They should only remain on while a block is colliding with the Switch.
			
		116: DONE
			Add indication that volume is muted
			
		117: DONE
			RoomNamer
			The first valid key typed after opening RoomNamer should erase 
			the current room name and replace it with that key.
			
		118: DONE
			RoomNamer
			When finishing the naming, check to see if there are any spaces at 
			the end and remove them.
			
		119: 
			Instead of splitting up blocks and tiles into seperate folders in the 
			game_pieces folder, have all game pieces in the game_pieces folder.
			
		120: 
			Add developer credits in options and/or title menu
			
		121: 
			Make sure every action can be performed by both keyboard and mouse
			
		122: 
			RoomSelect
			Add way to press numerical key to go directly to that level
			
		123: 
			When user starts game, need check to rearange/update stats incase 
			you've changed room data/uploaded new ver of game
			
			
			
			
		-------------------------------BUGS---------------------------------
		
		BackAndForthTile
			
			1: FIXED
				After a block finishes its move against a BackAndForthTile, the
				BackAndForthTile moves to a different space. Selecting the block that
				was against it doesn't give you the option to move in the direction where
				the BackAndForthTile just was, even though that path is unobstructed now.
				
			2: FIXED
				BackAndForthTile_GP isn't moving in correct sequence order.
			
		1: FIXED
			AddRoom GUI stuff still visible while in SwitchTileClientCreator
			
		2: FIXED
			RoomTester: Spaces with SwitchTiles do not get removed when the room resets
			* This is also happening in Story Mode
			
		3: FIXED
			RoomDesigner: After testing an un-added room, ADD ROOM button isn't active and says the room has been added to the playlist
			* In addition to that: after making a change to activate the ADD ROOM button, the SAVE CHANGES button becomes active
			
		1: FIXED
			The game considers any space outside of a room as a WallTile.
			This causes a movable block to stop on the last FloorTile before
			outerspace instead of falling in a hole like I think it should.
			
		2: FIXED
			In RoomCreator, in RoomNaming mode, the mouse tile can still be changed
			
		3: FIXED
			Text is difficult to read depending on what's behind it.
			Many of these situations come about in RoomCreator mode.
			
		4: FIXED BUT UNCONFIRMED
			Tried deleting some Switch Clients in SwitchTileEditor MainMenu one at a time,
			They still showed, but as if they were now under screenTint and game crashed
			after clicking FINISH EDITING button
			
		5: FIXED
			In SwitchTileEditor; deleted all clients, pressed ESC key, all clients were still removed
			Should cancel any changes
			
		6: FIXED
			SwitchClientCreator: If a SwitchTile has been deleted, the next one created, will use
			and already used outline color.
			
		7: FIXED
			OptionsMenu in GamePlay: Pressing SPACE still set the highlighted block
			in pending move mode
			
		8: FIXED
			If a Block ends up on a Redblock's homeSpace, the game doesn't move on to the
			next move. See MovableBlockManager
			
		9: FIXED
			BlockHighlighter isn't highlighting the last Block moved after a RedBlock has
			moved back to it's homeSpace
			
		10: FIXED
			RoomSelect: EditRoom button is visible in StoryMode room select upon entering RoomSelect
			It goes away if you go to User Rooms then back to StoryMode rooms
			
		11: FIXED - But not extensivley tested
			Scenario: In RoomTester. There are 2 Blocks, 1 Blue and 1 Red. 
			BlueBlock is on a SwitchTile which is keeping a client in active state
			as a HoleTile. RedBlock then moves on the client and falls in hole. 
			The BlueBlock then moves to the client and falls in hole. 
			There is now 0 Blocks so the room resets. Now, selecting either Block
			locks in pending move state but there aren't any move arrows.
			
		12: FIXED
			In GamePlay F4 to show spaceIndices isn't working
			
		13: FIXED
			GamePlay, BlockHighlighter. If all blocks are in the same row/column, 
			pressing a certain direction will not highlight the next one. For 
			example; 2 blocks in a puzzle, both in the same column, pressing RIGHT 
			will not highlight the other one.
			
		14: FIXED
			After completing a room and switching to the next one, Input isn't 
			responding. *Didn't check mouse input.
			
		15: FIXED
			Infinity text in SwitchClientCreator
			
		16: FIXED
			SwitchClientCreator and possibly SwitchEditor
			While in SwitchClientCreator, closing the BlockPusher application (the Windows window with the 'Close' red X button)
			causes an error next time going into RoomDesigner. Line 'var clientGridIndices:Array = new Array(stClientData[switchTiles.length].length);'
			in the 'RoomDesigner - private function loadFile():void'
			
		17: FIXED
			Fell in hole. BlockHighlighter then highlighted the hole.
			
		18: FIXED
			The 2nd time and beyond opening OptionsMenu_RD causes each GridSpace's highlight's
			visible to be false and each GridSpace's GoalOutline to be visible true
			
			
		19: FIXED
			SpaceSelector_RD
				GoalOutline stays visible in certain cases such as opening the OptionsMenu
				
		20: FIXED
			Menus like OptionsMenu menu and TitleScreenMenu menu
				If mouse if colliding w/ a button on menu tweens-in completion, that 
				option gets highlighted but the mouse isn't supposed to until it moves 
				onto a button.
				
		21: FIXED
			GamePlay, Room 13
				BlueBlock moved over SwitchTile, fell in SwitchClient Hole
				Remaining RedBlock was not highlighted
				Couldn't open OptionsMenu
				
		22: FIXED
			RoomDesigner
				ADDROOM button still active after saving changes to a modified room
			
			
			
		23: 
			More like an unexpected situation, this does not mess up anything.
			When clients are created, they can be created in groups. Each one
			in the group shares the same attributes; each one will change to
			the same type of tile and will have the same amount of moves.
			If a MovableBlock is sitting on a client when it's group's moves
			run out and then a different MovableBlock reactivates that group's
			move timer, the client the MovableBlock is sitting on will not activate
			it's move timer until the MovableBlock moves off of it and then a
			MovableBlock runs into it's parent. This can result in the babysat
			client having an out of sync move timer from it's group.
				
				Should there be a move timer assigned to and managed by the
				client group's parent?
				
					With this, when the MovableBlock moves off of the client,
					that client's remaining move counter will be the same as
					it's group's.
					
		24: FIXED
			Tried to play a room with SwitchTileClients, got this error in SwitchTile.addClients, this line: var d:Array = _stClientData[i];
			[Fault] exception, information=TypeError: Error #1034: Type Coercion failed: cannot convert 1 to Array.
			
		25: FIXED
			[Fault] exception, information=TypeError: Error #1034: Type Coercion failed: cannot convert blocks.switchTiles.switchTileCustomizer::SwitchTileClient@75dfe79 to blocks.NonInteractiveBlock.
			
		26: FIXED
			Room Designer
			Hovering over Auto blocks with a Floor brush while holding SHIFT 
			to delete floors highlights the Auto block but should only highlight Floors
			
		27: FIXED
			RoomDesigner
			Added a SwitchTile and brought up the switch tile creator/editor
			Added a SwitchClient
			Mouse pointer was still over added SwitchClient
			Hit ENTER key to finish switch editing
			Inner highlight on client that was just added remained
			
		28: FIXED
			RoomDesigner
			SwitchClient's with dashed outlines
			Going into edit mode for the Switch
			SwitchClient's dashes do not show
				Probably a setStackOrder function issue
			
		29: MAYBE IT'S FINE THE WAY IT IS
			RoomDesinger
			Adding a new SwitchTile_RD
			Switch doesn't have a colored outline but it's clients do
			
		30: FIXED
			RoomDesigner
			BFTileCreator
			Not all spaces available for sequence are highlighted
			
		31: FIXED
			RoomDesigner and Game Play
			The number text for BFTile is in the way of a switch client's number text
			
		32: FIXED
			Switch creator/editor is allowed to place clients on grid spaces with BFTiles
			
		33: FIXED
			I was able to create clients on top of a different SwitchTile's clients
			
		34: FIXED
			Stats loosing frames when changing pages
			
		35: FIXED
			Maybe for all buttons: While mouse is over a Block, if mouse is pressed but released
			while not over the button anymore, BlockHighlighter is gone, pressing SPACE key seems
			toggle pending move off
			
		36: FIXED
			In RoomDesigner
			Pressed ESC to exit OptionsMenu
			OptionsMenu tweened out
			RoomDesigner looked like it was in HUB state but
			I could not do anything beyond that
			It may have still been in OPTIONSMENU state
			
		37: FIXED
			OptionsMenuText not repsonding to mouse collision
			
		38: FIXED
			TitleMenuText & OptionsMenuText hitboxes are too small
			
		39: FIXED
			RedBlock clickable when not on home space
			
		40: MAYBE IT'S FINE THE WAY IT IS
			SwitchClient MovesRemainingText not visible during PENDINGMOVE if block is on SwitchClient
			
		41: FIXED
			In Game play, when a room loads, sometimes SwitchClients will 
			show for 1 frame the type they should not be in. The room named 
			"The Race 2" is a good example.
				I saw the problem when the room loaded coming from RoomCompleteScreen.
				Seems to only happen when coming from the previous room after completing it.
			
		42: 
			Tweening/moving objects have become jittery as of about 7/26/16
				Seems like it's not just BlockPusher
			
		43: 
			RoomSelect: Sometimes the room name will disappear instead of 
			tweening out. Seems random.
			
		44: 
			RoomSelect: The room name moves slightly ahead/sooner than the room
			
		45: FIXED
			Mute (by pressing the M key) can happen at any point but should not
			happen when naming a room.
			
		46: 
			RoomNamer
			Can't type anymore after hitting BACKSPACE sometimes
			
		47: 
			Options Menu GP
			Each time ESC key is hit during tweenOut() Sounds.knock1() is played
			instead of just playing once
		-----------------------------------------------------------------------------------------------
		
		
		TitleScreenWorld navigation and tweening:
			
			* Need an array in a hub like TitleScreenWorld that stores any active VarTween object so they're accessable for VarTween.cancel()
			* Each object that will be tweened needs to set its 'homeCoords' values
				* Every tween that's called will calculate the 'to' value using the object's 'homeCoords' value
				* to = homeCoords.x/y + offset
				* offset will be 1 of the following; FP.width, -FP.width, FP.height, -FP.height
			* TitleScreenMenu may have to wait for the "x" tween before doing a "y" tween and vice versa
			
			* Process:
				* Each navigation action should first build an array of the objects to tween
				* A loop then calls the tween for each object in that array
				* Each VarTween created is pushed into an array
				
				
			
		Each asterisk in the following is a NavEvent
		The tween's 'to' value for an OUT NavEvent will be 'homeCoords.x/y + screenOffset' where screenOffset would be one of the following; FP.halfWidth + FP.width, -FP.halfWidth, FP.halfHeight + FP.height, -FP.halfHeight
		The tween's 'to' value for an IN NavEvent will be 'homeCoords.x/y + screenOffset' where screenOffset would be 0
		Every 'x' tween has one IN tween and one OUT tween, tweening one section IN and one section OUT
			
				
				
				
		Each asterisk in the following is a NavEvent:
			
			Section 1 - PressSpaceScreen
			
				* OUT: Home to Left
				* IN:  Left to Home
			
			
			
			Section 2 - FileSelect
			
				* IN:  Right to Home
				* OUT: Home to Right
				* IN:  Left to Home
				* OUT: Home to Left
			
			
			
			Section 3 - TitleScreenMenu
			
			* IN:  Right to Home
			* OUT: Home to Right
			* IN:  Bottom to Home
			* OUT: Home to Bottom
			
			* Game Title:
				* OUT: Home to Top
				* IN:  Top to Home
			
			
		-----------------------------------------------------------------------------------------------
		
		
		Saving/Loading data:
			
			RoomEditor:
				
				Adding a room to the list of playable rooms:
				
				Idea: There is only a save button.
					Clicking the save button:
						If (the room hasn't been added to the playlist yet)
						{
							
						}
					
				"ADD ROOM TO LIST OF PLAYABLE ROOMS" TextButton:
						
						Displays in RoomEditor mode
						Displays in StartNewRoom GUI if:
							user is editing a playlist room and hasn't saved the changes
							new room qualifies to be added to room playlist
							
						Once a room has at least 1 MovableBlock & 1 GoalTile, the button is clickable
						Should the button stay out of RoomTesting mode?
						After the room is added or saved, it becomes unclickable until something is edited:
							
							A check is performed to see if it still has at least 1 MovableBlock & 1 GoalTile
							
						When clicked:
							
							A GUI appears:
								
								Text: This room will be added to the playlist.
								Text: Name your room!
									The name of the room is in the center of the screen, the user can type a new name for the room but doesn't have to
								Text: ENTER to complete, ESC to cancel
									ENTER and ESC could be text buttons
									
								After hitting ENTER:
									-
									A check is done on the room name:
										-
										If (the user has left it blank) {it will be named "Untitled" + untitledIndex}
										else
										{
											all room names are searched:
												-
												if (there's a match)
												{
													A number is added to the end of the name
												}
										}
										
										
										
					There is a text object near the 'ADD ROOM TO LIST OF PLAYABLE ROOMS' button:
						If (the room being edited has not been added to the list of playable rooms)
						{
							The text object reads: "Room has not been added"
						}
						else
						{
							The text object reads: "Room has been added"
						}
						
				"REMOVE ROOM" TextButton:
					-
					Deletes a room from the playable rooms list
					Displays in RoomListing mode.
					
				"SAVE CHANGES" TextButton:
					-
					Displays in RoomEditor mode.
					Displays only after a room has been added to the playable room list AND that room has been edited
					Displays in the StartNewRoom GUI if user is editing a playlist room and hasn't saved the changes
					
				Change the 'ERASE ALL' button to 'START NEW ROOM'
					'START NEW ROOM' button:
						-
						It's update does a check to see if any tiles have been placed:
							-
							If (at least 1 tile has been placed)
							{
								Becomes interactive once at lease 1 tile has been placed
							}
							else
							{
								busy = true;
							}
						When clicked:
							-
							A GUI appears:
								-
								Text: This will start fresh room turning all tiles blank
								Text: This will start fresh blank room. Any edits to this room will not be saved.
								Text: This will erase everything you've done to this room
								Text: This will erase anything you've edited in this room
								
								Text: Hit ENTER to confirm or ESC to cancel
								
								Idea 1:
								If (This is a room that has been added to the playlist and changed since last saved)
								{
									Text: This room has not been saved since it was last changed.
									Would you like to save the changes before starting a new room?
									
									TextButton: "SAVE"
										Clicking this button saves the changes & starts a new room
								}
								
								Idea 2:
								If (The room is addable to the playable room list)
								{
									If (the room is already in the playable room list and has been edited since it was last saved)
									{
										Text: The room has been edited since it was last saved:
											-
											Text: would you like to save changes or add room to list of playable rooms before continuing?
												TextButton: SAVE
												TextButton: ADD ROOM
												TextButton: CONTINUE WITHOUT SAVING
											Clicking any button will start a fresh room
									}
									else
									{
										TextButton: CONTINUE
									}
								}
								else
								{
									TextButton: CONTINUE
								}
								
		Room Ideas:
		1:
			Winnable? Confirmed
			Implimented? No
			Dimensions  - 5x5
			Goal spaces - 16, 24
			Blue blocks - 37, 39
			Red blocks  - 18
			Wall blocks - null
			Hole spaces - null
		2:
			Winnable? Confirmed
			Implimented? No
			Dimensions  - 6x6
			Goal spaces - 27, 28, 35, 36
			Blue blocks - 21, 42, 45, 51
			Red blocks  - 18
			Wall blocks - null
			Hole spaces - null
		3:
			Winnable? Confirmed
			Implimented? No
			Dimensions  - 5x3
			Goal spaces - 17
			Blue blocks - 8, 12, 26
			Red blocks  - null
			Wall blocks - null
			Hole spaces - null
		4:
			Winnable? Confirmed
			Implimented? No
			Dimensions  - 5x5
			Goal spaces - 24
			Blue blocks - 8, 12, 40
			Red blocks  - null
			Wall blocks - null
			Hole spaces - null
		5:
			Winnable? Unconfirmed
			Implimented? No
			Dimensions  - 5x5
			Goal spaces - 24
			Blue blocks - 8, 39
			Red blocks  - null
			Wall blocks - 26, 40
			Hole spaces - null
		6:
			Winnable? Confirmed
			Implimented? No
			Dimensions  - 5x5
			Goal spaces - 24
			Blue blocks - 9, 37, 39
			Red blocks  - null
			Wall blocks - 8, 12, 36, 40
			Hole spaces - null
		7:
			Winnable? Confirmed
			Implimented? No
			Dimensions  - 5x5
			Goal spaces - 24
			Blue blocks - 15, 37, 39
			Red blocks  - null
			Wall blocks - 8, 12, 36, 40
			Hole spaces - null
		8:
			Winnable? Confirmed
			Implimented? No
			Dimensions  - 5x5
			Goal spaces - 24
			Blue blocks - 8, 12, 40
			Red blocks  - null
			Wall blocks - null
			Hole spaces - 10
		9:
			Winnable? Unconfirmed
			Implimented? No
			Dimensions  - 5x5
			Goal spaces - 24
			Blue blocks - 37, 39
			Red blocks  - null
			Wall blocks - 8, 12, 36, 40
			Hole spaces - null
		10:
			Winnable? 
			Implimented? No
			Dimensions  - 
			Goal spaces - 
			Blue blocks - 
			Red blocks  - 
			Wall blocks - 
			Hole spaces - null
			
			----------------------------------------------------------------------------------------
			
			1. 3
			2. 7
			3. 9
			4. 4
			5. 8
			6. 12
			7. 8
			8. 11
			9. 12
			10. 4
			
			1. 4
			2. 6
			3. 14
			4. 14
			5. 8
			6. 10
			7. 4
			8. 6
			9. 11
			10. 10
			
			1. 6
			2. 19
			3. 6
			4. 9
			5. 7
			6. 11
			7. 6
			8. 1
			9. 3
			10. 4
			
			1. 7
			2. 6
			3. 5
			4. 5
			
			
			1.  Room A
			2.  Room B
			3.  Room C
			4.  Room D
			5.  FIRST ROOM
			6.  Second Room
			7.  Third Room
			8.  Fourth Room
			9.  Fifth Room
			10.  Sixth Room
			11.  Claw
			12.  Seventh Room
			13.  Eighth Room
			14.  Ninth Room
			15.  Tenth Room
			16.  Eleventh Room
			17.  Twelth Room
			18.  Thirteenth Room
			19.  Fourteenth Room
			20.  Fifteenth Room
			21.  Sixteenth Room
			22.  Friendly Help
			23.  Hot Dog
			24.  Invisible Maze 1
			25.  Choices
			26.  Choices 2
			27.  Back and Forth 1
			28.  One Move
			29.  Now You See Me
			30.  Separated
			31.  Get outta my way!
			32.  Red Choice
			33.  Now You See Me 2
			34.  Now You See Me 2
			
			1.  Room_1 Room A
			2.  Room_2 Room B
			3.  Room_3 Third Room
			4.  Room_4 Fourth Room
			5.  Room_5 Fifth Room
			6.  Room_6 Sixth Room
			7.  Room_7 Seventh Room
			8.  Room_8 Eighth Room
			9.  Room_9 Ninth Room
			10.  Room_10 Tenth Room
			11.  Room_11 Eleventh Room
			12.  Room_12 Twelth Room
			13.  Room_13 Thirteenth Room
			14.  Room_14 Fourteenth Room
			15.  Room_15 Fifteenth Room
			16.  Room_16 Sixteenth Room
			17.  Room_17 Friendly Help
			18.  Room_18 Hot Dog
			19.  Room_19 Invisible Maze 1
			20.  Room_20 Choices
			21.  Room_21 Choices 2
			22.  Room_22 Back and Forth 1
			23.  Room_23 One Move
			24.  Room_24 Now You See Me
			25.  Room_25 Separated
			26.  Room_26 Get outta my way!
			27.  Room_27 Room A
			28.  Room_28 Room B
			29.  Room_29 Room C
			30.  Room_30 Room D
			31.  Room_31 Now You See Me 2
			32.  Room_32 Red Choice
			33.  Room_33 Claw
			34.  Room_34 Organix
			
			1.  Room_1 Room A
			2.  Room_2 Room B
			3.  Room_3 Room C
			4.  Room_4 Room D
			5.  Room_5 FIRST ROOM
			6.  Room_6 Second Room
			7.  Room_7 Third Room
			8.  Room_8 Fourth Room
			9.  Room_9 Fifth Room
			10.  Room_10 Sixth Room
			11.  Room_11 Claw
			12.  Room_12 Seventh Room
			13.  Room_13 Eighth Room
			14.  Room_14 Ninth Room
			15.  Room_15 Tenth Room
			16.  Room_16 Eleventh Room
			17.  Room_17 Twelth Room
			18.  Room_18 Thirteenth Room
			19.  Room_19 Fourteenth Room
			20.  Room_20 Fifteenth Room
			21.  Room_21 Sixteenth Room
			22.  Room_22 Friendly Help
			23.  Room_23 Hot Dog
			24.  Room_24 Invisible Maze 1
			25.  Room_25 Choices
			26.  Room_26 Choices 2
			27.  Room_27 Back and Forth 1
			28.  Room_28 One Move
			29.  Room_29 Now You See Me
			30.  Room_30 Separated
			31.  Room_31 Get outta my way!
			32.  Room_32 Red Choice
			33.  Room_33 Now You See Me 2
			34.  Room_34 Organix
			
			-------------------------------------------------------------------------------------------
			
			GAME PLAY WORLD
			
			1. Needs to know what file to load:
				
				Plays story mode rooms
					xml only
					Story mode rooms are started from:
						Title menu
						RoomSelect
				
				Plays room testing rooms
					SharedObject
					Testing a room is started from:
						RoomDesigner
				
				Plays player designed rooms
					SharedObject
					Player designed rooms are started from
						RoomSelect
			
			2. 
			
			
			-------------------------------------------------------------------------------------------
			
			CURRENTLY
			
			
			DONE - Making sure RoomData.loadRoomData() is being used only for room drafts and user created rooms
			
			DONE - Making sure RoomData.saveRoomData() is being used only for room drafts and user created rooms
			
			DONE - RoomDesigner.saveRoomData() scenarios:
				xml save
					adding room
					saving changes
				draft save
				user creation save
					adding room
					saving changes
			
			-------------------------------------------------------------------------------------------
			
			TESTING
			
			
			Scenarios:
				
				
			
			
		*/
		
	}

}