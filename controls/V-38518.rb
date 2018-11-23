control 'V-38518' do
  title 'All rsyslog-generated log files must be owned by root.'
  desc  "The log files generated by rsyslog contain valuable information
regarding system configuration, user authentication, and other such
information. Log files should be protected from unauthorized access."
  impact 0.5
  tag "gtitle": 'SRG-OS-000206'
  tag "gid": 'V-38518'
  tag "rid": 'SV-50319r2_rule'
  tag "stig_id": 'RHEL-06-000133'
  tag "fix_id": 'F-43465r1_fix'
  tag "cci": ['CCI-001314']
  tag "nist": ['SI-11 b', 'Rev_4']
  tag "false_negatives": nil
  tag "false_positives": nil
  tag "documentable": false
  tag "mitigations": nil
  tag "severity_override_guidance": false
  tag "potential_impacts": nil
  tag "third_party_tools": nil
  tag "mitigation_controls": nil
  tag "responsibility": nil
  tag "ia_controls": nil
  tag "check": "The owner of all log files written by \"rsyslog\" should be
root. These log files are determined by the second part of each Rule line in
\"/etc/rsyslog.conf\" and typically all appear in \"/var/log\". To see the
owner of a given log file, run the following command:

$ ls -l [LOGFILE]

Some log files referenced in /etc/rsyslog.conf may be created by other programs
and may require exclusion from consideration.

If the owner is not root, this is a finding. "
  tag "fix": "The owner of all log files written by \"rsyslog\" should be root.
These log files are determined by the second part of each Rule line in
\"/etc/rsyslog.conf\" typically all appear in \"/var/log\". For each log file
[LOGFILE] referenced in \"/etc/rsyslog.conf\", run the following command to
inspect the file's owner:

$ ls -l [LOGFILE]

If the owner is not \"root\", run the following command to correct this:

# chown root [LOGFILE]"

  # strip comments, empty lines, and lines which start with $ in order to get rules
  rules = file('/etc/rsyslog.conf').content.lines.map do |l|
    pound_index = l.index('#')
    l = l.slice(0, pound_index) unless pound_index.nil?
    l.strip
  end.reject { |l| l.empty? || l.start_with?('$') }

  paths = rules.map do |r|
    _filter, action = r.split(/\s+/)
    next unless action.start_with? '-/', '/'

    action.sub(%r{^-/}, '/')
  end.reject(&:nil?)

  if paths.empty?
    describe 'rsyslog log files' do
      subject { paths }
      it { should be_empty }
    end
  else
    paths.each do |path|
      describe file(path) do
        its('owner') { should eq 'root' }
      end
    end
  end
end
