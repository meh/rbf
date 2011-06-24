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

class Transform < Parslet::Transform
  rule(?> => simple(:x)) { ?> }
  rule(?< => simple(:x)) { ?< }

  rule(?+ => simple(:x)) { ?+ }
  rule(?- => simple(:x)) { ?- }

  rule(?. => simple(:x)) { ?. }
  rule(?, => simple(:x)) { ?, }

  rule(:loop => subtree(:x)) { x }
end

end
