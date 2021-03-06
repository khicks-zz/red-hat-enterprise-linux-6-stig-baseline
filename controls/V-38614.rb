control "V-38614" do
  title "The SSH daemon must not allow authentication using an empty password."
  desc  "Configuring this setting for the SSH daemon provides additional
assurance that remote login via SSH will require a password, even in the event
of misconfiguration elsewhere."
  impact 0.7
  tag "gtitle": "SRG-OS-000106"
  tag "gid": "V-38614"
  tag "rid": "SV-50415r1_rule"
  tag "stig_id": "RHEL-06-000239"
  tag "fix_id": "F-43562r1_fix"
  tag "cci": ["CCI-000766"]
  tag "nist": ["IA-2 (2)", "Rev_4"]
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
  tag "check": "To determine how the SSH daemon's \"PermitEmptyPasswords\"
option is set, run the following command:

# grep -i PermitEmptyPasswords /etc/ssh/sshd_config

If no line, a commented line, or a line indicating the value \"no\" is
returned, then the required value is set.
If the required value is not set, this is a finding."
  tag "fix": "To explicitly disallow remote login from accounts with empty
passwords, add or correct the following line in \"/etc/ssh/sshd_config\":

PermitEmptyPasswords no

Any accounts with empty passwords should be disabled immediately, and PAM
configuration should prevent users from being able to assign themselves empty
passwords."

  describe sshd_config do
    its('PermitEmptyPasswords') { should (eq 'no').or be_nil }
  end
end

