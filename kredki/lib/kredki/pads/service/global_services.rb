require_relative 'service_inherited'

module Kredki
  module Pads
    # Module to include in service parents.
    module GlobalServices
      extend ServiceInherited
    end
  end
end