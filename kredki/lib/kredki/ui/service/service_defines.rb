require_relative 'service_inherited'

module Kredki
  module UI
    # Module to include in service parents.
    module ServiceDefines
      extend ServiceInherited
    end
  end
end