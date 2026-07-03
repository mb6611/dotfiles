-- snacks.nvim — folke's utility suite. It's already pulled in as a dependency of
-- claude-multi/claudecode/avante, but nothing here ran snacks.setup(), so its
-- modules stay off. This spec enables the (modern-looking) picker and binds the
-- keymap search to <leader>? (freed up in whichkey.lua — pausing after <leader>
-- already shows which-key's hints, so that mapping was redundant).
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      enabled = true,
      sources = {
        keymaps = {
          -- Drop the preview pane entirely. It only ever showed lazy.nvim's keys.lua
          -- handler (every map is registered through lazy's `keys`, so they all resolve
          -- to that one file). NOTE: disabling must happen at the LAYOUT level — a
          -- top-level `preview = false` is read as `false or <default>` and instead
          -- falls back to the file previewer.
          layout = { preview = false },
          -- Readable layout. The built-in formatter puts the verbose <Cmd>…<CR>
          -- BEFORE the description, crowding it off the right edge. Reorder to:
          --   [icon] mode  key            description                     raw-rhs(dim)
          -- i.e. what you press first, then what it does, then the raw mapping
          -- dimmed at the end for reference.
          format = function(item)
            local k = item.item
            local a = Snacks.picker.util.align
            local ret = {}
            if package.loaded["which-key"] then
              local ok, Icons = pcall(require, "which-key.icons")
              if ok then
                local icon, hl = Icons.get({ keymap = k, desc = k.desc })
                ret[#ret + 1] = icon and { a(icon, 3), hl } or { "   " }
              end
            end
            ret[#ret + 1] = { a(k.mode, 2), "SnacksPickerKeymapMode" }
            ret[#ret + 1] = { " " }
            ret[#ret + 1] = { a(Snacks.util.normkey(k.lhs), 14), "SnacksPickerKeymapLhs" }
            ret[#ret + 1] = { "  " }
            ret[#ret + 1] = { a(k.desc or "", 44) } -- description leads, wide column
            ret[#ret + 1] = { "  " }
            ret[#ret + 1] = { (k.rhs and k.rhs ~= "") and k.rhs or "callback", "NonText" }
            return ret
          end,
          -- Pure "documentation" view: show only keybinds you gave a description to
          -- (hides <Plug>/callback noise from plugins & vim builtins). Uncomment:
          -- filter = { filter = function(item) local d = item.item.desc; return d ~= nil and d ~= "" end },
        },
      },
    },
  },
  keys = {
    { "<leader>?", function() Snacks.picker.keymaps() end, desc = "Search keymaps" },
  },
}
