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
---@param mappings table<string,string>
M.push = function(name, mode, mappings)
  local maps = vim.api.nvim_get_keymap(mode)
  local existing_maps = {}
  for lhs, _ in pairs(mappings) do
    local existing = (find_mapping(maps, lhs))
    if existing then
      existing_maps[lhs] = existing
    end
  end

  M._stack[name] = { mode = mode, existing = existing_maps, mappings = mappings }

  for lhs, rhs in pairs(mappings) do
    -- TODO: need some way to pass options in here
    vim.keymap.set(mode, lhs, rhs)
  end
end

M.pop = function(name)
  local state = M._stack[name]
  M._stack[name] = nil

  for lhs, _ in pairs(state.mappings) do
    if state.existing[lhs] then
      --Handle mapping that existed
      local exist_mapping = state.existing[lhs]
      -- set existing keymaps back to the original key map
      vim.keymap.set(state.mode, exist_mapping.lhs, exist_mapping.rhs)
    else
      --Handle mapping that not existed
      -- P(lhs)
      vim.keymap.del(state.mode, lhs)
    end
  end
end

M.push("debug_mode", "n", {
  [" st"] = "echo 'Hello'",
  [",sp"] = "echo 'Goodbye'",
})

return M
