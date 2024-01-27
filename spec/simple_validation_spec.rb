# frozen_string_literal: true

# simple_validation_spec.rb
#
# Created by Chirantan Mitra on 2012-11-20
# Copyright 2012-2024. All rights reserved
#
# See LICENSE for license

require_relative 'spec_helper'

require_relative '../lib/simple_validation'

class TestEntity
  include ::SimpleValidation
end

class TestEntityWithValidation
  include ::SimpleValidation

  attr_reader :always_valid_invoked_count, :always_invalid_invoked_count

  validate :always_valid
  validate :always_invalid

  def initialize
    @always_valid_invoked_count = 0
    @always_invalid_invoked_count = 0
  end

  def always_valid
    @always_valid_invoked_count += 1
  end

  def always_invalid
    @always_invalid_invoked_count += 1
    add_error('Always invalid')
  end
end

class TestEntityWithConditionalValidation
  include ::SimpleValidation

  attr_reader :statement_one_invoked_count, :statement_two_invoked_count, :statement_three_invoked_count

  validate :statement_one, if: [:always_true?]
  validate :statement_two, if: [:always_false?]
  validate :statement_three, if: %i[always_true? always_false?]

  def initialize
    @statement_one_invoked_count = 0
    @statement_two_invoked_count = 0
    @statement_three_invoked_count = 0
  end

  def statement_one
    @statement_one_invoked_count += 1
  end

  def statement_two
    @statement_two_invoked_count += 1
  end

  def statement_three
    @statement_three_invoked_count += 1
  end

  def always_true?
    true
  end

  def always_false?
    false
  end
end

describe 'A validatable entity' do
  describe 'with an error' do
    subject { ::TestEntity.new }
    before  { subject.add_error('An error') }

    it 'is invalid' do
      expect(subject.invalid?).must_equal(true)
    end

    it 'is not valid' do
      expect(subject.valid?).must_equal(false)
    end

    it 'exposes its errors' do
      expect(subject.errors).must_equal(['An error'])
    end
  end

  describe 'whithout any errors' do
    subject { ::TestEntity.new }

    it 'is not invalid' do
      expect(subject.invalid?).must_equal(false)
    end

    it 'is valid' do
      expect(subject.valid?).must_equal(true)
    end

    it 'exposes its errors as an empty array' do
      expect(subject.errors).must_equal([])
    end
  end

  describe 'with custom validation' do
    subject { ::TestEntityWithValidation.new }

    describe '#valid?' do
      before { subject.valid? }

      it 'invokes its validations' do
        expect(subject.always_valid_invoked_count).must_equal(1)
        expect(subject.always_invalid_invoked_count).must_equal(1)
      end

      it 'has errors added during validation' do
        expect(subject.errors).must_equal(['Always invalid'])
      end

      describe 'on another #valid?' do
        before { subject.valid? }

        it "doesn't duplicate its errors" do
          expect(subject.errors).must_equal(['Always invalid'])
        end

        it "doesn't re-run validation" do
          expect(subject.always_valid_invoked_count).must_equal(1)
          expect(subject.always_invalid_invoked_count).must_equal(1)
        end
      end
    end

    describe '#errors' do
      before { subject.errors }

      it 'invokes its validations' do
        expect(subject.always_valid_invoked_count).must_equal(1)
        expect(subject.always_invalid_invoked_count).must_equal(1)
      end

      it 'has errors added during validation' do
        expect(subject.errors).must_equal(['Always invalid'])
      end

      describe 'on another #error' do
        before { subject.errors }

        it "doesn't duplicate its errors" do
          expect(subject.errors).must_equal(['Always invalid'])
        end

        it "doesn't re-run validation" do
          expect(subject.always_valid_invoked_count).must_equal(1)
          expect(subject.always_invalid_invoked_count).must_equal(1)
        end
      end
    end
  end

  describe 'with conditional validation' do
    subject { ::TestEntityWithConditionalValidation.new }

    describe '#valid?' do
      before { subject.valid? }

      it 'invokes its validations that passes all conditions' do
        expect(subject.statement_one_invoked_count).must_equal(1)
      end

      it "doesn't invoke its validations that fail all conditions" do
        expect(subject.statement_two_invoked_count).must_equal(0)
      end

      it "doesn't invoke its validations that fail conditions partially" do
        expect(subject.statement_three_invoked_count).must_equal(0)
      end
    end
  end

  describe 'with already existing errors' do
    subject { ::TestEntityWithValidation.new }

    it "doesn't lose its older errors on validation" do
      subject.add_error('An error')
      expect(subject.errors.sort).must_equal(['An error', 'Always invalid'].sort)
    end

    it "doesn't duplicate errors" do
      subject.add_error('An error')
      subject.add_error('An error')
      expect(subject.errors.sort).must_equal(['Always invalid', 'An error'].sort)
    end
  end

  describe '#add_error' do
    subject { ::TestEntity.new }

    it 'can accept multiple errors' do
      subject.add_errors(['An error', 'Another error'])
      expect(subject.errors.sort).must_equal(['An error', 'Another error'].sort)
    end

    it "doesn't duplicate errors" do
      subject.add_errors(['An error', 'Another error'])
      subject.add_errors(['An error', 'Another error'])
      expect(subject.errors.sort).must_equal(['An error', 'Another error'].sort)
    end
  end
end
