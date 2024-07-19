require_relative 'game_of_battleship'
require 'rspec'

RSpec.describe GameOfBattleship do
  let(:input_file) { 'test_input.txt' }

  # Example content for the input file
  before do
    File.open(input_file, "w") do |file|
      file.puts "5"
      file.puts "2"
      file.puts "1,1:2,2"
      file.puts "3,3:4,4"
      file.puts "2"
      file.puts "1,1:0,0"
      file.puts "3,3:2,2"
    end
  end

  let(:game) { described_class.new(input_file) }

  before do
    game.read_input
  end

  describe '#initialize' do
    it 'reads the input file and initializes the grids' do
      expect(game.instance_variable_get(:@grid_size)).to eq(5)
      expect(game.instance_variable_get(:@total_ships)).to eq(2)
      expect(game.instance_variable_get(:@player1_ships)).to eq([[1, 1], [2, 2]])
      expect(game.instance_variable_get(:@player2_ships)).to eq([[3, 3], [4, 4]])
      expect(game.instance_variable_get(:@total_missiles)).to eq(2)
      expect(game.instance_variable_get(:@player1_moves)).to eq([[1, 1], [0, 0]])
      expect(game.instance_variable_get(:@player2_moves)).to eq([[3, 3], [2, 2]])
    end
  end

  describe '#place_ships' do
    it 'places the ships on the grid' do
      grid = Array.new(5) { Array.new(5, '_') }
      game.place_ships([[1, 1], [2, 2]], grid)
      expect(grid[1][1]).to eq('B')
      expect(grid[2][2]).to eq('B')
    end
  end

  describe '#setup_game' do
    it 'sets up the game with ships placed on grids' do
      game.setup_game
      player1_grid = game.instance_variable_get(:@player1_grid)
      player2_grid = game.instance_variable_get(:@player2_grid)

      expect(player1_grid[1][1]).to eq('B')
      expect(player1_grid[2][2]).to eq('B')
      expect(player2_grid[3][3]).to eq('B')
      expect(player2_grid[4][4]).to eq('B')
    end
  end

  describe '#play_game' do
    it 'plays the game and outputs the correct results' do
      expect { game.play_game }.to output(/Player1/).to_stdout
      expect { game.play_game }.to output(/Player2/).to_stdout
      expect { game.play_game }.to output(/Player 2 wins/).to_stdout
    end
  end

  describe '#output_results' do
    it 'outputs the game results correctly' do
      game.setup_game

      game.instance_variable_get(:@player1_moves).each do |x, y|
        if game.instance_variable_get(:@player2_grid)[x][y] == 'B'
          game.instance_variable_get(:@player2_grid)[x][y] = 'X'
        else
          game.instance_variable_get(:@player2_grid)[x][y] = 'O'
        end
      end

      game.instance_variable_get(:@player2_moves).each do |x, y|
        if game.instance_variable_get(:@player1_grid)[x][y] == 'B'
          game.instance_variable_get(:@player1_grid)[x][y] = 'X'
        else
          game.instance_variable_get(:@player1_grid)[x][y] = 'O'
        end
      end

      expect { game.output_results }.to output(/Player1/).to_stdout
      expect { game.output_results }.to output(/Player2/).to_stdout
      expect { game.output_results }.to output(/Player 2 wins/).to_stdout
    end
  end
end
