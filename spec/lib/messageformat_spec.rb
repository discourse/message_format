# frozen_string_literal: true

require "spec_helper"

describe MessageFormat do
  describe ".compile" do
    subject { MessageFormat.compile(locale, messages, strict:) }

    let(:strict) { true }
    let(:locale) { "en" }
    let(:messages) do
      {
        a: "A {TYPE} example.",
        b: "This has {COUNT, plural, one{one member} other{# members}}.",
        c: "We have {P, number, percent} code coverage.",
      }
    end
    let(:expected_output) { <<~JS.chomp }
      import { number, plural } from "@messageformat/runtime";
      import { en } from "@messageformat/runtime/lib/cardinals";
      import { numberPercent } from "@messageformat/runtime/lib/formatters";
      export default {
        a: (d) => "A " + d.TYPE + " example.",
        b: (d) => "This has " + plural(d.COUNT, 0, en, { one: "one member", other: number("en", d.COUNT, 0) + " members" }) + ".",
        c: (d) => "We have " + numberPercent(d.P, "en") + " code coverage."
      }
    JS

    it "compiles messages properly" do
      expect(subject).must_equal expected_output
    end

    describe "when the messages are invalid" do
      let(:messages) { "{invalid:" }

      it "raises an error" do
        expect { subject }.must_raise MessageFormat::Compiler::CompileError
      end
    end

    describe "when using multiple locales" do
      let(:locale) { %w[de en] }
      let(:messages) do
        {
          de: {
            a: "A {TYPE} example.",
            b: "This has {COUNT, plural, one{one member} other{# members}}.",
          },
          en: {
            a: "A {TYPE} example.",
            b: "This has {COUNT, plural, one{one member} other{# members}}.",
          },
        }
      end
      let(:expected_output) { <<~JS.chomp }
        import { number, plural } from "@messageformat/runtime";
        import { de, en } from "@messageformat/runtime/lib/cardinals";
        export default {
          de: {
            a: (d) => "A " + d.TYPE + " example.",
            b: (d) => "This has " + plural(d.COUNT, 0, de, { one: "one member", other: number("de", d.COUNT, 0) + " members" }) + "."
          },
          en: {
            a: (d) => "A " + d.TYPE + " example.",
            b: (d) => "This has " + plural(d.COUNT, 0, en, { one: "one member", other: number("en", d.COUNT, 0) + " members" }) + "."
          }
        }
      JS

      it "compiles messages properly" do
        expect(subject).must_equal expected_output
      end
    end

    describe "when messages contain invalid rules" do
      let(:messages) do
        {
          a: "A {TYPE} example.",
          b: "This has {COUNT, plural, one{one member} many{# members} other{# members}}.",
          c: "We have {P, number, percent} code coverage.",
        }
      end

      describe "when in strict mode" do
        it "raises an error" do
          expect { subject }.must_raise MessageFormat::Compiler::CompileError
        end
      end

      describe "when not in strict mode" do
        let(:strict) { false }
        let(:expected_output) { <<~JS.chomp }
          import { number, plural } from "@messageformat/runtime";
          import { en } from "@messageformat/runtime/lib/cardinals";
          import { numberPercent } from "@messageformat/runtime/lib/formatters";
          export default {
            a: (d) => "A " + d.TYPE + " example.",
            b: (d) => "This has " + plural(d.COUNT, 0, en, { one: "one member", many: number("en", d.COUNT, 0) + " members", other: number("en", d.COUNT, 0) + " members" }) + ".",
            c: (d) => "We have " + numberPercent(d.P, "en") + " code coverage."
          }
        JS

        it "compiles messages properly" do
          expect(subject).must_equal expected_output
        end
      end
    end
  end
end
