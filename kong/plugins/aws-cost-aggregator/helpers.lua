local PLUGIN_NAME = "aws-cost-aggregator"
local cjson = require("cjson.safe")
local date = require("date")
local fmt = string.format

local _M = {}

-- This function know how many days are in each month and can account for leap years
-- @param month the month as an int 1-12
-- @param year for use with leap year calculations
function _M.get_days_in_month(month, year)
  --                       J   F   M   A   M   J   J   A   S   O   N  D  
  local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }   
  local d = days_in_month[month]
  -- calculate leap year day
  if month == 2 then
    if date.isleapyear(year) then
      d = 29
    end
  end
  -- return result
  return d
end

-- This function will append a 0 to the start of a number less than and not including 10
-- @param int any number
function _M.pad_date_integer(int)
  if int > 9 then
    return tostring(int)
  end
  return tostring("0"..int)
end

-- This function executes a Kong breakpoint for an exception
-- @param do_debug can be provided to allow additional params on http response
-- @param err is anyhting provided by the application
function _M.log_error(do_debug, error, do_exit)
  if not do_exit then
    do_exit = true
  end
  -- format global code
  local GLOBAL_ERROR = [[There has been an issue with this request.
  If this problem persists please contact an admin]]
  local formatGlobalError = GLOBAL_ERROR:gsub("\n ", "")
  -- build base message
  local baseErrorMsg = {
    message = formatGlobalError
  }
  -- add specific items for debug mode
  if do_debug then
    baseErrorMsg["plugin"] = PLUGIN_NAME
    baseErrorMsg["error"] = tostring(error:gsub("\n ", ""))
  end
  -- log with kong
  kong.log.err("[", PLUGIN_NAME, "] ", cjson.encode(error))
  kong.log.err("[", PLUGIN_NAME, "] ", cjson.encode(baseErrorMsg))
  -- execute server fault
  if do_exit then
    return kong.response.exit(500, baseErrorMsg)
  end
end

function _M.log_debug(msg)
  kong.log.debug("[", PLUGIN_NAME, "] ", msg)
end

return _M