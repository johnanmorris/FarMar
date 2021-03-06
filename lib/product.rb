module FarMar
	class Product
		attr_reader :id, :name, :vendor_id

		def initialize(product_hash)
			@id = product_hash[:id]
			@name = product_hash[:name]
			@vendor_id = product_hash[:vendor_id]
		end

		def self.all
			products = []
			CSV.read("/Users/johnamorris/ada/project-forks/FarMar/support/products.csv").each do |line|
				info_hash = {}
				info_hash[:id] = line[0].to_i
				info_hash[:name] = line[1]
				info_hash[:vendor_id] = line[2].to_i
				product = FarMar::Product.new(info_hash)
				products << product
			end
			return products
		end

		def self.find(id)
			raise ArgumentError.new("Invalid ID") if !id.is_a?(Fixnum)
			products = self.all
			products.each do |product|
				if product.id == id
					return product
				end
			end
			return nil
		end

		def vendor
			all_vendors = FarMar::Vendor.all
			all_vendors.each do |vendor|
				if vendor.id == vendor_id
					return vendor
				end
			end
		end

		def sales
			FarMar::Sale.all.select {|sale| sale.product_id == id}
		end

		def number_of_sales
			sales_list = sales
			return sales_list.length
		end

		def self.by_vendor(vendor_id)
			FarMar::Product.all.select { |product| product.vendor_id == vendor_id}
		end
	end
end
