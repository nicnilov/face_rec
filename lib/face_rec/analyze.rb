require 'highline/import'
require 'pry'

module Analyze
  def self.execute
    fr_output = request_fr_output_file
    map = analyze(fr_output)
    report(map)
  end

  def self.request_fr_output_file
    ask('Face recognition output csv: ') { |e| e.default = './output/fr_results_0.csv' }
  end

  def self.analyze(filename)
    File
      .readlines(filename)
      .each_with_object(Hash.new { |h, k| h[k] = [] }) do |line, acc|
        fields = line.strip.split(',')
        next unless fields.count == 3

        label = File.basename(fields[0], '.jpg').split('-').first
        acc[label.to_i] << [fields[1].to_i, fields[2].to_f]
        acc
      end
  end

  def self.report(map)
    outcome =
      map
      .each { |k, v| map[k] = v.sort_by(&:last) }
      .each_with_object(Hash.new { |h, k| h[k] = 0 }) do |(k, v), acc|
        acc[k == v[0][0] ? :correct : :incorrect] += 1
      end

    total = outcome[:correct].to_i + outcome[:incorrect].to_i
    accuracy = outcome[:correct].to_f / total

    say "Of #{total} total #{outcome[:correct]} correct matches and #{outcome[:incorrect]} incorrect"
    say "Accuracy is #{accuracy}"
  end
end

begin
  Analyze.execute
  say('Finished successfully')
rescue Interrupt => _
  say(' Interrupted, exiting')
rescue => error
  say("Exception: #{error.message}\n\n#{error.backtrace}")
end
