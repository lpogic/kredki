require_relative '../lib/kredki/core/has_flags'

RSpec.describe Kredki::HasFlags do
  let :klass do
    Class.new do
      extend Kredki::HasFlags

      flag :simple
      flag :true_on_empty, nil: true
      flag :backed, set: :set_backed, get: :get_backed

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

    expect(k.true_on_empty?).to eq true
    expect(k.true_on_empty!).to eq false
    expect(k.true_on_empty! false).to eq true
    expect(k.true_on_empty?).to eq false
    
    k.backed = true
    expect(k.backed?).to eq true
  end
end
