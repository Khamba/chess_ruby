class Pawn
	attr_reader :current_pos, :color, :unicode
	attr_writer :unicode

	def initialize(current_pos, color)
		@current_pos = current_pos
		@color = color
		@unicode = "\u265f"
		if color == "white"
			@unicode = "\u2659"
		end
	end

	def move_possible?(move, check=true)
		#move is in legal board limits
		return false unless move[0].between?(0,7) and move[1].between?(0,7)

		#move exposes the king to check
		if check
			return false if king_checked?(self, move)
		end

		#pawn captures a piece
		#enpassant is little tricky, will add later (after adding undo support)
		if (move[0]  == self.current_pos[0] + 1 || move[0] == self.current_pos[0]-1) and $pieces.select { |e| e.current_pos == move and e.color != self.color }.length == 1
			if self.color == "white"
				return true if move[1] == self.current_pos[1] + 1
			else
				return true if move[1] == self.current_pos[1] - 1
			end
		end

		#pawn should be in same file
		return false if move[0] != self.current_pos[0]

		#the moving position should be empty
		return false if $pieces.select { |e| e.current_pos == move }.length != 0

		#pawn must move only 1 space or 2 in special case
		if self.color == "white"
			if move[1] == self.current_pos[1] + 1
				return true
			end
			if move[1] == self.current_pos[1] + 2 and self.current_pos[1] == 1 and $pieces.select { |e| e.current_pos == [move[0], move[1]-1] }.length == 0
				return true
			end
		else
			if move[1] == self.current_pos[1] - 1
				return true
			end
			if move[1] == self.current_pos[1] - 2 and self.current_pos[1] == 6 and $pieces.select { |e| e.current_pos == [move[0], move[1]+1] }.length == 0
				return true
			end
		end

		#if all else fails the move is illegal
		return false
	end

	def move_to(pos)
		@current_pos = pos
	end

	def die
		@current_pos = nil
	end

end