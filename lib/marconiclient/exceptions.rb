module Marconiclient

  ERRORS = {
    400 => 'MalformedRequest',
    401 => 'UnauthorizedError',
    403 => 'ForbiddenError',
    404 => 'ResourceNotFound',
    500 => 'InternalServerError',
    502 => 'BadGatewayError',
    503 => 'ServiceUnavailableError'}

  class ResponseError < StandardError
  end
  
end
