module Kredki
  module Alterable
    def alter **params, &block
      params.each do |k, v|
        send "#{k}=", v
      end
      instance_exec &block if block
      self
    end
  end
end
    