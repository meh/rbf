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
    algos  = algorithms

    begin
      changed = algos.any? {|algo|
        algo.optimize(result)
      }
    end while changed

    result
  end

  def algorithms
    @@optimizations.map {|(name, block)|
      Algorithm.new(self, &block) unless options[name] == false
    }.compact
  end

  optimization :useless_operations do |tree|
    changed = false
    i       = 0

    until i >= tree.length
      if tree[i].is_a?(Array) && tree[i + 1].is_a?(Array)
        changed ||= optimize(tree[i])
        changed ||= optimize(tree[i + 1])

        i += 2
      elsif tree[i].is_a?(Array)
        changed ||= optimize(tree[i])

        i += 1
      elsif [[?+, ?-], [?-, ?+], [?>, ?<], [?<, ?>]].member?(tree[i ... i + 2])
        tree.slice!(i ... i + 2)

        changed ||= true
      else
        i += 1
      end
    end

    changed
  end

  optimization :clear_empty_loops do |tree|
    changed = false
    i       = 0

    until i >= tree.length
      if !tree[i].is_a?(Array)
        i += 1

        next
      else
        changed ||= optimize(tree[i])

        if tree[i].empty?
          changed ||= true

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

    changed
  end
end

end
