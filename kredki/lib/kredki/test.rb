require_relative 'ui'
require 'minitest/autorun'
require 'forwardable'

module Kredki
  class Test < Minitest::Test
    extend Forwardable

    (UI::Layer.instance_methods - Object.instance_methods).each do |it|
      def_delegator :@layer, it
    end

    def define ...
      def_delegator :@layer, GlobalServices.define(...)
    end

    def setup
      @layer = Kredki.application!.window! show: false
    end

    def assert_png
      path = "#{Kredki.dir}/test/tmp/#{self.class}_#{name}.png"
      @layer.window.to_png path
      expected = File.expand_path "#{dir}/#{name}.png"
      of = File.new path, "rb"
      ef = File.new expected, "rb"
      loop do
        oc = of.readpartial(1024) rescue nil
        ec = ef.readpartial(1024) rescue nil
        return assert false if oc != ec
        return assert true if !oc
      end
    end
  end
end