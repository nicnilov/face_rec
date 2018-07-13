require 'highline/import'
require 'pry'

module Prepare
  def self.execute
    source_dir = request_source_directory
    image_index = request_image_index
    filenames = group_file_names(source_dir)
    known_dir = request_destination_known_directory
    unknown_dir = request_destination_unknown_directory
    populate_images(filenames, image_index, source_dir, known_dir, unknown_dir)
  end

  def self.request_source_directory
    ask('Source images directory: ') { |e| e.default = './face_train'}
  end

  def self.request_destination_known_directory
    ask('Known images directory: ') { |e| e.default = './fr_known'}
  end

  def self.request_destination_unknown_directory
    ask('Unknown images directory: ') { |e| e.default = './fr_unknown'}
  end

  def self.request_image_index
    ask('Training set image index: ') { |e| e.default = '0'}.to_i
  end

  def self.group_file_names(source_dir)
    Dir.glob(File.join(source_dir, '*.jpg'))
       .map { |e| File.basename(e, '.jpg') }
       .each_with_object(Hash.new { |h, k| h[k] = [] }) do |name, acc|
         parts = name.split('-')
         next unless parts.count == 2

         acc[parts.first] << parts.last
         acc
       end
       .each_value(&:sort!)
       .sort.to_h
  end

  def self.populate_images(filenames, image_index, source_dir, known_dir, unknown_dir)
    filenames.each do |label, entries|
      source_file = File.join(source_dir, "#{label}-#{entries[image_index]}.jpg")
      test_file = File.join(source_dir, "#{label}-t.jpg")
      known_file = File.join(known_dir, "#{label}.jpg")
      unknown_file = File.join(unknown_dir, "#{label}-t.jpg")
      FileUtils.cp(source_file, known_file)
      FileUtils.cp(test_file, unknown_file)
    end
  end
end

begin
  Prepare.execute
  say('Finished successfully')
rescue Interrupt => _
  say(' Interrupted, exiting')
rescue => error
  say("Exception: #{error.message}\n\n#{error.backtrace}")
end
