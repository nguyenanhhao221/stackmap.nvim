local M = {}

-- M.setup = function(opts)
--   print("Options: ", opts)
-- end

--- find the duplicate mapping
---@param maps table current mapping
---@param lhs string lhs to check
local find_mapping = function(maps, lhs)
  -- pairs vs ipars
  -- pairs
  --    iterate over EVERY key in a table
  --    WITHOUT guarantee order
  -- ipairs
  --    iterate over ONLY numeric key in a table
  --    ORDER is guarantee
  for _, value in ipairs(maps) do
    if value.lhs == lhs then
      return value
    end
  end
  return nil
end

---
---@param name string
---@param mode string
---@param mapping table
M.push = function(name, mode, mapping)
  local maps = vim.api.nvim_get_keymap(mode)

  local existing_maps = {}
  for lhs, rhs in pairs(mapping) do
    print("Searching for lhs: ", lhs)
    local existing = find_mapping(maps, lhs)
    if existing then
      table.insert(existing_maps, existing)
    end
  end
  -- P(existing_maps)
  M._stack[name] = existing_maps
  for lhs, rhs in pairs(mapping) do
    vim.keymap.set(mode, lhs, rhs)
  end
end

-- Underscore is to indicated please do not touch this
-- _stack is created as an empty table at first, then other function will populate it due to lua cache behavior
M._stack = {}

M.pop = function(name) end

M.push("debug_mode", "n", {
  [" ht"] = 'echo "Hello"',
  [" hs"] = 'echo "Hello"',
})

return M
