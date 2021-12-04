require_relative "../../aoc_input"

input = get_input(2021, 4).split("\n")

called_numbers = input.shift.split(",").map(&:to_i)

def get_boards(input)
  boards = []
  board = []
  input.each do |line|
    next if line.empty? && board.empty?

    if line.empty?
      boards << board
      board = []
    else
      board << line.split.map(&:to_i)
    end
  end
  boards << board
  boards
end

def winner?(board)
  # Horizontal
  return true if board.any? { |x| x.all?(&:nil?) }

  # Column
  col = []
  board.first.size.times do |idx|
    board.each { |line| col << line[idx].nil? }
    return true if col.all?

    col = []
  end

  false
end

def play_board(num, board)
  board.each do |line|
    line.map! { |x| x == num ? nil : x }
  end
end

def first_winner(boards, called_numbers)
  called_numbers.each do |x|
    boards.each do |b|
      play_board(x, b)
      return [x, b] if winner?(b)
    end
  end
end

def last_winner(boards, called_numbers)
  last_winner = []
  called_numbers.each do |x|
    boards.dup.each do |b|
      play_board(x, b)
      if winner?(b)
        boards.delete(b)
        last_winner = [x, b]
      end
    end
  end
  last_winner
end

boards = get_boards(input)

num, board = first_winner(boards, called_numbers)
puts board.flatten.compact.sum * num

num, board = last_winner(boards, called_numbers)
puts board.flatten.compact.sum * num
