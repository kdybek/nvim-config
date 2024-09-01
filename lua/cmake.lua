local M = {}

local project_config = require('project-config')

local function generate_commands()
    local cmake_generate_cmd = 'cmake -G "Ninja Multi-Config" -S . -B "' ..
        project_config.build_dir ..
        '" -DCMAKE_EXPORT_COMPILE_COMMANDS=' .. (project_config.export_compile_commands and 'ON' or 'OFF')

    if project_config.export_compile_commands then
        cmake_generate_cmd = cmake_generate_cmd ..
            ' && del compile_commands.json 2>nul && mklink compile_commands.json "' ..
            project_config.build_dir .. '/compile_commands.json"'
    end

    local cmake_build_cmd = 'cmake --build "' ..
        project_config.build_dir .. '" --config "' .. project_config.build_config .. '"'

    local target_path = '".\\' ..
        project_config.build_dir .. '\\' .. project_config.build_config .. '\\' .. project_config.executable .. '"'

    local debugger_cmd = 'lldb -o "r" -o "q" -- ' .. target_path

    local cmake_clean_cmd = 'rmdir /s /q "' .. project_config.build_dir .. '" && del compile_commands.json 2>nul'

    local function cmake_generate()
        vim.cmd('!' .. cmake_generate_cmd)
    end

    local function cmake_build()
        vim.cmd('!' .. cmake_generate_cmd .. ' && ' .. cmake_build_cmd)
    end

    local function cmake_run()
        vim.cmd('! ' .. cmake_generate_cmd .. ' && ' .. cmake_build_cmd .. ' && ' .. target_path)
    end

    local function cmake_debug()
        vim.cmd('! ' .. cmake_generate_cmd .. ' && ' .. cmake_build_cmd .. ' && ' .. debugger_cmd)
    end

    local function cmake_clean()
        vim.cmd('! ' .. cmake_clean_cmd)
    end

    vim.api.nvim_create_user_command('CMakeGenerate', cmake_generate, {})
    vim.api.nvim_create_user_command('CMakeBuild', cmake_build, {})
    vim.api.nvim_create_user_command('CMakeRun', cmake_run, {})
    vim.api.nvim_create_user_command('CMakeDebug', cmake_debug, {})
    vim.api.nvim_create_user_command('CMakeClean', cmake_clean, {})
end

local function set_executable(executable)
    project_config.executable = executable.args
    generate_commands()
end

local function set_build_dir(build_dir)
    project_config.build_dir = build_dir.args
    generate_commands()
end

local function set_build_config(build_config)
    project_config.build_config = build_config.args
    generate_commands()
end

local function set_export_compile_commands(export_compile_commands)
    project_config.export_compile_commands = export_compile_commands.args
    generate_commands()
end

function M.setup()
    generate_commands()
    vim.api.nvim_create_user_command('SetExecutable', set_executable, { nargs = 1 })
    vim.api.nvim_create_user_command('SetBuildDir', set_build_dir, { nargs = 1 })
    vim.api.nvim_create_user_command('SetBuildConfig', set_build_config, { nargs = 1 })
    vim.api.nvim_create_user_command('SetExportCompileCommands', set_export_compile_commands, { nargs = 1 })
end

return M
