require_relative 'poly_tree_node'

class KnightPathFinder
  attr_accessor :visited_positions
  attr_reader :starting_pos, :root

  DELTAS = [
    [-1, 2],
    [1, 2],
    [1, -2],
    [-1, -2],
    [-2, -1],
    [2, 1],
    [-2, 1],
    [2, -1]
  ]

  def initialize(starting_pos)
    @visited_positions = [starting_pos]
    @root = PolyTreeNode.new(starting_pos)

    build_move_tree
  end

  def new_move_positions(pos)
    #get possible move positions from KnightPathFinder#valid_moves
    possible_move_positions = KnightPathFinder.valid_moves(pos)

    #delete positions that have already been visited from
    #possible_move_positions
    visited_positions.each do |visited_position|
      possible_move_positions.delete_if do |possible_position|
        possible_position.value == visited_position
      end
    end

    #add possible_move_positions to visited_positions unless
    #possible_position is already in visited_positions
    possible_move_positions.each do |pos_move|
      self.visited_positions << pos_move.value unless visited_positions.include?(pos_move.value)
    end

    #return cleaned possible_move_positions; now only positions that
    #have not already been visited are in possible_move_positions
    possible_move_positions
  end

  def self.valid_moves(pos)
    #generate valid_moves by iterating over DELTAS, then select
    #only those moves whose coordinates are within the board
    valid_moves = DELTAS.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end.select do |(x, y)|
      [x,y].all? do |el|
        el.between?(0,7)
      end
    end

    #convert valid_moves into valid_nodes
    valid_nodes = valid_moves.map do |position|
      PolyTreeNode.new(position)
    end

    #return valid_nodes; the value of each node is a
    #possible valid_move_position
    valid_nodes
  end

  def build_move_tree
    #add the knight's starting position to the queue
    queue = [root]

    #build move tree by:
    #  (1) shifting out node from queue
    #  (2) generating new_positions for shifted node by calling
    #      #new_move_positions on its value
    #  (3) declaring that each new_positions node is a child
    #      of the shifted node
    #  (4) adding new_positions to queue so that their children can be realized
    # building the move tree will terminate when every possible position is
    # in visited_positions; the reason that this process will terminate
    # is that #new_move_positions will cease to return values
    # when no more unique positions can be added to visited_positions
    until queue.empty?
      node = queue.shift

      new_positions = new_move_positions(node.value).each do |child|
        child.parent = node
      end

      queue.concat(new_positions)
    end
  end

  def find_path(end_position)
    #do depth first search for end_position starting from root
    end_position_node = root.dfs(end_position)

    #trace the path of the search backward and return positons in order
    trace_path_back(end_position_node)
  end

  def trace_path_back(end_position_node)
    # Goal: trace the knight's path back to root of the tree
    # Base Case: if the end_position_node is the root of the tree, return
    # an array of it
    # Recursive Rule: recurse on the parent of the end_position_node and
    # add the value of the end_position_node to it
    # Explanation: eventually the root will be reached, its position will be
    # returned as an array of one array, and the other instantions of the
    # trace_path_back method will push in the values of their
    # end_position_node's to this array
    return [end_position_node.value] if end_position_node == root
    trace_path_back(end_position_node.parent) << end_position_node.value
  end
end
