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

    def initialize (optimizer, &block)
      @optimizer = optimizer
      @block     = block
    end

    def optimize (tree)
      self.instance_exec(tree, &@block)
    end
  end

  def self.optimization (name, &block)
    (@@optimizations ||= []) << [name, block]
  end

  attr_reader :options

  def initialize (options={})
    @options = options
  end

  def optimize (tree)
    result = tree.clone

    algorithms.each {|alg|
      alg.optimize(result)
    }

    result
  end

  def algorithms
    @@optimizations.map {|(name, block)|
      Algorithm.new(self, &block) unless options[name] == false
    }.compact
  end

  optimization :useless_operations do |tree|
    i       = 0
    changed = false

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

        changed = true
      else
        i += 1
      end
    end

    optimize(tree) if changed
  end

  optimization :clear_empty_loops do |tree|
    i = 0

    until i >= tree.length
      if !tree[i].is_a?(Array)
        i += 1

        next
      else
        optimize(tree[i])

        if tree[i].empty?
          unless @warned
            @warned = true
            warn 'Optimizing out one or more potentially dangerous empty loops'
          end

          tree.delete_at(i)
        else
          i += 1
        end
      end
    end
  end
end

end
