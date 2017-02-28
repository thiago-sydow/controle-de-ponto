class GraphController < ActionController::Base
  layout nil
  before_action :doorkeeper_authorize!

  def introspect
    execute_and_render_query_result(GraphQL::Introspection::INTROSPECTION_QUERY)
  end

  def query
    query_string = params[:query]

    if query_string.blank?
      render json: {
        error: {
          status: :bad_request,
          kind: :missing_graphql_query,
          message: 'Missing or empty GraphQL query'
        }
      }, status: :bad_request
    else
      execute_and_render_query_result(query_string)
    end
  end

  private

  def execute_and_render_query_result(query_string)
    query_result = execute_query(query_string)

    if query_result.key?('errors')
      render json: {
        error: {
          status: :bad_request,
          kind: :graphql_error,
          message: 'GraphQL query error',
          detail: { errors: query_result['errors'] }
        }
      }, status: :bad_request
    else
      render json: query_result
    end
  end

  def execute_query(query_string)
    Schema.execute(
      query_string,
      context: query_context,
      variables: ensure_hash(params[:variables])
    )
  end

  def query_context
    {
      current_user: current_user
    }
  end

  def current_user
    @user ||= User.find_by(id: doorkeeper_token.resource_owner_id)
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    return {} if ambiguous_param.blank?

    case ambiguous_param
    when String
      ensure_hash(JSON.parse(ambiguous_param))
    when Hash, ActionController::Parameters
      ambiguous_param
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
