#
# config/constants.yml に定義した値を環境変数として読み込む.
#

settings_yml = File.join(Rails.root, "/config/settings.yml")
secret_settings_yml = File.join(Rails.root, "/config/secret_settings.yml")

def deep_freeze(hash)

  hash.freeze.each_value do |i|
    i.kind_of?(Hash) ? deep_freeze(i) : i.freeze
  end

end

SETTINGS = deep_freeze(YAML.load_file(settings_yml)[Rails.env].deep_symbolize_keys)
SECRET_SETTINGS = deep_freeze(YAML.load_file(secret_settings_yml)[Rails.env].deep_symbolize_keys)
