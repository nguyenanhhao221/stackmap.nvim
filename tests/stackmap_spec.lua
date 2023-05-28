local find_map = function(maps, lhs)
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      return map
    end
  end
end

describe("stackmap", function()
  it("it can be required", function()
    require("stackmap")
  end)

  it("can push a single mapping", function()
    local rhs = "echo 'This is a test'"

    require("stackmap").push("test", "n", {
      ["assjkadhksa"] = rhs,
    })

    local maps = vim.api.nvim_get_keymap("n")
    local found = find_map(maps, "assjkadhksa")
    assert.are.same(rhs, found.rhs)
  end)
end)
