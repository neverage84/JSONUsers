class User < ApplicationRecord
  belongs_to :address
  belongs_to :company

  def company_name
    company.name
  end
end
