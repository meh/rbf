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

require 'stringio'

class IO
  begin
    require 'Win32API'

    def read_char
      Win32API.new('crtdll', '_getch', [], 'L').Call
    end
  rescue LoadError
    def read_char
      system 'stty raw -echo'

      STDIN.getc
    ensure
      system 'stty -raw echo'
    end
  end
end

module RBF

class Interpreter
  class Storage < Hash
    attr_reader :position

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
      self[position || @position] = value.ord
    end

    def get (position=nil)
      self[position || @position].to_i rescue 0
    end

    def inspect
      "#<Storage(#{position}): #{super}>"
    end
  end

  attr_reader :options, :storage

  def initialize (options={})
    @options = options

    @storage = Storage.new(options[:env] || [])
    @input   = STDIN
    @output  = STDOUT

    @parser    = RBF::Parser.syntax(RBF.syntax(options[:syntax])).new
    @transform = RBF::Transform.new
    @optimizer = RBF::Optimizer.new(options)
  end
  
  def parse (text)
    return text if text.is_a?(Array)

    parsed = @parser.parse_with_debug(text)

    raise SyntaxError, 'There is a syntax error' unless parsed

    @optimizer.optimize(@transform.apply(parsed))
  end

  def evaluate (tree, options=nil)
    options ||= {}

    if options[:catch]
      @output = StringIO.new
    else
      @output = STDOUT
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
