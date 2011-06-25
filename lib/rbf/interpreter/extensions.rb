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
      system 'stty raw'

      STDIN.getc
    ensure
      system 'stty -raw echo'
    end
  end
end
