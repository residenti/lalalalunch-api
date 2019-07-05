#
# config/constants.yml に定義した値を環境変数として読み込む.
#

file = "#{Rails.root}/config/settings.yml"

def deep_freeze(hash)

  hash.freeze.each_value do |i|
    i.kind_of?(Hash) ? deep_freeze(i) : i.freeze
  end

end

SETTINGS = deep_freeze(YAML.load_file(file)[Rails.env].deep_symbolize_keys)
