require 'fileutils'
class Log
  def initialize(file)
    @file = file.to_s
    dir = @file.split('/')[0...-1].join('/')
    FileUtils.mkpath(dir)
  end

  def truncate
    File.open(@file, 'w') {|f| f.truncate(0) }
  end

  def write(line)
    File.open(@file, 'a') {|f| f.puts(line) }
  end

  def write_exception(exception, backtrace: true, title: nil)
    write(title) if title
    write(exception.message)
    exception.backtrace.each{|line| write line} if backtrace
  end
end
