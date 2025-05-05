#!/usr/bin/ruby

require 'fileutils'

# Path to the problematic file
file_path = '/Users/paraskashyap/Documents/GitHub/Budgee_App/ios/Pods/gRPC-Core/src/core/lib/promise/detail/basic_seq.h'

# Check if the file exists
if File.exist?(file_path)
  # Read the file content
  content = File.read(file_path)
  
  # Fix the template keyword issue by adding a space and additional template wrapper
  fixed_content = content.gsub(
    'Traits::template CheckResultAndRunNext<Wrapped>(',
    'Traits:: template CheckResultAndRunNext<Wrapped>('
  )
  
  # Write back the fixed content
  File.open(file_path, 'w') { |file| file.write(fixed_content) }
  
  puts "Successfully patched the template issue in basic_seq.h"
else
  puts "Error: Could not find the file at #{file_path}"
end