#!/usr/bin/env ruby

require 'tmpdir'
require 'dotenv'

Dotenv.load

dir = Dir.mktmpdir("temporary")
Dir.chdir "#{dir}"
`git clone https://#{ENV['GITHUB_ACCESS_TOKEN']}:x-oauth-basic@github.com/mikekavouras/glowb-certs.git certs_repo`
Dir.chdir "certs_repo"

branch = 'master'
app_identifier = ENV['APP_IDENTIFIER']

puts "Checking out #{branch} branch"
`git checkout #{branch}`

puts "Decrypting repo 🌬"
`./decrypt.rb "#{ENV['MATCH_PASSWORD']}"`

puts "Downloading profile 🌬"
system("sigh --force --development -u #{ENV['APPLE_USERNAME']} -a #{app_identifier}", out: $stdout, err: :out)

file = Dir[File.join(".", "*.mobileprovision")].first
`mv #{file} profiles/development/`

puts "Encrypting repo 🌬"
`./encrypt.rb "#{ENV['MATCH_PASSWORD']}"`
`git commit -am "update profiles and certs"`
`git push origin #{branch}`
