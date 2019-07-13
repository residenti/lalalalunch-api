module HttpRequest
  extend ActiveSupport::Concern # extendは必須.

  require 'net/https'

  GNAVI_API_PARAMS = {
    KEYID: SECRET_SETTINGS[:gnavi_keyid],
    HIT_PER_PAGE: 100,
    INPUT_COORDINATES_MODE: 1,
    LUNCH: 1
  }.freeze

  def get_request(latitude, longitude, range, late_lunch)
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード.
    params = URI.encode_www_form(
      {
        keyid: GNAVI_API_PARAMS[:KEYID],
        hit_per_page: GNAVI_API_PARAMS[:HIT_PER_PAGE],
        input_coordinates_mode: GNAVI_API_PARAMS[:INPUT_COORDINATES_MODE],
        lunch: GNAVI_API_PARAMS[:LUNCH],
        latitude: latitude,
        longitude: longitude,
        range: range,
        late_lunch: late_lunch
      }
    )

    uri = URI.parse(File.join(SETTINGS[:base_url], "?#{params}")) # URIを解析し、hostやportをバラバラに取得できるようにする

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true # https通信を許可.
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # 証明書の検証を行わない.

    http.get(uri.request_uri)
  end

end
