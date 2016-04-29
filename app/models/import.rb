class Import < ActiveRecord::Base
  belongs_to :importable, :polymorphic=>true

  validates :file, :presence=>true
  validates :client_id, :presence=>true

  belongs_to :client
  belongs_to :group

  has_attached_file :file, default_url: "/excel/:style/missing.xlsx"
  validates_attachment_content_type :file, :content_type => ["application/vnd.ms-excel",     
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]

  # after_create do |record|
  # 	record.run
  # end

  def run
    if !self.file.blank?
      xlsx = Roo::Excelx.new(self.file.path)

      xlsx.to_a.collect {|i|i[0]}.each do |phone|
        if group
          cm = group.group_members.where(:phone=>phone).first || group.group_members.build(:phone=>phone)
          cm.started_at = DateTime.now
          cm.ended_at = DateTime.now + 1.year
          cm.client_id = client_id
          cm.save
        end
      end
    else
      return []
    end
  end
end
