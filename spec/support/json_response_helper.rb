# Quick and dirty helpers for specs dealing with JSON responses
module JSONResponseHelper
  def json
    @json ||= JSON.load(response.body)
  end

  def graph
    json['data']
  end
end
