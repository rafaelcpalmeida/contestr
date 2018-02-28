module SubmissionsHelper
  require 'open3'
  require 'benchmark'
  require 'time'

  def analyze_process(submission, file_path, file_name, expected_result, *arguments)
    return_message = ''
    time = 0
    file_name = "#{file_path}#{file_name}"

    execute_script = lambda { |params|
      stdout, _, status = Open3.capture3(params)
      if status.to_s.split(' ').last != '0'
        evaluation = Evaluation.find_by(project_id: submission.project_id,
                                        user_id: submission.user_id)
        if evaluation.nil?
          Evaluation.new(project_id: submission.project_id,
                         user_id: submission.user_id,
                         build_result: 'error',
                         run_result: '',
                         execution_time: '0').save
        else
          Evaluation.update(evaluation.id,
                            maintainability: '',
                            security: '',
                            reliability: '',
                            language: '',
                            build_result: 'error',
                            run_result: '',
                            execution_time: '0')
        end
        Thread.exit
      end
      stdout
    }

    language = nil

    case file_name.partition('.').last
    when /php/
      time = Benchmark.measure do
        return_message = execute_script.call "php #{file_name} #{arguments.join(' ')}"
      end
      language = 'php'
    when /c/
      time = Benchmark.measure do
        execute_script.call "gcc #{file_name} -o #{file_name.partition('.').first}"

        return_message = execute_script.call "#{file_name.partition('.').first} #{arguments.join(' ')}"

        execute_script.call "rm #{file_name.partition('.').first}"
      end
      language = 'c'
    when /java/
      time = Benchmark.measure do
        execute_script.call "javac #{file_name}"

        return_message = execute_script.call "java #{file_name.partition('.').first} #{arguments.join(' ')}"

        execute_script.call "rm #{file_name.partition('.').first}"
      end
      language = 'java'
    when /py/
      time = Benchmark.measure do
        return_message = execute_script.call "python #{file_name} #{arguments.join(' ')}"
      end
      language = 'python'
    end

    name = file_name.gsub file_path, ''
    text_file_contents = "sonar.projectKey=#{submission.project_id}:#{submission.user_id}\nsonar.projectName=#{submission.project_id}:#{submission.user_id}\nsonar.projectVersion=1.0\nsonar.sources=#{name}"

    File.open("#{file_path}sonar-project.properties", 'w') { |file| file.write(text_file_contents) }

    system("cd #{file_path} && sonar-scanner")

    Sonar.table_name = 'projects'
    project = Sonar.find_by(kee: "#{submission.project_id}:#{submission.user_id}:#{name}")
    if project.nil?
      project = Sonar.find_by(kee: "#{submission.project_id}:#{submission.user_id}")
    end

    Sonar.table_name = 'project_measures'
    analysis = Sonar.where(component_uuid: project.uuid).order(id: :desc)

    maintainability = Sonar.find_by(analysis_uuid: analysis[0].analysis_uuid, metric_id: 121)
    security = Sonar.find_by(analysis_uuid: analysis[0].analysis_uuid, metric_id: 133)
    reliability = Sonar.find_by(analysis_uuid: analysis[0].analysis_uuid, metric_id: 129)

    evaluation = Evaluation.find_by(project_id: submission.project_id, user_id: submission.user_id)

    if evaluation.nil?
      Evaluation.new(project_id: submission.project_id,
                     user_id: submission.user_id,
                     maintainability: maintainability.text_value,
                     security: security.text_value,
                     reliability: reliability.text_value,
                     language: language,
                     build_result: 'ok',
                     run_result: return_message.to_s,
                     execution_time: time.real).save
    else
      Evaluation.update(evaluation.id,
                        maintainability: maintainability.text_value,
                        security: security.text_value,
                        reliability: reliability.text_value,
                        language: language,
                        build_result: 'ok',
                        run_result: return_message.to_s,
                        execution_time: time.real)
    end
    puts 'Thread ends'
    Thread.exit
  end
end
