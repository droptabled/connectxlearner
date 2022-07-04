# frozen_string_literal: true

require 'nmatrix'

class TransferLayer < ApplicationRecord
  belongs_to :bot

  # Overwrite inspect on transfer_layer to not show the giant layer matrix
  def inspect
    inspection = self.class.attribute_names.map do |name|
      case name
      when "layer_matrix"
        layer = layer_matrix
        dim_str = ""
        while layer.instance_of?(Array)
          dim_str += "[#{layer.size}]"
          layer = layer[0]
        end
        "#{name}: #{layer_matrix.class}" + dim_str
      else
        "#{name}: #{attribute_for_inspect(name)}"
      end
    end.compact.join(", ")

    "#<#{self.class} #{inspection}>"
  end

  def node_array
    @node_array ||= NMatrix.new([row_count, col_count], layer_matrix)
  end
end
