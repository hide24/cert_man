class Certificate < ApplicationRecord
  belongs_to :host
  after_create :set_version

  def set_version
    Certificate.transaction do
      current_version = Certificate.where(host_id: self.host_id).maximum(:version) || 0
      self.version = current_version.succ
      self.save!
    end
  end
end
