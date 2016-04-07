class Shop < ActiveRecord::Base
	belongs_to :client

	alias_attribute :longitude, :y
	alias_attribute :latitude, :x	

	validates :title, :address, :phone, :client_id, :presence=>true
	validates :longitude, :numericality=>{:greater_than_or_equal_to=>-180, :less_than_or_equal_to=>180}, :allow_nil=>true
	validates :latitude, :numericality=>{:greater_than_or_equal_to=>-90, :less_than_or_equal_to=>90}, :allow_nil=>true

	def self.permit_params
		[:client_id,:title,:address,:phone,:x,:y,:longitude, :latitude]
	end
end
