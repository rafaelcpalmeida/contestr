module SubmissionsHelper
  require 'open3'
  require 'benchmark'
  require 'time'

  def analyze_process(file_name, expected_result, *arguments)
    return_message = ''
    time = 0

    execute_script = lambda { |params|
      stdout, _, status = Open3.capture3(params)
      abort 'Error running script' unless status.to_s.split(' ').last == '0'

      stdout
    }

    case file_name.partition('.').last
    when /php/
      time = Benchmark.measure do
        return_message = execute_script.call "php #{file_name} #{arguments.join(' ')}"
      end
    when /c/
      time = Benchmark.measure do
        execute_script.call "gcc #{file_name} -o #{file_name.partition('.').first}"

        return_message = execute_script.call "#{file_name.partition('.').first} #{arguments.join(' ')}"

        execute_script.call "rm #{file_name.partition('.').first}"
      end
    when /java/
      time = Benchmark.measure do
        execute_script.call "javac #{file_name}"

        return_message = execute_script.call "java #{file_name.partition('.').first} #{arguments.join(' ')}"

        execute_script.call "rm #{file_name.partition('.').first}"
      end
    when /py/
      time = Benchmark.measure do
        return_message = execute_script.call "python #{file_name} #{arguments.join(' ')}"
      end
    end

    { elapsed_time: time.real, status: return_message.to_s == expected_result.to_s ? 'ok' : 'not ok' }
  end
end
