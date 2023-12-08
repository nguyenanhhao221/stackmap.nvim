local find_map = function(lhs)
  local maps = vim.api.nvim_get_keymap("n")
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      return map
    end
  end
end

describe("stackmap", function()
  before_each(function()
    -- Don't have this mapping before we start to test
    pcall(vim.keymap.del, "n", "asdashd")
    require("stackmap")._stack = {}
  end)

  it("can be require", function()
    require("stackmap")
  end)
  it("can push a single mapping", function()
    local expectRhs = "echo 'this is a test'"
    local stackmap = require("stackmap")
    stackmap.push("test1", "n", {
      asdashd = expectRhs,
    })

    local found = find_map("asdashd")
    assert.are.same(expectRhs, found.rhs)
  end)

  it("can push multiple mappings", function()
    local expectRhs = "echo 'this is a test'"
    local stackmap = require("stackmap")
    stackmap.push("test1", "n", {
      ["asdashd_1"] = expectRhs .. "1",
      ["asdashd_2"] = expectRhs .. "2",
    })

    local found1 = find_map("asdashd_1")
    assert.are.same(expectRhs .. "1", found1.rhs)
    local found2 = find_map("asdashd_2")
    assert.are.same(expectRhs .. "2", found2.rhs)
  end)

  it("can delete mapping after pop", function()
    local expectRhs = "echo 'this is a test'"
    require("stackmap").push("test_pop", "n", {
      abc = expectRhs,
    })

    local found = find_map("abc")
    assert.are.same(expectRhs, found.rhs)

    require("stackmap").pop("test_pop")

    local after_pop = find_map("abc")
    assert.are.same(nil, after_pop)
  end)
end)
