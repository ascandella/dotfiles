local on_attach = require('ai/lsp-shared').on_attach
local capabilities = require('ai/lsp-shared').capabilities()

local function setup()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  -- calculate workspace dir
  local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
  -- get the mason install path
  local install_path = require('mason-registry').get_package('jdtls'):get_install_path()
  local home_dir = os.getenv('HOME')
  -- get the debug adapter install path
  -- local debug_install_path = require('mason-registry').get_package('java-debug-adapter'):get_install_path()
  -- local bundles = {
  --   vim.fn.glob(debug_install_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', 1),
  -- }

  local config = {
    cmd = {
      home_dir .. '/.jenv/versions/21/bin/java',
      '-jar',
      install_path .. '/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar',
      '-configuration',
      install_path .. '/config_mac_arm',
      '--jvm-arg=-javaagent:' .. install_path .. '/lombok.jar',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-data',
      workspace_dir,
    },
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = vim.fs.dirname(
      vim.fs.find({ '.gradlew', '.git', 'mvnw', 'pom.xml', 'build.gradle' }, { upward = true })[1]
    ),

    settings = {
      java = {
        signatureHelp = { enabled = true },
        configuration = {
          runtimes = {
            {
              name = 'JavaSE-17',
              path = home_dir .. '/.jenv/versions/17',
            },
          },
        },
      },
    },

    init_options = {
      -- bundles = bundles,
    },
  }
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'java' },
    callback = function()
      require('jdtls').start_or_attach(config)
    end,
  })
end

return {
  setup = setup,
}
