# frozen_string_literal: true

require_relative "messageformat/version"
require "mini_racer"

module MessageFormat
  def self.compile(...)
    Compiler.new(...).compile
  end

  class Compiler
    class CompileError < StandardError
    end

    attr_reader :locale, :messages, :context, :strict

    def initialize(locale, messages, strict: true)
      @locale = locale
      @messages = messages
      @strict = strict
      @context = init_context
    end

    def compile
      context.call("compileMessageFormat", locale, messages, strict)
    rescue MiniRacer::RuntimeError => e
      raise CompileError.new(cause: e)
    end

    private

    def init_context
      MiniRacer::Context
        .new(timeout: 10_000)
        .tap do |context|
          context.load(File.expand_path("../dist/messageformat.js", __dir__))
          context.load(File.expand_path("../dist/compilemodule.js", __dir__))
          context.eval(<<~JS)
            function compileMessageFormat(locale, messages, strict) {
              const mf = new MessageFormat(locale, { strictPluralKeys: strict });
              return compileModule(mf, messages);
            }
          JS
        end
    end
  end
end
