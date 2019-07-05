module HttpRequest
  extend ActiveSupport::Concern # extendは必須.

  require 'net/https'

  def get_request(latitude, longitude, range, late_lunch)
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    params = URI.encode_www_form(
      {
        keyid: SECRET_SETTINGS[:gnavi_keyid],
        hit_per_page: 1,
        input_coordinates_mode: 1,
        lunch: 1,
        latitude: latitude,
        longitude: longitude,
        range: range,
        late_lunch: late_lunch
      }
    )

    uri = URI.parse(File.join(SETTINGS[:base_url], "?#{params}")) # URIを解析し、hostやportをバラバラに取得できるようにする

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true # https通信を許可.
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # 証明書なんたらかんたら...

    http.get(uri.request_uri)
  end

end
