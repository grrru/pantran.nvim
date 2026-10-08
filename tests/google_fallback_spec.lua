local google = require("pantran.engines.fallback.google")

describe("Google fallback response parsing", function()
  local apis, flatten

  before_each(function()
    apis, flatten = google._apis, vim.tbl_flatten
    vim.tbl_flatten = nil
  end)

  after_each(function()
    google._apis, vim.tbl_flatten = apis, flatten
  end)

  it('parses nested translations and detected languages after endpoint failure', function()
    google._apis = {
      {post = function() error("First endpoint failed") end},
      {post = function() return {{"Hallo Welt!", "en"}} end}
    }

    assert.are.same({text = "Hallo Welt!", detected = "en"},
      google.translate("Hello World!", "auto", "de"))
  end)
end)
