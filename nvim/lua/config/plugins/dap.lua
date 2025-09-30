return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap-python",
			-- "leoluz/nvim-dap-go",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function ()
			local dap = require "dap"
			local dapui = require "dapui"
			local mason = require "mason"
			-- mason.setup(
			-- 	opts = {
			-- 		ensure_installed = {
			-- 			"clangd",
			-- 			"codelldb",
			-- 			"gcc",
			-- 			"gdb",
			-- 		}
			-- 	}
			-- )
			dapui.setup()
			require("nvim-dap-virtual-text").setup()
			-- require("dap-go").setup()
			require("dap-python").setup("/Users/jayrgarg/.virtualenvs/debugpy/bin/python3")
			require('dap-python').test_runner = 'pytest'

			dap.adapters.codelldb = {
				type = "executable",
				command = "/Users/jayrgarg/.local/share/nvim/mason/bin/codelldb", --"codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

				-- On windows you may have to uncomment this:
				-- detached = false,
			}
			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
					args = function()
						local args_str = vim.fn.input('Arguments: ')
						-- Parse arguments respecting quoted strings
						local args = {}
						local current_arg = ""
						local in_quotes = false
						local quote_char = nil

						for i = 1, #args_str do
							local char = args_str:sub(i, i)

							if (char == '"' or char == "'") and not in_quotes then
								in_quotes = true
								quote_char = char
							elseif char == quote_char and in_quotes then
								in_quotes = false
								quote_char = nil
							elseif char == ' ' and not in_quotes then
								if current_arg ~= "" then
									table.insert(args, current_arg)
									current_arg = ""
								end
							else
								current_arg = current_arg .. char
							end
						end
						if current_arg ~= "" then
							table.insert(args, current_arg)
						end

						return args
					end,
				},
			}

			vim.keymap.set("n", "<space>db", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>dc", dap.run_to_cursor)

			-- Eval var under cursor
			vim.keymap.set("n", "<space>d?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<space>dk", dap.continue)
			vim.keymap.set("n", "<space>di", dap.step_into)
			vim.keymap.set("n", "<space>dl", dap.step_over)
			vim.keymap.set("n", "<space>d,", dap.step_out)
			vim.keymap.set("n", "<space>dj", dap.step_back)
			vim.keymap.set("n", "<space>dr", dap.restart)
			vim.keymap.set("n", "<space>ds", dap.terminate)

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			vim.keymap.set("n", "<space>dq", dapui.close)
			-- dap.listeners.before.event_terminated.dapui_config = function()
			-- 	dapui.close()
			-- end
			-- dap.listeners.before.event_exited.dapui_config = function()
			-- 	dapui.close()
			-- end
		end
	}
}
