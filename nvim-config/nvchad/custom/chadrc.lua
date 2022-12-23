-- First read our docs (completely) then check the example_config repo
-- See this for an example config: https://github.com/cfcosta/nvchad-config/blob/main/chadrc.lua
-- Or this https://github.com/NvChad/NvChad/issues/1326#issuecomment-1179903618
local M = {}
-- make sure you maintain the structure of `core/default_config.lua` here,

M.ui = {
    theme = "onenord" -- catppuccin
}

M.options = {
    -- NvChad options
    nvChad = {
        copy_cut = true, -- copy cut text ( x key ), visual and normal mode
        copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
        insert_nav = false, -- navigation in insertmode
        window_nav = true,

        -- updater
        update_url = "https://github.com/NvChad/NvChad",
        update_branch = "main"
    }
}

return M
