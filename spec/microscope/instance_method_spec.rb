require 'spec_helper'

describe Microscope::InstanceMethod do
  describe :ClassMethods do
    describe :past_participle_to_infinitive do
      let(:past_participles) { ['liked', 'loved', 'gateway_canceled', 'started', 'fed'] }
      let(:infinitives) { ['like', 'love', 'gateway_cancel', 'start', 'feed'] }
      let(:mapped_past_participles) { past_participles.map { |v| Microscope::InstanceMethod.past_participle_to_infinitive(v) } }

      specify do
        expect(mapped_past_participles).to eql infinitives
      end
    end
  end
end
