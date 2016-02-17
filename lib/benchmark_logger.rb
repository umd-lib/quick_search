BenchmarkLogger = ActiveSupport::Logger.new(Rails.root.join('log/benchmark.log'))
BenchmarkLogger.formatter = Logger::Formatter.new
