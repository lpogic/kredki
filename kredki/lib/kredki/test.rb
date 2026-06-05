require_relative 'module'
require 'minitest/autorun'
require 'forwardable'

module Kredki
  class Test < Minitest::Test
    extend Forwardable

    (Pads::Layer.instance_methods - Object.instance_methods).each do |it|
      def_delegator :@layer, it
    end

    def setup
      @layer = Kredki.application.open hidden: true
    end

    def assert_png
      local_path = dir.delete_prefix("#{Kredki.dir}/test/").gsub("/", "__")
      path = "#{Kredki.dir}/test/output/#{local_path}__#{name}.png"
      @layer.window.to_png path
      expected = File.expand_path "#{dir}/#{name}.png"
      of = File.new path, "rb"
      ef = File.new expected, "rb"
      loop do
        oc = of.readpartial(1024) rescue nil
        ec = ef.readpartial(1024) rescue nil
        return assert false, "Output and expected output are not the same.\nOutput: #{path}\nExpected output: #{expected}" if oc != ec
        return assert true if !oc
      end
    end
  end
end

include Kredki
include Kredki::Pads