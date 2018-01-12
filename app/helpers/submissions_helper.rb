module SubmissionsHelper
  require 'open3'
  require 'benchmark'
  require 'time'

  def analyze_process(file_name, expected_result, *arguments)
    return_message = ''
    time = 0

    def execute_script(params)
      stdout, _, status = Open3.capture3(params)
      abort 'Error running script' unless status.to_s.split(' ').last == '0'

      stdout
    end

    case file_name.partition('.').last
      when /php/
        time = Benchmark.measure do
          return_message = execute_script "php #{file_name} #{arguments.join(' ')}"
        end
      when /c/
        time = Benchmark.measure do
          execute_script "gcc #{file_name} -o #{file_name.partition('.').first}"

          return_message = execute_script "#{file_name.partition('.').first} #{arguments.join(' ')}"

          execute_script "rm #{file_name.partition('.').first}"
        end
      when /java/
        time = Benchmark.measure do
          execute_script "javac #{file_name}"

          return_message = execute_script "java #{file_name.partition('.').first} #{arguments.join(' ')}"

          execute_script "rm #{file_name.partition('.').first}"
        end
      when /py/
        time = Benchmark.measure do
          return_message = execute_script "python #{file_name} #{arguments.join(' ')}"
        end
    end

    { elapsed_time: time.real, status: return_message.to_s == expected_result.to_s ? 'ok' : 'not ok' }
  end
end