#
# config/constants.yml に定義した値を環境変数として読み込む.
#

file = "#{Rails.root}/config/constants.yml"

def deep_freeze(hash)

  hash.freeze.each_value do |i|
    i.kind_of?(Hash) ? deep_freeze(i) : i.freeze
  end

end

CONSTANT = deep_freeze(YAML.load_file(file)[Rails.env].deep_symbolize_keys)
