local local_init_file = 'local-init.lua'
local current_dir = vim.fn.getcwd()
local local_init_path = current_dir .. '/' .. local_init_file

if vim.fn.filereadable(local_init_path) == 1 then
    vim.cmd('luafile ' .. local_init_path)
end
