require 'spec_helper'
require 'command_kit/inflector'

describe CommandKit::Inflector do
  describe ".demodularize" do
    context "when given a single class or module name" do
      let(:name) { 'Foo' }

      it "must return the class or module name unchanged" do
        expect(subject.demodularize(name)).to eq(name)
      end
    end

    context "when given a class or module name with a leading namespace" do
      let(:namespace) { 'Foo::Bar' }
      let(:constant)  { "Baz" }
      let(:name) { "#{namespace}::#{constant}" }

      it "must return the constant name, without the leading namespace" do
        expect(subject.demodularize(name)).to eq(constant)
      end
    end

    context "when given a non-String" do
      it "must convert it to a String" do
        expect(subject.demodularize(:"Foo::Bar")).to eq('Bar')
      end
    end
  end

  describe ".underscore" do
    it "must convert CamelCase to camel_case" do
      expect(subject.underscore('CamelCase')).to eq('camel_case')
    end

    it "must convert camelCase to camel_case" do
      expect(subject.underscore('camelCase')).to eq('camel_case')
    end

    it "must convert Camel to camel" do
      expect(subject.underscore('Camel')).to eq('camel')
    end

    it "must convert CAMEL to camel" do
      expect(subject.underscore('CAMEL')).to eq('camel')
    end

    context "when given a String containing '/' characters" do
      it "must replace dashes with underscores" do
        expect(subject.underscore('foo-bar')).to eq('foo_bar')
      end
    end

    context "when given a non-String" do
      it "must convert it to a String" do
        expect(subject.underscore(:CamelCase)).to eq('camel_case')
      end
    end
  end

  describe ".dasherize" do
    it "must replace all underscores with dashes" do
      expect(subject.dasherize("foo_bar")).to eq('foo-bar')
    end

    context "when given a non-String" do
      it "must convert it to a String" do
        expect(subject.dasherize(:foo_bar)).to eq('foo-bar')
      end
    end
  end

  describe ".camelize" do
    context "when given a string with no underscores" do
      it "must capitalize the string" do
        expect(subject.camelize('foo')).to eq('Foo')
      end
    end

    context "when given a string with underscores" do
      it "must capitalize each word and remove all underscores" do
        expect(subject.camelize('foo_bar')).to eq('FooBar')
      end
    end

    context "when given a string with dashes" do
      it "must capitalize each word and remove all dashes" do
        expect(subject.camelize('foo-bar')).to eq('FooBar')
      end
    end

    context "when given a string containing '/' characters" do
      it "must replace the '/' characters with '::' strings" do
        expect(subject.camelize('foo_bar/baz_quox')).to eq('FooBar::BazQuox')
      end
    end

    context "when given a non-String" do
      it "must convert it to a String" do
        expect(subject.camelize(:foo_bar)).to eq('FooBar')
      end
    end
  end
end
