control "V-38694" do
  title "The operating system must manage information system identifiers for
users and devices by disabling the user identifier after an organization
defined time period of inactivity."
  desc  "Disabling inactive accounts ensures that accounts which may not have
been responsibly removed are not available to attackers who may have
compromised their credentials."
  impact 0.3
  tag "gtitle": "SRG-OS-000118"
  tag "gid": "V-38694"
  tag "rid": "SV-50495r1_rule"
  tag "stig_id": "RHEL-06-000335"
  tag "fix_id": "F-43643r2_fix"
  tag "cci": ["CCI-000795"]
  tag "nist": ["IA-4 e", "Rev_4"]
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
  tag "check": "To verify the \"INACTIVE\" setting, run the following command:

grep \"INACTIVE\" /etc/default/useradd

The output should indicate the \"INACTIVE\" configuration option is set to an
appropriate integer as shown in the example below:

# grep \"INACTIVE\" /etc/default/useradd
INACTIVE=35

If it does not, this is a finding."
  tag "fix": "To specify the number of days after a password expires (which
signifies inactivity) until an account is permanently disabled, add or correct
the following lines in \"/etc/default/useradd\", substituting \"[NUM_DAYS]\"
appropriately:

INACTIVE=[NUM_DAYS]

A value of 35 is recommended. If a password is currently on the verge of
expiration, then 35 days remain until the account is automatically disabled.
However, if the password will not expire for another 60 days, then 95 days
could elapse until the account would be automatically disabled. See the
\"useradd\" man page for more information. Determining the inactivity timeout
must be done with careful consideration of the length of a \"normal\" period of
inactivity for users in the particular environment. Setting the timeout too low
incurs support costs and also has the potential to impact availability of the
system to legitimate users."

  describe file("/etc/default/useradd") do
    its("content") { should match(/^\s*INACTIVE\s*=\s*(\d+)\s*$/) }
  end
  file("/etc/default/useradd").content.to_s.scan(/^\s*INACTIVE\s*=\s*(\d+)\s*$/).flatten.each do |entry|
    describe entry do
      it { should cmp <= 35 }
    end
  end
  file("/etc/default/useradd").content.to_s.scan(/^\s*INACTIVE\s*=\s*(\d+)\s*$/).flatten.each do |entry|
    describe entry do
      it { should cmp > -1 }
    end
  end
end

