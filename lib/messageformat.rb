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

    attr_reader :locale, :messages, :context

    def initialize(locale, messages)
      @locale = locale
      @messages = messages
      @context = init_context
    end

    def compile
      context.call("compileMessageFormat", locale, messages)
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
            function compileMessageFormat(locale, messages) {
              const mf = new MessageFormat(locale);
              return compileModule(mf, messages);
            }
          JS
        end
    end
  end
end
