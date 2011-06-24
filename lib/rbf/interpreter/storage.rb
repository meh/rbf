#--
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                   Version 2, December 2004
#
#  Copyleft meh. [http://meh.paranoid.pk | meh@paranoici.org]
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module RBF; class Interpreter

class Storage < Hash
  attr_accessor :position

  def initialize (data)
    if data.is_a?(Array)
      parent = {}

      data.each_with_index {|value, index|
        parent[index] = value
      }

      super(parent)
    else
      super
    end

    @position = 0
  end

  def check!
    unless self[@position].is_a?(Integer)
      self[@position] = 0
    end
  end

  def forward!
    @position += 1
  end

  def backward!
    @position -= 1
  end 

  def increase!
    check!

    self[@position] += 1
  end

  def decrease!
    check!

    self[@position] -= 1
  end

  def set (value, position=nil)
    self[position ? position.to_i : @position.to_i] = value.ord
  end

  def get (position=nil)
    self[position ? position.to_i : @position.to_i].to_i rescue 0
  end

  def inspect
    "#<Storage(#{position}): #{super}>"
  end
end

end; end
