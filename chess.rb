require 'yaml'

def king_checked?(piece, new_position)
	#store current position of piece
	old_position = piece.current_pos

	caputers = false
	if $pieces.select { |e| e.color != piece.color and e.current_pos == new_position}.length == 1
		caputers = true
		captured_piece = $pieces.select { |e| e.color != piece.color and e.current_pos == new_position}
	end

	if caputers
		$pieces -= captured_piece
	end

	piece.move_to(new_position)

	$pieces.select { |e| e.color != piece.color }.each do |i|
		if i.move_possible?($pieces.select { |ez| ez.color == piece.color and ez.class.name == "King" }.first.current_pos, false)
			piece.move_to(old_position)
			$pieces += captured_piece if caputers
			return true
		end
	end
	piece.move_to(old_position)
	$pieces += captured_piece if caputers
	return false
end

def toggle_color(turn_color)
	if turn_color == "white"
		"black"
	else
		"white"	
	end
end

def set_unicode(piece)
	if piece.color == "white"
		case piece.class.name
		when "King"
			piece.unicode = "\u2654"
		when "Queen"
			piece.unicode = "\u2655"
		when "Rook"
			piece.unicode = "\u2656"
		when "Bishop"
			piece.unicode = "\u2657"
		when "Knight"
			piece.unicode = "\u2658"
		when "Pawn"
			piece.unicode = "\u2659"
		end
	else
		case piece.class.name
		when "King"
			piece.unicode = "\u265a"
		when "Queen"
			piece.unicode = "\u265b"
		when "Rook"
			piece.unicode = "\u265c"
		when "Bishop"
			piece.unicode = "\u265d"
		when "Knight"
			piece.unicode = "\u265e"
		when "Pawn"
			piece.unicode = "\u265f"
		end
	end
end


require_relative './lib/board.rb'
require_relative './lib/king.rb'
require_relative './lib/queen.rb'
require_relative './lib/rook.rb'
require_relative './lib/bishop.rb'
require_relative './lib/knight.rb'
require_relative './lib/pawn.rb'
require_relative './lib/none.rb'

puts "\nEnter 'new' or '1' for new game or 'load' to load previously saved game."
choice = gets.chomp
board = Board.new

if choice.downcase == "new" or choice == "1"

	#Set up initial board
	$pieces = []
	undo_stack = []

	#populate pawns
	white_pawns = []
	black_pawns = []
	8.times do |i|
		$pieces << Pawn.new([i,1], "white")
		$pieces << Pawn.new([i,6], "black")
	end

	#populate kings
	$pieces += [King.new([4,0], "white"),King.new([4,7], "black")]

	#populate queens
	$pieces += [Queen.new([3,0], "white"), Queen.new([3,7], "black")]

	#populate rooks
	$pieces += [Rook.new([0,0], "white"),Rook.new([7,0], "white"), Rook.new([0,7], "black"),Rook.new([7,7], "black")]

	#populate bishops
	$pieces += [Bishop.new([2,0], "white"),Bishop.new([5,0], "white"), Bishop.new([2,7], "black"),Bishop.new([5,7], "black")]

	#populate knights
	$pieces += [ Knight.new([1,0], "white"), Knight.new([6,0], "white"), Knight.new([1,7], "black"), Knight.new([6,7], "black")]

	board.display_board
	turn_color = "white"

else
	files = Dir.entries("./saved_games")
	files.reverse!
	files.pop
	files.pop

	if files.length == 0
		puts "There are no saved files."
		puts "Please try again."
		exit
	end
	puts "\nThe saved games are: "
	puts files
	puts 
	file_name = ""
	while not (File::exists? "./saved_games/#{file_name}" and not File::directory? "./saved_games/#{file_name}")
		puts "Choose a valid file to play."
		file_name = gets.chomp
	end

	y = File.read("./saved_games/#{file_name}")
	saved_arr = YAML::load(y)
	$pieces = saved_arr[0]
	turn_color = saved_arr[1]
	undo_stack = saved_arr[2]

	$pieces.each do |pc|
		set_unicode(pc)
	end

	board.display_board
end

while true
=begin
	if kings[:white_king].stalemate?
		puts "White king is in stalemate."
		break
	end

	if kings[:black_king].stalemate?
		puts "Black king is in stalemate."
		break
	end
=end
	
	$pieces.select {|pc| pc.class.name == "King"}.each do |kng|
		if kng.checkmate?
			puts
			puts
			puts "Checkmate!"
			puts "#{kng.color} loses."
			exit
		end
	end

	puts
	print "\n"
	print "Enter #{turn_color} move:"
	move_str = gets.chomp
	move_str.slice! "x"

	if move_str == "O-O"
		if turn_color == "white"
			if $pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first.current_pos == [4, 0] and $pieces.select {|e| e.current_pos == [7,0] and e.class.name == "Rook" and e.color == turn_color}.length == 1 and $pieces.select { |e| e.current_pos == [5, 0] }.length == 0 and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [6,0])) and $pieces.select { |e| e.current_pos == [6, 0] }.length == 0 and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [5,0])) and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [4,0]))
				$pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first.move_to([6,0])
				$pieces.select {|e| e.current_pos == [7,0] and e.class.name == "Rook" and e.color == turn_color}.first.move_to([5,0])
				undo_stack.push("white short castle")
			else
				puts "Invalid Short Castle"
				next
			end
		else
			if $pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first.current_pos == [4, 7] and $pieces.select {|e| e.current_pos == [7,7] and e.class.name == "Rook" and e.color == turn_color}.length == 1 and $pieces.select { |e| e.current_pos == [5, 7] }.length == 0 and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [6,7])) and $pieces.select { |e| e.current_pos == [6, 7] }.length == 0 and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [5,7])) and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [4,7]))
				$pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first.move_to([6,7])
				$pieces.select {|e| e.current_pos == [7,7] and e.class.name == "Rook" and e.color == turn_color}.first.move_to([5,7])
				undo_stack.push("black short castle")
			else
				puts "Invalid Short Castle"
				next
			end
		end
	elsif move_str == "O-O-O"
		if turn_color == "white"
			if $pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first.current_pos == [4, 0] and $pieces.select {|e| e.current_pos == [0,0] and e.class.name == "Rook" and e.color == turn_color}.length == 1 and $pieces.select { |e| e.current_pos == [1, 0] }.length == 0 and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [2,0])) and $pieces.select { |e| e.current_pos == [2, 0] }.length == 0 and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [3,0])) and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [4,0])) and $pieces.select { |e| e.current_pos == [3, 0] }.length == 0
				$pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first.move_to([2,0])
				$pieces.select {|e| e.current_pos == [0,0] and e.class.name == "Rook" and e.color == turn_color}.first.move_to([3,0])
				undo_stack.push("white long castle")
			else
				puts "Invalid long Castle"
				next
			end
		else
			if $pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first.current_pos == [4, 7] and $pieces.select {|e| e.current_pos == [0,7] and e.class.name == "Rook" and e.color == turn_color}.length == 1 and $pieces.select { |e| e.current_pos == [1, 7] }.length == 0 and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [2,7])) and $pieces.select { |e| e.current_pos == [2, 7] }.length == 0 and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [3,7])) and (not king_checked?($pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first, [4,7])) and $pieces.select { |e| e.current_pos == [3, 7] }.length == 0
				$pieces.select { |e| e.class.name == "King" and e.color == turn_color}.first.move_to([2,7])
				$pieces.select {|e| e.current_pos == [0,7] and e.class.name == "Rook" and e.color == turn_color}.first.move_to([3,7])
				undo_stack.push("black long castle")
			else
				puts "Invalid long Castle"
				next
			end
		end
	elsif move_str.downcase == "draw" or move_str.downcase == "tie"
		puts "The game is a draw."
		exit
	elsif move_str.downcase == "resign"
		puts "#{turn_color} resigns."
		puts "Game over."
		exit
	elsif move_str.downcase == "save"
		to_save = [$pieces, turn_color, undo_stack]
		y = YAML::dump(to_save)

		file_saved = false
		while not file_saved
			puts "\nEnter file name to save."
			file_name = gets.chomp
			if File::exists?("./saved_games/#{file_name}")
				puts "\nFile exists. Want to overwrite? (yes or y)"
				owr = gets.chomp
				owr = owr.downcase
				if owr != "yes" and owr != "y"
					next
				end
			end

			File.open("./saved_games/#{file_name}", "w") { |file| file.write(y) }
			file_saved = true
			puts "File successfully saved with name #{file_name}"

			puts "\nWant to exit(press 1) or continue playing(press any other key)?"
			file_name = gets.chomp
			if file_name == "1"
				exit
			end
		end
	elsif move_str.downcase == "exit"
		puts "\n Thanks for playing."
		exit
	elsif move_str.downcase == "undo"
		undo = undo_stack.pop
		if undo.is_a? String
			#undo a castle
			if undo == "white short castle"
				$pieces.select { |e| e.current_pos == [6,0] and e.class.name == "King" }.first.move_to([4,0])
				$pieces.select { |e| e.current_pos == [5,0] and e.class.name == "Rook" }.first.move_to([7,0])
			elsif undo == "black short castle"
				$pieces.select { |e| e.current_pos == [6,7] and e.class.name == "King" }.first.move_to([4,7])
				$pieces.select { |e| e.current_pos == [5,7] and e.class.name == "Rook" }.first.move_to([7,7])
			elsif undo == "white long castle"
				$pieces.select { |e| e.current_pos == [2,0] and e.class.name == "King" }.first.move_to([4,0])
				$pieces.select { |e| e.current_pos == [3,0] and e.class.name == "Rook" }.first.move_to([0,0])
			elsif undo == "black long castle"
				$pieces.select { |e| e.current_pos == [2,7] and e.class.name == "King" }.first.move_to([4,7])
				$pieces.select { |e| e.current_pos == [3,7] and e.class.name == "Rook" }.first.move_to([0,7])
			else
				puts "Something seriously went wrong there."
			end				
		else
			#undo a move
			begin
				undo[0].move_to(undo[-1])
			rescue
				puts "Undo not possible"
				next
			end
		end		
	else		
		moving_piece = /[RNBKQ]/.match(move_str)
		moving_piece ||= "P"
		moving_piece = moving_piece.to_s

		move = []
		move[0] = /[a-h]+/.match(move_str).to_s[-1].ord() - 97
		move[1] = /[1-8]/.match(move_str).to_s()[-1].to_i() - 1

		clash_resolver = nil
		if /[a-h]+/.match(move_str).to_s.length > 1
			clash_resolver = /[a-h]+/.match(move_str).to_s[0].ord() - 97
		end

		caputers = false
		if $pieces.select { |e| e.color != turn_color and e.current_pos == move}.length == 1
			caputers = true
		end

		if moving_piece == "K"
			pc = $pieces.select { |e| e.color == turn_color and e.class.name == "King" and e.move_possible?(move)}
			if pc.length == 1
				undo_stack.push([pc[0], pc[0].current_pos])
				pc[0].move_to(move)
			else
				puts "Invalid move for the king."
				next
			end
		elsif moving_piece == "Q"
			pc = $pieces.select { |e| e.color == turn_color and e.class.name == "Queen"  and e.move_possible?(move) }
			if pc.length == 1
				undo_stack.push([pc[0], pc[0].current_pos])
				pc[0].move_to(move)
			else
				puts "Invalid move"
				next
			end
		elsif moving_piece == "R"
			pc = $pieces.select { |e| e.color == turn_color and e.class.name == "Rook"  and e.move_possible?(move) }
			if pc.length == 1
				undo_stack.push([pc[0], pc[0].current_pos])
				pc[0].move_to(move)
			elsif pc.length == 2
				if clash_resolver
					pc = pc.select { |e| e.current_pos[0] == clash_resolver }
					undo_stack.push([pc[0], pc[0].current_pos])
					pc[0].move_to(move)
				else
					puts "Two rooks can move to that place."
				end
			else
				puts "Invalid move."
				next
			end
		elsif moving_piece == "N"
			pc = $pieces.select { |e| e.color == turn_color and e.class.name == "Knight"  and e.move_possible?(move) }
			if pc.length == 1
				undo_stack.push([pc[0], pc[0].current_pos])
				pc[0].move_to(move)
			elsif pc.length == 2
				if clash_resolver
					pc = pc.select { |e| e.current_pos[0] == clash_resolver }
					undo_stack.push([pc[0], pc[0].current_pos])
					pc[0].move_to(move)
				else
					puts "Two knights can move to that place."
				end
			else
				puts "Invalid move."
				next
			end
		elsif moving_piece == "B"
			pc = $pieces.select { |e| e.color == turn_color and e.class.name == "Bishop"  and e.move_possible?(move) }
			if pc.length == 1
				undo_stack.push([pc[0], pc[0].current_pos])
				pc[0].move_to(move)
			else
				puts "Invalid move"
				next
			end	
		elsif moving_piece == "P"
			pc = $pieces.select { |e| e.color == turn_color and e.class.name == "Pawn" and e.move_possible?(move) }
			if pc.length == 1
				undo_stack.push([pc[0], pc[0].current_pos])
				pc[0].move_to(move)
			elsif pc.length == 2
				if clash_resolver
					pc = pc.select { |e| e.current_pos[0] == clash_resolver }
					undo_stack.push([pc[0], pc[0].current_pos])
					pc[0].move_to(move)
				else
					puts "Two pawns can move to that place."
				end
			else
				puts "Invalid move."
				next
			end
		else
			puts "Invalid chess move."
			next
		end

		if caputers
			$pieces -= $pieces.select { |e| e.color != turn_color and e.current_pos == move}
		end
	end
	
	board.display_board
	turn_color = toggle_color(turn_color)
end