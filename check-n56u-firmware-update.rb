#!/usr/bin/env ruby
# title:  check-n56u-firmware-update.rb
# descr:  check padavan's rt-n56u firmware for the latest version
# author: andrew o'neill
# date:   2016

require 'json'
require 'net/http'
require 'net/smtp'

# Configuration parameters. Change these before execution
@filename = '/var/tmp/n56u_timestamp'
@url = 'https://api.bitbucket.org/2.0/repositories/padavan/rt-n56u/downloads?pagelen=30'
@smtp_server = ''
@smtp_port = ''
@permit_domain = ''
@smtp_user = ''
@smtp_pass = ''
@rcpt_addr = ''
@from_addr = ''

# Method for getting latest RT-N56U firmware file name and timestamp
def getdlinfo
  name, dl_date = nil

  uri = URI.parse(@url)
  downloads = JSON.parse(Net::HTTP.get(uri))
  
  downloads['values'].each do |x|
    if x['name'] =~ /RT-N56U_.*_base.trx/
      name = x['name']
      dl_date = x['created_on']
    end
  end
  
  return name, dl_date
end

# Go ahead and get filename and upload date
name, dl_date = getdlinfo

# Method for sending out the email notification
def sendnotify(name, dl_date)
msgstr = <<END_OF_MESSAGE
From: #{@from_addr}
To: #{@rcpt_addr}
Subject: RT-N56U Firmware Update

Firmware release: #{name}
Timestamp: #{dl_date}
END_OF_MESSAGE

  puts "Update found! Sending notification..."

  Net::SMTP.start(@smtp_server, @smtp_port, 
  @permit_domain, @smtp_user, 
  @smtp_pass, :plain) do |smtp|
    smtp.send_message msgstr, @from_addr, @rcpt_addr
  end
end

# Create the timestamp file if it doesn't already exist
if ! File.file?(@filename)
  puts "#{@filename} doesn't exist, creating it and exiting."
  ts_file = File.new(@filename,'w+') 
  ts_file.write(dl_date)
  ts_file.close
  exit 0
end

# Check the current release against what we've been checking against (local file with tstamp)
ts_file = File.open(@filename)
old_date = ts_file.read
ts_file.close
if old_date == dl_date
  puts "No update"
else
  sendnotify(name, dl_date)
end
