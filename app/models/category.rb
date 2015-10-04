class Category < ActiveRecord::Base
  belongs_to :admin
  has_many :pages

  def created_by
    admin.email
  end
end
