class GameOfBattleship
  def initialize(input_file)
    @input_file = input_file
    read_input
    @player1_grid = Array.new(@grid_size) { Array.new(@grid_size, '_') }
    @player2_grid = Array.new(@grid_size) { Array.new(@grid_size, '_') }
  end

  def read_input
    File.open(@input_file, "r") do |file|
      @grid_size = file.readline.to_i
      @total_ships = file.readline.to_i
      
      @player1_ships = parse_ship_positions(file.readline)
      @player2_ships = parse_ship_positions(file.readline)
      
      @total_missiles = file.readline.to_i
      
      @player1_moves = parse_moves(file.readline)
      @player2_moves = parse_moves(file.readline)
    end
  end

  def parse_ship_positions(line)
    line.chomp.split(":").map { |pos| pos.split(",").map(&:to_i) }
  end

  def parse_moves(line)
    line.chomp.split(":").map { |move| move.split(",").map(&:to_i) }
  end

  def play_game
    setup_game
    
    @player1_moves.each do |x, y|
      if @player2_grid[x][y] == 'B'
        @player2_grid[x][y] = 'X' # Mark as hit
      else
        @player2_grid[x][y] = 'O' # Mark as missed
      end
    end

    @player2_moves.each do |x, y|
      if @player1_grid[x][y] == 'B'
        @player1_grid[x][y] = 'X' # Mark as hit
      else
        @player1_grid[x][y] = 'O' # Mark as missed
      end
    end

    output_results
  end

  def setup_game
    place_ships(@player1_ships, @player1_grid)
    place_ships(@player2_ships, @player2_grid)
  end

  def place_ships(player_ships, grid)
    player_ships.each do |ship|
      grid[ship[0]][ship[1]] = 'B'
    end
  end

  def output_results
    player1_output = @player1_grid.map { |row| row.join(' ') }.join("\n")
    player2_output = @player2_grid.map { |row| row.join(' ') }.join("\n")
    
    puts "Player1\n#{player1_output}"
    puts "Player2\n#{player2_output}"

    p1_hits = @player2_grid.flatten.count('X')
    p2_hits = @player1_grid.flatten.count('X')

    puts "P1:#{p1_hits}"
    puts "P2:#{p2_hits}"

    if p1_hits > p2_hits
      puts "Player 1 wins"
    elsif p2_hits > p1_hits
      puts "Player 2 wins"
    else
      puts "It is a draw"
    end
  end
end

game = GameOfBattleship.new("input.txt")
game.play_game
