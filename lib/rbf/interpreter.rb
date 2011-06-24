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
  class Storage < Array
    def initialize (*args)
      super

      @pointer = 0

      check!
    end

    def check!
      if self[@pointer].nil?
        self[@pointer] = 0
      end
    end

    def forward!
      @pointer += 1

      check!
    end

    def backward!
      @pointer -= 1

      check!
    end 

    def increase!
      self[@pointer] += 1
    end

    def decrease!
      self[@pointer] -= 1
    end

    def set (value)
      self[@pointer] = value.to_i
    end

    def get
      self[@pointer].to_i
    end
  end

  def initialize
    @storage = Storage.new
    @input   = STDIN
  end

  def evaluate (tree, options={})
    if options[:catch]
      @output = StringIO.new
    else
      @output = STDOUT
    end

    cycle(tree)

    if options[:catch]
      @output.rewind
      @output.read
    end
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
    @output.print @storage.get.chr
    @output.flush
  end

  define_method ?, do
    @storage.set @input.read_char
  end
end

end
