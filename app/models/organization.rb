class Organization < ApplicationRecord
  has_many :users, through: :user_organizations

  def dn(reverse: false, delimiter: ',')
    dns =  [
      [:C, self.country],
      [:ST, self.state],
      [:L, self.locality],
      [:O, self.organization],
      [:OU, self.unit]
    ].reject{|k, v| v.blank?}
    dns = dns.reverse if reverse
    dns.map{|k, v| '%s=%s' % [k, v]}.join(delimiter)
  end
end
