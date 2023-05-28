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

    require("stackmap").push("test", "n", { ["assjkadhksa"] = rhs })

    local maps = vim.api.nvim_get_keymap("n")
    local found = find_map(maps, "assjkadhksa")
    assert.are.same(rhs, found.rhs)
  end)

  it("can push a multiple mappings", function()
    local rhs = "echo 'This is a test'"

    require("stackmap").push("test 2", "n", {
      ["aaaa"] = rhs .. "1",
      ["bbbb"] = rhs .. "2",
    })

    local maps = vim.api.nvim_get_keymap("n")
    local found_1 = find_map(maps, "aaaa")
    assert.are.same(rhs .. "1", found_1.rhs)
    local found_2 = find_map(maps, "bbbb")
    assert.are.same(rhs .. "2", found_2.rhs)
  end)
end)
