local find_map = function(maps, lhs)
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      return map
    end
  end
end

describe("stackmap", function()
  it("can be require", function()
    require("stackmap")
  end)
  it("can push a single mapping", function()
    local expectRhs = "echo 'this is a test'"
    local stackmap = require("stackmap")
    stackmap.push("test1", "n", {
      asdashd = expectRhs,
    })

    local maps = vim.api.nvim_get_keymap("n")
    local found = find_map(maps, "asdashd")
    assert.are.same(expectRhs, found.rhs)
  end)

  it("can push multiple mappings", function()
    local expectRhs = "echo 'this is a test'"
    local stackmap = require("stackmap")
    stackmap.push("test1", "n", {
      ["asdashd_1"] = expectRhs .. "1",
      ["asdashd_2"] = expectRhs .. "2",
    })

    local maps = vim.api.nvim_get_keymap("n")
    local found1 = find_map(maps, "asdashd_1")
    assert.are.same(expectRhs .. "1", found1.rhs)
    local found2 = find_map(maps, "asdashd_2")
    assert.are.same(expectRhs .. "2", found2.rhs)
  end)
end)
