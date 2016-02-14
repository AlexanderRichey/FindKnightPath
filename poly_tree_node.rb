class PolyTreeNode
  def initialize(value)
    @parent = nil
    @children = []
    @value = value
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def value
    @value
  end

  def parent=(new_parent)
    old_parent = self.parent
    old_parent.children.delete_if { |el| el == self } unless old_parent == nil

    @parent = new_parent
    unless new_parent == nil || new_parent.children.include?(self)
      new_parent.children << self
    end
  end

  def add_child(new_child)
    new_child.parent = self
  end

  def remove_child(child)
    raise "This is not a child of self." unless child.parent == self
    child.parent = nil
  end

  def inspect
    { 'value' => @value, 'parent_value' => @parent.value }.inspect
  end

  def dfs(target_value)
    return self if self.value == target_value

    self.children.each do |child|
      result = child.dfs(target_value)

      return result if result
    end

    nil
  end

  # def dfs(target_value)
  #   if self.value == target_value
  #     return self
  #   elsif self.children.empty?
  #     return nil
  #   else
  #     self.children.each do |el|
  #       result = el.dfs(target_value)
  #       if result.nil?
  #         next
  #       elsif result.value == target_value
  #         return result
  #       end
  #     end
  #   end
  #
  #   nil
  # end

  def bfs(target_value)
    queue = [self]

    until queue.empty?
      node = queue.shift

      if node.value == target_value
        return node
      else
        queue.concat(node.children)
      end
    end

    nil
  end
end
