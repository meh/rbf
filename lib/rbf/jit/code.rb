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

module RBF; class JIT

class Code
  attr_reader :options

  def initialize (tree, options=nil)
    @options = options

    @module = LLVM::Module.create('brainfuck')
    @module.functions.add('self', [], LLVM::Void) do |func|
      builder = LLVM::Builder.create
    end

    @module.verify
  end

  def execute
    LLVM::ExecutionEngine.create_jit_compiler(@module).run_function(@module.functions['self'])
  end
end

end; end
