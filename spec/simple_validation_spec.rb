require_relative "spec_helper"

require_relative "../lib/simple_validation"

class TestEntity
  include SimpleValidation
end

class TestEntityWithValidation
  include SimpleValidation

  attr_reader :always_valid_invoked
  attr_reader :always_invalid_invoked

  validate :always_valid
  validate :always_invalid

  def initialize
    @always_valid_invoked = false
    @always_invalid_invoked = false
  end

  def always_valid
    @always_valid_invoked = true
  end

  def always_invalid
    @always_invalid_invoked = true
    add_error "Always invalid"
  end
end

describe "An entity that can be validated" do
  describe "when it has errors" do
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

    it "allows custom validation" do
      @entity.errors.must_equal ["An error"]
    end
  end

  describe "when it doesn't have any error" do
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

  describe "when it has a custom validation" do
    before do
      @entity = TestEntityWithValidation.new
    end

    describe "on validation" do
      before do
        @entity.valid?
      end

      it "invokes the validations" do
        @entity.always_valid_invoked.must_equal true
        @entity.always_invalid_invoked.must_equal true
      end

      it "has errors added during validation" do
        @entity.errors.must_equal ["Always invalid"]
      end
    end

    describe "with already existing errors" do
      it "doesn't lose its older errors on validation" do
        @entity = TestEntityWithValidation.new
        @entity.add_errors(["An error", "Another error"])
        @entity.valid?
        @entity.errors.must_equal ["An error", "Another error", "Always invalid"]
      end
    end

    describe "when double validated" do
      it "doesn't duplicate its errors" do
        @entity = TestEntityWithValidation.new
        @entity.valid?
        @entity.valid?
        @entity.errors.must_equal ["Always invalid"]
      end
    end
  end

  it "can be added an array of errors" do
    @entity = TestEntity.new
    @entity.add_errors(["An error", "Another error"])
    @entity.errors.must_equal ["An error", "Another error"]
  end
end
