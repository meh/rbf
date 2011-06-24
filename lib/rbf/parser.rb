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

require 'parslet'

module RBF

class Parser < Parslet::Parser
  def self.apply (keys)
    klass = self.clone
    
    klass.class_eval {
      rule(:forward)  { str(keys[:forward]).as(?>) }
      rule(:backward) { str(keys[:backward]).as(?<) }

      rule(:increase) { str(keys[:increase]).as(?+) }
      rule(:decrease) { str(keys[:decrease]).as(?-) }

      rule(:output) { str(keys[:output]).as(?.) }
      rule(:input)  { str(keys[:input]).as(?,) }

      rule(:while_start) { str(keys[:while_start]) }
      rule(:while_end)   { str(keys[:while_end]) }

      rule(:comment) { (
        str(keys[:forward])  |
        str(keys[:backward]) |

        str(keys[:increase]) |
        str(keys[:decrease]) |

        str(keys[:output]) |
        str(keys[:input])  |

        str(keys[:while_start]) |
        str(keys[:while_end])
      ).absent? >> any }
    }

    klass
  end

  rule(:keyword) {
    forward  |
    backward |
    increase |
    decrease |
    output   |
    input
  }

  rule(:while_loop) {
    while_start >> code.as(:loop) >> while_end
  }

  rule(:code) {
    (while_loop | keyword | comment).repeat
  }

  root :code
end

end
