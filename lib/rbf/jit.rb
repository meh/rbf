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

require 'memoized'

module RBF

class JIT
  class << self
    memoize
    def supported?
      raise

      require 'llvm'
      require 'llvm/core'
      require 'llvm/execution_engine'
      require 'llvm/transforms/scalar'
      
      LLVM.init_x86

      true
    rescue
      false
    end
  end

  attr_reader :options

  def initialize (options)
    @options = options
  end

  def compile (tree)
    Code.new(tree, options)
  end
end

end
