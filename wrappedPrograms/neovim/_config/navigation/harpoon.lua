local harpoon = require("harpoon")
harpoon:setup({
	settings = {
		save_on_toggle = true,
		sync_on_ui_close = true,
	},
})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

-- ui and adding marks
vim.keymap.set("n", "<leader>ht", function()
	toggle_telescope(harpoon:list())
end, { desc = "Harpoon telescope window" })
vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Add mark" })
vim.keymap.set("n", "<leader>hm", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Quick menu" })

-- navigation
vim.keymap.set("n", "<leader>hn", function()
	harpoon:list():next()
end, { desc = "Next mark" })
vim.keymap.set("n", "<leader>hp", function()
	harpoon:list():prev()
end, { desc = "Previous mark" })
vim.keymap.set("n", "<leader>hl", function()
	harpoon:list():select(1)
end, { desc = "Nav to mark 1" })
vim.keymap.set("n", "<leader>hu", function()
	harpoon:list():select(2)
end, { desc = "Nav to mark 2" })
vim.keymap.set("n", "<leader>hy", function()
	harpoon:list():select(3)
end, { desc = "Nav to mark 3" })
vim.keymap.set("n", "<leader>h;", function()
	harpoon:list():select(4)
end, { desc = "Nav to mark 4" })
