return {
  "CRAG666/code_runner.nvim",
  cmd = { "RunCode", "RunFile", "RunProject", "RunClose", "CRFiletype", "CRProjects" },
  keys = {
    { "<leader>rr", "<cmd>RunCode<CR>",  desc = "Run code" },
    { "<leader>rf", "<cmd>RunFile<CR>",  desc = "Run file" },
    { "<leader>rc", "<cmd>RunClose<CR>", desc = "Close runner" },
  },
  opts = {
    -- Force output INSIDE Neovim (float UI, not external terminal)
    mode = "float", -- alternatives: "term", "tab"
    focus = true,
    startinsert = true,
    float = { border = "rounded", width = 0.9, height = 0.9 },

    filetype = {
      java = {
        "cd $dir &&",
        "javac $fileName &&",
        "java $fileNameWithoutExt",
      },
      python = "python3 -u",
      typescript = "deno run",
      rust = {
        "cd $dir &&",
        "rustc $fileName &&",
        "$dir/$fileNameWithoutExt",
      },
      c = function(...)
        local c_base = {
          "cd $dir &&",
          "gcc $fileName -o",
          "/tmp/$fileNameWithoutExt",
        }
        local c_exec = {
          "&& /tmp/$fileNameWithoutExt &&",
          "rm /tmp/$fileNameWithoutExt",
        }
        vim.ui.input({ prompt = "Add more args:" }, function(input)
          c_base[4] = input
          require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
        end)
      end,
    },
  },
  config = function(_, opts)
    require("code_runner").setup(opts)
  end,
}
