class King
	attr_reader :current_pos, :color, :unicode
	attr_writer :unicode

	def initialize(current_pos, color)
		@current_pos = current_pos
		@color = color
		@unicode = "\u265a"
		if color == "white"
			@unicode = "\u2654"
		end
	end

	def move_possible?(move, check = true)
		#move is in legal board limits
		return false unless move[0].between?(0,7) and move[1].between?(0,7)

		#resultant position should not be a same colored piece
		return false if $pieces.select { |e| e.current_pos == move and e.color == self.color }.length != 0

		#move exposes the king to check
		if check
			return false if king_checked?(self, move)
		end

		#king can only be 1 space away
		for i in self.current_pos[0]-1..self.current_pos[0]+1
			for j in self.current_pos[1]-1..self.current_pos[1]+1
				return true if move[0] == i and move[1] == j
			end
		end

		#if all else fails the move is illegal
		return false
	end

	#add support for stalemate later
=begin
	def stalemate?
		return false if king_checked?(self, self.current_pos)
		for i in self.current_pos[0]-1..self.current_pos[0]+1
			for j in self.current_pos[1]-1..self.current_pos[1]+1
				return false if move_possible?([i,j])
			end
		end
		true
	end
=end
	def checkmate?
		for i in self.current_pos[0]-1..self.current_pos[0]+1
			for j in self.current_pos[1]-1..self.current_pos[1]+1
				return false if self.move_possible?([i,j])
			end
		end
		return true if king_checked?(self, self.current_pos)
		false
	end

	def move_to(pos)
		@current_pos = pos
	end
end