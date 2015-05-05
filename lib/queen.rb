class Queen
	attr_reader :current_pos, :color, :unicode
	attr_writer :unicode

	def initialize(current_pos, color)
		@current_pos = current_pos
		@color = color
		@unicode = "\u265b"
		if color == "white"
			@unicode = "\u2655"
		end
	end

	def move_possible?(move, check = true)
		#the check is here so that the king_checked? method can use this without falling into endless name calling

		#move is in legal board limits
		return false unless move[0].between?(0,7) and move[1].between?(0,7)

		#resultant position is not same colored piece
		return false if $pieces.select { |e| e.current_pos == move and e.color == self.color }.length != 0

		#move exposes the king to check
		if check
			return false if king_checked?(self, move)
		end

		#queen should be in same diagonal or file or rank
		return false if move[0] + move[1] != self.current_pos[0] + self.current_pos[1] and move[1] - move[0] != self.current_pos[1] - self.current_pos[0] and move[0] != self.current_pos[0] and move[1] != self.current_pos[1]

		#all positions in between should be empty
		if move[0] + move[1] == self.current_pos[0] + self.current_pos[1]
			if self.current_pos[0] > move[0]
				for i in move[0]+1 ... self.current_pos[0]
					j = move[0] + move[1] - i
					return false if $pieces.select { |e| e.current_pos == [i, j]}.length != 0
				end
			else
				for i in self.current_pos[0]+1 ... move[0]
					j = move[0] + move[1] - i
					return false if $pieces.select { |e| e.current_pos == [i, j]}.length != 0
				end
			end
		elsif move[1] - move[0] == self.current_pos[1] - self.current_pos[0]
			if self.current_pos[0] > move[0]
				for i in move[0]+1 ... self.current_pos[0]
					j = move[1] - move[0] + i
					return false if $pieces.select { |e| e.current_pos == [i, j]}.length != 0
				end
			else
				for i in self.current_pos[0]+1 ... move[0]
					j = move[1] - move[0] + i
					return false if $pieces.select { |e| e.current_pos == [i, j]}.length != 0
				end
			end
		elsif move[0] > self.current_pos[0]
			for i in self.current_pos[0]+1 ... move[0] do
				return false if $pieces.select { |e| e.current_pos == [i, move[1]]}.length != 0
			end

		elsif move[0] < self.current_pos[0]
			for i in move[0]+1 ... self.current_pos[0] do
				return false if $pieces.select { |e| e.current_pos == [i, move[1]]}.length != 0
			end
		elsif move[1] > self.current_pos[1]
			for i in self.current_pos[1]+1 ... move[1] do
				return false if $pieces.select { |e| e.current_pos == [move[0], i]}.length != 0
			end

		else
			for i in move[1]+1 ... self.current_pos[1] do
				return false if $pieces.select { |e| e.current_pos == [move[0], i]}.length != 0
			end
		end

		#if all else fails the move is legal
		return true
	end

	def die
		@current_pos = nil
	end

	def move_to(pos)
		@current_pos = pos
	end
end