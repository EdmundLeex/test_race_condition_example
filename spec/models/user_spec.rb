require 'rails_helper'

RSpec.describe User, type: :model do
  describe '::create' do
    it 'requires email' do
      expect { User.create! }.to raise_error ActiveRecord::RecordInvalid
    end

    context 'single threaded' do
      it "doesn't allow duplicate email" do
        User.create!(email: 'foobar@example.com')
        expect { User.create!(email: 'foobar@example.com') }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'multi-threaded' do
      it "doesn't run into race condition" do
        expect(ActiveRecord::Base.connection.pool.size).to eq(5)

        wait_for_threads = true

        threads = 4.times.map do
          Thread.new do
            begin
              true while wait_for_threads

              User.create(email: 'foobar@example.com')
            rescue ActiveRecord::RecordNotUnique => e
              # no op
            end
          end
        end
        wait_for_threads = false
        threads.each(&:join)

        expect(User.count).to eq 1
      end
    end
  end
end
