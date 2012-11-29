# simple_validation_spec.rb
#
# Created by Chirantan Mitra on 2012-11-20
# Copyright 2012.  All rights reserved
#
# See LICENSE for license

require File.expand_path("spec_helper", File.dirname(__FILE__))

require File.expand_path("../lib/simple_validation", File.dirname(__FILE__))

class TestEntity
  include SimpleValidation
end

class TestEntityWithValidation
  include SimpleValidation

  attr_reader :always_valid_invoked_count
  attr_reader :always_invalid_invoked_count

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
    add_error "Always invalid"
  end
end

class TestEntityWithConditionalValidation
  include SimpleValidation

  attr_reader :statement_one_invoked_count
  attr_reader :statement_two_invoked_count
  attr_reader :statement_three_invoked_count

  validate :statement_one, :if => [:condition_one?]
  validate :statement_two, :if => [:condition_two?]
  validate :statement_three, :if => [:condition_one?, :condition_two?]

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

  def condition_one?
    true
  end

  def condition_two?
    false
  end
end

describe "A validatable entity" do
  describe "with an error" do
    before do
      @entity = TestEntity.new
      @entity.add_error("An error")
    end

    it "is invalid" do
      @entity.invalid?.must_equal true
    end

    it "is not valid" do
      @entity.valid?.must_equal false
    end

    it "exposes its errors" do
      @entity.errors.must_equal ["An error"]
    end
  end

  describe "whithout any errors" do
    before do
      @entity = TestEntity.new
    end

    it "is not invalid" do
      @entity.invalid?.must_equal false
    end

    it "is valid" do
      @entity.valid?.must_equal true
    end

    it "exposes its errors as an empty array" do
      @entity.errors.must_equal []
    end
  end

  describe "with custom validation" do
    before do
      @entity = TestEntityWithValidation.new
    end

    describe "#valid?" do
      before do
        @entity.valid?
      end

      it "invokes its validations" do
        @entity.always_valid_invoked_count.must_equal 1
        @entity.always_invalid_invoked_count.must_equal 1
      end

      it "has errors added during validation" do
        @entity.errors.must_equal ["Always invalid"]
      end

      describe "on another #valid?" do
        before do
          @entity.valid?
        end

        it "doesn't duplicate its errors" do
          @entity.errors.must_equal ["Always invalid"]
        end

        it "doesn't re-run validation" do
          @entity.always_valid_invoked_count.must_equal 1
          @entity.always_invalid_invoked_count.must_equal 1
        end
      end
    end

    describe "#errors" do
      before do
        @entity.errors
      end

      it "invokes its validations" do
        @entity.always_valid_invoked_count.must_equal 1
        @entity.always_invalid_invoked_count.must_equal 1
      end

      it "has errors added during validation" do
        @entity.errors.must_equal ["Always invalid"]
      end

      describe "on another #error" do
        before do
          @entity.errors
        end

        it "doesn't duplicate its errors" do
          @entity.errors.must_equal ["Always invalid"]
        end

        it "doesn't re-run validation" do
          @entity.always_valid_invoked_count.must_equal 1
          @entity.always_invalid_invoked_count.must_equal 1
        end
      end
    end
  end

  describe "with conditional validation" do
    before do
      @entity = TestEntityWithConditionalValidation.new
    end

    describe "#valid?" do
      before do
        @entity.valid?
      end

      it "invokes its validations that passes all conditions" do
        @entity.statement_one_invoked_count.must_equal 1
      end

      it "doesn't invoke its validations that fail all conditions" do
        @entity.statement_two_invoked_count.must_equal 0
      end

      it "doesn't invoke its validations that fail conditions partially" do
        @entity.statement_three_invoked_count.must_equal 0
      end
    end
  end

  describe "with already existing errors" do
    it "doesn't lose its older errors on validation" do
      entity = TestEntityWithValidation.new
      entity.add_error("An error")
      entity.errors.sort.must_equal ["An error", "Always invalid"].sort
    end

    it "doesn't duplicate errors" do
      entity = TestEntityWithValidation.new
      entity.add_error("An error")
      entity.add_error("An error")
      entity.errors.sort.must_equal ["Always invalid", "An error"].sort
    end
  end

  describe "#add_error" do
    it "can accept multiple errors" do
      entity = TestEntity.new
      entity.add_errors(["An error", "Another error"])
      entity.errors.sort.must_equal ["An error", "Another error"].sort
    end

    it "doesn't duplicate errors" do
      entity = TestEntity.new
      entity.add_errors(["An error", "Another error"])
      entity.add_errors(["An error", "Another error"])
      entity.errors.sort.must_equal ["An error", "Another error"].sort
    end
  end
end
