return {
  {
    -- This will make sure, upon CR/Enter the first item on suggested list is not auto selected
    -- and only the explicitly selected item will be insert_text_mode
    -- use shift+enter to auto-insert the first suggested item
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      local cmp = require 'cmp'
      opts.mapping["<CR>"] = cmp.mapping.confirm({ select = false }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      opts.completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      }
    end
  }
}
