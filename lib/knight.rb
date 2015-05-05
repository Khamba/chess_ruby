class Knight
	attr_reader :current_pos, :color, :unicode
	attr_writer :unicode

	def initialize(current_pos, color)
		@current_pos = current_pos
		@color = color
		@unicode = "\u265e"
		if color == "white"
			@unicode = "\u2658"
		end
	end

	def move_possible?(move, check=true)
		#move is in legal board limits
		return false unless move[0].between?(0,7) and move[1].between?(0,7)

		#resultant position is not same colored piece
		return false if $pieces.select { |e| e.current_pos == move and e.color == self.color }.length != 0

		#move exposes the king to check
		if check
			return false if king_checked?(self, move)
		end

		#knight cannot be in same file or rank
		return false if move[0] == self.current_pos[0] or move[1] == self.current_pos[1]

		#knight only moves two and a half spaces
		return true if (move[0] - self.current_pos[0]).abs + (move[1] - self.current_pos[1]).abs == 3

		#if all else fails the move is illegal
		return false
	end

	def die
		@current_pos = nil
	end

	def move_to(pos)
		@current_pos = pos
	end

end