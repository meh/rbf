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

require 'rbf/interpreter/extensions'
require 'rbf/interpreter/storage'

module RBF

class Interpreter
  attr_reader :options, :storage

  def initialize (options={})
    @options = options

    @storage = Storage.new(options[:env] || [])
    @input   = STDIN
    @output  = STDOUT

    @parser    = RBF::Parser.syntax(RBF.syntax(options[:syntax])).new
    @transform = RBF::Transform.new
    @optimizer = RBF::Optimizer.new(options)
    @jit       = RBF::JIT.new(options)
  end
  
  def parse (text)
    return text if text.is_a?(Array)

    parsed = @parser.parse_with_debug(text)

    raise SyntaxError, 'There is a syntax error' unless parsed

    @optimizer.optimize(@transform.apply(parsed))
  end

  def evaluate (tree, options=nil)
    options = @options.merge(options || {})

    if options[:catch]
      @output = StringIO.new
    else
      @output = STDOUT
    end

    tree = parse(tree)

    if JIT.supported? && !options[:catch]
      return @jit.compile(tree).execute
    end

    cycle(parse(tree))

    if options[:catch]
      @output.rewind
      @output.read
    end
  end

  def execute (path, options=nil)
    evaluate(File.read(path), options)
  end

  def cycle (tree)
    tree.each {|token|
      if token.is_a?(Array)
        self.loop(token)
      else
        self.send(token)
      end
    }
  end

  def loop (tree)
    while @storage.get != 0
      cycle(tree)
    end
  end

  define_method ?> do
    @storage.forward!
  end

  define_method ?< do
    @storage.backward!
  end

  define_method ?+ do
    @storage.increase!
  end

  define_method ?- do
    @storage.decrease!
  end

  define_method ?. do
    @output.print @storage.get.chr rescue nil
    @output.flush
  end

  define_method ?, do
    @storage.set @input.read_char
  end
end

end
