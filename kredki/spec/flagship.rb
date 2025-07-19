require_relative '../lib/kredki-core/flagship'

RSpec.describe Kredki::Flagship do
  let :klass do
    Class.new do
      extend Kredki::Flagship

      def_flag :simple
      def_flag :nil_raised, nil: true
      def_flag :backed, set: :set_backed, get: :get_backed

      def set_backed enable
        @external_backed = true
      end

      def get_backed
        @external_backed
      end
    end
  end

  it do

    k = klass.new
    expect(k.simple?).to eq false
    expect(k.simple!).to eq true
    expect(k.simple?).to eq true
    k.simple = :~
    expect(k.simple?).to eq false

    expect(k.nil_raised?).to eq true
    expect(k.nil_raised!).to eq false
    expect(k.nil_raised! false).to eq true
    expect(k.nil_raised?).to eq false
    
    k.backed = true
    expect(k.backed?).to eq true
  end
end
