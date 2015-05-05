class Board

	def display_board
		ch = "a"
		print "   "
		8.times do
			print "  #{ch} "
			ch = (ch.ord + 1).chr
		end

		dash = "\u2015\u2015\u2015"
		print "\n    "
		8.times { print dash.encode('utf-8') + " " }
		8.times do |i|
			print "\n #{8-i} |"
			8.times do |j|
				piece_code = " "
				$pieces.select { |e| e.current_pos == [j, 7-i] }.each { |pc| piece_code = pc.unicode}
				print " #{piece_code} ".encode('utf-8') + "|"
			end
			print " #{8-i}\n    " 
			8.times { print dash.encode('utf-8') + " " }
		end

		ch = "a"
		print "\n   "
		8.times do
			print "  #{ch} "
			ch = (ch.ord + 1).chr
		end
	end
end