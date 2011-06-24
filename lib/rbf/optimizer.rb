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

module RBF

class Optimizer
  class Algorithm
    attr_reader :optimizer

    def initialize (optimizer)
      @optimizer = optimizer
    end

    def optimize (tree)
      nil
    end
  end

  attr_reader :options

  def initialize (options={})
    @options = options
  end

  def optimize (tree)
    result = tree.clone

    algorithms.each {|alg|
      alg.new(self).optimize(result)
    }

    result
  end

  def algorithms
    Optimizer.constants.map {|const|
      Optimizer.const_get(const) unless options[const.to_s.downcase.to_sym] == false
    }.compact
  end

  class UselessOperations < Algorithm
    def optimize (tree)
      i = 0

      until i >= tree.length
        if tree[i].is_a?(Array) && tree[i + 1].is_a?(Array)
          optimize(tree[i])
          optimize(tree[i + 1])

          i += 2
        elsif tree[i].is_a?(Array)
          optimize(tree[i])

          i += 1
        elsif [[?+, ?-], [?-, ?+], [?>, ?<], [?<, ?>]].member?(tree[i ... i + 2])
          tree.slice!(i ... i + 2)
        else
          i += 1
        end
      end 
    end
  end
end

end
