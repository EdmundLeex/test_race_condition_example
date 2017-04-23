require 'rails_helper'

RSpec.describe User, type: :model do
  describe '::create' do
    it 'requires email' do
      expect { User.create! }.to raise_error ActiveRecord::RecordInvalid
    end

    context 'signle threaded' do
      it "doesn't allow duplicate email" do
        User.create!(email: 'foobar@example.com')
        expect { User.create!(email: 'foobar@example.com') }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'multi-threaded' do
      it "doesn't run into race condition" do
        expect(ActiveRecord::Base.connection.pool.size).to eq(5)
        wait_for_all_threads = true

        mutex = Mutex.new

        threads = 4.times.map do
          Thread.new do
            true while wait_for_all_threads

            User.create(email: 'foobar@example.com')
          end
        end

        wait_for_all_threads = false
        threads.each(&:join)

        binding.pry
      end
    end
  end
end
