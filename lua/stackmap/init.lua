local M = {}

M._stack = {}

---@param maps table: mapping table
---@param lhs string: left hand side mapping
local find_mapping = function(maps, lhs)
  for _, value in ipairs(maps) do
    if value.lhs == lhs then
      return value
    end
  end
end

---
---@param name string
---@param mode string
---@param mapping table<string,string>
M.push = function(name, mode, mapping)
  local maps = vim.api.nvim_get_keymap(mode)
  local existing_maps = {}

  for lhs, rhs in pairs(mapping) do
    local existing = (find_mapping(maps, lhs))
    if existing then
      table.insert(existing_maps, existing)
    end
  end

  M._stack[name] = existing_maps
  for lhs, rhs in pairs(mapping) do
    -- TODO: need some way to pass options in here
    vim.keymap.set(mode, lhs, rhs)
  end
end

M.pop = function(name) end

-- lua require("mapstack").push("debug_mode", {...})

-- lua require("mapstack").pop("debug_mode")

M.push("debug_mode", "n", {
  [" st"] = "echo 'Hello'",
  [" sp"] = "echo 'Goodbye'",
})

return M
