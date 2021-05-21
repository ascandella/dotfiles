local utils = require('utils')

utils.map('n', '<Leader>,', '<CMD>lua require\'telescope-config\'.project_files()<CR>', {noremap = true, silent = true})
