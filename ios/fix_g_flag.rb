#!/usr/bin/ruby

require 'xcodeproj'

def find_pods_project
  pods_proj_path = '/Users/paraskashyap/Documents/GitHub/Budgee_App/ios/Pods/Pods.xcodeproj'
  
  unless File.exist?(pods_proj_path)
    puts "Error: Could not find Pods project at #{pods_proj_path}"
    exit 1
  end
  
  return pods_proj_path
end

def fix_g_flag_issues(pods_proj_path)
  project = Xcodeproj::Project.open(pods_proj_path)
  modified = false
  
  project.targets.each do |target|
    if target.name == 'gRPC-Core' || target.name == 'BoringSSL-GRPC'
      puts "Processing target: #{target.name}"
      
      target.build_configurations.each do |config|
        # Fix OTHER_LDFLAGS
        if config.build_settings['OTHER_LDFLAGS']
          original_flags = config.build_settings['OTHER_LDFLAGS']
          cleaned_flags = original_flags.reject { |flag| flag.to_s.start_with?('-G') }
          
          if original_flags.length != cleaned_flags.length
            config.build_settings['OTHER_LDFLAGS'] = cleaned_flags
            modified = true
            puts "  Fixed OTHER_LDFLAGS in #{config.name} configuration"
          end
        end
        
        # Fix OTHER_CFLAGS
        if config.build_settings['OTHER_CFLAGS']
          original_flags = config.build_settings['OTHER_CFLAGS']
          cleaned_flags = original_flags.reject { |flag| flag.to_s.start_with?('-G') }
          
          if original_flags.length != cleaned_flags.length
            config.build_settings['OTHER_CFLAGS'] = cleaned_flags
            modified = true
            puts "  Fixed OTHER_CFLAGS in #{config.name} configuration"
          end
        end
      end
    end
  end
  
  if modified
    project.save
    puts "Successfully fixed '-G' flag issues in #{pods_proj_path}"
  else
    puts "No '-G' flag issues found in the project."
  end
end

# Install xcodeproj gem if not already installed
system("gem list -i xcodeproj || sudo gem install xcodeproj")

pods_proj_path = find_pods_project
fix_g_flag_issues(pods_proj_path)